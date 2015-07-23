//
//  TFAudioManager.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFAudioManager.h"
#import "TFChromecastManager.h"

@interface TFAudioManager () <AVAudioRecorderDelegate, AVAudioPlayerDelegate, TFChromecastManagerDelegate>

@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) BOOL isPlayingAudio;
@property (nonatomic, assign) BOOL shouldPlayThroughChromeCast;

@property (nonatomic, strong) TFChromecastManager *chromeMan;

@end
@implementation TFAudioManager

#pragma mark - Initializers
+(id)sharedManager
{
    static TFAudioManager   *sharedMan = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMan = [[TFAudioManager alloc] init];
    });
    
    return sharedMan;
}
#pragma mark - Action Methods

#pragma mark Playing Audio
-(void)pauseAudio
{
    if (self.isPlayingAudio) {
        if (self.shouldPlayThroughChromeCast) {
            [self.chromeMan pauseAudio];
        }
        else
        {
            [self.player pause];
            
        }
    }
}
-(void)playAudioFromStory:(Story *)t_story image:(imageObject *)t_img
{
    
    if (self.shouldPlayThroughChromeCast) {
        
        [self.chromeMan playAudioFromStory:t_story image:t_img];
    }
    else
    {
        if (t_story && t_story.recordingS3Url) {
            
            NSData *recordingData = [NSData dataWithContentsOfURL:t_story.recordingS3Url];
            
            NSError *error;
            
            if (self.isPlayingAudio) {
                [self.player stop];
            }
            
            self.player = [[AVAudioPlayer alloc] initWithData:recordingData error:&error];
            
            self.player.numberOfLoops = 0.0;
            self.player.volume = 1.0;
            
            [self.player prepareToPlay];
            [self.player play];
            if ([self.delegate respondsToSelector:@selector(didBeginPlayingAudio)]) {
                [self.delegate didBeginPlayingAudio];
            }
        }
 
    }
}
#pragma mark Recording Audio
-(void)beginRecording
{
    [self.audioSession setActive:YES error:nil];
    [self.recorder prepareToRecord];
    
    [self.recorder record];
}
-(void)stopRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
        
        NSURL *fileUrl = [self.recorder url];
        
        if ([self.delegate respondsToSelector:@selector(didFinishRecordingWithUrl:)]) {
            [self.delegate didFinishRecordingWithUrl:fileUrl];
        }
    }
}
#pragma mark - Delegate Methods

#pragma mark Recorder

#pragma mark Chromecast
-(void)didBeginPlayingAudio
{
    if ([self.delegate respondsToSelector:@selector(didBeginPlayingAudio)]) {
        [self.delegate didBeginPlayingAudio];
    }
}
-(void)didPauseAudio
{
    [self.delegate didPauseAudio];
}

#pragma mark - Getters
-(AVAudioSession *)audioSession
{
    if (!_audioSession) {
        _audioSession = [AVAudioSession sharedInstance];
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    
    return _audioSession;
}
-(BOOL)isPlayingAudio
{
    if (self.shouldPlayThroughChromeCast) {
        return self.chromeMan.isPlayingAudio;
    }
    else
    {
        if (_player) {
            return _player.isPlaying;
        }
    }
    
    return NO;
}
-(TFChromecastManager *)chromeMan
{
    if (!_chromeMan) {
        _chromeMan = [TFChromecastManager sharedManager];
        _chromeMan.delegate = self;
    }
    
    return _chromeMan;
}
-(BOOL)shouldPlayThroughChromeCast
{
    switch ([TFSettings TFAudioPlayerOutputOverride]) {
        case TFAudioPlayTypeDevice:
        {
            return NO;
        }
            break;
            
        case TFAudioPlayTypeDefault:
        {
            if (self.chromeMan.isConnected) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        default:
            break;
    }
}
-(AVAudioRecorder *)recorder
{
    if (!_recorder) {
        
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"MyAudioMemo.m4a",
                                   nil];
        NSURL *recordingURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        _recorder = [[AVAudioRecorder alloc] initWithURL:recordingURL settings:recordSetting error:nil];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
    }
    
    return _recorder;
}



@end
