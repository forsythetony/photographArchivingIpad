//
//  StoryCreationViewController.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageObject.h"
#import "Story.h"
#import "StoryRecordingMeter.h"
#import "UploadingButton.h"

@class StoryCreationViewController;

@protocol StoryTellerCreationFormDelegate <NSObject>

@optional

-(void)didSaveStory:(Story*) aStory;

@end
@interface StoryCreationViewController : UIViewController

@property (nonatomic, weak) id <StoryTellerCreationFormDelegate> delegate;

@property (nonatomic, strong) imageObject *information;

@property (nonatomic, strong) NSURL *s3URL;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleValue;

@property (weak, nonatomic) IBOutlet UILabel *storytellerLabel;
@property (weak, nonatomic) IBOutlet UITextField *storytellerValue;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;


@property (weak, nonatomic) IBOutlet UploadingButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet StoryRecordingMeter *meterView;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;



@end
