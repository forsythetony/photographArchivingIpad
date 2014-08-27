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
#import "Story+StoryHelpers.h"



@interface StoryCreationViewController () <TFCommunicatorDelegate, UITextFieldDelegate> {
        UIFont *labelFont;
    UIColor *labelTextColor;
    
    NSURL *recordingURL;
    TFDataCommunicator *mainCom;
    

    NSMutableDictionary *buttonStyle;
    
    NSInteger totalTimeInMilliseconds;
    
}

@end

@implementation StoryCreationViewController
@synthesize titleLabel, storytellerLabel, dateLabel;
@synthesize titleValue, storytellerValue, datePickerView;



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
    

    [self setupVariables];
    [self aestheticsConfig];
    
    
    [datePickerView addTarget:self action:@selector(dateWasUpdated:) forControlEvents:UIControlEventValueChanged];
    
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
    
    
    titleValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
    titleValue.inputAccessoryView = [self createInputAccessoryView];
    [titleValue setDelegate:self];
    
    storytellerValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [storytellerValue setDelegate:self];
    
}
#pragma mark - AVAudioPlayerDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(UIView*)createInputAccessoryView
{
    UIView *inputView;
    
    //  Sizes
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect inputViewRect;
    
    CGFloat inputViewHeight = 40.0;
    CGFloat inputViewWidth = screenRect.size.width;
    
    inputViewRect.size.height = inputViewHeight;
    inputViewRect.size.width = inputViewWidth;
    inputViewRect.origin = CGPointMake(0.0, 0.0);
    
    //  Initialize View
    
    inputView = [[UIView alloc] initWithFrame:inputViewRect];
    
    //  Configure View
    
    [inputView setBackgroundColor:[UIColor whiteColor]];
    
    //  Add buttons
    
    CGFloat buttonHeight = inputViewHeight * 0.75;
    CGFloat buttonWidth = 50.0;
    
    CGRect nextButtonRect;
    
    nextButtonRect.origin.x = 10.0;
    nextButtonRect.origin.y = 0.0;//(inputViewHeight / 2.0) - (buttonHeight / 2.0);
    nextButtonRect.size.width = buttonWidth;
    nextButtonRect.size.height = buttonHeight;
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:nextButtonRect];
    
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor yellowColor]];
    [nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //  Add Buttons to inputview
    
    [inputView addSubview:nextButton];
    
    return inputView;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == titleValue ) {
        
        [self.updaterDelegate didUpdateTitle:titleValue.text];
    }
}
-(void)nextButton:(id) sender
{
    
}
-(void)dateWasUpdated:(UIDatePicker*) sender
{
    if (sender == datePickerView) {
        
        [self.updaterDelegate didUpdateDate:sender.date];
    }
}
@end