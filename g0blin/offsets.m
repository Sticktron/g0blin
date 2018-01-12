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
#include <sys/sysctl.h>


uint64_t OFFSET_ZONE_MAP;
uint64_t OFFSET_KERNEL_MAP;
uint64_t OFFSET_KERNEL_TASK;
uint64_t OFFSET_REALHOST;
uint64_t OFFSET_BZERO;
uint64_t OFFSET_BCOPY;
uint64_t OFFSET_COPYIN;
uint64_t OFFSET_COPYOUT;
uint64_t OFFSET_IPC_PORT_ALLOC_SPECIAL;
uint64_t OFFSET_IPC_KOBJECT_SET;
uint64_t OFFSET_IPC_PORT_MAKE_SEND;
uint64_t OFFSET_IOSURFACEROOTUSERCLIENT_VTAB;
uint64_t OFFSET_OSSERIALIZER_SERIALIZE;
uint64_t OFFSET_ROP_ADD_X0_X0_0x10;
uint64_t OFFSET_ROOT_MOUNT_V_NODE;


kern_return_t init_offsets()
{
    LOG("Detecting device and OS...");
    
    kern_return_t error = KERN_SUCCESS;
    
    //read device id
    int d_prop[2] = {CTL_HW, HW_MACHINE};
    char device[20];
    size_t d_prop_len = sizeof(device);
    //sysctl(d_prop, 2, NULL, &d_prop_len, NULL, 0);
    sysctl(d_prop, 2, device, &d_prop_len, NULL, 0);
    LOG("device: %s", device);
    
    int version_prop[2] = {CTL_KERN, KERN_OSVERSION};
    char osversion[20];
    size_t version_prop_len = sizeof(osversion);
    //sysctl(version_prop, 2, NULL, &version_prop_len, NULL, 0);
    sysctl(version_prop, 2, osversion, &version_prop_len, NULL, 0);
    LOG("version: %s", osversion);
    
    
    // iPhone 6
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
        }
    }
    
    // iPhone 6s
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006462174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
        
        
        // 10.3.2 --------------------------------------------------------------
        // offically working offsets by sticktron.
        //----------------------------------------------------------------------
        if(!strcmp(osversion, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007548478; /* "zone_init: kmem_suballoc failed" */
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a4048;
            OFFSET_REALHOST                             = 0xfffffff00752aba0; /* host_priv_self */
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff0071806f4;
            OFFSET_COPYOUT                              = 0xfffffff0071808e8;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099e94; /* convert_task_suspension_token_to_port */
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad16c; /* convert_task_suspension_token_to_port */
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070999b8; /* "ipc_host_init" */
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064b1398;
            OFFSET_ROOT_MOUNT_V_NODE                    = 0xfffffff0075a40b0;
        }
        //----------------------------------------------------------------------
        
        
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
    }
    
    // iPad Air (WiFi), iPad Air (China) and iPad Air (Cellular)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fe174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006502174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006501174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006501174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
        }
    }
    
    // iPad Mini 2 (Cellular), iPad Mini 2 (WiFi) and iPad Mini 2 (China)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fe174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fe174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fd174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064fd174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
        }
    }
    
    // iPad Air (WiFi)
    if(!strcmp(device, "iPad4,1"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f336a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00650dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
    }
    
    // iPad Mini 2 (Cellular)
    if(!strcmp(device, "iPad4,5"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f336a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00650dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
    }
    
    // iPad Mini 2 (WiFi)
    if(!strcmp(device, "iPad4,4"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f336a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00650dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
    }
    
    // iPad Air (China)
    if(!strcmp(device, "iPad4,3"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f336a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00650dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
        
    }
    
    // iPad Air (Cellular)
    if(!strcmp(device, "iPad4,2"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f336a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00650dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
        
    }
    
    // iPad Mini 2 (China)
    if(!strcmp(device, "iPad4,6"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f336a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00650dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
        
    }
    
    // iPad Mini 3 (Cellular), iPad Mini 3 (WiFi) and iPad Mini 3 (China)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064ba174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064be174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064bd174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064bd174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064be174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
        }
    }
    
    // iPad Air 2 (Cellular) and iPad Air 2 (WiFi)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006456174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006456174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006459174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006459174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006456174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
        }
    }
    
    // iPad Mini 4 (Cellular) and iPad Mini 4 (WiFi)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644e174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644e174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644d174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644d174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ecdd38;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00644e174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
        }
    }
    
    // iPad Mini 3 (Cellular)
    if(!strcmp(device, "iPad4,8"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f32a60;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064cdfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
    }
    
    // iPad Mini 3 (WiFi)
    if(!strcmp(device, "iPad4,7"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f32a60;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064cdfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
        
    }
    
    // iPad Air 2 (Cellular)
    if(!strcmp(device, "iPad5,4"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007566360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075c2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075c2050;
            OFFSET_REALHOST                        = 0xfffffff007548a98;
            OFFSET_BZERO                           = 0xfffffff00708e140;
            OFFSET_BCOPY                           = 0xfffffff00708df80;
            OFFSET_COPYIN                          = 0xfffffff00718f864;
            OFFSET_COPYOUT                         = 0xfffffff00718fa6c;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a6200;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b98a0;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5d44;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ed93e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006471fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075c20b8;
        }
        
    }
    
    // iPad Mini 4 (Cellular)
    if(!strcmp(device, "iPad5,2"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007566360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075c2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075c2050;
            OFFSET_REALHOST                        = 0xfffffff007548a98;
            OFFSET_BZERO                           = 0xfffffff00708e140;
            OFFSET_BCOPY                           = 0xfffffff00708df80;
            OFFSET_COPYIN                          = 0xfffffff00718f76c;
            OFFSET_COPYOUT                         = 0xfffffff00718f974;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a6200;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b98a0;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5d44;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ed93e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006469fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075c20b8;
        }
        
    }
    
    // iPad Air 2 (WiFi)
    if(!strcmp(device, "iPad5,3"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007566360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075c2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075c2050;
            OFFSET_REALHOST                        = 0xfffffff007548a98;
            OFFSET_BZERO                           = 0xfffffff00708e140;
            OFFSET_BCOPY                           = 0xfffffff00708df80;
            OFFSET_COPYIN                          = 0xfffffff00718f864;
            OFFSET_COPYOUT                         = 0xfffffff00718fa6c;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a6200;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b98a0;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5d44;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ed93e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006471fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075c20b8;
        }
        
    }
    
    // iPad Mini 4 (WiFi)
    if(!strcmp(device, "iPad5,1"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007566360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075c2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075c2050;
            OFFSET_REALHOST                        = 0xfffffff007548a98;
            OFFSET_BZERO                           = 0xfffffff00708e140;
            OFFSET_BCOPY                           = 0xfffffff00708df80;
            OFFSET_COPYIN                          = 0xfffffff00718f76c;
            OFFSET_COPYOUT                         = 0xfffffff00718f974;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a6200;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b98a0;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5d44;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ed93e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006469fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075c20b8;
        }
        
    }
    
    // iPad Mini 3 (China)
    if(!strcmp(device, "iPad4,9"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f32a60;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064cdfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
        
    }
    
    // iPad 5 (Cellular) and iPad 5 (WiFi)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e61cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006426174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e65cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00642a174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e65cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006429174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e65cb8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006429174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
    }
    
    // iPad Pro 9.7-inch (WiFi) and iPad Pro 9.7-inch (Cellular)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00633e0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063420c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063410c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e3d738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063410c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
    }
    
    // iPad Pro 9.7-inch (WiFi)
    if(!strcmp(device, "iPad6,3"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007556360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b2050;
            OFFSET_REALHOST                        = 0xfffffff007538a98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff007182af0;
            OFFSET_COPYOUT                         = 0xfffffff007182cf8;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099fe0;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad680;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099b24;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e4d5e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006376140;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b20b8;
        }
    }
    
    // iPad Pro 9.7-inch (Cellular)
    if(!strcmp(device, "iPad6,4"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007556360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b2050;
            OFFSET_REALHOST                        = 0xfffffff007538a98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff007182af0;
            OFFSET_COPYOUT                         = 0xfffffff007182cf8;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099fe0;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad680;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099b24;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e4d5e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006376140;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b20b8;
        }
        
    }
    
    // iPad Pro 12.9-inch (Cellular) and iPad Pro 12.9-inch (WiFi)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637e0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637e0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637d0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e49738;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00637d0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
    }
    
    // iPad Pro 12.9-inch (Cellular)
    if(!strcmp(device, "iPad6,8"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007556360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b2050;
            OFFSET_REALHOST                        = 0xfffffff007538a98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff007182af0;
            OFFSET_COPYOUT                         = 0xfffffff007182cf8;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099fe0;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad680;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099b24;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e595e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063aa140;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b20b8;
        }
        
    }
    
    // iPad Pro 12.9-inch (WiFi)
    if(!strcmp(device, "iPad6,7"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007556360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b2050;
            OFFSET_REALHOST                        = 0xfffffff007538a98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff007182af0;
            OFFSET_COPYOUT                         = 0xfffffff007182cf8;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099fe0;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad680;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099b24;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e595e0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0063aa140;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b20b8;
        }
        
    }
    
    // iPad Pro 2 (12.9-inch, WiFi) and iPad Pro 2 (12.9-inch, Cellular)
    if(!strcmp(device, "iPad7,1") || !strcmp(device, "iPad7,2"))
    {
        // 10.3.3
        if(!strcmp(osversion, "14G60"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075ec048;
            OFFSET_REALHOST                        = 0xfffffff007572ba0;
            OFFSET_BZERO                           = 0xfffffff0070c1f80;
            OFFSET_BCOPY                           = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                          = 0xfffffff0071c5ecc;
            OFFSET_COPYOUT                         = 0xfffffff0071c61ac;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070df014;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070f22ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070deb38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ec1578;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00632e0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075ec0b0;
        }
        // 10.3.2
        if(!strcmp(osversion, "14F8089"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075ec048;
            OFFSET_REALHOST                        = 0xfffffff007572ba0;
            OFFSET_BZERO                           = 0xfffffff0070c1f80;
            OFFSET_BCOPY                           = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                          = 0xfffffff0071c6220;
            OFFSET_COPYOUT                         = 0xfffffff0071c6500;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070df014;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070f22ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070deb38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ec1578;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00632e0c8;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075ec0b0;
        }
    }
    
    
    // iPhone SE
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006482174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006482174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006481174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006481174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007556360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b2050;
            OFFSET_REALHOST                        = 0xfffffff007538a98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff007182af0;
            OFFSET_COPYOUT                         = 0xfffffff007182cf8;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099fe0;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad680;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099b24;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e8c820;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00649dfb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b20b8;
        }
    }
    
    // iPhone 5s (Global) and iPhone 5s (GSM)
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006522174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006526174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006525174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006525174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a80b0;
        }
    }
    
    // iPhone 5s (Global)
    if(!strcmp(device, "iPhone6,2"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2ca20;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006531fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
        
    }
    
    // iPhone 5s (GSM)
    if(!strcmp(device, "iPhone6,1"))
    {
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff00755a360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b6058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b6050;
            OFFSET_REALHOST                        = 0xfffffff00753ca98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff0071835dc;
            OFFSET_COPYOUT                         = 0xfffffff0071837e4;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff00709a060;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad700;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099ba4;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006f2ca20;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006531fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b60b8;
        }
    }
    
    // iPhone 6+
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b2174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006eee1b8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064b5174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
        }
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007566360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075c2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075c2050;
            OFFSET_REALHOST                        = 0xfffffff007548a98;
            OFFSET_BZERO                           = 0xfffffff00708e140;
            OFFSET_BCOPY                           = 0xfffffff00708df80;
            OFFSET_COPYIN                          = 0xfffffff00718f76c;
            OFFSET_COPYOUT                         = 0xfffffff00718f974;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a6200;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b98a0;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5d44;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef57a0;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff0064c1fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075c20b8;
        }
        
    }
    
    // iPhone 6s+
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006462174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006466174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099efc;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad154;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099a20;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006465174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075a40b0;
        }
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007556360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075b2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075b2050;
            OFFSET_REALHOST                        = 0xfffffff007538a98;
            OFFSET_BZERO                           = 0xfffffff007082140;
            OFFSET_BCOPY                           = 0xfffffff007081f80;
            OFFSET_COPYIN                          = 0xfffffff007182af0;
            OFFSET_COPYOUT                         = 0xfffffff007182cf8;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff007099fe0;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070ad680;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff007099b24;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006e84820;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006481fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b20b8;
        }
        
    }
    
    // iPod touch 6
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651a174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651e174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651d174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
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
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006ef2d78;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff00651d174;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075b40b0;
        }
        // 10.2.1
        if(!strcmp(osversion, "14D27"))
        {
            OFFSET_ZONE_MAP                        = 0xfffffff007566360;
            OFFSET_KERNEL_MAP                      = 0xfffffff0075c2058;
            OFFSET_KERNEL_TASK                     = 0xfffffff0075c2050;
            OFFSET_REALHOST                        = 0xfffffff007548a98;
            OFFSET_BZERO                           = 0xfffffff00708e140;
            OFFSET_BCOPY                           = 0xfffffff00708df80;
            OFFSET_COPYIN                          = 0xfffffff00718f76c;
            OFFSET_COPYOUT                         = 0xfffffff00718f974;
            
            OFFSET_IPC_PORT_ALLOC_SPECIAL          = 0xfffffff0070a6200;
            OFFSET_IPC_KOBJECT_SET                 = 0xfffffff0070b98a0;
            OFFSET_IPC_PORT_MAKE_SEND              = 0xfffffff0070a5d44;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB    = 0xfffffff006efa320;
            OFFSET_ROP_ADD_X0_X0_0x10              = 0xfffffff006529fb0;
            
            OFFSET_ROOT_MOUNT_V_NODE               = 0xfffffff0075c20b8;
        }
        
        
    }
    
    
    
    if(!OFFSET_ZONE_MAP)
    {
        LOG("%s on %s isn't supported", device, osversion);
        error = KERN_FAILURE;
    }
    else
    {
        LOG("loading offsets for %s - %s", device, osversion);
        LOG("test offset ZONE_MAP: %llx", OFFSET_ZONE_MAP);
        error = KERN_SUCCESS;
    }
    
    return error;
}
