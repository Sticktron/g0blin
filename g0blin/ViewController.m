//
//  ViewController.m
//  g0blin
//
//  Created by Sticktron on 2017-12-26.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"
#import "SettingsController.h"
#import "v0rtex.h"
#import "common.h"
#import "offsets.h"
#import "kernel.h"
#import "kpp.h"
#import "remount.h"
#import "bootstrap.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#include <sys/utsname.h>


#import "Meter.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/mach_host.h>
#include <mach/mach_time.h>
#include <net/if.h>
#include <net/if_var.h>
#include <net/if_dl.h>

#define    RTM_IFINFO2  0x12 //from route.h

#define GRAPE               [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1]
#define STRAWBERRY          [UIColor colorWithRed:1 green:0 blue:0.5 alpha:1]

#define METER_ICON_COLOR        [UIColor colorWithWhite:0.3 alpha:1]
#define METER_TEXT_COLOR        [UIColor colorWithWhite:0.5 alpha:1]

#define UPDATE_INTERVAL         1.0f
#define WIDGET_HEIGHT           52.0f
#define ICON_HEIGHT             16.0f
#define LABEL_HEIGHT            16.0f

typedef struct {
    uint64_t totalSystemTime;
    uint64_t totalUserTime;
    uint64_t totalIdleTime;
} CPUSample;

typedef struct {
    uint64_t timestamp;
    uint64_t totalDownloadBytes;
    uint64_t totalUploadBytes;
} NetSample;


extern int (*gsystem)(const char *);


@interface UIApplication (private)
- (void)suspend;
- (void)suspendReturningToLastApp:(bool)arg1;
@end

@interface UIImage (private)
+ (id)imageNamed:(id)name inBundle:(id)bundle;
@end


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITextView *consoleView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *reinstallBootstrapLabel;

@property (nonatomic, strong) Meter *cpuMeter;
@property (nonatomic, strong) Meter *ramMeter;
@property (nonatomic, strong) Meter *diskMeter;
@property (nonatomic, strong) Meter *uploadMeter;
@property (nonatomic, strong) Meter *downloadMeter;
@property (nonatomic, strong) NSMutableArray *meters;
@property (nonatomic, strong) NSTimer *meterUpdateTimer;
@property (nonatomic, assign) CPUSample lastCPUSample;
@property (nonatomic, assign) NetSample lastNetSample;
- (void)updateLayout;
@end


static task_t tfp0;
static uint64_t kslide;
static uint64_t kbase;
static uint64_t kcred;
//static uint64_t selfproc;
//static uint64_t origcred;

BOOL respringNeeded;
BOOL fun;
AVPlayer *player;
AVPlayerViewController *cont;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.consoleView.layer.cornerRadius = 6;
    self.consoleView.text = nil;
    
    self.goButton.layer.cornerRadius = 16;
    
    self.reinstallBootstrapLabel.hidden = YES;
    
    // print kernel version
    struct utsname u;
    uname(&u);
    [self log:[NSString stringWithFormat:@"%s \n", u.version]];
    
    
#pragma mark - meters
    
    // create meters
    _cpuMeter = [[Meter alloc] initWithName:@"cpu" title:@"CPU"];
    _ramMeter = [[Meter alloc] initWithName:@"ram" title:@"RAM"];
    _diskMeter = [[Meter alloc] initWithName:@"disk" title:@"DISK"];
    _uploadMeter = [[Meter alloc] initWithName:@"upload" title:@"U/L"];
    _downloadMeter = [[Meter alloc] initWithName:@"download" title:@"D/L"];
    
    // store meters in order
    _meters = [NSMutableArray arrayWithArray:@[ _cpuMeter,
                                                _ramMeter,
                                                _diskMeter,
                                                _uploadMeter,
                                                _downloadMeter ]];
    // create views
    for (Meter *meter in self.meters) {
        UIButton *icon = [[UIButton alloc] init];
        icon.userInteractionEnabled = NO;
        
        UIImage *iconImage = [UIImage imageNamed:meter.name inBundle:[NSBundle mainBundle]];
        iconImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [icon setImage:iconImage forState:UIControlStateNormal];
        icon.tintColor = METER_ICON_COLOR;
        //icon.layer.compositingFilter = @"plusL";
        [self.view addSubview:icon];
        meter.icon = icon;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = meter.title;
        label.textColor = METER_TEXT_COLOR;
        //label.layer.compositingFilter = @"plusL";
        [self.view addSubview:label];
        meter.label = label;
    }
    
