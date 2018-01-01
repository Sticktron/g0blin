//
//  offsets.m
//  g0blin
//
//  Created by Sticktron on 2017-12-26.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#include "offsets.h"
#include "common.h"
#include <sys/utsname.h>
#import <UIKit/UIDevice.h>

uint64_t OFFSET_ZONE_MAP;
uint64_t OFFSET_KERNEL_MAP;
uint64_t OFFSET_KERNEL_TASK;
uint64_t OFFSET_REALHOST;
uint64_t OFFSET_COPYIN;
uint64_t OFFSET_COPYOUT;
uint64_t OFFSET_CHGPROCCNT;
uint64_t OFFSET_KAUTH_CRED_REF;
uint64_t OFFSET_IPC_PORT_ALLOC_SPECIAL;
uint64_t OFFSET_IPC_KOBJECT_SET;
uint64_t OFFSET_IPC_PORT_MAKE_SEND;
uint64_t OFFSET_OSSERIALIZER_SERIALIZE;
uint64_t OFFSET_ROP_LDR_X0_X0_0x10;
uint64_t OFFSET_ROOT_MOUNT_V_NODE;

kern_return_t init_offsets() {
    
    struct utsname u = { 0 };
    uname(&u);
    
    LOG("Detecting device and OS...");
    
    LOG("sysname: %s", u.sysname);
    LOG("nodename: %s", u.nodename);
    LOG("version: %s", u.version);
    LOG("release: %s", u.release);
    LOG("machine: %s", u.machine);
    
    NSString *ver = [[NSProcessInfo processInfo] operatingSystemVersionString];
    LOG("operatingSystemVersionString: %@", ver);
    
    if (strcmp(u.machine, "iPhone6,1") == 0 || strcmp(u.machine, "iPhone6,2") == 0)
    {
        if ([ver isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff007181218;
            OFFSET_COPYOUT                         =0xfffffff00718140c;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099aa0;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006474a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
        else if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff007180e98;
            OFFSET_COPYOUT                         =0xfffffff00718108c;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e77c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007368b08;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a38;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007441908;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006470a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff0071811ec;
            OFFSET_COPYOUT                         =0xfffffff0071813e0;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a38;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006474a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
        else if ([ver isEqual: @"Version 10.3 (Build 14E277)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff007181218;
            OFFSET_COPYOUT                         =0xfffffff00718140c;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099aa0;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006474a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
    }
    
    //6
    else if (strcmp(u.machine, "iPhone7,1") == 0 || strcmp(u.machine, "iPhone7,2") == 0)
    {
        if ([ver isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d3a8;
            OFFSET_COPYOUT                         =0xfffffff00718d59c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5c40;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006404a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
            
        }
        else if ([ver isEqual: @"Version 10.3 (Build 14E277)"])
        {
            
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d3a8;
            OFFSET_COPYOUT                         =0xfffffff00718d59c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5c40;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006404a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
            
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d37c;
            OFFSET_COPYOUT                         =0xfffffff00718d570;
            OFFSET_CHGPROCCNT                      =0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006400a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d028;
            OFFSET_COPYOUT                         =0xfffffff00718d21c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006400a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
            
        }
    }
    
    
    //6S 10.3.3
    else if (strcmp(u.machine, "iPhone8,1") == 0 || strcmp(u.machine, "iPhone8,2") == 0)
    {
        if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff0071803a0;
            OFFSET_COPYOUT                         =0xfffffff007180594;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070999b8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063b0a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
            
        }
        else if ([ver  isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff007180720;
            OFFSET_COPYOUT                         =0xfffffff007180914;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a20;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063b4a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff0071806f4;
            OFFSET_COPYOUT                         =0xfffffff0071808e8;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070999b8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063b4a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
            
        }
        else if ([ver  isEqual: @"Version 10.3 (Build 14E277)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff007180720;
            OFFSET_COPYOUT                         =0xfffffff007180914;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a20;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063b4a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
        }
        
    }
    //SE
    else if (strcmp(u.machine, "iPhone8,4") == 0)
    {
        if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff0071803a0;
            OFFSET_COPYOUT                         =0xfffffff007180594;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070999b8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063d0a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff0071806f4;
            OFFSET_COPYOUT                         =0xfffffff0071808e8;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070999b8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063d0a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
        }
        else if ([ver isEqual: @"Version 10.3 (Build 14E277)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff007180720;
            OFFSET_COPYOUT                         =0xfffffff007180914;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a20;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063d0a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
            
        }
        if ([ver  isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007548478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a4048;
            OFFSET_REALHOST                        =0xfffffff00752aba0;
            OFFSET_COPYIN                          =0xfffffff007180720;
            OFFSET_COPYOUT                         =0xfffffff007180914;
            OFFSET_CHGPROCCNT                      =0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a20;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063d0a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a40b0;
        }
    }
    
    //7
    else if (strcmp(u.machine, "iPhone9,1") == 0 || strcmp(u.machine, "iPhone9,2") == 0 || strcmp(u.machine, "iPhone9,3") == 0 || strcmp(u.machine, "iPhone9,4") == 0)
    {
        if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007590478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075ec048;
            OFFSET_REALHOST                        =0xfffffff007572ba0;
            OFFSET_COPYIN                          =0xfffffff0071c5db4;
            OFFSET_COPYOUT                         =0xfffffff0071c6094;
            OFFSET_CHGPROCCNT                      =0xfffffff0073d38e4;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073adc68;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070deff4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070f22cc;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070deb18;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007486a14;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006310a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075ec0b0;
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            
            OFFSET_ZONE_MAP                        =0xfffffff007590478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075ec048;
            OFFSET_REALHOST                        =0xfffffff007572ba0;
            OFFSET_COPYIN                          =0xfffffff0071c6108;
            OFFSET_COPYOUT                         =0xfffffff0071c63e8;
            OFFSET_CHGPROCCNT                      =0xfffffff0073d3994;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073add44;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070deff4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070f22cc;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070deb18;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007486ac4;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006314a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075ec0b0;
            
        }
        else if ([ver isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            
            OFFSET_ZONE_MAP                        =0xfffffff007590478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075ec048;
            OFFSET_REALHOST                        =0xfffffff007572ba0;
            OFFSET_COPYIN                          =0xfffffff0071c6134;
            OFFSET_COPYOUT                         =0xfffffff0071c6414;
            OFFSET_CHGPROCCNT                      =0xfffffff0073d366c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073ada04;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070df05c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070f22b4;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070deb80;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007486530;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006314a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075ec0b0;
            
        }
        else if ([ver isEqual: @"Version 10.3 (Build 14E277)"])
        {
            
            OFFSET_ZONE_MAP                        =0xfffffff007590478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075ec048;
            OFFSET_REALHOST                        =0xfffffff007572ba0;
            OFFSET_COPYIN                          =0xfffffff0071c6134;
            OFFSET_COPYOUT                         =0xfffffff0071c6414;
            OFFSET_CHGPROCCNT                      =0xfffffff0073d366c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073ada04;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070df05c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070f22b4;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070deb80;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007486530;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006314a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075ec0b0;
            
        }
    }
    //iPod 6
    else if (strcmp(u.machine, "iPod7,1") == 0)
    {
        if ([ver isEqual: @"Version 10.3 (Build 14E277)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d3a8;
            OFFSET_COPYOUT                         =0xfffffff00718d59c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5c40;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00646ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
            
        }
        else if ([ver isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d3a8;
            OFFSET_COPYOUT                         =0xfffffff00718d59c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5c40;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00646ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
            
        }
        else if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d028;
            OFFSET_COPYOUT                         =0xfffffff00718d21c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006468a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d37c;
            OFFSET_COPYOUT                         =0xfffffff00718d570;
            OFFSET_CHGPROCCNT                      =0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00646ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
    }
    
    //iPad Pro 10.5"
    else if (strcmp(u.machine, "iPad7,3") == 0 || strcmp(u.machine, "iPad7,4") == 0)
    {
        if ([ver isEqual: @"Version 10.3.2 (Build 14F8089)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff007590478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075ec048;
            OFFSET_REALHOST                        =0xfffffff007572ba0;
            OFFSET_COPYIN                          =0xfffffff0071c6220;
            OFFSET_COPYOUT                         =0xfffffff0071c6500;
            OFFSET_CHGPROCCNT                      =0xfffffff0073d3bd8;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073adf88;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070df014;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070f22ec;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070deb38;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007486d08;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006244a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075ec0b0;
        }
        else if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"]) {
            OFFSET_ZONE_MAP                        =0xfffffff007590478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075ec048;
            OFFSET_REALHOST                        =0xfffffff007572ba0;
            OFFSET_COPYIN                          =0xfffffff0071c5ecc;
            OFFSET_COPYOUT                         =0xfffffff0071c61ac;
            OFFSET_CHGPROCCNT                      =0xfffffff0073d3b28;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073adeac;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070df014;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070f22ec;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070deb38;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007486c58;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006244a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075ec0b0;
        }
    }
    //iPad Mini 3
    
    else if (strcmp(u.machine, "iPad4,7") == 0 || strcmp(u.machine, "iPad4,8") == 0 || strcmp(u.machine, "iPad4,9") == 0) {
        if ([ver isEqual: @"Version 10.3 (Build 14E277)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff007181218;
            OFFSET_COPYOUT                         =0xfffffff00718140c;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099aa0;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00640ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
        else if ([ver isEqual: @"Version 10.3.1 (Build 14E304)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff007181218;
            OFFSET_COPYOUT                         =0xfffffff00718140c;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099aa0;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00640ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
        else if ([ver isEqual: @"Version 10.3.2 (Build 14F89)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff0071811ec;
            OFFSET_COPYOUT                         =0xfffffff0071813e0;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a38;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00640ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
        else if ([ver isEqual: @"Version 10.3.3 (Build 14G60)"])
        {
            OFFSET_ZONE_MAP                        =0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075a8048;
            OFFSET_REALHOST                        =0xfffffff00752eba0;
            OFFSET_COPYIN                          =0xfffffff007180e98;
            OFFSET_COPYOUT                         =0xfffffff00718108c;
            OFFSET_CHGPROCCNT                      =0xfffffff00738e77c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007368b08;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff007099a38;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff007441908;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff006408a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075a80b0;
        }
    }
    //iPad Mini 4 & iPad Air 2
    else if (strcmp(u.machine, "iPad5,1") == 0 || strcmp(u.machine, "iPad5,2") == 0 || strcmp(u.machine, "iPad5,3") == 0 || strcmp(u.machine, "iPad5,4") == 0) {
        if (strcmp(u.version, "Darwin Kernel Version 16.5.0: Thu Feb 23 23:22:54 PST 2017; root:xnu-3789.52.2~7/RELEASE_ARM64_T7000") == 0) {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d3a8;
            OFFSET_COPYOUT                         =0xfffffff00718d59c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5c40;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00639ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if (strcmp(u.version, "Darwin Kernel Version 16.5.0: Thu Feb 23 23:22:55 PST 2017; root:xnu-3789.52.2~7/RELEASE_ARM64_T7001") == 0) {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d4a0;
            OFFSET_COPYOUT                         =0xfffffff00718d694;
            OFFSET_CHGPROCCNT                      =0xfffffff00739a9b0;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374d50;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5c40;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744d8d0;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063a8a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if (strcmp(u.version, "Darwin Kernel Version 16.6.0: Mon Apr 17 17:33:35 PDT 2017; root:xnu-3789.60.24~24/RELEASE_ARM64_T7000") == 0) {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d37c;
            OFFSET_COPYOUT                         =0xfffffff00718d570;
            OFFSET_CHGPROCCNT                      =0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00639ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if (strcmp(u.version, "Darwin Kernel Version 16.6.0: Mon Apr 17 17:33:35 PDT 2017; root:xnu-3789.60.24~24/RELEASE_ARM64_T7001") == 0) {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d474;
            OFFSET_COPYOUT                         =0xfffffff00718d668;
            OFFSET_CHGPROCCNT                      =0xfffffff00739acd8;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007375090;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744de64;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063a4a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if (strcmp(u.version, "Darwin Kernel Version 16.7.0: Thu Jun 15 18:33:36 PDT 2017; root:xnu-3789.70.16~4/RELEASE_ARM64_T7000") == 0) {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d028;
            OFFSET_COPYOUT                         =0xfffffff00718d21c;
            OFFSET_CHGPROCCNT                      =0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff00639ca84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
        else if (strcmp(u.version, "Darwin Kernel Version 16.7.0: Thu Jun 15 18:33:35 PDT 2017; root:xnu-3789.70.16~4/RELEASE_ARM64_T7001") == 0) {
            OFFSET_ZONE_MAP                        =0xfffffff007558478;
            OFFSET_KERNEL_MAP                      =0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     =0xfffffff0075b4048;
            OFFSET_REALHOST                        =0xfffffff00753aba0;
            OFFSET_COPYIN                          =0xfffffff00718d120;
            OFFSET_COPYOUT                         =0xfffffff00718d314;
            OFFSET_CHGPROCCNT                      =0xfffffff00739ac28;
            OFFSET_KAUTH_CRED_REF                  =0xfffffff007374fb4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          =0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 =0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              =0xfffffff0070a5bd8;
            OFFSET_OSSERIALIZER_SERIALIZE          =0xfffffff00744ddb4;
            OFFSET_ROP_LDR_X0_X0_0x10              =0xfffffff0063a4a84;
            OFFSET_ROOT_MOUNT_V_NODE               =0xfffffff0075b40b0;
        }
    } else {
        LOG("Device not supported.");
        return KERN_FAILURE;
    }
    
    return KERN_SUCCESS;
}
