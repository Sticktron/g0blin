//
//  Meter.h
//  Meters Widget
//
//  Copyright © 2014-2018 Sticktron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Meter : NSObject

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithName:(NSString *)name title:(NSString *)title;

@end
