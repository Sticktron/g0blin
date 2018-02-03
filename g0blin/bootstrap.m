//
//  bootstrap.m
//  g0blin
//
//  Created by Sticktron on 2017-12-27.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 qwertyoruiop. All rights reserved.
//

#import "common.h"
#include <sys/spawn.h>
#include <sys/stat.h>
#include <copyfile.h>
#include <mach-o/dyld.h>

extern int (*gsystem)(const char *);


// void touch_file(char *path) {
//     fclose(fopen(path, "w+"));
// }


kern_return_t do_bootstrap(bool force) {
    
    
    //--------------------------------------------------------------------------
    /* Cleanup from RC0/RC1 */
    
    unlink("/.installed_g0blin");
    unlink("/.installed_g0blin_rc0");
    unlink("/.installed_g0blin_rc1");

    //gsystem("touch /.installed_g0blin_rc2");
    open("/.installed_g0blin_rc2", O_RDWR|O_CREAT, 0644);
    
    // cleanup hosts file
    
    // uninstall dropbear
    //unlink("/Library/LaunchDaemons/dropbear.plist");
    //unlink("/etc/dropbear/dropbear_ecdsa_host_key");
    //unlink("/etc/dropbear/dropbear_rsa_host_key");
    //rmdir("/etc/dropbear");
    //unlink("/usr/local/bin/dropbear");
    //unlink("/usr/local/bin/dropbearconvert");
    //unlink("/usr/local/bin/dropbearkey");
    
    // set SBShowNonDefaultSystemApps = YES in com.apple.springboard.plist
    gsystem("killall -SIGSTOP cfprefsd");
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    [plist setObject:@YES forKey:@"SBShowNonDefaultSystemApps"];
    [plist writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically:YES];
    gsystem("killall -9 cfprefsd");
    
    // set SBShowNonDefaultSystemApps = YES in com.apple.springboard.plist
    //CFStringRef appName = CFSTR("com.apple.springboard");
    //CFPreferencesAppSynchronize(appName);
    //CFPreferencesSetAppValue(CFSTR("SBShowNonDefaultSystemApps"), kCFBooleanTrue, appName);
    //CFPreferencesAppSynchronize(appName);
    
    //--------------------------------------------------------------------------
    
    
    // Install Cydia if necessary or requested
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app/"] || force) {
        LOG("installing Cydia...");
        
        // copy launchctl
        unlink("/bin/launchctl");
        NSString *launchctl = [[NSBundle mainBundle] URLForResource:@"launchctl" withExtension:@""].path;
        copyfile([launchctl UTF8String], "/bin/launchctl", 0, COPYFILE_ALL);
        chmod("/bin/launchctl", 0755);
        
        // copy tar
        unlink("/bin/tar");
        NSString *tar = [[NSBundle mainBundle] URLForResource:@"tar" withExtension:@""].path;
        copyfile([tar UTF8String], "/bin/tar", 0, COPYFILE_ALL);
        chmod("/bin/tar", 0755);
        
        // unpack bootstrap.tar
        NSString *bootstrap = [[NSBundle mainBundle] URLForResource:@"bootstrap" withExtension:@"tar"].path;
        pid_t pid;
        posix_spawn(&pid, "/bin/tar", 0, 0, (char**)&(const char*[]){"/bin/tar", "--preserve-permissions", "--no-overwrite-dir", "-C", "/", "-xvf", [bootstrap UTF8String], NULL}, NULL);
        waitpid(pid, 0, 0);
        LOG("unpacked bootstrap ");
        
        
        // !!! DO NOT USE TRADITIONAL STASHING !!!
        //gsystem("touch /.cydia_no_stash");
        open("/.cydia_no_stash", O_RDWR|O_CREAT, 0644);
        
        
        // run Cydia install scripts
        LOG("running Cydia extrainst scripts...");
        gsystem("/var/lib/dpkg/info/base.extrainst_");
        gsystem("/var/lib/dpkg/info/firmware-sbin.extrainst_");
        gsystem("/var/lib/dpkg/info/uikittools.extrainst_");
        gsystem("/var/lib/dpkg/info/com.saurik.patcyh.extrainst_");
        
        
        // modify hosts (don't phone home)
        gsystem("echo '127.0.0.1 iphonesubmissions.apple.com' >> /etc/hosts");
        gsystem("echo '127.0.0.1 radarsubmissions.apple.com' >> /etc/hosts");
        
        // modify hosts (block Software Update)
        gsystem("echo '127.0.0.1 mesu.apple.com' >> /etc/hosts");
        
        
        // rebuild icon cache
        LOG("running uicache...");
        gsystem("su -c uicache mobile");
        
        
        LOG("finished installing bootstrap");
    }
    LOG("Cydia is installed");
    
    
    // copy reload script
    unlink("/usr/libexec/reload");
    NSString *reload = [[NSBundle mainBundle] URLForResource:@"reload" withExtension:@""].path;
    copyfile([reload UTF8String], "/usr/libexec/reload", 0, COPYFILE_ALL);
    chmod("/usr/libexec/reload", 0755);
    chown("/usr/libexec/reload", 0, 0);
    
    // copy reload plist
    unlink("/Library/LaunchDaemons/0.reload.plist");
    NSString *reloadPlist = [[NSBundle mainBundle] URLForResource:@"0.reload" withExtension:@"plist"].path;
    copyfile([reloadPlist UTF8String], "/Library/LaunchDaemons/0.reload.plist", 0, COPYFILE_ALL);
    chmod("/Library/LaunchDaemons/0.reload.plist", 0644);
    chown("/Library/LaunchDaemons/0.reload.plist", 0, 0);
    
    
    // permissions fix
    chmod("/private", 0777);
    chmod("/private/var", 0777);
    chmod("/private/var/mobile", 0777);
    chmod("/private/var/mobile/Library", 0777);
    chmod("/private/var/mobile/Library/Preferences", 0777);
    
    
    // kill Software Update
    gsystem("launchctl unload /System/Library/LaunchDaemons/com.apple.mobile.softwareupdated.plist");
    unlink("/System/Library/LaunchDaemons/com.apple.mobile.softwareupdated.plist");
    gsystem("launchctl kill 9 system/com.apple.mobile.softwareupdated");
    
    // obliterate Software Update
    //unlink("/System/Library/PrivateFrameworks/MobileSoftwareUpdate.framework/Support/softwareupdated")
    
    
    // kill OTA updater
    gsystem("rm -rf /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate; touch /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate; chmod 000 /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate; chown 0:0 /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate");
    LOG("killed OTA updater");
    
    
    LOG("finished bootstrapping.");
        
    return KERN_SUCCESS; // TODO: handle errors?
}
