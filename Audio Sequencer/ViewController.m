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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BBGroove *groove = [BBGroove groove];
    groove.tempo = 120;
    groove.beats = 4;
    groove.beatUnit = BBGrooverBeatQuarter;
    
    BBVoice *bass = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    bass.name = @"Bass Drum";
    bass.audioPath = @"bassdrum.wav";
    
    BBVoice *snare = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    snare.name = @"Snare drum";
    snare.audioPath = @"snare.aif";
    
    BBVoice *hihat = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    hihat.name = @"Hi Hat";
    hihat.audioPath = @"clap2.wav";
    
    BBVoice *kick = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    kick.name = @"Kick";
    kick.audioPath = @"kick.wav";

    
    groove.voices = @[bass, snare, hihat, kick];
    
    _groover = [BBGroover grooverWithGroove:groove];
    
    _groover.delegate = self;
    
    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
    
    self.tempoSlider.value = groove.tempo;
    [self updateTempo:groove.tempo];
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
    BBVoice *voice = _groover.groove.voices[row];
    
    if ([voice.values[column] boolValue]) {
        [voice setValue:NO forIndex:column];
    } else {
        [voice setValue:YES forIndex:column];
    }
    
    [gridView setNeedsDisplay];
}

- (BOOL) gridView:(GridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column {
    return [[_groover.groove.voices[row] values][column] boolValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helper Methods
- (void) updateTempo:(NSUInteger)tempo {
    _tempoLabel.text = [NSString stringWithFormat:@"%lu bpm", (unsigned long)tempo];
}

#pragma mark IBActions
- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    _groover.groove.tempo = (NSUInteger)slider.value;
    
    [self updateTempo:_groover.groove.tempo];
    
}

- (IBAction)startTapped:(id)sender {
    [_groover resumeGrooving];
}

- (IBAction)stopTapped:(id)sender {
    [_groover pauseGrooving];
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

-(IBAction)stepsSelected:(id)sender {
    
    [_groover pauseGrooving];
    /*
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view];
    
    BBVoice *bass = [BBVoice voiceWithSubdivision:BBGrooverBeatQuarter];
    bass.name = @"Bass Drum";
    bass.audioPath = @"bassdrum.wav";
    
    BBVoice *snare = [BBVoice voiceWithSubdivision:BBGrooverBeatQuarter];
    snare.name = @"Snare drum";
    snare.audioPath = @"snare2.wav";
    
    BBVoice *hihat = [BBVoice voiceWithSubdivision:BBGrooverBeatQuarter];
    hihat.name = @"Hi Hat";
    hihat.audioPath = @"hihat.wav";
    
    BBVoice *kick = [BBVoice voiceWithSubdivision:BBGrooverBeatQuarter];
    kick.name = @"Kick";
    kick.audioPath = @"kick.wav";
    
    BBGroove *groove = [BBGroove groove];

    groove.voices = @[bass, snare, hihat, kick];
    
    _groover = [BBGroover grooverWithGroove:groove];
    _groover.delegate = self;

    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
     */
}

@end
