#ifndef COMMON_H
#define COMMON_H

#include <stdint.h>             // uint*_t

#import <Foundation/Foundation.h>

#ifdef __LP64__
#   define ADDR "0x%016llx"
    typedef uint64_t kptr_t;
#else
#   define ADDR "0x%08x"
    typedef uint32_t kptr_t;
#endif

#define LOG(str, args...) do { NSLog(@str "\n", ##args); } while(0)


// Re-direct LOG macro to GUI ...

//#include "ViewController.h"
//extern id controller;
//#define LOG(str, args...) do { \
//    if (controller && [controller respondsToSelector:@selector(log:)]) { \
//        if ([NSThread isMainThread]) { \
//            [controller log:[NSString stringWithFormat:@str "\n", ##args]]; \
//        } else { \
//            [controller performSelectorOnMainThread:@selector(log:) withObject:[NSString stringWithFormat:@str "\n", ##args] waitUntilDone:NO]; \
//        } \
//    } else { \
//        NSLog(@str "\n", ##args); \
//    } \
//} while(0)

#endif
