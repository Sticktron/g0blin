//
//  main.m
//  g0blin
//
//  Created by Sticktron on 2017-12-26.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <dlfcn.h>

int (*gsystem)(const char *) = 0;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        gsystem = dlsym(RTLD_DEFAULT,"system"); //thx tihmstar :)
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
