//
//  ImageDisplayRecordingSliderView.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDisplayStoryUpdater.h"

typedef struct tRecordingDuration {
    
    NSInteger milliseconds;
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    
} RecordingDuration;

//typedef NS_ENUM(NSInteger, DurationDisplayType) {
//
//    DurationDisplayTypeShort,
//    DurationDisplayTypeFine,
//    DurationDisplayTypeFull
//    
//};

@class ImageDisplayRecordingSliderView;

@protocol ImageDisplayRecordingSliderViewDelegate <NSObject>

-(void)didSlideToRecordLock;
-(void)didUnlockSliderWithRecordingTime:(RecordingDuration*) recDuration;

@end

@interface ImageDisplayRecordingSliderView : UIView

@property (nonatomic, weak) id <ImageDisplayRecordingSliderViewDelegate> delegate;
@property (nonatomic, weak) id <ImageDisplayStoryUpdater> updaterDelegate;


-(void)startedRecording;
-(void)stoppedRecording;

@end