#pragma mark -
    
    // abort if already jailbroken
    if (strstr(u.version, "MarijuanARM")) {
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"jailbroke yo!" forState:UIControlStateDisabled];
    }
    
    // try to load offsets for device
    if (init_offsets() == KERN_SUCCESS) {
        [self log:@"Ready. \n"];
    } else {
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"device not supported" forState:UIControlStateDisabled];
    }
    
    // fun
    self.logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun:)];
    tripleTap.delaysTouchesBegan = YES;
    tripleTap.numberOfTapsRequired = 3;
    [self.logoView addGestureRecognizer:tripleTap];
}

- (void)log:(NSString *)text {
    self.consoleView.text = [NSString stringWithFormat:@"%@%@ \n", self.consoleView.text, text];
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    //segue exit marker
    
    SettingsController *settingsController = segue.sourceViewController;
    self.reinstallBootstrapLabel.hidden = !settingsController.reinstallBootstrapSwitch.on;
}

- (IBAction)go:(UIButton *)sender {
    
    [self stopUpdating];
    
    self.goButton.enabled = NO;
    self.goButton.backgroundColor = UIColor.darkGrayColor;
    [self.goButton setTitle:@"jailbreaking" forState:UIControlStateDisabled];
    
    [self log:@"exploiting kernel"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        kern_return_t ret = v0rtex(&tfp0, &kslide, &kcred);
        if (ret != KERN_SUCCESS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.goButton.enabled = YES;
                self.goButton.backgroundColor = GRAPE;
                [self.goButton setTitle:@"try again" forState:UIControlStateNormal];
                
                [self log:@"ERROR: exploit failed \n"];
            });
            return;
        }
        LOG("v0rtex was successful");
        
        LOG("tfp0 -> %x", tfp0);
        LOG("slide -> 0x%llx", kslide);
        kbase = kslide + 0xFFFFFFF007004000;
        LOG("kern base -> 0x%llx", kbase);
        LOG("kern cred -> 0x%llx", kcred);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self bypassKPP];
        });
    });
}

- (void)bypassKPP {
    [self log:@"pwning kernel"];
    
    if (do_kpp(1, 0, kbase, kslide, tfp0) == KERN_SUCCESS) {
        LOG("you down with kpp? yeah you know me");
        [self remount];
    } else {
        [self log:@"ERROR: kpp bypass failed \n"];
    }
}

- (void)remount {
    [self log:@"remounting"];
    
    if (do_remount(kslide) == KERN_SUCCESS) {
        [self bootstrap];
    } else {
        [self log:@"ERROR: failed to remount system partition \n"];
    }
}

- (void)bootstrap {
    [self log:@"bootstrapping"];
    
    BOOL force = NO;
    if (self.reinstallBootstrapLabel.hidden == NO) {
        force = YES;
        [self log:@"(forcing reinstall)"];
    }
    
    if (do_bootstrap(force) == KERN_SUCCESS) {
        [self finish];
    } else {
        [self log:@"ERROR: failed to bootstrap \n"];
    }
}

- (void)finish {
    [self log:@"device is now jailbroken!"];
    [self log:@""];
    
    [self.goButton setTitle:@"finishing" forState:UIControlStateDisabled];
        
    // load user launchdaemons; do run commands
    gsystem("(echo 'really jailbroken'; launchctl load /Library/LaunchDaemons/0.reload.plist)&");
    
    // OpenSSH workaround (won't load via launchdaemon)
    gsystem("launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist;/usr/libexec/sshd-keygen-wrapper");

    LOG("finish() finished.");
}

