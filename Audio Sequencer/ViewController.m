//
//  ViewController.m
//  Audio Sequencer
//
//  Created by Josh on 2/26/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import "ViewController.h"
#import "BBVoice.h"
#import "BBGroove.h"
#import "OALSimpleAudio.h"


static NSString *kick1 = @"Kick 1";
static NSString *kick2 = @"Kick 2";
static NSString *kick3 = @"Kick 3";
static NSString *bassdrum1 = @"Bass Drum 1";

static NSString *hihat1 = @"Hi Hat 1";
static NSString *hihat2 = @"Hi Hat 2";
static NSString *hihat3 = @"Hi Hat 3";

static NSString *rim1 = @"Rim 1";
static NSString *rim2 = @"Rim 2";
static NSString *rim3 = @"Rim 3";

static NSString *shaker1 = @"Shaker 1";
static NSString *shaker2 = @"Shaker 2";



static NSString *snare1 = @"Snare 1";
static NSString *snare2 = @"Snare 2";


static NSString *snap1 = @"Snap 1";
static NSString *snap2 = @"Snap 2";


static NSString *clap1 = @"Clap 1";
static NSString *clap2 = @"Clap 2";


static NSString *openhat1 = @"Open Hat 1";

static NSString *triangle1 = @"Triangle 1";
static NSString *vox1 = @"Vox 1";



// Make it so that you can change the number of divisions

@interface ViewController (){
    UIAlertController *actionSheet;
    UIAlertController *beatsSheet;
    
    GridView *gv;
    NSInteger channelIndex;
    NSString *selectedSound;
    
    NSString *channelOneSound;
    NSString *channelTwoSound;
    NSString *channelThreeSound;
    NSString *channelFourSound;
    
    NSMutableArray *channelOneSelections;
    NSMutableArray *channelTwoSelections;
    NSMutableArray *channelThreeSelections;
    NSMutableArray *channelFourSelections;
    
    NSInteger tempo_;
    
    BOOL loaded;
    BOOL grooving;
    NSInteger beats;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!loaded){
        grooving = NO;
        loaded = YES;
        beats = 16;
        channelIndex = 0;
        tempo_ = 120;
        channelOneSound = kick1;
        channelTwoSound = snare1;
        channelThreeSound = hihat1;
        channelFourSound = openhat1;
    }
    
    NSArray *views = @[self.snareView, self.kickView, self.hiHatView, self.openHatView];
    NSArray *buttons = @[self.startButton, self.beatsButton, self.clearButton];
    
    channelOneSelections = [[NSMutableArray alloc]init];
    channelTwoSelections = [[NSMutableArray alloc]init];
    channelThreeSelections = [[NSMutableArray alloc]init];
    channelFourSelections = [[NSMutableArray alloc]init];
    
    for (UIView *view in views){
        [self makeRounded:view.layer color:[UIColor blackColor] borderWidth:0.1f cornerRadius:3.0f];
    }
    
    
    for (UIButton *button in buttons){
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 10;
    }
    NSArray *sounds = @[kick1, kick2, kick3, bassdrum1, hihat1, hihat2, hihat3, snare1, snare2, snap1, snap2, clap1, clap2, openhat1, triangle1, rim1, rim2, rim3, shaker1, shaker2, vox1];

    actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    for (NSString *sound in sounds){
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:sound style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            selectedSound = action.title;
            if (channelIndex == 1){
                channelOneSound = selectedSound;
                
            }
            else if (channelIndex == 2){
                channelTwoSound = selectedSound;
            }
            else if (channelIndex == 3){
                channelThreeSound = selectedSound;
            }
            else if (channelIndex == 4){
                channelFourSound = selectedSound;
            }
            [self clearVoices];
            [self setSounds];
            
            NSLog(@"Test");
        }];
    
        [actionSheet addAction:action];
    }
    
    beatsSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [beatsSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    NSArray *beatsArray = @[[NSNumber numberWithInt:32], [NSNumber numberWithInt:16], [NSNumber numberWithInt:8], [NSNumber numberWithInt:4]];
    for (NSNumber *beat in beatsArray){
        [beatsSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", beat] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (beats == [beat integerValue]){
                return;
            }
            beats = [beat integerValue];
            [self clearTapped:nil];
            [self setSounds];
            
        }]];
    }

    
    UITapGestureRecognizer *oneGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didSelectOne)];
    [self.kickView addGestureRecognizer:oneGesture];
    
    
    UITapGestureRecognizer *twoGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didSelectTwo)];
    [self.snareView addGestureRecognizer:twoGesture];
    
    
    UITapGestureRecognizer *threeGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didSelectThree)];
    [self.hiHatView addGestureRecognizer:threeGesture];
    
    
    UITapGestureRecognizer *fourGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didSelectFour)];
    [self.openHatView addGestureRecognizer:fourGesture];
    
    
    [self setSounds];
}


- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger firstLoad = [defaults integerForKey:@"FirstLoad"];
    
    if (firstLoad != 1){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Welcome to Audio Fuego" message:@"Choose from 21 unique sounds across four channels. Click a sound to the left to alter it." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        [self presentViewController:ac animated:YES completion:^{
            [defaults setInteger:1 forKey:@"FirstLoad"];
            [defaults synchronize];
        }];
    }
}


- (void)setSounds {
    BBGroove *groove = [BBGroove groove];
    groove.tempo = tempo_;
    groove.beats = 4;
    groove.beatUnit = BBGrooverBeatMin;
    
    BBVoice *channel1 = [BBVoice voiceWithSubdivision:beats];
    channel1.name = channelOneSound;
    self.kickLabel.text = channelOneSound;
    channel1.audioPath = [self sound:channelOneSound];
    
    BBVoice *channel2 = [BBVoice voiceWithSubdivision:beats];
    channel2.name = channelTwoSound;
    self.snareLabel.text = channelTwoSound;
    channel2.audioPath = [self sound:channelTwoSound];
    
    BBVoice *channel3 = [BBVoice voiceWithSubdivision:beats];
    channel3.name = channelThreeSound;
    self.hiHatLabel.text = channelThreeSound;
    channel3.audioPath = [self sound:channelThreeSound];
    
    BBVoice *channel4 = [BBVoice voiceWithSubdivision:beats];
    channel4.name = channelFourSound;
    self.openHatsLabel.text = channelFourSound;
    channel4.audioPath = [self sound:channelFourSound];
    
    
    groove.voices = @[channel1, channel2, channel3, channel4];
    
    NSInteger index = 0;
    
    
    NSArray *channelSelections = @[channelOneSelections, channelTwoSelections, channelThreeSelections, channelFourSelections];
    
    for (NSMutableArray *chanSelections in channelSelections){
        BBVoice *voice = [groove.voices objectAtIndex:index];
        
        for (NSNumber *num in chanSelections){
            [voice setValue:YES forIndex:num.integerValue];
        }
        index++;
    }
    
    
    _groover = [BBGroover grooverWithGroove:groove];
    
    _groover.delegate = self;
    
    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
    
    self.tempoSlider.value = groove.tempo;
    [self updateTempo:groove.tempo];
    [gv layoutIfNeeded];

}


- (void)didSelectOne{
    channelIndex = 1;
    [self presentActionSheet];
}


- (void)didSelectTwo{
    channelIndex = 2;
    [self presentActionSheet];
}


- (void)didSelectThree{
    channelIndex = 3;
    [self presentActionSheet];
}


- (void)didSelectFour{
    channelIndex = 4;
    [self presentActionSheet];
}


- (void)presentActionSheet{
    grooving = YES;
    [self startTapped:nil];

    [self presentViewController:actionSheet animated:YES completion:nil];


}

#pragma mark BBGrooverDelegate Methods
- (void) groover:(BBGroover *)sequencer didTick:(NSUInteger)tick {
    _tickView.currentTick = tick;
    [_tickView setNeedsLayout];
}


