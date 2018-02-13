//
//  kernel.h
//  g0blin
//
//  Created by Ben (@PsychoTea) on 16/12/2017.
//

#include <mach/mach.h>

void init_kernel(task_t tfp0);
size_t tfp0_kread(uint64_t where, void *p, size_t size);
uint64_t rk64(uint64_t kaddr);
uint32_t rk32(uint64_t kaddr);
void wk64(uint64_t kaddr, uint64_t val);
void wk32(uint64_t kaddr, uint32_t val);
size_t kwrite(uint64_t where, const void *p, size_t size);
size_t kwrite_uint64(uint64_t where, uint64_t value);
size_t kwrite_uint32(uint64_t where, uint32_t value);


kern_return_t mach_vm_write(vm_map_t target_task,
                            mach_vm_address_t address,
                            vm_offset_t data,
                            mach_msg_type_number_t dataCnt);

kern_return_t mach_vm_read_overwrite(vm_map_t target_task,
                                     mach_vm_address_t address,
                                     mach_vm_size_t size,
                                     mach_vm_address_t data,
                                     mach_vm_size_t *outsize);

kern_return_t mach_vm_allocate(vm_map_t, mach_vm_address_t *, mach_vm_size_t, int);
