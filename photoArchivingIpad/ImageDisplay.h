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

#import "ImageDispaySubviews.h"

@interface ImageDisplay : UIViewController <ImageDisplayStoryUpdater>


@property (nonatomic, strong) imageObject* imageInformation;
@property (nonatomic, strong) Story* currentStory;
@property (nonatomic, strong) PAARecording* currentRecording;


@property (weak, nonatomic) IBOutlet UIView *imageDisplaySliderCont;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *storyCreationContainer;
@property (weak, nonatomic) IBOutlet UIView *largeImageDisplayContainer;
@property (weak, nonatomic) IBOutlet UIButton *saveStoryButton;

@end
