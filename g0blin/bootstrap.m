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

kern_return_t do_bootstrap(bool force) {
    
    // cfprefsd test
    CFStringRef testKey = CFSTR("MikeG");
    CFStringRef testValue = CFSTR("was_here");
    CFPreferencesAppSynchronize(CFSTR("com.apple.springboard"));
    CFPreferencesSetAppValue(testKey, testValue, CFSTR("com.apple.springboard"));
    CFPreferencesAppSynchronize(CFSTR("com.apple.springboard"));
    
    
    /* Cleanup from RC0/RC1 */
    
    unlink("/.installed_g0blin");
    unlink("/.installed_g0blin_rc0");
    
    // uninstall dropbear
    unlink("/Library/LaunchDaemons/dropbear.plist");
    unlink("/etc/dropbear/dropbear_ecdsa_host_key");
    unlink("/etc/dropbear/dropbear_rsa_host_key");
    rmdir("/etc/dropbear");
    unlink("/usr/local/bin/dropbear");
    unlink("/usr/local/bin/dropbearconvert");
    unlink("/usr/local/bin/dropbearkey");
    
    // delete reload daemon and script
    unlink("/usr/libexec/reload");
    unlink("/Library/LaunchDaemons/0.reload.plist");
    
    // set SBShowNonDefaultSystemApps = YES
    gsystem("killall -SIGSTOP cfprefsd");
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    [plist setObject:@YES forKey:@"SBShowNonDefaultSystemApps"];
    [plist writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically:NO];
    gsystem("killall -9 cfprefsd");
    
    // 2x just to be sure
    gsystem("killall -SIGSTOP cfprefsd");
    plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    [plist setObject:@YES forKey:@"SBShowNonDefaultSystemApps"];
    [plist writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically:YES];
    gsystem("killall -9 cfprefsd");
    
    /*****/
    
    
    
    // Install Cydia if necessary or requested
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app/"] || force) {
        LOG("installing Cydia...");
        
        // copy launchctl
        NSString *launchctl = [[NSBundle mainBundle] URLForResource:@"launchctl" withExtension:@""].path;
        unlink("/bin/launchctl");
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
        open("/.cydia_no_stash", O_RDWR|O_CREAT);
        
        // run Cydia install scripts
        LOG("running Cydia extrainst scripts...");
        gsystem("/var/lib/dpkg/info/base.extrainst_");
        gsystem("/var/lib/dpkg/info/firmware-sbin.extrainst_");
        gsystem("/var/lib/dpkg/info/uikittools.extrainst_");
        gsystem("/var/lib/dpkg/info/com.saurik.patcyh.extrainst_");
        
        // don't phone home
        gsystem("echo '127.0.0.1 iphonesubmissions.apple.com' >> /etc/hosts");
        gsystem("echo '127.0.0.1 radarsubmissions.apple.com' >> /etc/hosts");
        
        // don't check for updates
        //gsystem("echo '127.0.0.1 mesu.apple.com' >> /etc/hosts");
        //gsystem("echo '127.0.0.1 appldnld.apple.com' >> /etc/hosts");
        
        // rebuild icon cache
        LOG("running uicache...");
        gsystem("su -c uicache mobile");
        
        LOG("finished installing bootstrap");
    }
    LOG("Cydia is installed");
    
    
    // update permissions
    chmod("/private", 0777);
    chmod("/private/var", 0777);
    chmod("/private/var/mobile", 0777);
    chmod("/private/var/mobile/Library", 0777);
    chmod("/private/var/mobile/Library/Preferences", 0777);

    // stop SU daemon
    unlink("/System/Library/LaunchDaemons/com.apple.mobile.softwareupdated.plist");
    
    // kill OTA updater
    gsystem("rm -rf /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate; touch /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate; chmod 000 /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate; chown 0:0 /var/MobileAsset/Assets/com_apple_MobileAsset_SoftwareUpdate");
    LOG("killed OTA updater");
    
    // load user launchdaemons; do run commands
    gsystem("echo 'really jailbroken';ls /Library/LaunchDaemons | while read a; do launchctl load /Library/LaunchDaemons/$a; done; ls /etc/rc.d | while read a; do /etc/rc.d/$a; done;");
    
    // OpenSSH workaround (won't load via launchdaemon)
    gsystem("launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist;/usr/libexec/sshd-keygen-wrapper");
    
    
    LOG("finished bootstrapping.");
        
    return KERN_SUCCESS; // TODO: handle errors?
}
