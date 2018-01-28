#import "common.h"
#include <mach/mach.h>
#include <stdint.h> // uint*_t

kern_return_t v0rtex(task_t *tfp0, uint64_t *kslide, uint64_t *kernucred, uint64_t *selfproc, uint64_t *origcred);
