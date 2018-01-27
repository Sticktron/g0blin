#import "common.h"
#include <mach/mach.h>
#include <stdint.h>             // uint*_t

//kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide, kptr_t *kernucred, kptr_t *selfproc);
kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide, kptr_t *kernucred);
//kern_return_t v0rtex(task_t *tfp0, uint64_t *kslide);