- (IBAction)fun:(UITapGestureRecognizer *)recognizer {
    LOG("got secret tap 3");
    
    if (!fun) {
        fun = YES;
        
        BOOL hasAudio = [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!hasAudio) {
            LOG("no audio :/");
        }
        
        NSURL *url = [NSBundle.mainBundle URLForResource:@"y0nkers" withExtension:@"m4v"];
        LOG("url = %@", url);
        if (!url) {
            LOG("filenotfound");
            return;
        }
        
        player = [AVPlayer playerWithURL:url];
        cont = [[AVPlayerViewController alloc] init];
        cont.player = player;
        cont.showsPlaybackControls = NO;
        cont.updatesNowPlayingInfoCenter = NO;
        
        cont.view.frame = self.consoleView.bounds;
        [self.consoleView addSubview:cont.view];
        [player play];
        
    } else {
        [player pause];
        [cont.view removeFromSuperview];
        player = nil;
        cont = nil;
        fun = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // make SURE the timer is dead.
    [_meterUpdateTimer invalidate];
    _meterUpdateTimer = nil;
}

- (void)dealloc {
    // make SURE the timer is dead.
    [_meterUpdateTimer invalidate];
    _meterUpdateTimer = nil;
}


#pragma mark - Meters

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LOG("METERS > Starting Meters !!!");
    [self startUpdating];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    LOG("METERS > Stopping Meters.");
    [self stopUpdating];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateLayout];
}

- (void)updateLayout {
    
    // update visibility...
    
    NSMutableArray *visibleMeters = [NSMutableArray array];
    
    for (Meter *meter in self.meters) {
        if (meter.enabled) {
            meter.icon.hidden = NO;
            meter.label.hidden = NO;
            [visibleMeters addObject:meter];
        } else {
            meter.icon.hidden = YES;
            meter.label.hidden = YES;
        }
    }
    
    
    // update position...
    
    int count = (int)visibleMeters.count;
    if (count > 0) {
        int topMargin = (self.goButton.frame.origin.y - ICON_HEIGHT - LABEL_HEIGHT) - 30;
        int width = self.view.bounds.size.width / count;
        int x = 0;
        
        for (Meter *meter in visibleMeters) {
            meter.icon.frame = CGRectMake(x, topMargin, width, ICON_HEIGHT);
            meter.label.frame = CGRectMake(x, topMargin + ICON_HEIGHT, width, LABEL_HEIGHT);
            x += width;
            NSLog(@"Meters: Layed out meter (%@): Icon = %@; Label = %@", meter.name, NSStringFromCGRect(meter.icon.frame), NSStringFromCGRect(meter.label.frame));
        }
    }
}

- (void)startUpdating {
    // bail if the meters are already running
    if ([self.meterUpdateTimer isValid]) {
        //HBLogDebug(@"meters are already running, no need to start them again");
        NSLog(@"meters are already running, no need to start them again");
        
    } else {
        // show placeholder values
        for (Meter *meter in self.meters) {
            meter.label.text = meter.title;
        }
        
        // get new starting measurements
        self.lastCPUSample = [self getCPUSample];
        self.lastNetSample = [self getNetSample];
        
        // start timer
        self.meterUpdateTimer = [NSTimer timerWithTimeInterval:UPDATE_INTERVAL target:self
                                                      selector:@selector(updateMeters:)
                                                      userInfo:nil
                                                       repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.meterUpdateTimer forMode:NSRunLoopCommonModes];
        NSLog(@"Started Timer ••••• (%@)", self.meterUpdateTimer);
    }
}

- (void)stopUpdating {
    if (self.meterUpdateTimer) {
        NSLog(@"Stopping Timer ••••• (%@)", self.meterUpdateTimer);
        [self.meterUpdateTimer invalidate];
        self.meterUpdateTimer = nil;
    }
}

