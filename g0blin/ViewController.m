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
#import "BEMSimpleLineGraphView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#include <sys/utsname.h>


#define RTM_IFINFO2         0x12 //from route.h

#define GRAPE               [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1]
#define STRAWBERRY          [UIColor colorWithRed:1 green:0 blue:0.5 alpha:1]

#define LEAD                [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1]

#define UPDATE_INTERVAL     2.0f

#define GRAPH_MAX_POINTS    30


typedef struct {
    uint64_t totalSystemTime;
    uint64_t totalUserTime;
    uint64_t totalIdleTime;
} CPUSample;


extern int (*gsystem)(const char *);


@interface ViewController () <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITextView *consoleView;
@property (weak, nonatomic) IBOutlet UILabel *cpuMeterLabel;
@property (weak, nonatomic) IBOutlet UILabel *ramMeterLabel;
@property (weak, nonatomic) IBOutlet UIView *cpuGraphContainer;

@property (nonatomic, assign) BOOL jailbroken;
@property (nonatomic, assign) BOOL fun;
@property (nonatomic, assign) BOOL needsReboot;
@property (nonatomic, strong) AVPlayerViewController *playerController;
@property (nonatomic, strong) NSTimer *meterUpdateTimer;
@property (nonatomic, assign) CPUSample lastCPUSample;
@property (nonatomic, strong) NSMutableArray *cpuHistory;
@property (nonatomic, strong) BEMSimpleLineGraphView *cpuGraph;
@end


task_t tfp0;

uint64_t kslide;
uint64_t kern_cred;
uint64_t self_cred;
uint64_t self_proc;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jailbroken = NO;
    self.fun = NO;
    self.needsReboot = NO;
    
    self.goButton.layer.cornerRadius = 16;
    self.consoleView.layer.cornerRadius = 6;
    self.consoleView.text = nil;
    
    self.cpuMeterLabel.text = @"_";
    self.ramMeterLabel.text = @"_";
    
    [self setupGraph];
    
    // setup fun trigger
    self.logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun:)];
    tripleTap.delaysTouchesBegan = YES;
    tripleTap.numberOfTapsRequired = 3;
    [self.logoView addGestureRecognizer:tripleTap];
    
    // print device info
    struct utsname u;
    uname(&u);
    [self log:[NSString stringWithFormat:@"%s \n", u.version]];
    [self log:[NSString stringWithFormat:@"H/W: %s", u.machine]];
    [self log:[NSString stringWithFormat:@"S/W: %@ \n", [[NSProcessInfo processInfo] operatingSystemVersionString]]];
    
    // abort if already jailbroken
    if (strstr(u.version, "MarijuanARM")) {
        self.jailbroken = YES;
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"already jailbroken" forState:UIControlStateDisabled];
        [self log:@"Enjoy! \n"];
        return;
    }
    
    // check if device is supported
    if (init_offsets() == KERN_SUCCESS) {
        [self log:@"Ready. \n"];
    } else {
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"device not supported" forState:UIControlStateDisabled];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LOG("Starting Meters !!!");
    [self startUpdating];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    LOG("Stopping Meters");
    [self stopUpdating];
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


#pragma mark - jailbreak

- (void)log:(NSString *)text {
    self.consoleView.text = [NSString stringWithFormat:@"%@%@ \n", self.consoleView.text, text];
}

- (IBAction)go:(UIButton *)sender {
    [self stopUpdating];
    
    self.goButton.enabled = NO;
    self.goButton.backgroundColor = UIColor.darkGrayColor;
    
    if (self.needsReboot) {
        [self.goButton setTitle:@"rebooting" forState:UIControlStateDisabled];
        [self log:@"rebooting..."];
    } else {
        [self.goButton setTitle:@"jailbreaking" forState:UIControlStateDisabled];
        [self log:@"exploiting kernel..."];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        kern_return_t ret = v0rtex(&tfp0, &kslide, &kern_cred, &self_cred, &self_proc);
        if (ret != KERN_SUCCESS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self log:@"ERROR: exploit failed :( \n\n"];
                [self log:@"Please reboot and try again. \n"];
                
                self.needsReboot = YES;
                
                [self.goButton setTitle:@"failed, reboot" forState:UIControlStateNormal];
                self.goButton.backgroundColor = GRAPE;
                self.goButton.enabled = YES;
            });
            return;
        }
        LOG("*****  v0rtex was successful  *****");
        LOG("tfp0 -> %x", tfp0);
        LOG("slide -> 0x%llx", kslide);
        LOG("kern_cred -> 0x%llx", kern_cred);
        LOG("self_cred -> 0x%llx", self_cred);
        LOG("self_proc -> 0x%llx", self_proc);
        LOG("***********************************");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self bypassKPP];
        });
    });
}

