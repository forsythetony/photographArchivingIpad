//
//  ImageDisplay.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "ImageDisplay.h"
#import <POP.h>
#import "TFDataCommunicator.h"
#import <AVFoundation/AVFoundation.h>
#import "Story+StoryHelpers.h"

@interface ImageDisplay () <ImageDisplayRecordingSliderViewDelegate, TFCommunicatorDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    
    //  Audio stuff
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    
    NSURL *recordingURL;
    
    ImageDisplayRecordingSliderView *sliderView;
    
    StoryCreationViewController *formController;
    LargeImageDisplayView *displayView;
    TFDataCommunicator *mainCom;
}


@end

@implementation ImageDisplay
@synthesize imageInformation;
@synthesize imageDisplaySliderCont, largeImageDisplayContainer;
@synthesize currentStory, currentRecording;
@synthesize saveStoryButton;


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
    [super viewDidLoad];
    
    //  Set up data communicator
    
    mainCom = [TFDataCommunicator new];
    [mainCom setupTransferManager];
    mainCom.delegate = self;
    
    
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", imageInformation.title);
    
    sliderView = [[ImageDisplayRecordingSliderView alloc] initWithFrame:imageDisplaySliderCont.bounds];
    sliderView.delegate = self;
    sliderView.updaterDelegate = self;
    
    
    [imageDisplaySliderCont addSubview:sliderView];
    
    _testLabel.text = @"";

    StoryCreationViewController *form = [[StoryCreationViewController alloc] initWithNibName:@"AddStoryForm" bundle:[NSBundle mainBundle]];
    form.updaterDelegate = self;
    
    
    form.view.frame = CGRectMake(1000.0, 0.0, _storyCreationContainer.bounds.size.width, _storyCreationContainer.bounds.size.height);
    
    [_storyCreationContainer addSubview:form.view];
    [self addChildViewController:form];
    [form didMoveToParentViewController:self];
    
    

    displayView = [[LargeImageDisplayView alloc] initWithFrame:largeImageDisplayContainer.bounds];
    
    [largeImageDisplayContainer addSubview:displayView];
    [mainCom retrieveImageWithURL:[imageInformation.photoURL absoluteString]];
    
    
    //  Button Setup
    
    [saveStoryButton setTitle:@"Save Story" forState:UIControlStateNormal];
    [saveStoryButton setEnabled:NO];
    
    
    formController = form;
    [self audioPlayerSetup];
    
}
-(void)moveFormToView
{
    POPSpringAnimation *moveAnimation = [POPSpringAnimation animation];
    moveAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    
    
    moveAnimation.fromValue = [NSValue valueWithCGRect:formController.view.frame];
    moveAnimation.toValue = [NSValue valueWithCGRect:formController.view.bounds];
    
    [formController.view pop_addAnimation:moveAnimation forKey:@"moving"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSlideToRecordLock
{
    
    currentStory = [Story setupWithRandomID];
    
    _testLabel.text = @"Recording";

    [self moveFormToView];
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        
    } else {
        
        // Pause recording
        [recorder pause];
    }
    
    [sliderView startedRecording];
    

    
}
-(void)didUnlockSliderWithRecordingTime:(NSInteger)recordingTime
{
    
    _testLabel.text = @"Stopped Recording";
    
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    NSURL *recorderURL = recorder.url;
    
    NSLog(@"The recorders url string is %@", recorderURL.absoluteString);
    
    currentRecording = [PAARecording new];
    
    currentRecording.title = @"Some title";
    currentRecording.recordingLength = recordingTime;
    
    [mainCom uploadAudioFileWithUrl:recorder.url andKey:[[NSDate date] displayDateOfType:sdatetypeURL]];
    [sliderView stoppedRecording];
    

    
}
/*
    Data communicator delegate methods
*/
-(void)finishedUploadingRequestWithData:(NSDictionary *)data
{

    currentRecording.s3URL = data[keyImageURL];
    
    [formController didAddRecording:currentRecording];
    
    [saveStoryButton setEnabled:YES];
    
}
-(void)finishedPullingImageFromUrl:(UIImage *)image
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [displayView setDisplayedImage:image];
    });
}
/*
    Recording Stuff
*/
-(void)audioPlayerSetup
{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    recordingURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:recordingURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];

}

/*
    Story Updater Delegate Methods
*/

-(BOOL)didUpdateTitle:(NSString *)newTitle
{
    BOOL isSuccessful = YES;
    
    if (currentStory) {
        currentStory.title = newTitle;
    }
    
    return  isSuccessful;
}
-(BOOL)didUpdateDate:(NSDate *)newDate
{
    BOOL isSuccess = YES;
    
    
    if (currentStory) {
        currentStory.storyDate = newDate;
    }
    
    return isSuccess;
}
-(BOOL)didUpdateStoryteller:(NSString *)newStoryteller
{
    BOOL isSuccess = YES;
    
    if(currentStory)
    {
        currentStory.storyTeller = newStoryteller;
    }
    
    return isSuccess;
}
- (IBAction)didTapSaveStory:(id)sender {
    
    
}

@end
