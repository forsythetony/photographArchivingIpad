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
#import "StoriesDisplayTableview.h"
#import "ImageDisplay+testThingies.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "TAStyler.h"
#import <Masonry/Masonry.h>

@interface ImageDisplay () <ImageDisplayRecordingSliderViewDelegate, TFCommunicatorDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate, StoriesCellDelegate> {
    
    //  Audio stuff
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    
    NSURL *recordingURL;
    
    ImageDisplayRecordingSliderView *sliderView;
    
    StoryCreationViewController *formController;
    LargeImageDisplayView *displayView;
    TFDataCommunicator *mainCom;
    StoriesDisplayTableview *storiesList;
    
    Story *storySlatedForDeletion;
    
    NSArray *currentStories;

    VBFPopFlatButton *zeSaveButton;
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
    
    [self aestheticsConfiguration];
    
    currentStories = imageInformation.stories;
    
    //  Set up data communicator
    
    mainCom = [TFDataCommunicator new];
    [mainCom setupTransferManager];
    mainCom.delegate = self;
    
    
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", imageInformation.title);
    
    sliderView = [[ImageDisplayRecordingSliderView alloc] initWithFrame:imageDisplaySliderCont.bounds];
    sliderView.delegate = self;
    sliderView.updaterDelegate = self;
    
    [imageDisplaySliderCont setBackgroundColor:[UIColor clearColor]];
    [imageDisplaySliderCont addSubview:sliderView];
    
    _testLabel.text = @"";
    
    CGRect storiesListFrame = _storyCreationContainer.bounds;
    
    storiesList = [[StoriesDisplayTableview alloc] initWithFrame:storiesListFrame];
    storiesList.delegate = self;
    storiesList.dataSource = self;
    
    
    [_storyCreationContainer addSubview:storiesList];
    

    

    displayView = [[LargeImageDisplayView alloc] initWithFrame:largeImageDisplayContainer.bounds];
    
    [largeImageDisplayContainer addSubview:displayView];
    [mainCom retrieveImageWithURL:[imageInformation.photoURL absoluteString]];
    
    
    //  Button Setup
    
