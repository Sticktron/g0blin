//
//  offsets.m
//  g0blin
//
//  Created by Sticktron on 2017-12-26.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "offsets.h"
#import "common.h"
#include <sys/utsname.h>
#include <sys/sysctl.h>
#include <mach/mach.h>

uint64_t OFFSET_ZONE_MAP;
uint64_t OFFSET_KERNEL_MAP;
uint64_t OFFSET_KERNEL_TASK;
uint64_t OFFSET_REALHOST;
uint64_t OFFSET_COPYIN;
uint64_t OFFSET_COPYOUT;
uint64_t OFFSET_IPC_PORT_ALLOC_SPECIAL;
uint64_t OFFSET_IPC_KOBJECT_SET;
uint64_t OFFSET_IPC_PORT_MAKE_SEND;
uint64_t OFFSET_CHGPROCCNT;
uint64_t OFFSET_KAUTH_CRED_REF;
uint64_t OFFSET_OSSERIALIZER_SERIALIZE;
uint64_t OFFSET_ROP_LDR_X0_X0_0x10;
uint64_t OFFSET_ROOTVNODE;

uint64_t OFFSET_BZERO;
uint64_t OFFSET_BCOPY;
uint64_t OFFSET_IOSURFACEROOTUSERCLIENT_VTAB;
uint64_t OFFSET_ROP_ADD_X0_X0_0x10;

uint64_t OFFSET_KERNEL_BASE;


