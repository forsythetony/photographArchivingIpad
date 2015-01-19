//
//  ImageDisplay.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageObject.h"
#import "PAARecording.h"
#import "WorkspaceViewController.h"
#import "ImageDispaySubviews.h"

@protocol ImageDisplayDelegate <NSObject>

-(void)shouldDismiss;
-(void)playAudioWithStory:(Story*) audioStory;
-(void)shouldStopAudio;
-(void)updatePlayerVolumeTo:(float) newVolume;

@end
@interface ImageDisplay : UIViewController <ImageDisplayStoryUpdater>


@property (weak, nonatomic) IBOutlet UIView *plusButtonContainer;
@property (nonatomic, strong) imageObject* imageInformation;
@property (nonatomic, strong) Story* currentStory;
@property (nonatomic, strong) PAARecording* currentRecording;

@property (nonatomic, weak) id <ImageDisplayDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *imageDisplaySliderCont;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *storyCreationContainer;
@property (weak, nonatomic) IBOutlet UIView *largeImageDisplayContainer;
@property (weak, nonatomic) IBOutlet UIButton *saveStoryButton;


@property (assign, nonatomic) BOOL useChromecast;

@end