- (void)bypassKPP {
    [self log:@"patching kernel..."];
    
    if (do_kpp(tfp0, kslide, kern_cred, self_cred, self_proc) == KERN_SUCCESS) {
        LOG("♬ you done with kpp? yeah you know me ♬");
        [self remount];
    } else {
        [self log:@"ERROR: kpp bypass failed \n"];
    }
}

- (void)remount {
    [self log:@"remounting..."];
    
    if (do_remount(kslide) == KERN_SUCCESS) {
        [self bootstrap];
    } else {
        [self log:@"ERROR: failed to remount system partition \n"];
    }
}

- (void)bootstrap {
    [self log:@"bootstrapping..."];
    
    if (do_bootstrap() == KERN_SUCCESS) {
        [self finish];
    } else {
        [self log:@"ERROR: failed to bootstrap \n"];
    }
}

- (void)finish {
    [self log:@"device is now jailbroken !!"];
    [self log:@""];
    [self log:@"restarting SpringBoard..."];
    [self log:@""];
    
    [self.goButton setTitle:@"finishing" forState:UIControlStateDisabled];
    
    LOG("killing backboardd...");
    gsystem("(killall backboardd)&");
    
    LOG("restoring our creds");
    WriteAnywhere64(self_proc + offset_p_cred, self_cred);
}


#pragma mark - fun

- (IBAction)fun:(UITapGestureRecognizer *)recognizer {
    LOG("got secret tap 3");
    
    if (self.fun == NO) {
        
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
        
        self.playerController = [[AVPlayerViewController alloc] init];
        self.playerController.view.frame = self.consoleView.bounds;
        self.playerController.showsPlaybackControls = YES;
        self.playerController.updatesNowPlayingInfoCenter = YES;
        self.playerController.player = [AVPlayer playerWithURL:url];
        
        [self.consoleView addSubview:self.playerController.view];
        [self.playerController.player play];
        
        self.logoView.image = [UIImage imageNamed:@"logo-lit"];
        
        self.fun = YES;
        
    } else {
        [self.playerController.player pause];
        [self.playerController.view removeFromSuperview];
        self.playerController.player = nil;
        self.playerController = nil;
        
        self.logoView.image = [UIImage imageNamed:@"logo"];
        
        self.fun = NO;
    }
}


#pragma mark - meters

- (void)startUpdating {
    // bail if the meters are already running
    if ([self.meterUpdateTimer isValid]) {
        LOG("meters are already running, no need to start them again");
        return;
    }
    
    // get new starting measurements
    self.lastCPUSample = [self getCPUSample];
    
    // start timer
    self.meterUpdateTimer = [NSTimer timerWithTimeInterval:UPDATE_INTERVAL target:self
                                                  selector:@selector(updateMeters:)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.meterUpdateTimer forMode:NSRunLoopCommonModes];
    LOG("Started Timer ••••• (%@)", self.meterUpdateTimer);
}

- (void)stopUpdating {
    if (self.meterUpdateTimer) {
        LOG("Stopping Timer ••••• (%@)", self.meterUpdateTimer);
        [self.meterUpdateTimer invalidate];
        self.meterUpdateTimer = nil;
        
        // show meter placeholders
        self.cpuMeterLabel.text = @"_";
        self.ramMeterLabel.text = @"_";
        
        // reset graph
        for (int i=0; i<self.cpuHistory.count; i++) {
            self.cpuHistory[i] = @0;
        }
        [self.cpuGraph reloadGraph];
    }
}