kern_return_t init_offsets()
{
    LOG("Detecting device and OS...");
    
    //read device id
    int d_prop[2] = {CTL_HW, HW_MACHINE};
    char device[20];
    size_t d_prop_len = sizeof(device);
    sysctl(d_prop, 2, device, &d_prop_len, NULL, 0);
    LOG("device: %s", device);
    
    int version_prop[2] = {CTL_KERN, KERN_OSVERSION};
    char osversion[20];
    size_t version_prop_len = sizeof(osversion);
    sysctl(version_prop, 2, osversion, &version_prop_len, NULL, 0);
    LOG("version: %s", osversion);
    
    
    
/*
 
Supported devices ...

iPod7,1 - iPod 6


iPhone6,1 - iPhone 5S (Global)
iPhone6,2 - iPhone 5S (GSM)

iPhone7,1 - iPhone 6+
iPhone7,2 - iPhone 6
 
iPhone8,1 - iPhone 6S
iPhone8,2 - iPhone 6S+

iPhone8,4 - iPhone SE

 
iPad4,1 - iPad Air (WiFi)
iPad4,2 - iPad Air (Cellular)
iPad4,3 - iPad Air (China)

iPad4,4 - iPad Mini 2 (WiFi)
iPad4,5 - iPad Mini 2 (Cellular)
iPad4,6 - iPad Mini 2 (China)

iPad4,7 - iPad Mini 3 (WiFi)
iPad4,8 - iPad Mini 3 (Cellular)
iPad4,9 - iPad Mini 3 (China)

iPad5,1 - iPad Mini 4 (WiFi)
iPad5,2 - iPad Mini 4 (Cellular)
 
iPad5,3 - iPad Air 2 (Cellular)
iPad5,4 - iPad Air 2 (WiFi)

iPad6,3 - iPad Pro 9.7" (WiFi)
iPad6,4 - iPad Pro 9.7" (Cellular)

iPad6,7 - iPad Pro 12.9" (WiFi)
iPad6,8 - iPad Pro 12.9" (Cellular)

 
iPad6,11 - iPad 5/2017 (WiFi)
iPad6,12 - iPad 5/2017 (Cellular)
 
*/

    
//------------------------------------------------------------------------------
    
#pragma mark iPhone 6 (iPhone7,2)
    
    if(!strcmp(device, "iPhone7,2"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d028;
            OFFSET_COPYOUT                         = 0xfffffff00718d21c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006400a84;
            
            
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d37c;
            OFFSET_COPYOUT                         = 0xfffffff00718d570;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006400a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006404a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006404a84;
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPhone 6S (iPhone 8,1)
    
    if(!strcmp(device, "iPhone8,1"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071803a0;
            OFFSET_COPYOUT                         = 0xfffffff007180594;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006462174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b0a84;
        }
        
        
        
        
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b1398;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b4a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b4a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b4a84;
        }
    }
    
    
//------------------------------------------------------------------------------

#pragma mark - iPad Air (iPad4,1/iPad4,2/iPad4,3)
    
    if(!strcmp(device, "iPad4,1") || !strcmp(device, "iPad4,3") || !strcmp(device, "iPad4,2"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180e98;
            OFFSET_COPYOUT                         = 0xfffffff00718108c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e77c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368b08;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fe174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441908;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00644ca84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071811ec;
            OFFSET_COPYOUT                         = 0xfffffff0071813e0;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006502174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006450a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006501174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006450a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006501174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006450a84;
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPad Mini 2 (iPad4,4/iPad4,5/iPad4,6)

    if(!strcmp(device, "iPad4,5") || !strcmp(device, "iPad4,4") || !strcmp(device, "iPad4,6"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180e98;
            OFFSET_COPYOUT                         = 0xfffffff00718108c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e77c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368b08;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fe174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441908;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00644ca84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071811ec;
            OFFSET_COPYOUT                         = 0xfffffff0071813e0;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fe174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00644ca84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fd174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00644ca84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fd174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00644ca84;
        }
    }
    
    
//------------------------------------------------------------------------------

#pragma mark iPad Mini 3 (iPad4,7/iPad4,8/iPad4,9)
    
    if(!strcmp(device, "iPad4,8") || !strcmp(device, "iPad4,7") || !strcmp(device, "iPad4,9"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180e98;
            OFFSET_COPYOUT                         = 0xfffffff00718108c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e77c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368b08;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064ba174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441908;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006408a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071811ec;
            OFFSET_COPYOUT                         = 0xfffffff0071813e0;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064be174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00640ca84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064bd174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00640ca84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064bd174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00640ca84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F91"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071811ec;
            OFFSET_COPYOUT                         = 0xfffffff0071813e0;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064be174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00640ca84;
        }
    }
    
    
//------------------------------------------------------------------------------

#pragma mark iPad Air 2 (iPad5,3/iPad5,4)
    
    if(!strcmp(device, "iPad5,4") || !strcmp(device, "iPad5,3"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d120;
            OFFSET_COPYOUT                         = 0xfffffff00718d314;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739ac28;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374fb4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006456174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744ddb4;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063a4a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d474;
            OFFSET_COPYOUT                         = 0xfffffff00718d668;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739acd8;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007375090;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006456174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744de64;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063a4a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d4a0;
            OFFSET_COPYOUT                         = 0xfffffff00718d694;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a9b0;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374d50;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006459174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d8d0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063a8a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d4a0;
            OFFSET_COPYOUT                         = 0xfffffff00718d694;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a9b0;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374d50;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006459174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d8d0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063a8a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F91"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d474;
            OFFSET_COPYOUT                         = 0xfffffff00718d668;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739acd8;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007375090;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006456174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744de64;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063a4a84;
        }
    }
    
    
//------------------------------------------------------------------------------

#pragma mark iPad Mini 4 (iPad5,2/iPad5,1)
    
    if(!strcmp(device, "iPad5,2") || !strcmp(device, "iPad5,1"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d028;
            OFFSET_COPYOUT                         = 0xfffffff00718d21c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644e174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00639ca84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d37c;
            OFFSET_COPYOUT                         = 0xfffffff00718d570;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644e174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00639ca84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644d174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00639ca84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644d174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00639ca84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F91"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d37c;
            OFFSET_COPYOUT                         = 0xfffffff00718d570;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644e174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00639ca84;
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPad 5 (iPad6,12/iPad6,11)
    
    if(!strcmp(device, "iPad6,12") || !strcmp(device, "iPad6,11"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071803a0;
            OFFSET_COPYOUT                         = 0xfffffff007180594;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e61cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006426174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006374a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F90"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e65cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00642a174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006378a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e65cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006429174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006378a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e65cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006429174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006378a84;
        }
    }
    
    
//------------------------------------------------------------------------------

#pragma mark iPad Pro 9.7" (iPad6,3/iPad6,4)
    
    if(!strcmp(device, "iPad6,3") || !strcmp(device, "iPad6,4"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071803a0;
            OFFSET_COPYOUT                         = 0xfffffff007180594;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00633e0c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006254a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063420c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006258a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063410c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006258a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063410c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006258a84;
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPad Pro 12.9" (iPad6,7/iPad6,8)
    
    if(!strcmp(device, "iPad6,8") || !strcmp(device, "iPad6,7"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071803a0;
            OFFSET_COPYOUT                         = 0xfffffff007180594;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637e0c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006294a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637e0c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006294a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637d0c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006294a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637d0c8;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006294a84;
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark - iPhone SE (iPhone8,4)
    
    if(!strcmp(device, "iPhone8,4"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071803a0;
            OFFSET_COPYOUT                         = 0xfffffff007180594;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006482174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063d0a84;
        }
        
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006482174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063d0a84;
        }
        
        // 10.3.2 Beta
        if (!strcmp(osversion, "14F5065b"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006482174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063d0a84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006481174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063d0a84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006481174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063d0a84;
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPhone 5S (iPhone6,1, iPhone6,2)
    
    if(!strcmp(device, "iPhone6,2") || !strcmp(device, "iPhone6,1"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180e98;
            OFFSET_COPYOUT                         = 0xfffffff00718108c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e77c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368b08;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006522174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441908;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006470a84;
            
            
        }
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071811ec;
            OFFSET_COPYOUT                         = 0xfffffff0071813e0;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e82c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007368be4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006526174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff0074419b8;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006474a84;
            
            
        }
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006525174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006474a84;
            
            
        }
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a8048;
            OFFSET_REALHOST                        = 0xfffffff00752eba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007181218;
            OFFSET_COPYOUT                         = 0xfffffff00718140c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a80b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738e504;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073688a4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006525174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007441424;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006474a84;
            
            
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPhone 6+ (iPhone7,1)
    
    if(!strcmp(device, "iPhone7,1"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d028;
            OFFSET_COPYOUT                         = 0xfffffff00718d21c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006400a84;
            
            
        }
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d37c;
            OFFSET_COPYOUT                         = 0xfffffff00718d570;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006400a84;
            
            
        }
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006404a84;
            
            
        }
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006404a84;
            
            
        }
    }
    
    
//------------------------------------------------------------------------------
    
#pragma mark iPhone 6S+ (iPhone8,2)
    
    if(!strcmp(device, "iPhone8,2"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071803a0;
            OFFSET_COPYOUT                         = 0xfffffff007180594;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d894;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367c18;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006462174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440a20;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b0a84;
            
            
        }
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff0071806f4;
            OFFSET_COPYOUT                         = 0xfffffff0071808e8;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d944;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007367cf4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006466174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff007440ad0;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b4a84;
            
            
        }
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b4a84;
            
            
        }
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075a4048;
            OFFSET_REALHOST                        = 0xfffffff00752aba0;
            OFFSET_BZERO                           = 0xfffffff007081f80;
            OFFSET_BCOPY                           = 0xfffffff007081dc0;
            OFFSET_COPYIN                          = 0xfffffff007180720;
            OFFSET_COPYOUT                         = 0xfffffff007180914;
            OFFSET_ROOTVNODE                       = 0xfffffff0075a40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00738d61c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff0073679b4;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744053c;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff0063b4a84;
            
            
        }
    }
    
    
//------------------------------------------------------------------------------

#pragma mark - iPod 6 (iPod7,1)
    
    if(!strcmp(device, "iPod7,1"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d028;
            OFFSET_COPYOUT                         = 0xfffffff00718d21c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aa04;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374d90;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651a174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744db90;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff006468a84;
            
            
        }
        // 10.3.2
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d37c;
            OFFSET_COPYOUT                         = 0xfffffff00718d570;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739aab4;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374e6c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651e174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744dc40;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00646ca84;
        }
        
        // 10.3.1
        if(!strcmp(osversion, "14E304"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651d174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00646ca84;
        }
        
        // 10.3
        if(!strcmp(osversion, "14E277"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b4048;
            OFFSET_REALHOST                        = 0xfffffff00753aba0;
            OFFSET_BZERO                           = 0xfffffff00708df80;
            OFFSET_BCOPY                           = 0xfffffff00708ddc0;
            OFFSET_COPYIN                          = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                         = 0xfffffff00718d59c;
            OFFSET_ROOTVNODE                       = 0xfffffff0075b40b0;
            OFFSET_CHGPROCCNT                      = 0xfffffff00739a78c;
            OFFSET_KAUTH_CRED_REF                  = 0xfffffff007374b2c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651d174;
            OFFSET_OSSERIALIZER_SERIALIZE          = 0xfffffff00744d6ac;
            OFFSET_ROP_LDR_X0_X0_0x10              = 0xfffffff00646ca84;
        }
    }
    
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
    
    
    if (!OFFSET_ZONE_MAP) {
        LOG("%s on %s isn't supported", device, osversion);
        return KERN_FAILURE;
    }
    
    LOG("loading offsets for %s - %s", device, osversion);
    LOG("test offset ZONE_MAP: %llx", OFFSET_ZONE_MAP);
    
    return KERN_SUCCESS;
}
