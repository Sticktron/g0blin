//
//  kpp.h
//  g0blin
//
//  Created by Sticktron on 2017-12-26.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 qwertyoruiop. All rights reserved.
//

#include <dlfcn.h>
#include <copyfile.h>
#include <stdio.h>
#include <spawn.h>
#include <unistd.h>
#include <mach/mach.h>
#include <mach-o/dyld.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <sys/utsname.h>
#include <Foundation/Foundation.h>


kern_return_t do_kpp(task_t tfp0, uint64_t slide, uint64_t kern_cred, uint64_t self_cred, uint64_t selfproc);
    
size_t kread(uint64_t where, void *p, size_t size);
uint64_t kread_uint64(uint64_t where);
uint32_t kread_uint32(uint64_t where);
size_t kwrite(uint64_t where, const void *p, size_t size);
size_t kwrite_uint64(uint64_t where, uint64_t value);
size_t kwrite_uint32(uint64_t where, uint32_t value);

void kx2(uint64_t fptr, uint64_t arg1, uint64_t arg2);
uint32_t kx5(uint64_t fptr, uint64_t arg1, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5);

kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
kern_return_t mach_vm_write(vm_map_t target_task, mach_vm_address_t address, vm_offset_t data, mach_msg_type_number_t dataCnt);
kern_return_t mach_vm_protect(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, boolean_t set_maximum, vm_prot_t new_protection);
kern_return_t mach_vm_allocate(vm_map_t target, mach_vm_address_t *address, mach_vm_size_t size, int flags);

#define ReadAnywhere32 kread_uint32
#define WriteAnywhere32 kwrite_uint32
#define ReadAnywhere64 kread_uint64
#define WriteAnywhere64 kwrite_uint64

#define copyin(to, from, size) kread(from, to, size)
#define copyout(to, from, size) kwrite(to, from, size)

#define CS_VALID                    0x0000001    /* dynamically valid */
#define CS_ADHOC                    0x0000002    /* ad hoc signed */
#define CS_GET_TASK_ALLOW           0x0000004    /* has get-task-allow entitlement */
#define CS_INSTALLER                0x0000008    /* has installer entitlement */

#define CS_HARD                     0x0000100    /* don't load invalid pages */
#define CS_KILL                     0x0000200    /* kill process if it becomes invalid */
#define CS_CHECK_EXPIRATION         0x0000400    /* force expiration checking */
#define CS_RESTRICT                 0x0000800    /* tell dyld to treat restricted */
#define CS_ENFORCEMENT              0x0001000    /* require enforcement */
#define CS_REQUIRE_LV               0x0002000    /* require library validation */
#define CS_ENTITLEMENTS_VALIDATED   0x0004000

#define CS_ALLOWED_MACHO            0x00ffffe

#define CS_EXEC_SET_HARD            0x0100000    /* set CS_HARD on any exec'ed process */
#define CS_EXEC_SET_KILL            0x0200000    /* set CS_KILL on any exec'ed process */
#define CS_EXEC_SET_ENFORCEMENT     0x0400000    /* set CS_ENFORCEMENT on any exec'ed process */
#define CS_EXEC_SET_INSTALLER       0x0800000    /* set CS_INSTALLER on any exec'ed process */

#define CS_KILLED                   0x1000000    /* was killed by kernel for invalidity */
#define CS_DYLD_PLATFORM            0x2000000    /* dyld used to load this is a platform binary */
#define CS_PLATFORM_BINARY          0x4000000    /* this is a platform binary */
#define CS_PLATFORM_PATH            0x8000000    /* platform binary by the fact of path (osx only) */

