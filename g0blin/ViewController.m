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
#import "BEMSimpleLineGraphView.h"


#define RTM_IFINFO2         0x12 //from route.h

#define GRAPE               [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1]
#define STRAWBERRY          [UIColor colorWithRed:1 green:0 blue:0.5 alpha:1]

#define UPDATE_INTERVAL     1.5f
#define GRAPH_MAX_POINTS    20

#define offset_p_pid        0x10
#define offset_p_proc       0x100


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
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *cpuGraph;

@property (nonatomic, strong) NSTimer *meterUpdateTimer;
@property (nonatomic, assign) CPUSample lastCPUSample;
@property (nonatomic, strong) NSMutableArray *cpuHistory;
@end


static task_t tfp0;

uint64_t kslide;
uint64_t kern_cred;
uint64_t self_cred;
uint64_t self_proc;

BOOL jailbroken;
BOOL fun;
AVPlayer *player;
AVPlayerViewController *cont;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.consoleView.layer.cornerRadius = 6;
    self.consoleView.text = nil;
    
    self.goButton.layer.cornerRadius = 16;
    
    // print kernel version
    struct utsname u;
    uname(&u);
    [self log:[NSString stringWithFormat:@"%s \n", u.version]];
    [self log:[NSString stringWithFormat:@"H/W: %s", u.machine]];
    [self log:[NSString stringWithFormat:@"S/W: %@ \n", [[NSProcessInfo processInfo] operatingSystemVersionString]]];
    
    // setup fun
    self.logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun:)];
    tripleTap.delaysTouchesBegan = YES;
    tripleTap.numberOfTapsRequired = 3;
    [self.logoView addGestureRecognizer:tripleTap];
    
    jailbroken = NO;
    
    if (strstr(u.version, "MarijuanARM")) {
        jailbroken = YES;
        
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"already jailbroken" forState:UIControlStateDisabled];
        
        [self log:@"Enjoy! \n"];
        
        return;
    }
    
    if (init_offsets() == KERN_SUCCESS) {
        [self log:@"Ready. \n"];
    } else {
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"device not supported" forState:UIControlStateDisabled];
    }
    
    // setup graph...
    
    self.cpuGraph.layer.cornerRadius = 4;
    self.cpuGraph.clipsToBounds = YES;
    
    self.cpuGraph.animationGraphStyle = BEMLineAnimationNone;
    
    self.cpuGraph.averageLine.enableAverageLine = NO;
    self.cpuGraph.enableTouchReport = NO;
    self.cpuGraph.enablePopUpReport = NO;
    
    self.cpuGraph.colorReferenceLines = [UIColor colorWithWhite:0.66 alpha:1];

    self.cpuGraph.autoScaleYAxis = NO;
    self.cpuGraph.positionYAxisRight = YES;
    self.cpuGraph.enableReferenceYAxisLines = YES;
    self.cpuGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];

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
        cont.updatesNowPlayingInfoCenter = YES;
        cont.view.frame = self.consoleView.bounds;
        [self.consoleView addSubview:cont.view];
        [player play];
        cont.showsPlaybackControls = YES;
        
    } else {
        [player pause];
        [cont.view removeFromSuperview];
        player = nil;
        cont = nil;
        fun = NO;
    }
}

- (void)log:(NSString *)text {
    self.consoleView.text = [NSString stringWithFormat:@"%@%@ \n", self.consoleView.text, text];
}

- (IBAction)go:(UIButton *)sender {
    [self stopUpdating];
    
    self.goButton.enabled = NO;
    self.goButton.backgroundColor = UIColor.darkGrayColor;
    [self.goButton setTitle:@"jailbreaking" forState:UIControlStateDisabled];
    
    [self log:@"exploiting kernel..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        kern_return_t ret = v0rtex(&tfp0, &kslide, &kern_cred, &self_cred, &self_proc);
        if (ret != KERN_SUCCESS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self log:@"ERROR: exploit failed :( \n"];
                [self log:@"Please try again \n"];
                
                [self.goButton setTitle:@"try again" forState:UIControlStateNormal];
                self.goButton.backgroundColor = GRAPE;
                self.goButton.enabled = YES;
                
                [self startUpdating];
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
    //gsystem("killall -9 backboardd");
    
    LOG("restoring our creds");
    WriteAnywhere64(self_proc + offset_p_proc, self_cred);
    
}


#pragma mark - meters

- (void)startUpdating {
    // bail if the meters are already running
    if ([self.meterUpdateTimer isValid]) {
        LOG("meters are already running, no need to start them again");
        
    } else {
        // reset graph
        //self.cpuHistory = [NSMutableArray arrayWithArray:@[@0,@0]];
        self.cpuHistory = [NSMutableArray array];
        [self.cpuGraph reloadGraph];
        
        // show placeholder values
        self.cpuMeterLabel.text = @"_";
        self.ramMeterLabel.text = @"_";
        
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
}

- (void)stopUpdating {
    if (self.meterUpdateTimer) {
        LOG("Stopping Timer ••••• (%@)", self.meterUpdateTimer);
        [self.meterUpdateTimer invalidate];
        self.meterUpdateTimer = nil;
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

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)(self.cpuHistory.count);
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSNumber *val = self.cpuHistory[index];
    float fval = [val floatValue];
    fval = self.cpuGraph.bounds.size.height * (fval/100.0);
    //LOG("val[%d] = %0.1f  (y=%0.1f)", (int)index, [val floatValue], fval);
    return fval;
}

- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph {
    return @"";
}

//- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
//    return 10;
//}

@end
