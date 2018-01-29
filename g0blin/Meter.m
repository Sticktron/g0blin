//
//  Meter.m
//  Meters Widget
//
//  Copyright © 2014-2018 Sticktron. All rights reserved.
//

#import "Meter.h"

@implementation Meter

- (instancetype)initWithName:(NSString *)name title:(NSString *)title {
    if (self = [super init]) {
        _name = name;
        _title = title;
        _enabled = YES;
    }
    return self;
}

@end
