//
//  remount.h
//  g0blin
//
//  Created by Sticktron on 2017-12-27.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 qwertyoruiop. All rights reserved.
//

#ifndef remount_h
#define remount_h

#include <stdio.h>
#include <mach/mach.h>

kern_return_t do_remount(uint64_t slide);

#endif /* remount_h */
