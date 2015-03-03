//
//  TimerView.h
//  Audio Sequencer
//
//  Created by Josh on 3/1/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerViewDelegate;

@interface TimerView : UIView

@property (nonatomic, assign) IBOutlet id<TimerViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentTick;

@end

@protocol TimerViewDelegate <NSObject>

- (NSUInteger) ticksForTickView:(TimerView *)tickView;

@end
