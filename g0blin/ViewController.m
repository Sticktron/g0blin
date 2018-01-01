//
//  ViewController.m
//  g0blin
//
//  Created by Sticktron on 2017-12-26.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"
#import "SettingsController.h"
#include "v0rtex.h"
#include "common.h"
#include "offsets.h"
#include "kernel.h"
#include "kpp.h"
#include "remount.h"
#include "bootstrap.h"
#include <sys/utsname.h>


#define GRAPE [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1]


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITextView *consoleView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *reinstallBootstrapLabel;
@end


static task_t tfp0;
static uint64_t kslide;
static uint64_t kbase;
static uint64_t kcred;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.progressView.progress = 0;
    self.progressView.hidden = YES;

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
    
    
    if (init_offsets() != KERN_SUCCESS) {
        self.goButton.enabled = NO;
        self.goButton.backgroundColor = UIColor.darkGrayColor;
        [self.goButton setTitle:@"device not supported" forState:UIControlStateDisabled];
        return;
    }
    
    [self log:@"Ready. \n"];
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
    self.goButton.enabled = NO;
    self.goButton.backgroundColor = UIColor.darkGrayColor;
    [self.goButton setTitle:@"jailbreaking" forState:UIControlStateDisabled];
    
    self.progressView.hidden = NO;
    [self.progressView setProgress:0.1 animated:YES];
    
    [self log:@"exploiting kernel"];
    
    kern_return_t ret = v0rtex(&tfp0, &kslide, &kcred);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
    });
}

- (void)bypassKPP {
    
    [self.progressView setProgress:0.3 animated:YES];
    [self log:@"bypassing KPP"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        if (do_kpp(1, 0, kbase, kslide, tfp0, kcred) != KERN_SUCCESS) {
            [self log:@"ERROR: kpp bypass failed \n"];
            return;
        }
        LOG("fuck kpp, yolo kjc!");
        
        [self remount];
    });
}

- (void)remount {

    [self.progressView setProgress:0.5 animated:YES];
    [self log:@"remounting / as r/w"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        if (do_remount(kslide) != KERN_SUCCESS) {
            [self log:@"ERROR: failed to remount system partition \n"];
            return;
        }

        [self bootstrap];
  });
}

- (void)bootstrap {
    
    [self.progressView setProgress:0.6 animated:YES];
    [self log:@"bootstrapping"];
    
    BOOL force = NO;
    if (self.reinstallBootstrapLabel.hidden == NO) {
        force = YES;
        [self log:@"(forcing reinstall)"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (do_bootstrap(force) != KERN_SUCCESS) {
            [self log:@"ERROR: failed to bootstrap \n"];
            return;
        }
        
        [self finish];
    });
}

- (void)finish {
    [self.progressView setProgress:1 animated:YES];
    [self log:@"All done, peace!"];

    [self.goButton setTitle:@"jailbroke yo!" forState:UIControlStateDisabled];
    
    sleep(2);
    
    // start launchdaemons ...
    LOG("reloading...");
    pid_t pid;
    posix_spawn(&pid, "/bin/launchctl", 0, 0, (char**)&(const char*[]){"/bin/launchctl", "load", "/Library/LaunchDaemons/0.reload.plist", NULL}, NULL);
//    waitpid(pid, 0, 0);
    
    sleep(2);
    
    // respring
//    LOG("respringing...");
//    pid_t pid2;
//    posix_spawn(&pid2, "/usr/bin/killall", 0, 0, (char**)&(const char*[]){"/usr/bin/killall", "-9", "SpringBoard", NULL}, NULL);
}

@end
