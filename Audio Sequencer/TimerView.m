//
//  TimerView.m
//  Audio Sequencer
//
//  Created by Josh on 3/1/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import "TimerView.h"

@interface TimerView ()

@property (nonatomic, strong) UIView *tick;

@end

@implementation TimerView

- (void) awakeFromNib
{
    _currentTick = 0;
    _tick = [[UIView alloc] init];
    _tick.backgroundColor = [UIColor blackColor];
    [self addSubview:_tick];
}

- (void) layoutSubviews {
    NSUInteger ticks = [_delegate ticksForTickView:self];
    
    CGRect rect = self.frame;
    
    float width  = rect.size.width / ticks;
    float height = rect.size.height;
    float x      = width * _currentTick;
    float y      = 0;
    
    _tick.frame = CGRectMake(x, y, width, height);
}

@end
