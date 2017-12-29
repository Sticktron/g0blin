//
//  remount.m
//  g0blin
//
//  Created by Sticktron on 2017-12-27.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 qwertyoruiop. All rights reserved.
//

#include "offsets.h"
#include "common.h"
#include "kernel.h"
#include <sys/mount.h>


#define KSTRUCT_OFFSET_MOUNT_MNT_FLAG   0x70
#define KSTRUCT_OFFSET_VNODE_V_UN       0xd8


kern_return_t do_remount(uint64_t slide) {
    
    uint64_t _rootnode = OFFSET_ROOT_MOUNT_V_NODE + slide;
    uint64_t rootfs_vnode = rk64(_rootnode);
    
    // read flags
    uint64_t v_mount = rk64(rootfs_vnode + KSTRUCT_OFFSET_VNODE_V_UN);
    uint32_t v_flag = rk32(v_mount + KSTRUCT_OFFSET_MOUNT_MNT_FLAG + 1);
    
    // unset rootfs flag
    wk32(v_mount + KSTRUCT_OFFSET_MOUNT_MNT_FLAG + 1, v_flag & (~(0x1<<6)));
    
    // remount
    char *nmz = strdup("/dev/disk0s1s1");
    int lolr = mount("hfs", "/", MNT_UPDATE, (void *)&nmz);
    if (lolr == -1) {
        LOG("ERROR: could not remount '/'");
        return KERN_FAILURE;
    }
    LOG("successfully remounted '/'");
    
    // set original flags back
    v_mount = rk64(rootfs_vnode + KSTRUCT_OFFSET_VNODE_V_UN);
    wk32(v_mount + KSTRUCT_OFFSET_MOUNT_MNT_FLAG + 1, v_flag);
    
    return KERN_SUCCESS;
}
