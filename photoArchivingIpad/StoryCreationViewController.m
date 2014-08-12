//
//  StoryCreationViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoryCreationViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Story.h"
#import "TFDataCommunicator.h"
#import "NSMutableDictionary+attributesDictionary.h"



@interface StoryCreationViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate, TFCommunicatorDelegate, UITextFieldDelegate> {
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    NSInteger recordingSeconds;
    NSInteger recordingMilliseconds;
    
    NSTimer *recordingTimer;
    
    UIFont *labelFont;
    UIColor *labelTextColor;
    
    NSURL *recordingURL;
    TFDataCommunicator *mainCom;
    
    CGFloat levelPercentage;
    
    NSTimer *audioLevelTimer;
    
    NSMutableDictionary *buttonStyle;
    
    NSInteger totalTimeInMilliseconds;
    
}

@end

@implementation StoryCreationViewController
@synthesize recordPauseButton, playButton, stopButton, timeLabel;
@synthesize titleLabel, storytellerLabel, dateLabel;
@synthesize titleValue, storytellerValue, datePickerView, saveButton;

@synthesize meterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self audioPlayerSetup];

    [self setupVariables];
    [self aestheticsConfig];
    [meterView addMeterToView];
}

-(void)setupVariables
{
    recordingSeconds = 0;
    recordingMilliseconds = 0;
    totalTimeInMilliseconds = 0;
    
    levelPercentage = 0.0;
    
    
    labelFont = [UIFont fontWithName:@"DINAlternate-Bold" size:20.0];
    labelTextColor = [UIColor blackColor];
    
    mainCom = [[TFDataCommunicator alloc] init];
    [mainCom setupTransferManager];
    mainCom.delegate = self;
    
    CGFloat buttonFontSize = 16.0l;
    UIFont *buttonFont = [UIFont fontWithName:global_font_family size:buttonFontSize];
    
    UIColor *buttonTextColor = [UIColor RedditBlue];
    
    buttonStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeButtonDefault];
    
    [buttonStyle updateValues:@[buttonFont,
                               buttonTextColor]
                      forKeys:@[keyFont,
                                keyTextColor]];
    
    
}
-(void)aestheticsConfig
{
    [titleLabel setFont:labelFont];
    [storytellerLabel setFont:labelFont];
    [dateLabel setFont:labelFont];
    
    [datePickerView setDatePickerMode:UIDatePickerModeDate];
    
    CGFloat timeLabelFontSize = 14.0;
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setText:@"0.00"];
    [timeLabel setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:timeLabelFontSize]];
    
    playButton.titleLabel.font = [buttonStyle objectForConstKey:keyFont];
    playButton.titleLabel.textColor = [buttonStyle objectForConstKey:keyTextColor];
    
    stopButton.titleLabel.font = [buttonStyle objectForConstKey:keyFont];
    stopButton.titleLabel.textColor = [buttonStyle objectForConstKey:keyTextColor];
    
    recordPauseButton.titleLabel.font = [buttonStyle objectForConstKey:keyFont];
    recordPauseButton.titleLabel.textColor = [buttonStyle objectForConstKey:keyTextColor];
    
    saveButton.titleLabel.font = [buttonStyle objectForConstKey:keyFont];
    saveButton.titleLabel.textColor = [buttonStyle objectForConstKey:keyTextColor];
}
-(void)audioPlayerSetup
{
    [playButton setEnabled:NO];
    [stopButton setEnabled:NO];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    recordingURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:recordingURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
}



- (IBAction)saveTapped:(id)sender {
    
    Story* newStory = [Story new];
    
    if (recorder.url) {
        newStory.recordingURL = recorder.url;
     
        
    }
    
    newStory.title = titleValue.text;
    newStory.storyTeller = storytellerValue.text;
    newStory.storyDate = datePickerView.date;
    newStory.recordingS3Url = _s3URL;
    newStory.recordingLength = [NSNumber numberWithInteger:totalTimeInMilliseconds];
    
    [self.delegate didSaveStory:newStory];
    
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}
-(void)finishedUploadingRequestWithData:(NSDictionary *)data
{
    NSLog(@"URL is %@", data[keyImageURL]);
    
    _s3URL = data[keyImageURL];
    

    [saveButton stopUploading];
    
}


#pragma mark Recording - 

- (IBAction)recordPauseTapped:(id)sender {
    
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self startTimer];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
    [saveButton setEnabled:NO];
    
}

- (IBAction)stopTapped:(id)sender {
    
    [recorder stop];
    [self stopTimer];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [mainCom uploadAudioFileWithUrl:recorder.url];
    [saveButton startUploading];
    
}

- (IBAction)playTapped:(id)sender {
    
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
    
    
}

#pragma mark Metering Stuff - 

-(void)updateTheMeter
{
    [meterView updateLevelToPercentage:levelPercentage];
    
}
-(CGFloat)percentagePowerForAverage:(CGFloat) average andPeak:(CGFloat) peak
{
    
    CGFloat topLevel = 0.4;
    CGFloat percentageLevel = 0.0;
    
    CGFloat linearDecPeak = powf(10.0, ( peak / 20.0));
    
    
    if (linearDecPeak >= topLevel) {
        percentageLevel = 1.0;
    }
    else
    {
        percentageLevel = linearDecPeak / topLevel;
        
    }
    
    
    return percentageLevel;
}

-(void)levelTimerCallback:(NSTimer*) timer
{
    [recorder updateMeters];
    
    CGFloat averagePower = [recorder averagePowerForChannel:0];
    CGFloat peakPower = [recorder peakPowerForChannel:0];
    
    
    
    levelPercentage = [self percentagePowerForAverage:averagePower andPeak:peakPower];
    
    
    [self performSelectorOnMainThread:@selector(updateTheMeter) withObject:nil waitUntilDone:NO];
    
}

#pragma mark Timer Stuff -

-(void)startTimer
{
    CGFloat levelTimerInterval = 0.03;
    
    recordingTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(refreshLabel:) userInfo:nil repeats:YES];
    
    audioLevelTimer = [NSTimer scheduledTimerWithTimeInterval:levelTimerInterval target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    
    
    //[recordingTimer fire];
}
-(void)stopTimer
{
    [recordingTimer invalidate];
    [audioLevelTimer invalidate];
    audioLevelTimer = nil;
    
    recordingSeconds = 0;
    
}
-(void)refreshLabel:(id) sender
{
    if (recordingMilliseconds == 100) {
        recordingMilliseconds = 0;
        recordingSeconds++;
    }
    else
    {
        recordingMilliseconds++;
    }
    totalTimeInMilliseconds++;
    
    [timeLabel setText:[NSString stringWithFormat:@"%d.%3d", recordingSeconds, recordingMilliseconds]];
}
@end