    [saveStoryButton setTitle:@"Save Story" forState:UIControlStateNormal];
    [saveStoryButton setEnabled:NO];
    
    
    [saveStoryButton setAlpha:0.0];
    [self audioPlayerSetup];
     [_plusButtonContainer setBackgroundColor:[UIColor clearColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [storiesList reloadData];
    [self setSaveButtonToDisabled];
    [self createButtons];
    
}
-(void)aestheticsConfiguration
{
    //  Set Background Pattern/Color
    
    UIImage *patternImage = [UIImage imageNamed:@"subtle_carbon.png"];
    
    UIColor *mainBackgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.view.backgroundColor = mainBackgroundColor;
    
    _storyCreationContainer.backgroundColor = [UIColor charcoalColor];
    
    
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
    formController = [[StoryCreationViewController alloc] initWithNibName:@"AddStoryForm" bundle:[NSBundle mainBundle]];
    formController.updaterDelegate = self;
    
    
    formController.view.frame = CGRectMake(1000.0, 0.0, _storyCreationContainer.bounds.size.width, _storyCreationContainer.bounds.size.height);
    
    [_storyCreationContainer addSubview:formController.view];
    [self addChildViewController:formController];
    [formController didMoveToParentViewController:self];
    

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
-(void)didUnlockSliderWithRecordingTime:(RecordingDuration*) recDuration
{
    
    _testLabel.text = @"Stopped Recording";
    
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    NSURL *recorderURL = recorder.url;
    
    NSLog(@"The recorders url string is %@", recorderURL.absoluteString);
    
    currentRecording = [PAARecording new];
    
    currentRecording.recordingLength = [TADuration createWithMilliseconds:recDuration->milliseconds Seconds:recDuration->seconds Minutes:recDuration->minutes andHours:recDuration->hours];
    
    currentRecording.title = @"Some title";
    
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
    
    currentStory.audioRecording = currentRecording;
    
    [self performSelectorOnMainThread:@selector(setSaveButtonToEnabled) withObject:nil waitUntilDone:NO];
    
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
    
    NSLog(@"Data For Current Story\nTitle: %@\nStoryTeller: %@\nDate: %@", currentStory.title, currentStory.storyTeller, [currentStory.storyDate description]);
    
    currentStory.audioRecording = currentRecording;
    
    [mainCom addStoryToImage:currentStory imageObject:imageInformation];
    
    

    
    [self removeStoryFromView];
    
}
-(void)finishedAddingStoryWithHTTPResponseCode:(NSInteger)responseCode
{
    if (responseCode == 201) {
        
        [self performSelectorOnMainThread:@selector(addStoryToList:) withObject:currentStory waitUntilDone:NO];
//        [self addStoryToList:currentStory];
        
        currentStory = nil;
        currentRecording = nil;
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error adding the story to the photograph." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
    }
}
-(void)addStoryToList:(Story*) newStory
{
    NSMutableArray *storiesarr;
    
    if (currentStories) {
        storiesarr = [NSMutableArray arrayWithArray:currentStories];
    }
    else
    {
        storiesarr = [NSMutableArray new];
    }
    
    
    
    NSInteger rowOfNewStory = [storiesarr count];
    
    NSIndexPath *newIndex = [NSIndexPath indexPathForRow:rowOfNewStory inSection:0];
    
    [storiesList beginUpdates];
    
    [storiesarr addObject:newStory];
    
    
    
    
    currentStories = [NSArray arrayWithArray:storiesarr];
    
    [storiesList insertRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationFade];
    
    [storiesList endUpdates];
    
}
-(void)removeStoryFromView
{
    CGRect currentStoryFrame = formController.view.frame;
    CGRect newStoryControllerFrame = currentStoryFrame;
    
    newStoryControllerFrame.origin.x += 1000.0;
    
    POPSpringAnimation *moveControllerAway = [POPSpringAnimation animation];
    moveControllerAway.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    
    moveControllerAway.fromValue = [NSValue valueWithCGRect:currentStoryFrame];
    moveControllerAway.toValue = [NSValue valueWithCGRect:newStoryControllerFrame];
    
    [moveControllerAway setCompletionBlock:^(POPAnimation *ani, BOOL maybe) {
        [formController removeFromParentViewController ];
        formController = nil;
        
    }];
    
    [formController.view pop_addAnimation:moveControllerAway forKey:@"moveingAway"];
}
/*
    Stories Display Table view stuff
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == storiesList) {
        return 1;
    }
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == storiesList) {
        return [currentStories count];
    }

    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * storiesListCellID = @"storiesTableViewCell";
    
    StoriesDisplayTableviewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storiesListCellID];
    
    if (cell == nil) {
        
        UINib *cellNib = [UINib nibWithNibName:@"StoriesDisplayTableviewCellTableViewCell" bundle:[NSBundle mainBundle]];
        
        [tableView registerNib:cellNib forCellReuseIdentifier:storiesListCellID];
        
        
        
    }
    
    cell = (StoriesDisplayTableviewCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:storiesListCellID];
    [cell setDelegate:self];
    
    [cell setMyStory:[currentStories objectAtIndex:indexPath.row]];
    
    return cell;
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == storiesList) {
        return YES;
    }
    
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        Story *storyToRemove = [currentStories objectAtIndex:indexPath.row];
        
        storySlatedForDeletion = storyToRemove;
        
        [mainCom removeStoryFromImage:imageInformation withStoryID:storyToRemove.stringId];
        
        /*
        NSInteger cellIndex = indexPath.row;
        
        NSMutableArray *stories = [NSMutableArray arrayWithArray:currentStories];
        
        [tableView beginUpdates];
        [stories removeObjectAtIndex:cellIndex];
        currentStories = [NSArray arrayWithArray:stories];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        */
        
    }
}

-(void)finishedDeletingStoryWithStatusCode:(NSInteger)statusCode
{
    if (statusCode == 200) {
        
        [self performSelectorOnMainThread:@selector(removeStorySlatedForDeletion) withObject:nil waitUntilDone:NO];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"Could not delete the story" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        storySlatedForDeletion = nil;
        
    }
}
-(void)removeStorySlatedForDeletion
{
    
    

    [storiesList beginUpdates];
    
    NSMutableArray *storiesArr = [NSMutableArray arrayWithArray:currentStories];
    
    NSInteger storyIndexPath = [storiesArr indexOfObject:storySlatedForDeletion];
    
    NSIndexPath *deletionIndexPath = [NSIndexPath indexPathForRow:storyIndexPath inSection:0];
    
    [storiesArr removeObjectAtIndex:storyIndexPath];
    
    currentStories = [NSArray arrayWithArray:storiesArr];
        [storiesList deleteRowsAtIndexPaths:@[deletionIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    storySlatedForDeletion = nil;
    
    
    [storiesList endUpdates];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == storiesList) {
        return 162.0;
    }
    
    return 10.0;
    
}
-(void)shouldChangeButtonToState:(ButtonState)newState
{
    switch (newState) {
        case ButtonStateEnabled: {
         
            [self performSelectorOnMainThread:@selector(setSaveButtonToEnabled) withObject:nil waitUntilDone:NO];
        }
            break;
            
        case ButtonStateUploading: {
            
            [self performSelectorOnMainThread:@selector(setSaveButtonUploading) withObject:nil waitUntilDone:NO];
            
        }
            break;
            
        case ButtonStateDisabled: {
            
            [self performSelectorOnMainThread:@selector(setSaveButtonToDisabled) withObject:nil waitUntilDone:NO];
            
        }
            break;
        default:
            break;
    }
}
-(void)setSaveButtonToEnabled
{
//    [saveStoryButton setTitle:@"Save" forState:UIControlStateNormal];
//    [saveStoryButton setTitle:@"Save" forState:UIControlStateDisabled];
//    
//    [saveStoryButton setEnabled:YES];
    
    [zeSaveButton animateToType:buttonAddType];
    [zeSaveButton setRoundBackgroundColor:[UIColor successColor]];
    [zeSaveButton setEnabled:YES];
    
}
-(void)setSaveButtonToDisabled
{
//    [saveStoryButton setTitle:@"Save" forState:UIControlStateNormal];
//    [saveStoryButton setEnabled:NO];
    
    [zeSaveButton setEnabled:NO];
    [zeSaveButton setRoundBackgroundColor:[UIColor grayColor]];
}
-(void)setSaveButtonUploading
{
    //[saveStoryButton setTitle:@"Uploading..." forState:UIControlStateNormal];
//    [saveStoryButton setTitle:@"Uploading" forState:UIControlStateDisabled];
//    [saveStoryButton setEnabled:NO];
    
    [zeSaveButton setEnabled:NO];
    [zeSaveButton setRoundBackgroundColor:[UIColor grayColor]];
    
}
-(void)createButtons
{
    CGRect backButtonFrame;
    
    backButtonFrame.origin = CGPointMake(0.0, 0.0);
    backButtonFrame.size.width = 50.0;
    backButtonFrame.size.height = 50.0;
    
    VBFPopFlatButton *backButton = [[VBFPopFlatButton alloc] initWithFrame:backButtonFrame buttonType:buttonBackType buttonStyle:buttonRoundedStyle];
    
    backButton.roundBackgroundColor = [TAStyler getButtonBackgroundColor];
    backButton.linesColor = [TAStyler getButtonForegroundColor];
    
    backButton.lineThickness = 1.0;
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    VBFPopFlatButton *testButton = [[VBFPopFlatButton alloc] initWithFrame:backButtonFrame buttonType:buttonDefaultType buttonStyle:buttonRoundedStyle];
    
    testButton.roundBackgroundColor = [UIColor successColor];
    testButton.linesColor = [TAStyler getButtonForegroundColor];
    
    testButton.lineThickness = 2.0;
    
    [testButton addTarget:self action:@selector(testingThings:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:testButton];
    [self.view addSubview:backButton];
    
    float padding = 10.0;
    
    
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.lessThanOrEqualTo(self.view.mas_bottom).with.offset(- ((backButtonFrame.size.height / 2.0) + padding + 10.0)).with.priorityMedium();
        make.leading.equalTo(largeImageDisplayContainer.mas_leading).with.priorityMedium();
        
    }];
    
    CGFloat xPos = self.view.bounds.size.width - 60.0;
    CGFloat yPos = self.view.bounds.size.height - 60.0;
    
    [testButton setCenter:CGPointMake(xPos, yPos)];
   // testButton.layer.mask.anchorPoint = CGPointMake(0.5, 0.5);
   // testButton.layer.mask.position = [_plusButtonContainer center];
/*
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_plusButtonContainer).priorityHigh();
        
        
    }];


    CGFloat testButtonX = sliderView.center.x - (backButtonFrame.size.width / 2.0);
    CGFloat testButtonY = sliderView.frame.origin.y + sliderView.frame.size.height + 30.0;
    
    CGFloat testButtonWidth = backButtonFrame.size.width;
    CGFloat testButtonHeight = backButtonFrame.size.height;
    
    CGRect testButtonFrame = CGRectMake(testButtonX, testButtonY, testButtonWidth, testButtonHeight);
    
    [testButton setFrame:testButtonFrame];
    */

    [testButton setEnabled:NO];
    [testButton setRoundBackgroundColor:[UIColor grayColor]];
    zeSaveButton = testButton;
}
-(void)goBack:(id) sender
{
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.delegate shouldDismiss];
}
-(void)testingThings:(id) sender
{
    NSLog(@"Data For Current Story\nTitle: %@\nStoryTeller: %@\nDate: %@", currentStory.title, currentStory.storyTeller, [currentStory.storyDate description]);
    
    currentStory.audioRecording = currentRecording;
    
    [mainCom addStoryToImage:currentStory imageObject:imageInformation];
    
    
    
    
    [self removeStoryFromView];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)playAudioStreamWithStory:(Story *)audioStory
{
    [self.delegate playAudioWithStory:audioStory];
}
-(void)shouldStopAudio
{
    [self.delegate shouldStopAudio];
}
@end
