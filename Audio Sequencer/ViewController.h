//
//  ViewController.h
//  Audio Sequencer
//
//  Created by Josh on 2/26/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "TimerView.h"
#import "BBGroover.h"

@interface ViewController : UIViewController <BBGrooverDelegate, GridViewDelegate, TimerViewDelegate>

@property (nonatomic, strong) BBGroover *groover;
@property (strong, nonatomic) IBOutlet UISlider *tempoSlider;

@property (strong, nonatomic) IBOutlet TimerView *tickView;
@property (strong, nonatomic) IBOutlet UILabel *tempoLabel;


@end

