//
//  ImageDisplayRecordingSliderView.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDisplayStoryUpdater.h"

@class ImageDisplayRecordingSliderView;

@protocol ImageDisplayRecordingSliderViewDelegate <NSObject>

-(void)didSlideToRecordLock;
-(void)didUnlockSlider;

@end

@interface ImageDisplayRecordingSliderView : UIView

@property (nonatomic, weak) id <ImageDisplayRecordingSliderViewDelegate> delegate;
@property (nonatomic, weak) id <ImageDisplayStoryUpdater> updaterDelegate;

@end