- (void)updateMeters:(NSTimer *)timer {
    //HBLogDebug(@"updateMeters called (timer %@)", timer);
    NSLog(@"updateMeters called (timer %@)", timer);
    
    // Disk Meter: free space on /User
    if (self.diskMeter.enabled) {
        long long bytesFree = [self diskFreeInBytesForPath:@"/private/var"];
        double gigsFree = (double)bytesFree / (1024*1024*1024);
        [self.diskMeter.label setText:[NSString stringWithFormat:@"%.1f GB", gigsFree]];
    }
    
    // RAM Meter: "available" memory (free + inactive)
    if (self.ramMeter.enabled) {
        uint32_t ram = [self memoryAvailableInBytes];
        ram /= (1024*1024); // convert to MB
        [self.ramMeter.label setText:[NSString stringWithFormat:@"%u MB", ram]];
    }
    
    // CPU Meter: percentage of time in use since last sample
    if (self.cpuMeter.enabled) {
        CPUSample cpu_delta;
        CPUSample cpu_sample = [self getCPUSample];
        
        // get usage for period
        cpu_delta.totalUserTime = cpu_sample.totalUserTime - self.lastCPUSample.totalUserTime;
        cpu_delta.totalSystemTime = cpu_sample.totalSystemTime - self.lastCPUSample.totalSystemTime;
        cpu_delta.totalIdleTime = cpu_sample.totalIdleTime - self.lastCPUSample.totalIdleTime;
        
        // calculate time spent in use as a percentage of the total time
        uint64_t total = cpu_delta.totalUserTime + cpu_delta.totalSystemTime + cpu_delta.totalIdleTime;
        //        double idle = (double)(cpu_delta.totalIdleTime) / (double)total * 100.0; // in %
        //        double used = 100.0 - idle;
        double used = ((cpu_delta.totalUserTime + cpu_delta.totalSystemTime) / (double)total) * 100.0;
        
        [self.cpuMeter.label setText:[NSString stringWithFormat:@"%.1f %%", used]];
        
        // save this sample for next time
        self.lastCPUSample = cpu_sample;
    }
    
    
    // Net Meters: bandwidth used during sample period, normalized to per-second values
    if (self.uploadMeter.enabled || self.downloadMeter.enabled) {
        NetSample net_delta;
        NetSample net_sample = [self getNetSample];
        
        // calculate period length
        net_delta.timestamp = (net_sample.timestamp - self.lastNetSample.timestamp);
        double interval = net_delta.timestamp / 1000.0 / 1000.0 / 1000.0; // ns-to-s
        //HBLogDebug(@"Net Meters sample delta: %fs", interval);
        
        // get bytes transferred since last sample was taken
        net_delta.totalUploadBytes = net_sample.totalUploadBytes - self.lastNetSample.totalUploadBytes;
        net_delta.totalDownloadBytes = net_sample.totalDownloadBytes - self.lastNetSample.totalDownloadBytes;
        
        if (self.uploadMeter.enabled) {
            double ul = (double)net_delta.totalUploadBytes / interval;
            self.uploadMeter.label.text = [self formatBytes:ul];
        }
        
        if (self.downloadMeter.enabled) {
            double dl = net_delta.totalDownloadBytes / interval;
            self.downloadMeter.label.text = [self formatBytes:dl];
        }
        
        // save this sample for next time
        self.lastNetSample = net_sample;
    }
}

- (long long)diskFreeInBytesForPath:(NSString *)path {
    long long result = 0;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:nil];
    if (attr && attr[@"NSFileSystemFreeSize"]) {
        result = [attr[@"NSFileSystemFreeSize"] longLongValue];
    }
    return result;
}

- (uint32_t)memoryAvailableInBytes {
    // I'm counting "available" as free + inactive memory
    
    uint32_t bytesAvailable = 0;
    
    // get page size
    vm_size_t pagesize = vm_kernel_page_size;
    NSLog(@"Using page size of: %d bytes", (int)pagesize);
    
    // get stats
    kern_return_t kr;
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vm_stat;
    
    kr = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &count);
    if (kr != KERN_SUCCESS) {
        NSLog(@"Meters] Error getting VM_INFO from host!");
        
    } else {
        unsigned long bytesInactive = vm_stat.inactive_count * pagesize;
        unsigned long bytesFree = vm_stat.free_count * pagesize;
        bytesAvailable = (uint32_t)(bytesFree + bytesInactive);
        NSLog(@"[Meters] Got RAM stats: Free=%lu B; Inactive=%lu B; Total Available=%u B", bytesFree, bytesInactive, bytesAvailable);
    }
    
    return bytesAvailable;
}

