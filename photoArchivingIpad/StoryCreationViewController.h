//
//  StoryCreationViewController.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageHandling.h"
#import "StoryRecordingMeter.h"
#import "UploadingButton.h"
#import "ImageDisplayStoryUpdater.h"
#import "PAARecording.h"

typedef NS_ENUM(NSInteger, textFieldType) {
    textFieldTypeTitle,
    textFieldTypeStoryteller
    
};
@class StoryCreationViewController;

@protocol StoryTellerCreationFormDelegate <NSObject>

@optional

-(void)didSaveStory:(Story*) aStory;

@end

@interface StoryCreationViewController : UIViewController

@property (nonatomic, weak) id <StoryTellerCreationFormDelegate> delegate;
@property (nonatomic, weak) id <ImageDisplayStoryUpdater> updaterDelegate;

@property (nonatomic, strong) imageObject *information;
@property (nonatomic, strong) PAARecording *myRecording;

@property (nonatomic, strong) NSURL *s3URL;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleValue;

@property (weak, nonatomic) IBOutlet UILabel *storytellerLabel;
@property (weak, nonatomic) IBOutlet UITextField *storytellerValue;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIView *recordingContainer;
@property (weak, nonatomic) IBOutlet UILabel *recordingTitle;
@property (weak, nonatomic) IBOutlet UILabel *recordingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordingTitleTitle;
@property (weak, nonatomic) IBOutlet UILabel *recordingTimeTitle;

-(void)didAddRecording:(PAARecording*) recording;



@end
