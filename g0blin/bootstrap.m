//
//  bootstrap.m
//  g0blin
//
//  Created by Sticktron on 2017-12-27.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 qwertyoruiop. All rights reserved.
//

#include "common.h"
#include <sys/spawn.h>
#include <sys/stat.h>
#include <copyfile.h>
#include <mach-o/dyld.h>


kern_return_t do_bootstrap(bool force) {
    
    char path[256];
    uint32_t size = sizeof(path);
    _NSGetExecutablePath(path, &size);
    char *pt = realpath(path, 0);
    pid_t pd = 0;
    NSString* execpath = [[NSString stringWithUTF8String:pt] stringByDeletingLastPathComponent];
    
    int f = open("/.installed_g0blin", O_RDONLY);
    if (f == -1 || force) {
        LOG("installing bootstrap...");
        
        NSString* bootstrap = [execpath stringByAppendingPathComponent:@"bootstrap.tar"];
        NSString* tar = [execpath stringByAppendingPathComponent:@"tar"];
        NSString* launchctl = [execpath stringByAppendingPathComponent:@"launchctl"];
        
        unlink("/bin/tar");
        unlink("/bin/launchctl");
        
        copyfile([tar UTF8String], "/bin/tar", 0, COPYFILE_ALL);
        chmod("/bin/tar", 0755);
        
        chdir("/");
        posix_spawn(&pd, "/bin/tar", 0, 0, (char**)&(const char*[]){"/bin/tar", "--preserve-permissions", "--no-overwrite-dir", "-xvf", [bootstrap UTF8String], NULL}, NULL);
        waitpid(pd, 0, 0);
        LOG("bootstrap unpacked");
        
        copyfile([launchctl UTF8String], "/bin/launchctl", 0, COPYFILE_ALL);
        chmod("/bin/launchctl", 0755);
        
        open("/.installed_g0blin", O_RDWR|O_CREAT);
        open("/.cydia_no_stash", O_RDWR|O_CREAT);
        
        // run Cydia install scripts
        {
            char *name = "/var/lib/dpkg/info/base.extrainst_";
            posix_spawn(&pd, name, 0, 0, (char**)&(const char*[]){name, NULL}, NULL);
            waitpid(pd, 0, 0);
            
            name = "/var/lib/dpkg/info/com.saurik.patcyh.extrainst_";
            posix_spawn(&pd, name, 0, 0, (char**)&(const char*[]){name, NULL}, NULL);
            waitpid(pd, 0, 0);
            
            name = "/var/lib/dpkg/info/firmware-sbin.extrainst_";
            posix_spawn(&pd, name, 0, 0, (char**)&(const char*[]){name, NULL}, NULL);
            waitpid(pd, 0, 0);
            
            name = "/var/lib/dpkg/info/uikittools.extrainst_";
            posix_spawn(&pd, name, 0, 0, (char**)&(const char*[]){name, NULL}, NULL);
            waitpid(pd, 0, 0);
        }
        LOG("ran Cydia extrainst scripts");
        
        // block some Apple IPs
        posix_spawn(&pd, "/bin/bash", 0, 0, (char**)&(const char*[]){"/bin/bash", "-c", """echo '127.0.0.1 iphonesubmissions.apple.com' >> /etc/hosts""", NULL}, NULL);
        posix_spawn(&pd, "/bin/bash", 0, 0, (char**)&(const char*[]){"/bin/bash", "-c", """echo '127.0.0.1 radarsubmissions.apple.com' >> /etc/hosts""", NULL}, NULL);
        posix_spawn(&pd, "/bin/bash", 0, 0, (char**)&(const char*[]){"/bin/bash", "-c", """echo '127.0.0.1 mesu.apple.com' >> /etc/hosts""", NULL}, NULL);
        posix_spawn(&pd, "/bin/bash", 0, 0, (char**)&(const char*[]){"/bin/bash", "-c", """echo '127.0.0.1 appldnld.apple.com' >> /etc/hosts""", NULL}, NULL);
        LOG("modified hosts file");
        
        // SBShowNonDefaultSystemApps = YES
        posix_spawn(&pd, "killall", 0, 0, (char**)&(const char*[]){"killall", "-SIGSTOP", "cfprefsd", NULL}, NULL);
        NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
        [plist setObject:[NSNumber numberWithBool:YES] forKey:@"SBShowNonDefaultSystemApps"];
        [plist writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically:YES];
        posix_spawn(&pd, "killall", 0, 0, (char**)&(const char*[]){"killall", "-9", "cfprefsd", NULL}, NULL);
        LOG("modified com.apple.springboard.plist");
        
        // update icons
        LOG("uicache...");
        posix_spawn(&pd, "/usr/bin/uicache", 0, 0, (char**)&(const char*[]){"/usr/bin/uicache", NULL}, NULL);
        waitpid(pd, 0, 0);
        
        LOG("finished installing bootstrap");
        
    } else {
        LOG("bootstrap already installed");
    }
    
    // copy reload
    NSString *reload = [execpath stringByAppendingPathComponent:@"reload"];
    unlink("/usr/libexec/reload");
    copyfile([reload UTF8String], "/usr/libexec/reload", 0, COPYFILE_ALL);
    chmod("/usr/libexec/reload", 0755);
    chown("/usr/libexec/reload", 0, 0);
    
    // copy 0.reload.plist
    NSString *reloadPlist = [execpath stringByAppendingPathComponent:@"0.reload.plist"];
    unlink("/Library/LaunchDaemons/0.reload.plist");
    copyfile([reloadPlist UTF8String], "/Library/LaunchDaemons/0.reload.plist", 0, COPYFILE_ALL);
    chmod("/Library/LaunchDaemons/0.reload.plist", 0644);
    chown("/Library/LaunchDaemons/0.reload.plist", 0, 0);
    
    // copy dropbear.plist
    NSString *dropbearPlist = [execpath stringByAppendingPathComponent:@"dropbear.plist"];
    unlink("/Library/LaunchDaemons/dropbear.plist");
    copyfile([dropbearPlist UTF8String], "/Library/LaunchDaemons/dropbear.plist", 0, COPYFILE_ALL);
    chmod("/Library/LaunchDaemons/dropbear.plist", 0644);
    chown("/Library/LaunchDaemons/dropbear.plist", 0, 0);
    
    // stop SU daemon
    unlink("/System/Library/LaunchDaemons/com.apple.mobile.softwareupdated.plist");
    
    // update permissions
    chmod("/private", 0777);
    chmod("/private/var", 0777);
    chmod("/private/var/mobile", 0777);
    chmod("/private/var/mobile/Library", 0777);
    chmod("/private/var/mobile/Library/Preferences", 0777);
    LOG("updated permissions");

    // kill OTA updater
    pid_t pid;
    unlink("/var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate");
    posix_spawn(&pid, "touch", 0, 0, (char**)&(const char*[]){"touch", "/var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate", NULL}, NULL);
    chmod("/var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate", 000);
    chown("/var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate", 0, 0);
    LOG("killed OTA updater");
    
    LOG("finished bootstrapping");
        
    return KERN_SUCCESS;
}
