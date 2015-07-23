//
//  TFAudioManager.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Story.h"
#import "imageObject.h"
#import "TFSettings.h"

@protocol TFAudioManagerDelegate;

@interface TFAudioManager : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

+(id)sharedManager;

-(void)playAudioFromStory:(Story*) t_story image:(imageObject*) t_img;
-(void)pauseAudio;
-(void)stopAudio;
-(void)beginRecording;
-(void)stopRecording;

@property (nonatomic, weak) id<TFAudioManagerDelegate> delegate;

@end

@protocol TFAudioManagerDelegate <NSObject>

@optional
-(void)didBeginPlayingAudio;
-(void)didPauseAudio;
-(void)didFinishRecordingWithUrl:(NSURL*) t_url;

@end
