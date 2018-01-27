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


#define GRAPE       [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1]
#define STRAWBERRY  [UIColor colorWithRed:1 green:0 blue:0.5 alpha:1]

extern int (*gsystem)(const char *);


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITextView *consoleView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *reinstallBootstrapLabel;
@end


static task_t tfp0;
static uint64_t kslide;
static uint64_t kbase;
static uint64_t kcred;

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
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun:)];
    doubleTap.delaysTouchesBegan = YES;
    doubleTap.numberOfTapsRequired = 3;
    [self.logoView addGestureRecognizer:doubleTap];
    self.logoView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (respringNeeded == YES) {
        [self restart];
        return;
    }
    
    self.goButton.enabled = NO;
    self.goButton.backgroundColor = UIColor.darkGrayColor;
    [self.goButton setTitle:@"jailbreaking" forState:UIControlStateDisabled];
    
    [self log:@"exploiting kernel"];
    
    kern_return_t ret = v0rtex(&tfp0, &kslide, &kcred);
    if (ret != KERN_SUCCESS) {
        self.goButton.enabled = YES;
        self.goButton.backgroundColor = GRAPE;
        [self.goButton setTitle:@"try again" forState:UIControlStateNormal];
        
        [self log:@"ERROR: exploit failed \n"];
        return;
    }
    LOG("v0rtex was successful");
    
    LOG("tfp0 -> %x", tfp0);
    LOG("slide -> 0x%llx", kslide);
    kbase = kslide + 0xFFFFFFF007004000;
    LOG("kern base -> 0x%llx", kbase);
    LOG("kern cred -> 0x%llx", kcred);

    [self bypassKPP];
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
    sleep(5);
    [self restart];
}

- (void)restart {
    [self log:@"restarting backboardd..."];
    
    // 1. kill
    //gsystem("(killall backboardd)&");
    
    // 2. kill from another process
    //pid_t pid;
    //const char* args[] = { "killall", "backboardd", NULL };
    //posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    
    // 3. stop then kill
    //gsystem("(launchctl stop com.apple.backboardd; killall backboardd SpringBoard)&");
    gsystem("launchctl stop com.apple.backboardd; killall backboardd SpringBoard");
}

- (IBAction)fun:(UITapGestureRecognizer *)recognizer {
    LOG("got secret tap");
    
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

@end
