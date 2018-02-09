#import "common.h"
#include <mach/mach.h>
#include <stdint.h> // uint*_t

typedef kern_return_t (*v0rtex_cb_t)(task_t tfp0, kptr_t kbase, void *data);

kern_return_t v0rtex(task_t *tfp0, uint64_t *kslide, uint64_t *kerncred, uint64_t *selfcred, uint64_t *selfproc);