- (CPUSample)getCPUSample {
    /*
     CPUSample: { totalUserTime, totalSystemTime, totalIdleTime }
     */
    CPUSample sample = {0, 0, 0};
    
    kern_return_t kr;
    mach_msg_type_number_t count;
    host_cpu_load_info_data_t r_load;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (int *)&r_load, &count);
    
    if (kr != KERN_SUCCESS) {
        NSLog(@"######## Meters: error fetching HOST_CPU_LOAD_INFO !#");
    } else {
        sample.totalUserTime = r_load.cpu_ticks[CPU_STATE_USER] + r_load.cpu_ticks[CPU_STATE_NICE];
        sample.totalSystemTime = r_load.cpu_ticks[CPU_STATE_SYSTEM];
        sample.totalIdleTime = r_load.cpu_ticks[CPU_STATE_IDLE];
    }
    
    //HBLogDebug(@"got CPU sample [ user:%llu; sys:%llu; idle:%llu ]", sample.totalUserTime, sample.totalSystemTime, sample.totalIdleTime);
    
    return sample;
}

- (NetSample)getNetSample {
    /*
     NetSample: { timestamp, totalUploadBytes, totalDownloadBytes }
     */
    NetSample sample = {0, 0, 0};
    
    int mib[] = {
        CTL_NET,
        PF_ROUTE,
        0,
        0,
        NET_RT_IFLIST2,
        0
    };
    
    size_t len = 0;
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) >= 0) {
        char *buf = (char *)malloc(len);
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) >= 0) {
            
            // read interface stats ...
            
            char *lim = buf + len;
            char *next = NULL;
            u_int64_t totalibytes = 0;
            u_int64_t totalobytes = 0;
            char name[32];
            
            for (next = buf; next < lim; ) {
                struct if_msghdr *ifm = (struct if_msghdr *)next;
                next += ifm->ifm_msglen;
                
                if (ifm->ifm_type == RTM_IFINFO2) {
                    struct if_msghdr2 *if2m = (struct if_msghdr2 *)ifm;
                    struct sockaddr_dl *sdl = (struct sockaddr_dl *)(if2m + 1);
                    
                    strncpy(name, sdl->sdl_data, sdl->sdl_nlen);
                    name[sdl->sdl_nlen] = 0;
                    
                    NSString *interface = [NSString stringWithUTF8String:name];
                    //HBLogDebug(@"interface (%u) name=%@", if2m->ifm_index, interface);
                    
                    // skip local interface (lo0)
                    if (![interface isEqualToString:@"lo0"]) {
                        totalibytes += if2m->ifm_data.ifi_ibytes;
                        totalobytes += if2m->ifm_data.ifi_obytes;
                    }
                }
            }
            
            sample.timestamp = [self timestamp];
            sample.totalUploadBytes = totalobytes;
            sample.totalDownloadBytes = totalibytes;
            
        } else {
            NSLog(@"######## Meters: sysctl error !#");
        }
        
        free(buf);
        
    } else {
        NSLog(@"######## Meters: sysctl error !#");
    }
    
    //HBLogDebug(@"got Net sample [ up:%llu; down=%llu ]", sample.totalUploadBytes, sample.totalDownloadBytes);
    
    return sample;
}

- (uint64_t)timestamp {
    
    // get timer units
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    // get timer value
    uint64_t timestamp = mach_absolute_time();
    
    // convert to nanoseconds
    timestamp *= info.numer;
    timestamp /= info.denom;
    
    return timestamp;
}

- (NSString *)formatBytes:(double)bytes {
    NSString *result;
    
    if (bytes > (1024*1024*1024)) { // G
        result = [NSString stringWithFormat:@"%.1f GB/s", bytes/1024/1024/1024];
    } else if (bytes > (1024*1024)) { // M
        result = [NSString stringWithFormat:@"%.1f MB/s", bytes/1024/1024];
    } else if (bytes > 1024) { // K
        result = [NSString stringWithFormat:@"%.1f KB/s", bytes/1024];
    } else if (bytes > 0 ) {
        result = [NSString stringWithFormat:@"%.0f B/s", bytes];
    } else {
        result = @"0";
    }
    
    return result;
}

- (Meter *)meterForName:(NSString *)name {
    //HBLogDebug(@"looking for meter (%@) in self.meters=%@", name, self.meters);
    for (Meter *meter in self.meters) {
        if ([meter.name isEqualToString:name]) {
            return meter;
        }
    }
    return nil;
}

@end