- (void)updateMeters:(NSTimer *)timer {
    LOG("updating meters (timer: %@)", timer);
    
    // RAM Meter: "available" memory (free + inactive)
    uint32_t ram = [self memoryAvailableInBytes];
    ram /= (1024*1024); // convert to MB
    self.ramMeterLabel.text = [NSString stringWithFormat:@"%u MB", ram];
    
    
    // CPU Meter: percentage of time in use since last sample
    CPUSample cpu_delta;
    CPUSample cpu_sample = [self getCPUSample];
    
    // get usage for period
    cpu_delta.totalUserTime = cpu_sample.totalUserTime - self.lastCPUSample.totalUserTime;
    cpu_delta.totalSystemTime = cpu_sample.totalSystemTime - self.lastCPUSample.totalSystemTime;
    cpu_delta.totalIdleTime = cpu_sample.totalIdleTime - self.lastCPUSample.totalIdleTime;
    
    // calculate time spent in use as a percentage of the total time
    uint64_t total = cpu_delta.totalUserTime + cpu_delta.totalSystemTime + cpu_delta.totalIdleTime;
    double used = ((cpu_delta.totalUserTime + cpu_delta.totalSystemTime) / (double)total) * 100.0;
    
    self.cpuMeterLabel.text = [NSString stringWithFormat:@"%.1f %%", used];
    
    self.lastCPUSample = cpu_sample;
    
    
    // update graph
    [self.cpuHistory addObject:[NSNumber numberWithDouble:used]];
    if (self.cpuHistory.count > GRAPH_MAX_POINTS) {
        [self.cpuHistory removeObjectAtIndex:0];
    }
    [self.cpuGraph reloadGraph];
}

- (uint32_t)memoryAvailableInBytes {
    // I'm counting "available" as free + inactive memory
    
    uint32_t bytesAvailable = 0;
    
    // get page size
    vm_size_t pagesize = vm_kernel_page_size;
    //NSLog(@"[Meters] using page size: %d bytes", (int)pagesize);
    
    // get stats
    kern_return_t kr;
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vm_stat;
    
    kr = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &count);
    if (kr != KERN_SUCCESS) {
        LOG("Error getting VM_INFO from host!");
    } else {
        unsigned long bytesInactive = vm_stat.inactive_count * pagesize;
        unsigned long bytesFree = vm_stat.free_count * pagesize;
        bytesAvailable = (uint32_t)(bytesFree + bytesInactive);
        //LOG(@"Got RAM stats: Free=%lu B; Inactive=%lu B; Total Available=%u B", bytesFree, bytesInactive, bytesAvailable);
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
        LOG("Error fetching HOST_CPU_LOAD_INFO !");
    } else {
        sample.totalUserTime = r_load.cpu_ticks[CPU_STATE_USER] + r_load.cpu_ticks[CPU_STATE_NICE];
        sample.totalSystemTime = r_load.cpu_ticks[CPU_STATE_SYSTEM];
        sample.totalIdleTime = r_load.cpu_ticks[CPU_STATE_IDLE];
        //LOG(@"got CPU sample [ user:%llu; sys:%llu; idle:%llu ]", sample.totalUserTime, sample.totalSystemTime, sample.totalIdleTime);
    }
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


#pragma mark - graph

- (void)setupGraph {
    // seed graph data with zeros
    self.cpuHistory = [NSMutableArray array];
    for (int i=0; i<GRAPH_MAX_POINTS; i++) {
        [self.cpuHistory addObject:@0];
    }
    
    self.cpuGraphContainer.backgroundColor = self.view.backgroundColor;
    self.cpuGraphContainer.opaque = YES;
    
    self.cpuGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:self.cpuGraphContainer.bounds];
    self.cpuGraph.delegate = self;
    self.cpuGraph.dataSource = self;

    self.cpuGraph.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    self.cpuGraph.opaque = YES;
    self.cpuGraph.layer.cornerRadius = 4;
    self.cpuGraph.clipsToBounds = YES;

    self.cpuGraph.animationGraphStyle = BEMLineAnimationNone;
    self.cpuGraph.averageLine.enableAverageLine = NO;
    self.cpuGraph.enableTouchReport = NO;
    self.cpuGraph.enablePopUpReport = NO;
    self.cpuGraph.enableYAxisLabel = NO;
    self.cpuGraph.autoScaleYAxis = NO;
    self.cpuGraph.colorTop = [UIColor colorWithWhite:0.15 alpha:1];
    self.cpuGraph.colorBottom = [UIColor colorWithWhite:0.15 alpha:1];
    self.cpuGraph.colorLine = self.cpuMeterLabel.textColor;
    
    [self.cpuGraphContainer addSubview:self.cpuGraph];
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.cpuHistory.count; // == GRAPH_MAX_POINTS
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    float val = [self.cpuHistory[index] floatValue];
//    LOG("val[%d] = %0.1f", (int)index, val);
    
    float adj_val = self.cpuGraph.bounds.size.height * (val/100.0);
//    LOG("adj_val = %0.1f", adj_val);
    val = adj_val;
    
    return val;
}

- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph {
    return @"";
}

@end
