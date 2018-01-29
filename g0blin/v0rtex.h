#import "common.h"
#include <mach/mach.h>
#include <stdint.h> // uint*_t

typedef kern_return_t (*v0rtex_cb_t)(task_t tfp0, kptr_t kbase, void *data);

kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide, kptr_t *kernucred);
