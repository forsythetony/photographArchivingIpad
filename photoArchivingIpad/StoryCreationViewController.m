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
    
    NSArray *namesArray;
    
    UITextField *currentTextField;
    
    
}

@end

@implementation StoryCreationViewController
@synthesize titleLabel, storytellerLabel, dateLabel;
@synthesize titleValue, storytellerValue, datePickerView;
@synthesize recordingContainer, recordingTimeLabel, recordingTitle, recordingTitleTitle, recordingTimeTitle;


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
    
    namesArray = @[ @"Anthony F.", @"Marilyn F.", @"John F.", @"Matt F.", @"Mark F. "];
    
}
-(void)aestheticsConfig
{
    [titleLabel setFont:labelFont];
    [storytellerLabel setFont:labelFont];
    [dateLabel setFont:labelFont];
    
    [datePickerView setDatePickerMode:UIDatePickerModeDate];
    
    
    titleValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
    titleValue.inputAccessoryView = [self createInputAccessoryViewForTextFieldType:textFieldTypeTitle];
    [titleValue setDelegate:self];
    titleValue.placeholder = @"Story Title";
    
    storytellerValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [storytellerValue setDelegate:self];
    storytellerValue.placeholder = @"Name";
    storytellerValue.inputAccessoryView = [self createInputAccessoryViewForTextFieldType:textFieldTypeStoryteller];
    
    recordingTitle.text = @"New Recording";
    recordingTitle.alpha = 0.0;
    
    recordingTimeLabel.text = @"0";
    recordingTimeLabel.alpha = 0.0;
    
    UIFont *titleTitleFont = [UIFont fontWithName:@"DINAlternate-Bold" size:9.0];
    
    
    recordingTitleTitle.font = titleTitleFont;
    
    recordingTitleTitle.backgroundColor = [UIColor clearColor];
    recordingTitleTitle.textColor = [UIColor charcoalColor];
    recordingTitleTitle.alpha = 0.0;
    
    recordingTimeTitle.font = titleTitleFont;
    recordingTimeTitle.backgroundColor = [UIColor clearColor];
    recordingTimeTitle.textColor = [UIColor charcoalColor];
    recordingTimeTitle.alpha = 0.0;
    
    
    UIFont *valueFont = [UIFont fontWithName:@"DINAlternate-Bold" size:15.0];

    recordingTitle.font = valueFont;
    
    recordingTimeLabel.font = valueFont;
    
}
#pragma mark - AVAudioPlayerDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(UIView*)createInputAccessoryViewForTextFieldType:(textFieldType) type
{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect inputViewRect;
    
    CGFloat inputViewHeight = 40.0;
    CGFloat inputViewWidth = screenRect.size.width;
    
    inputViewRect.size.height = inputViewHeight;
    inputViewRect.size.width = inputViewWidth;
    inputViewRect.origin = CGPointMake(0.0, 0.0);
    
     //  Add buttons
    
    CGFloat buttonHeight = inputViewHeight - 5.0;
    CGFloat buttonWidth = 100.0;
    
    CGRect nextButtonRect;
    
    nextButtonRect.origin.x = 10.0;
    nextButtonRect.origin.y = 5.0;//(inputViewHeight / 2.0) - (buttonHeight / 2.0);
    nextButtonRect.size.width = buttonWidth;
    nextButtonRect.size.height = buttonHeight;
    
    
    
    switch (type) {
        case textFieldTypeStoryteller: {
            UIView *inputView;
            
            //  Initialize View
            
            inputView = [[UIView alloc] initWithFrame:inputViewRect];
            
            //  Configure View
            
            [inputView setBackgroundColor:[UIColor whiteColor]];
            

            //  Sizes
            
            UIButton *previousButton = [[UIButton alloc] initWithFrame:nextButtonRect];
            
            [previousButton setTitle:@"Previous" forState:UIControlStateApplication];
            [previousButton setTitleColor:[UIColor blueberryColor] forState:UIControlStateNormal];
            
            [previousButton addTarget:self action:@selector(previousButton:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat xStartForNames = previousButton.frame.origin.x + previousButton.frame.size.width + 50.0;
            
            NSInteger buttonTag = 0;
            
            for (NSString* name in namesArray) {
                
                CGFloat buttonWidth = 100.0;
                CGFloat buttonHeight = nextButtonRect.size.height - 10.0;
                
                
                CGRect buttonFrame;
                buttonFrame.size = CGSizeMake(buttonWidth, buttonHeight);
                buttonFrame.origin.x = xStartForNames;
                buttonFrame.origin.y = 5.0;
                
                UIButton *newButton = [[UIButton alloc] initWithFrame:buttonFrame];
                
                [newButton setTitle:name forState:UIControlStateNormal];
                [newButton setBackgroundColor:[UIColor chartreuseColor]];
                newButton.titleLabel.textColor = [UIColor whiteColor];
                newButton.titleLabel.textAlignment = NSTextAlignmentLeft;
                newButton.layer.cornerRadius = 5.0;
                
                [newButton addTarget:self action:@selector(namesTarget:) forControlEvents:UIControlEventTouchUpInside];
                
                newButton.tag = buttonTag;
                buttonTag++;
                
                xStartForNames += buttonWidth + 10.0;
                
                
                [inputView addSubview:newButton];
                
                
                
            }
            
            [inputView addSubview:previousButton];
            
            return inputView;

        }
            break;
            
        case textFieldTypeTitle: {
            
            UIView *inputViewTitle = [[UIView alloc] initWithFrame:inputViewRect];
            
            //  Configure View
            
            [inputViewTitle setBackgroundColor:[UIColor whiteColor]];
            

            UIButton *nextButton = [[UIButton alloc] initWithFrame:nextButtonRect];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];
            [nextButton setTitleColor:[UIColor blueberryColor] forState:UIControlStateNormal];
            
            [nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
            [inputViewTitle addSubview:nextButton];

            return inputViewTitle;
        }
            break;
            
        default:
            return nil;
            
            break;
    }
    

    
}
- (IBAction)tappedSaveButton:(id)sender {
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == titleValue ) {
        
        [self.updaterDelegate didUpdateTitle:textField.text];
    }
    else if( textField == storytellerValue)
    {
        [self.updaterDelegate didUpdateStoryteller:textField.text];
    }
}
-(void)didAddRecording:(PAARecording *)recording
{
    _myRecording = recording;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        recordingTimeLabel.text = [NSString stringWithFormat:@"%d %@", recording.recordingLength, @"seconds"];
        
        recordingTimeLabel.alpha = 1.0;
        recordingTimeTitle.alpha = 1.0;
        recordingTitleTitle.alpha = 1.0;
        
        recordingTitle.alpha = 1.0;

    });
    
}
-(void)nextButton:(id) sender
{
    if (titleValue.isFirstResponder) {
        [titleValue resignFirstResponder];
    }
    
    [storytellerValue becomeFirstResponder];
}
-(void)previousButton:(id) sender
{
    if (storytellerValue.isFirstResponder) {
        [storytellerValue resignFirstResponder];
    }
    
    [titleValue becomeFirstResponder];
}
-(void)dateWasUpdated:(UIDatePicker*) sender
{
    if (sender == datePickerView) {
        
        [self.updaterDelegate didUpdateDate:sender.date];
    }
}
-(void)namesTarget:(UIButton*) sender
{
    NSInteger nameIndex = sender.tag;
    
    NSString *nameString = [namesArray objectAtIndex:nameIndex];
    
    currentTextField.text = nameString;
    
}
-(NSArray*)createArrayOfButtonsFromNamesArray
{
    NSMutableArray *namesArr = [NSMutableArray new];
    
    NSString *fontFamily = @"DINAlternate-Bold";
    CGFloat fontSize = 13.0;
    
    UIFont *nameFont = [UIFont fontWithName:fontFamily size:fontSize];
    
    UIColor *textColor = [UIColor charcoalColor];
    
    for (NSString* name in namesArray) {
        
        UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 40.0)];
        
        [nameButton setTitle:name forState:UIControlStateNormal];
        nameButton.titleLabel.font = nameFont;
        nameButton.titleLabel.textColor = textColor;
        
        [nameButton addTarget:self action:@selector(namesTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        [nameButton sizeToFit];
        
        
        nameButton.tag = [namesArray indexOfObject:name];
    
        [namesArr addObject:nameButton];
        
    }
    
    return [NSArray arrayWithArray:namesArr];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    currentTextField = textField;
    
    return YES;
}
@end