- (void) groover:(BBGroover *)sequencer voicesDidTick:(NSArray *)voices {
    for (BBVoice *voice in voices) {
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
    
}

#pragma mark TimerView methods
- (NSUInteger) ticksForTickView:(TimerView *)tickView {
    return [_groover currentSubdivision];
}


#pragma mark GridView Methods
- (NSUInteger) gridView:(GridView *)gridView columnsForRow:(NSUInteger)row {
    return [_groover.groove.voices[row] subdivision];
}


- (NSUInteger) rowsForGridView:(GridView *)gridView {
    return _groover.groove.voices.count;
}


- (void) gridView:(GridView *)gridView wasSelectedAtRow:(NSUInteger)row column:(NSUInteger)column {
    gv = gridView;
    // keep reference so we can when we set new sounds also maintain the selections
    BBVoice *voice = _groover.groove.voices[row];
    
    NSMutableArray *tmpArray;
    
    if (row == 0){
        tmpArray = channelOneSelections;
    }
    else if (row == 1){
        tmpArray = channelTwoSelections;
    }
    else if (row == 2){
        tmpArray = channelThreeSelections;
    }
    else if (row == 3){
        tmpArray = channelFourSelections;
    }
    
    if ([voice.values[column] boolValue]) {
        [voice setValue:NO forIndex:column];
        [tmpArray removeObject:[NSNumber numberWithUnsignedInteger:column]];

    } else {
        [voice setValue:YES forIndex:column];
        [tmpArray addObject:[NSNumber numberWithUnsignedInteger:column]];
    }
    
    [gridView setNeedsDisplay];
}


- (BOOL) gridView:(GridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column {
    return [[_groover.groove.voices[row] values][column] boolValue];
}


#pragma mark Helper Methods
- (void) updateTempo:(NSUInteger)tempo {
    tempo_ = tempo;
    _tempoLabel.text = [NSString stringWithFormat:@"%lu bpm", (unsigned long)tempo];
}


#pragma mark IBActions
- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    _groover.groove.tempo = (NSUInteger)slider.value;
    
    [self updateTempo:_groover.groove.tempo];
    
}


- (IBAction)startTapped:(id)sender {
    if (!grooving){
        grooving = YES;
        
        // disable updating button
        [self.startButton setTitle:@" Stop " forState:UIControlStateNormal];

        [_groover resumeGrooving];
    }
    else{
        grooving = NO;
        [self.startButton setTitle:@" Start " forState:UIControlStateNormal];
        [_groover pauseGrooving];
    }
}


- (void)clearVoices{
    for (BBVoice *voice in self.groover.groove.voices) {
        for (int i = 0; i < 15; i++){
            [voice setValue:NO forIndex:i];
        }
    }
}


- (IBAction)clearTapped:(id)sender {
    [_groover pauseGrooving];
    for (BBVoice *voice in self.groover.groove.voices) {
        for (int i = 0; i < 15; i++){
            [voice setValue:NO forIndex:i];
        }
    }
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view];
}


- (IBAction)beatsSelected:(id)sender {
    [self presentViewController:beatsSheet animated:YES completion:nil];
}



#pragma mark Utility Functions

- (void) makeRounded:(CALayer *)layer color:(UIColor *)color borderWidth:(float)borderWidth cornerRadius:(float)cornerRadius{
    //TODO - Move to Utility Function File
    layer.cornerRadius = cornerRadius;
    layer.borderWidth = borderWidth;
    if (color != nil){
        layer.borderColor = color.CGColor;
    }
    else {
        layer.borderColor = [UIColor clearColor].CGColor;
        
    }
}


- (NSString *)sound:(NSString *)string{
    return [NSString stringWithFormat:@"%@.wav", string];
}


- (IBAction)backgroundTap:(id)sender {
    if (actionSheet.isFirstResponder){
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
