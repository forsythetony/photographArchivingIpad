//
//  WorkspaceViewController.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
#import "WorkspaceViewController.h"
#import <objc/message.h>
#import "StoryCreationViewController.h"
#import "StoriesDisplayTable.h"
#import "ImageDisplay.h"
#import "NSDictionary+ObjectCreationHelpers.h"
#import <QuartzCore/QuartzCore.h>
#import "TAProgressView.h"
#import "TATriggerFrame.h"
#import "HTGCTextChannel.h"
#import <AVFoundation/AVFoundation.h>

#define TLWALLSPACING 100.0
#define MAINSCROLLVIEWSIZE 10000.0

typedef struct tDateLineLayout {
    
    CGPoint center;
    CGFloat height;
    BOOL shouldShow;
    
} DateLineLayoutVals;
typedef struct tScrollTriggerArea {
    
    CGRect leftTrigger;
    CGRect rightTrigger;
    BOOL isRightTriggered;
    BOOL isLeftTriggered;
    

} ScrollTriggers;

static NSString* segueDisplayLargeImage = @"showLargeImageDisplay";
static NSString* kReceiverAppID         = @"94B7DFA1";

@interface WorkspaceViewController ()
<
    StoryTellerCreationFormDelegate,
    UIAlertViewDelegate,
    UIScrollViewDelegate,
    TATriggerFrameDelegate,
    ImageDisplayDelegate,
    AVAudioPlayerDelegate,
    imageObjectDelegate
>
{
    
    float   TLSpacing;
    
    float   xDelta, yDelta,
            firstX, firstY;
    
    double  pureStartDate,
            pureEndDate;
    
    BOOL    useDummyData,
            shouldLoadAgain;
    
    CGPoint startingPoint;
    
    dummyDataProvider   *dataProvider;
    timelineManager     *TLManager;
    TFDataCommunicator  *mainDataCom;

    UIScrollView    *mainScrollView;
    
    NSDate  *startDate,
            *endDate;
    
    NSArray *photoList;
    NSArray *imageInformationVClist;
    
    UIPopoverController *storyAddPopover;
    
    UIView *buttonsContainerView;
    
    NSTimer *moveScreenTimer;
    
    ScrollTriggers scrollTrigger;
    
    pictureFrame *grabbedFrame;
    CGPoint newGrabbedCenter;
    
    BOOL finishedMoving;
    BOOL justWentRight;
    
    NSUInteger triggerTime;
    
    UIView *rightTriggerView, *leftTriggerView;
    
    CGFloat triggerWidth;
    
    
    NSTimer *triggerLockTimer;
    BOOL triggerLocked;
    
    TAProgressView *customProgressView;
    TATriggerFrame *rightTrigFrame, *leftTrigFrame;
    
    float triggerTimeFloat;
    
    
    UIImage *_btnImage;
    UIImage *_btnImageSelected;
    
    AVAudioPlayer *player;
    
    imageObject *prevImage;
    
    BOOL imageSent;
    NSInteger sentNum;
    
    UIView *dateUpdaterLine;
    UILabel *dateUpdaterDayLabel;
    UILabel *dateUpdaterLabel;
    
    UIView *alertView;
    
    imageObject *updatingImageObject;
    ImagePackage *updatingImagePackage;
    
    BOOL isDateUpdateLockOn;
    
    NSTimer *updateLineColorTimer, *incompleteTimer;
    
    AVAudioSession* currentAudioSession;
}

@property GCKMediaControlChannel *mediaControlChannel;
@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property(nonatomic, strong) GCKDeviceScanner *deviceScanner;
@property(nonatomic, strong) UIButton *chromecastButton;
@property(nonatomic, strong) GCKDeviceManager *deviceManager;
@property(nonatomic, readonly) GCKMediaInformation *mediaInformation;

@end

@implementation WorkspaceViewController
@synthesize timelineDateRange;

#pragma mark Initialization Stuff -

-(void)variableSetup
{
    triggerWidth = 60.0;
    triggerLocked = NO;
    triggerTimeFloat = 1.5;
    prevImage = nil;
    imageSent = NO;
    sentNum = 0;
    isDateUpdateLockOn = NO;
}


-(void)setupTriggerViews
{
 
    CGRect leftFrame;
    
    leftFrame.origin = CGPointMake(0.0, 0.0);
    leftFrame.size.width = triggerWidth;
    leftFrame.size.height = mainScrollView.frame.size.height;
    
    
    leftTrigFrame = [[TATriggerFrame alloc] initWithFrame:leftFrame];
    [leftTrigFrame setTotalTime:triggerTimeFloat];
    [leftTrigFrame setTriggerColor:[UIColor chartreuseColor]];
    
    
    CGRect rightFrame;
    
    rightFrame.origin.x = mainScrollView.frame.size.width - triggerWidth;
    rightFrame.origin.y = 0.0;
    rightFrame.size.width = triggerWidth;
    rightFrame.size.height = leftFrame.size.height;

    rightTrigFrame = [[TATriggerFrame alloc] initWithFrame:rightFrame];
    
    [rightTrigFrame setTotalTime:triggerTimeFloat];
    [rightTrigFrame setTriggerColor:[UIColor chartreuseColor]];
    rightTrigFrame.delegate = self;
    
    [self.view addSubview:rightTrigFrame];
    
    
    
   // [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(trigUpdate) userInfo:nil repeats:NO];
        
}
-(void)didFinishAnimation:(TATriggerFrame *)progressView
{
    [self goRight:nil];
}
-(void)finishedAddingStory
{
    UIAlertView *storyAddedAlert = [[UIAlertView alloc] initWithTitle:@"Story Added!" message:@"The story has been added to the image" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    [storyAddedAlert show];
    
}
-(void)didSaveStory:(Story *)aStory
{
    [_displayImageInformation addStory:aStory];
    
    [_infPager updateImageInformation:_displayImageInformation];
    [mainDataCom addStoryToImage:aStory imageObject:_displayImageInformation];
    
    [storyAddPopover dismissPopoverAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}
/*
- (void)createImagesArray
{
    
    NSBundle *theBundle = [NSBundle mainBundle];
    
    NSLog(@"Bundle path is: %@", theBundle.resourcePath);
    
}
*/
-(void)printFrameData {
    
    NSLog(@"\nScroll view content size is...%@\n", NSStringFromCGSize(mainScrollView.contentSize));
    
    NSLog(@"\nScroll view frame is...%@\n", NSStringFromCGRect(mainScrollView.frame));
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if (shouldLoadAgain == YES) {
        [self createScrollView];
        //[self createAuxViews];

        [mainDataCom getPhotosForUser:@"forsytheTony"];
        [self printFrameData];
        shouldLoadAgain = NO;
    }
    else {
        CGSize newContentSize = mainScrollView.contentSize;
        
        newContentSize.height -= self.navigationController.navigationBar.frame.size.height + 20.0;
        
        [mainScrollView setContentSize:newContentSize];
        [self printFrameData];
    }
    /*
    StoryCreationViewController *story = [[StoryCreationViewController alloc] initWithNibName:@"AddStoryForm" bundle:[NSBundle mainBundle]];
    story.delegate = self;
    storyAddPopover = [[UIPopoverController alloc] initWithContentViewController:story];
    

    
    CGRect leftTrigger = CGRectMake(0.0, 0.0, triggerWidth, self.view.frame.size.height);
    CGRect rightTrigger = CGRectMake(self.view.frame.size.width - triggerWidth, 0.0, triggerWidth, self.view.frame.size.height);
    
    scrollTrigger.leftTrigger = leftTrigger;
    scrollTrigger.rightTrigger = rightTrigger;
    scrollTrigger.isLeftTriggered = NO;
    scrollTrigger.isRightTriggered = NO;
    justWentRight = NO;
    
    [self setupTriggerViews];
    
    //[self testLayer];
    
    //[self testProgressView];
    */
    
//    [mainScrollView setContentSize:CGSizeMake(MAINSCROLLVIEWSIZE, 768)];
}
-(void)trigUpdate
{
    [rightTrigFrame start];
}
-(void)initialSetup
{
    
    self.modalPresentationStyle = UIModalTransitionStylePartialCurl;
    
    self.view.backgroundColor   =[UIColor clearColor];
    self.title                  = @"Timeline";
    
    
    if (!self.timelineDateRange) {
        
        self.timelineDateRange = [DateRange createRangeWithDefaultValues];
    }
    
    photoList = [NSArray new];
    
    useDummyData = NO;
    
    
    mainDataCom = [[TFDataCommunicator alloc] init];

    mainDataCom.delegate    = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    finishedMoving = NO;
  
    self.navigationController.navigationBar.tintColor = [UIColor black75PercentColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
}
-(void)finishedPullingPhotoList:(NSArray *)list
{
    
    if (list.count > 0) {
        
        NSMutableArray *framez = [NSMutableArray new];
        
        for (NSDictionary* dict in list)
        {
            /*
            NSLog(@"%@", dict);
            
            imageObject *obj = [imageObject new];
            
            pictureFrame *frame = [pictureFrame createFrame];
            
            
            obj.photoURL        = [NSURL URLWithString:[dict objectForKey:@"imageURL"]];
            obj.thumbNailURL    = [NSURL URLWithString:[dict objectForKey:@"thumbnailURL"]];
            obj.date            = [NSDate dateWithv1String:dict[@"imageInformation"][@"dateTaken"][@"dateString"]];
            obj.title           = [[dict objectForKey:@"imageInformation"] objectForKey:@"title"];
            obj.centerXoffset   = @0.0;
            obj.imageInformation = [NSDictionary dictionaryWithDictionary:dict];
            obj.uploader        =   [[dict objectForKey:@"uploadInformation"] objectForKey:@"uploader"];
            obj.confidence      =   [NSString stringWithFormat:@"%@", [[[dict objectForKey:@"imageInformation"] objectForKey:@"dateTaken"] objectForKey:@"confidence"]];
            obj.id = [NSString stringWithFormat:@"%@", dict[@"_id"]];
            
            NSString *recordingURL = dict[@"recordingURL"];
            
            NSArray *storiesArray = dict[jsonKeyStories];
            
            if (storiesArray) {
                
                NSMutableArray *storiesArr = [NSMutableArray new];
                
                for (NSDictionary *storyDictionary in storiesArray) {
                
                    Story *newStory = [Story new];
                    
                    newStory.title = storyDictionary[jsonKeyStories_title];
                    
                    newStory.storyTeller = storyDictionary[jsonKeyStories_StoryTeller];
                    newStory.recordingS3Url = [NSURL URLWithString:storyDictionary[jsonKeyStories_RecordingURL]];
                    newStory.storyDate = [NSDate dateWithv1String:storyDictionary[jsonKeyStories_Date]];
                    newStory.stringId = storyDictionary[jsonKeyStories_stringID];
                    
                    [storiesArr addObject:newStory];
                }
                obj.stories = [NSArray arrayWithArray:storiesArr];
            }
            if (recordingURL) {
                obj.recordingURL = [NSURL URLWithString:recordingURL];
            }
            else
            {
                obj.recordingURL = nil;
            }
            
            if (obj.photoURL)
            {
                
            [frame setImageObject:obj];
            
            [frame setFrame:CGRectMake(
                                       0.0  , 0.0,
                                       70.0 , 70.0
                                       )];
            
            [framez addObject:frame];
            }
             */
            
            
            imageObject *newImage = [dict convertToBabbageImageObject];
           
            
            pictureFrame *frame = [pictureFrame createFrame];
            

                
                [frame setImageObject:newImage];
                
                [frame setFrame:CGRectMake(
                                           0.0  , 0.0,
                                           70.0 , 70.0
                                           )];
                
                [framez addObject:frame];

            
            
        }
        
        photoList = [NSArray arrayWithArray:framez];
        
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
        
    }
    
}
-(void)dummyDataGenerator
{
    
    NSMutableArray *objsArr = [NSMutableArray new];
    
    imageObject *obj1 = [imageObject new];
    
    obj1.photoURL = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/node-photo-archive/mainPhotos/Lazy_Sunday2014-06-13T18-54%3A50-701Z"];
    obj1.thumbNailURL = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/node-photo-archive/mainPhotos/Lazy_Sunday2014-06-13T18-54%3A50-701Z-thumbnail"];
    obj1.date = [NSDate dateWithv1String:@"06/22/1912"];
    obj1.title = @"Girls Towm";
    obj1.centerXoffset = @(0.0);
    obj1.uploader = @"forsythetony";
    [objsArr addObject:obj1];
    
    photoList = [NSArray arrayWithArray:objsArr];
    
    [self updateUI];
}
-(void)updateUI
{
    
    [TLManager setInitialPhotographs:photoList];
    
    [TLManager bringSubyearsToFront];
    
    [self addGestureRecognizers];
    
}
-(void)viewWillAppear:(BOOL)animated {
//    [mainScrollView setContentOffset:CGPointZero];
}
- (void)viewDidLoad
{
    [self variableSetup];
    
    shouldLoadAgain = YES;
    
    [super viewDidLoad];
    
    [self initialSetup];
    
    [self chromecastThings];
    
    NSLog(@"ViewdidLoad");
    [self printFrameData];
    
    self.view.autoresizesSubviews = YES;
}

-(void)handleStoryAddition:(id) sender
{
    
    [storyAddPopover presentPopoverFromRect:_addStoryButton.frame inView:buttonsContainerView  permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}
-(void)handleOtherInfoClickFromSender:(id) sender
{
    if (_displayedImage) {
        [mainDataCom deletePhoto:_displayImageInformation];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[StoryCreationViewController class]]) {
        
        StoryCreationViewController *dest = (StoryCreationViewController*)segue.destinationViewController;
        
        
        [dest setInformation:_displayImageInformation];
        
    }
    else if( [segue.destinationViewController isKindOfClass:[ImageDisplay class]])
    {
        ImageDisplay *dest = (ImageDisplay*)segue.destinationViewController;
        dest.delegate = self;
        dest.imageInformation = (imageObject*)sender;
    }
}
-(UIImage*)getImageViewForStoryType:(buttonIconType) storyType withButtonHeight:(float) buttonHeight
{
    

    float buttonIconSize = buttonHeight;
    float mainIconSize = buttonIconSize * 0.7;
    float plusIconSize = buttonIconSize * 0.3;
    
    
    CGRect plusRect = CGRectMake(2.0, (buttonIconSize / 2.0) - (plusIconSize / 2.0) - 3.0, plusIconSize, plusIconSize);
    CGRect iconRect = CGRectMake(plusRect.origin.x + plusRect.size.width - 2.0, (buttonIconSize / 2.0) - (mainIconSize / 2.0), mainIconSize, mainIconSize);
 
    CGRect buttonIconRect = CGRectMake(0.0, 0.0, buttonIconSize, buttonIconSize);
    
    UIView *mainView = [[UIView alloc] initWithFrame:buttonIconRect];
    
    FAKFontAwesome *mainIcon;
    
    FAKFontAwesome *plusIcon = [FAKFontAwesome plusIconWithSize:plusIconSize];
    [plusIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    
    switch (storyType) {
        case buttonIconTypeStory:
            
            mainIcon = [FAKFontAwesome bookIconWithSize:mainIconSize];
            
            [mainIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
            
            break;
            case buttonIconTypeRecording:
            
            mainIcon = [FAKFontAwesome volumeDownIconWithSize:mainIconSize];
            
            break;
            case buttonIconTypeOther:
            mainIcon = [FAKFontAwesome infoIconWithSize:mainIconSize];
            break;
        default:
            break;
    }
    
    UIImageView *plusImage = [[UIImageView alloc] initWithFrame:plusRect];
    UIImageView *mainImage = [[UIImageView alloc] initWithFrame:iconRect];
    
    [plusImage setImage:[plusIcon imageWithSize:CGSizeMake(plusIconSize, plusIconSize)]  ];
    [mainImage setImage:[mainIcon imageWithSize:CGSizeMake(mainIconSize, mainIconSize)]];
    
    [mainView addSubview:plusImage];
    [mainView addSubview:mainImage];
    
    UIGraphicsBeginImageContextWithOptions(mainView.bounds.size, NO, 0.0);
    [    mainView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


-(void)createSmallViewsWithImages:(NSArray*) images
{
    
    CGPoint centerOfView = self.view.center;
    
    for (imageObject* obj in images) {
        
        pictureFrame *frame = [pictureFrame createFrame];
        
        obj.delegate = self;
        
        CGPoint frameCenter = centerOfView;
        
        frameCenter.x       += [[obj centerXoffset] floatValue];
        frameCenter.y       =   mainScrollView.bounds.size.height + 100.0;
        
        frame.center        = frameCenter;
        
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handlePanFrom:)];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTapFrom:)];
        
        panRecognizer.delegate = self;
        tapRecognizer.delegate = self;
        
        [frame addGestureRecognizer:panRecognizer];
        [frame addGestureRecognizer:tapRecognizer];
        
        [frame bounceInFromPoint:mainScrollView.bounds.size.height
                         toPoint:mainScrollView.center.y];
        
        [mainScrollView addSubview:frame];
        
    }
    
}

-(void)createScrollView
{
    //  MIRAME: THIS FEELS A BIT HACKED TOGETHER AND SHOULD BE FIXED SOON
    
    float scrollViewHeight = (self.view.bounds.size.height);
    
    CGRect scrollViewFrame = CGRectMake(
                                        0.0                 , 0.0,
                                        MAINSCROLLVIEWSIZE  , scrollViewHeight
                                        );
    
    
    CGRect screenRect   = CGRectMake(
                                     0.0                          , 0.0,
                                     self.view.bounds.size.width  , scrollViewHeight
                                     );
    
    
    mainScrollView  = [[UIScrollView alloc] initWithFrame:screenRect];
    
    
    mainScrollView.contentSize      = scrollViewFrame.size;
    mainScrollView.contentSize      = CGSizeMake(mainScrollView.contentSize.width, mainScrollView.frame.size.height);
    mainScrollView.scrollEnabled    = YES;
    mainScrollView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    mainScrollView.showsHorizontalScrollIndicator  = NO;
    //mainScrollView.maximumZoomScale = 4.0;
    //mainScrollView.minimumZoomScale = 1.0;
    mainScrollView.delegate = self;
    mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    
    [self.view addSubview:mainScrollView];
    
    [self createTimelineWithValues];
    
}
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return TLManager.TLView;
//    
//}
//-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    
//}
-(void)createTimelineWithValues
{
    startDate   = timelineDateRange.startDate;
    endDate     = timelineDateRange.endDate;
    
    UIColor *TLbackground = [UIColor midnightBlueColor];
    
    CGRect scrollViewRect           = mainScrollView.frame;
    CGSize scrollViewContentSize    = mainScrollView.contentSize;
    
    
    CGRect timelineViewFrame    = CGRectMake(
                                             scrollViewRect.origin.x     ,  scrollViewRect.origin.y,
                                             scrollViewContentSize.width ,  scrollViewContentSize.height
                                             );
    UIView *timelineView = [[UIView alloc] initWithFrame:timelineViewFrame];
    
    
    timelineView.backgroundColor    = TLbackground;
    
    [mainScrollView addSubview:timelineView];
    
    TLManager = [timelineManager new];
    TLManager.delegate = self;
    
    [TLManager setStartDate:startDate
                 andEndDate:endDate
                    andView:timelineView
                andXOffsert:TLWALLSPACING ];
    
    
    [self addTimelineLineToView:timelineView];
    
    [self createYearPointsWithYearData:timelineDateRange
                        andContentSize:mainScrollView.contentSize
                                toView:timelineView];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}
-(void)addTimelineLineToView:(UIView*) TLVIEW
{
    
    float animationDuration     = 1.5;
    
    
    CGRect TLStartFrame = CGRectMake(
                                     TLWALLSPACING  , mainScrollView.center.y,
                                     1.0            , 2.0
                                     );
    
    CGRect TLFinalFrame = CGRectMake(
                                     TLWALLSPACING                                              , mainScrollView.center.y,
                                     mainScrollView.contentSize.width - (TLWALLSPACING * 2.0)   ,  2.0
                                     );
    
    UIColor *TLLineColor = [UIColor black25PercentColor];
    
    UIView *TLLine = [[UIView alloc] initWithFrame:TLStartFrame];
    
    TLLine.backgroundColor = TLLineColor;
    
    TLManager.lineCenter = [NSValue valueWithCGPoint:TLLine.center];
    
    [TLVIEW addSubview:TLLine];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [TLLine setFrame:TLFinalFrame];
        
    }];
    
    
    /*
    
    //  Add test views
    
    CGRect testViewFrame    =   CGRectMake(
                                               50.0 , 300,
                                               70.0 , 70.0
                                           );
    
    UIView *testView = [[UIView alloc] initWithFrame:testViewFrame];
    
    testView.backgroundColor    =   [UIColor yellowColor];
    
    [mainScrollView addSubview:testView];
    */
    
    
}
-(void)createYearPointsWithYearData:(DateRange*) yearData andContentSize:(CGSize) contentSize toView:(UIView*) timelineView
{
    NSMutableArray *savedPoints = [NSMutableArray new];
    NSMutableArray *savedYears = [NSMutableArray new];
    
    NSInteger startYear = [[yearData.startDate yearAsNumber] integerValue];
    NSInteger endYear   = [[yearData.endDate yearAsNumber] integerValue];
    
    float sizeOfTL = contentSize.width - (TLWALLSPACING * 2.0);
    
    NSInteger yearDiff = abs((int)startYear - (int)endYear);
    
    TLSpacing = sizeOfTL / (float)yearDiff;
    
    NSInteger frameDiff = (NSInteger)sizeOfTL / yearDiff;
    
    CGRect labelFrame = CGRectMake(
                                   0.0  , 0.0,
                                   50.0 , 30.0
                                   );
    
    CGPoint labelCenter = CGPointMake(TLWALLSPACING, timelineView.center.y);
    
    NSInteger yr = startYear;
    
    float labelYOffset      = 15.0;
    float animationDuration = 0.2;
    
    for (int i = 0; i <= yearDiff; i++) {
        
        NSDictionary *labelAttributes = [self getTextAttributesWithYear:yr withInfo:yearData];
        
        UILabel *yrLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        yrLabel.text            = labelAttributes[@"yearString"];
        yrLabel.textAlignment   = NSTextAlignmentCenter;
        yrLabel.font            = [UIFont fontWithName:labelAttributes[@"fontFamily"]
                                                  size:[labelAttributes[@"fontSize"] floatValue]];
        yrLabel.textColor       = labelAttributes[@"textColor"];
        
        [yrLabel sizeToFit];

        [timelineView addSubview:yrLabel];
        
        float heightMod = [labelAttributes[@"heightMod"] floatValue];
        
        if (labelYOffset < 0) {
            
            heightMod *= -1;
            
        }
        
        CGPoint yrLabelCenter;
        
        yrLabelCenter.x =   labelCenter.x + [labelAttributes[@"xOffset"] floatValue];
        yrLabelCenter.y =   labelCenter.y + labelYOffset + heightMod;
        
        [yrLabel setCenter:yrLabelCenter];
        
        [yrLabel setAlpha:0.0];
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [yrLabel setAlpha:[labelAttributes[@"finalAlpha"] floatValue]];
            
        }];
        
        animationDuration += 0.1;
    
        switch ([labelAttributes[@"rotation"] integerValue]) {
                
                
            case labelRotationTypeRight:
                
                yrLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
                break;
                
                
            case labelRotationTypeLeft:
                
                yrLabel.transform = CGAffineTransformMakeRotation((M_PI*3)/2);
                break;
                
                
            default:
                break;
        }
        
        //  Create line
        
        float lineHeight            = [labelAttributes[@"lineHeight"] floatValue];
        float startingLineHeight    = 1.0;
        
        if (labelYOffset < 0) {
            
            lineHeight          *= -1;
            startingLineHeight  *= -1;
            
        }
        
        CGRect lineFrame = CGRectMake(
                                          labelCenter.x , timelineView.center.y,
                                          1.0           , startingLineHeight
                                      );
        
        UIView *labelLine = [[UIView alloc] initWithFrame:lineFrame];
        
        labelLine.backgroundColor   = [UIColor black25PercentColor];
        lineFrame.size.height       = lineHeight;
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [labelLine setFrame:lineFrame];
            
        }];
    
        [timelineView addSubview:labelLine];
        
        
        yrLabel.backgroundColor     = labelAttributes[@"background"];
        
        if ([labelAttributes[@"shouldSaveCenter"] boolValue]) {
            
            
            
            [savedPoints addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:yrLabel.center], @"point",[labelAttributes objectForKey:@"yearString"], @"year", nil]];
            [savedYears addObject:yrLabel];
            
            
            
            
        }
        
        //  Update values
        
        labelCenter.x   += frameDiff;
        labelYOffset    *= -1;
        yr++;
        
    }
    
    TLManager.savedCenters = savedPoints;
    TLManager.savedYears = [NSArray arrayWithArray:savedYears];
    

}
/*
-(void)testMove
{
    NSLog(@"I fired!");
    
    pictureFrame *theFrame = [_photographs objectAtIndex:0];
    
    CGPoint oldCenter = [theFrame center];
    
    CGPoint trans = CGPointMake(50.0, 50.0);
    
    CGPoint newCenter = CGPointMake(oldCenter.x + trans.x, oldCenter.y + trans.y);
    
    [theFrame setCenter:newCenter];
}
*/
#pragma mark Gesture Recognizer Methods -
-(void)addGestureRecognizers
{
    
    for (pictureFrame* theFrame in photoList)
    {
        
//        UIPanGestureRecognizer *panRecog = [UIPanGestureRecognizer new];
//        
//        [panRecog addTarget:self
//                     action:@selector(handlePanFrom:)];
//        
//        [theFrame addGestureRecognizer:panRecog];
        
        [theFrame addPanGestureRecognizerWithObject:self];
        
        
        UITapGestureRecognizer *tapRecog = [UITapGestureRecognizer new];
        
        tapRecog.numberOfTapsRequired = 1;
        
        [tapRecog addTarget:self
                     action:@selector(handleTapFrom:)];
        
        
        
        UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer new];
        
        doubleTap.numberOfTapsRequired = 1;
        
        [doubleTap addTarget:self
                      action:@selector(handleDoubleTap:)];
        
        [tapRecog requireGestureRecognizerToFail:doubleTap];
        
        [theFrame addGestureRecognizer:doubleTap];
        [theFrame addGestureRecognizer:tapRecog];
        
        
    }
    
}
-(void)handleImageSectionFrom:(id) sender
{

    
    largeImageViewer *largeViewer = [largeImageViewer createLargeViewerWithFrame:self.view.frame];
    
    largeViewer.delegate = self;
    
    
    
    [self presentViewController:largeViewer animated:NO completion:^{
        [largeViewer setDisplayedImage:_displayImageInformation];
    }];
}
-(void)removeImageSelection:(id) sender
{
    UITapGestureRecognizer *rec = (UITapGestureRecognizer*)sender;
    
    [rec.view removeFromSuperview];
}
-(void)handlePanFrom:(id) sender
{
    if (isDateUpdateLockOn)
        return;
    
    
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        
        grabbedFrame = (pictureFrame*)[sender view];
        
        [self drawLineFromFrame:grabbedFrame];
        [self addDateUpdateLabelForFrame:grabbedFrame];
        [self addDateUpdateDayLabelForFrame:grabbedFrame];
    }
    
    //CGFloat transMod = 1.0;
    
    translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
    
   // NSLog(@"\n\nOld point:\t%@\n", NSStringFromCGPoint(translatedPoint));

    
    
    //NSLog(@"New point:\t%@\n", NSStringFromCGPoint(translatedPoint));
    
    
    if (!finishedMoving) {
        pictureFrame *newFrame = (pictureFrame*)[(UIPanGestureRecognizer*)sender view];
        
        [[sender view] setCenter:translatedPoint];
        [self updateDateLineWithFrame:newFrame];
        [self updateDateUpdaterLabelWithFrame:newFrame];
        [self updateDayLabelForFrame:newFrame];
        ;
    }
    
    [self findPointInView:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        
        CGFloat velocityX   = (([(UIPanGestureRecognizer*)sender velocityInView:self.view].x) / 1);
        
        CGFloat finalX      = translatedPoint.x;// + velocityX;
        CGFloat finalY      = translatedPoint.y;// + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            
            if (finalX < 0) {
                
                //finalX = 0;
                
            } else if (finalX > 768) {
                
                //finalX = 768;
            }
            
            if (finalY < 0) {
                
                finalY = 0;
                
            } else if (finalY > 1024) {
                
                finalY = 1024;
            }
            
        } else {
            
            if (finalX < 0) {
                
                //finalX = 0;
                
            } else if (finalX > 1024) {
                
                //finalX = 768;
            }
            
            if (finalY < 0) {
                
                finalY = 0;
                
            } else if (finalY > 768) {
                
                finalY = 1024;
            }
        }
        
        
        
        CGFloat animationDuration = (ABS(velocityX) * .0002) + .2;
        
        //NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
        
        pictureFrame *frame = (pictureFrame*)[sender view];
        
        [self updateDateForFrame:frame];
        [self updateDayLabelForFrame:frame];
        
        isDateUpdateLockOn = YES;
        grabbedFrame = nil;
    }
    
}

-(void)handleTapFrom:(UIGestureRecognizer*) recognizer
{
    
    pictureFrame *frame = (pictureFrame*)recognizer.view;

    [frame resize];
    
    
}
-(void)handleDoubleTap:(UITapGestureRecognizer*) recognizer
{
    
    pictureFrame *frame = (pictureFrame*)[recognizer view];
    
    [TLManager.TLView bringSubviewToFront:frame];
    
    
    imageObject *obj = frame.imageObject;
    
    NSURL *fullSizeURL = obj.photoURL;
    
    CGFloat displayedImageWidth = self.displayedImage.frame.size.width;
    CGFloat displayedImageHeight = self.displayedImage.frame.size.height;
    
    __weak typeof(self) weakSelf = self;
    
    [_displayedImage sd_setImageWithURL:fullSizeURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        float sizeDelta = 10.0;
        
        
        POPSpringAnimation *imageSizeChange = [POPSpringAnimation animation];
        
        imageSizeChange.property = [POPAnimatableProperty propertyWithName:kPOPViewSize];
        
        imageSizeChange.fromValue = [NSValue valueWithCGSize:CGSizeMake(displayedImageWidth - sizeDelta, displayedImageHeight - sizeDelta)];
        
        imageSizeChange.toValue = [NSValue valueWithCGSize:CGSizeMake(displayedImageWidth, displayedImageHeight)];
        
        [weakSelf pop_addAnimation:imageSizeChange forKey:@"imageResizeLarger"];
        
        POPSpringAnimation *alphaChange = [POPSpringAnimation animation];
        
        alphaChange.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        
        alphaChange.fromValue = @(0.0);
        alphaChange.toValue = @(1.0);
        
        [weakSelf pop_addAnimation:alphaChange forKey:@"alphaChange"];
    }];
    /*
    [_displayedImage setImageWithURL:fullSizeURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        float sizeDelta = 10.0;
        
        
        POPSpringAnimation *imageSizeChange = [POPSpringAnimation animation];
        
        imageSizeChange.property = [POPAnimatableProperty propertyWithName:kPOPViewSize];
        
        imageSizeChange.fromValue = [NSValue valueWithCGSize:CGSizeMake(displayedImageWidth - sizeDelta, displayedImageHeight - sizeDelta)];
        
        imageSizeChange.toValue = [NSValue valueWithCGSize:CGSizeMake(displayedImageWidth, displayedImageHeight)];
        
        [weakSelf pop_addAnimation:imageSizeChange forKey:@"imageResizeLarger"];
        
        POPSpringAnimation *alphaChange = [POPSpringAnimation animation];
        
        alphaChange.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        
        alphaChange.fromValue = @(0.0);
        alphaChange.toValue = @(1.0);
        
        [weakSelf pop_addAnimation:alphaChange forKey:@"alphaChange"];
        
        
        
        
        
    }];
     */
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    for (pictureFrame* frm in photoList) {
        
        if (frm != frame) {
            [frm stopAllTheGlowing];
        }
        else
        {
            [frm largeResize];
        }
    }
    
    //  This function sends the image to the chromecast
    
    if (self.deviceManager.isConnected) {
        [self sendImage:frame.imageObject];
    }
    
    if (![deviceType isEqualToString:@"iPhone"]) {
        [self displayInformationForImage:frame.imageObject];
    }
    
    [_infPager updateImageInformation:frame.imageObject];

    
}
-(void)displayInformationForImage:(imageObject*) obj
{
    
    NSString *displayString = [NSString stringWithFormat:@"%@", obj.imageInformation];
    
    _imageInfoDisplay.text = displayString;
    _displayImageInformation = obj;
    
    POPSpringAnimation *alphaChange = [POPSpringAnimation animation];
    
    alphaChange.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    
    alphaChange.fromValue = @(0.0);
    alphaChange.toValue = @(1.0);
    
    [_imageInfoDisplay pop_addAnimation:alphaChange
                                 forKey:@"alphaChangeToOne"];
    
    float    slideDelta      = 300.0,
            slideInTo       = slideDelta - (slideDelta / 2.0),
            slideInFrom     = slideDelta;

    
    POPSpringAnimation *verticalSlideIn = [POPSpringAnimation animation];
    
    verticalSlideIn.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    
    verticalSlideIn.fromValue = @(slideInFrom);
    verticalSlideIn.toValue = @(slideInTo);
    
    verticalSlideIn.springBounciness = 6.0;
    verticalSlideIn.springSpeed = 8.0;
    
    [_imageInfoDisplay.layer pop_addAnimation:verticalSlideIn forKey:@"slideInFromBottom"];
    
    POPSpringAnimation *buttonOneSlide = [POPSpringAnimation animation];
    
    //buttonOneSlide.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
//    
//    buttonOneSlide.fromValue = [NSValue valueWithCGPoint:CGPointMake(_addStoryButton.center.x, 500.0)];
//    buttonOneSlide.toValue = [NSValue valueWithCGPoint:_addStoryButton.center];
//
    buttonOneSlide.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    
    float buttonOneSlideToValue = _addStoryButton.frame.origin.y + (_addStoryButton.frame.size.height / 2);
    
    buttonOneSlide.fromValue = @(slideInFrom);
    buttonOneSlide.toValue = @(buttonOneSlideToValue);
    
    POPSpringAnimation *btn2Slide = [POPSpringAnimation animation];
    
    btn2Slide.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    
    buttonOneSlideToValue += 60.0;
    
    btn2Slide.fromValue = @(slideInFrom);
    btn2Slide.toValue = @(buttonOneSlideToValue);
    
    
    
    POPSpringAnimation *btn3Slide = [POPSpringAnimation animation];
    
    btn3Slide.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    
    btn3Slide.fromValue = @(slideInFrom);
    btn3Slide.toValue = @(slideInTo);

    [_addRecording.layer pop_addAnimation:btn2Slide forKey:@"buttonTwoSlideUp"];
    [_addRecording pop_addAnimation:alphaChange forKey:@"buttonTwoAlphaChange"];
    
    [_addStoryButton.layer pop_addAnimation:buttonOneSlide forKey:@"buttonOneSlideUp"];
    [_addStoryButton pop_addAnimation:alphaChange forKey:@"buttonOneAlphaChange"];
    
    [_addOtherInfo pop_addAnimation:alphaChange forKey:@"otherInfoButtonAlpha"];
    [_addOtherInfo pop_addAnimation:btn3Slide forKey:@"btn3slide"];
    
    
    
    [self performSegueWithIdentifier:segueDisplayLargeImage sender:obj];
    
}
#pragma mark - Delegate Methods

#pragma mark Timeline Manager

-(void)finishedUpdatedFrame:(pictureFrame *)frame withNewInformation:(NSDictionary *)info
{
    
    NSString *notificationString = [NSString stringWithFormat:@"The date for the frame has been updated to %@", [info[@"newDate"] displayDateOfType:sDateTypeMonthAndYear]];
    
    
    NSDictionary *options = @{
                              kCRToastTextKey                       : notificationString,
                              kCRToastTextAlignmentKey              : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey            : [UIColor charcoalColor],
                              kCRToastNotificationTypeKey           : @(CRToastTypeNavigationBar),
                              kCRToastFontKey                       : [UIFont fontWithName:@"DINAlternate-Bold" size:20.0],
                              kCRToastAnimationInTypeKey            : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey           : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey       : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey      : @(CRToastAnimationDirectionBottom),
                              kCRToastTimeIntervalKey               : @(2.0)
                              };
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
    
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updated!" message:notificationString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    //[alert show];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTempAlertWithTitle:@"Updated" andMessage:notificationString];
    });

}

#pragma mark Playing Audio

-(void)playAudioWithStory:(Story *)audioStory
{
    if(_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePaused) {
        
        [_mediaControlChannel play];
    }
    else {
        [self playAudioFromStory:audioStory];
    }

    
}

-(void)shouldStopAudio
{
    if(!self.deviceManager || !self.deviceManager.isConnected) {
        
        if (player) {
            if(player.isPlaying) {
                [player pause];
            }
        }
    }
    else {
        if (_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePlaying) {
            [_mediaControlChannel pause];
        }
    }
}

#pragma mark Keyboard
-(void)keyboardDidHide:(NSNotification*) notification
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)keyboardDidShow:(NSNotification*) notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect newViewRect = self.view.frame;
    
    newViewRect.origin.y -= keyboardRect.size.width;
    
    //NSLog(@"\nKeyboard Frame: %@\nNew View Frame: %@", NSStringFromCGRect(keyboardRect), NSStringFromCGRect(newViewRect));
    [self.view setFrame:newViewRect];
}

#pragma mark Large Image Viewer

-(void)shouldDismissImageViewer:(id)imageViewer
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utility Methods

-(NSTimeInterval)getTimeIntervalWithDate:(NSDate*) date
{
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate referenceDate]];
    
    //NSLog(@"\nThe time interval is: %f\n", interval);
    
    return interval;
    
}

-(NSDictionary*)getTextAttributesWithYear:(NSInteger) year withInfo:(DateRange*) info
{
    UIColor     *textColor,
                *backgroundColor;
    
    NSNumber    *fontSize,
                *heightMod,
                *finalAlpha,
                *xOffSet,
                *rotation,
                *lineHeight,
                *shouldSaveCenter;
    
    NSString    *yearString;

    NSInteger startYear = [[info.startDate yearAsNumber] integerValue];
    NSInteger endYear   = [[info.endDate yearAsNumber] integerValue];
    
    float lineHeightPrim = 0.0;
    
    if (year == startYear || year == endYear) {
        
        lineHeightPrim  = 0.0;

        textColor       = [UIColor warmGrayColor];
        fontSize        = [NSNumber numberWithFloat:75.0];
        heightMod       = [NSNumber numberWithFloat:0.0];
        yearString      = [NSString stringWithFormat:@"%li", (long)year];
        finalAlpha      = [NSNumber numberWithFloat:0.3];
        backgroundColor = [UIColor clearColor];
        lineHeight      = [NSNumber numberWithFloat:lineHeightPrim];
        
        if (year ==  startYear) {
            
            xOffSet  = [NSNumber numberWithFloat:-60.0];
            rotation = [NSNumber numberWithInteger:labelRotationTypeLeft];
            
        }
        else {
            
            xOffSet   = [NSNumber numberWithFloat:80.0];
            rotation  = [NSNumber numberWithInteger:labelRotationTypeRight];
            heightMod = [NSNumber numberWithFloat:-10.0];
            
        }
        
    }
    else {
        if (year % 5 == 0) {
            
            if (year % 10 == 0) {
                
                lineHeightPrim = 70.0;

                textColor      = [UIColor warmGrayColor];
                fontSize       = [NSNumber numberWithFloat:30.0];
                heightMod      = [NSNumber numberWithFloat:lineHeightPrim];
                lineHeight     = [NSNumber numberWithFloat:lineHeightPrim - 10.0];
                yearString     = [NSString stringWithFormat:@"%li", (long)year];
                
            }
            else {
                
                lineHeightPrim = 30.0;

                textColor      = [UIColor warmGrayColor];
                fontSize       = [NSNumber numberWithFloat:lineHeightPrim - 5.0];
                heightMod      = [NSNumber numberWithFloat:lineHeightPrim];
                yearString     = [NSString stringWithFormat:@"%li", (long)year];
                lineHeight     = [NSNumber numberWithFloat:lineHeightPrim - 7.5];
                
            }
            
            finalAlpha = [NSNumber numberWithFloat:1.0];
            shouldSaveCenter = [NSNumber numberWithBool:YES];
            
        }
        else {
            
            textColor = [UIColor warmGrayColor];
            fontSize  = [NSNumber numberWithFloat:15.0];
            heightMod = [NSNumber numberWithFloat:0];
           
            
            NSInteger yearCopy = year;
            
            while (yearCopy >= 100) {
                
                yearCopy -= 100;
                
            }
            
            
            
            if (yearCopy >= 10) {
                
                yearString = [NSString stringWithFormat:@"'%li", (long)yearCopy];
            }
            else {
                
                yearString = [NSString stringWithFormat:@"'0%li", (long)yearCopy];
            }
            
            finalAlpha = [NSNumber numberWithFloat:0.6];
            lineHeight = [NSNumber numberWithFloat:0.0];
            
        }
        
        xOffSet         = [NSNumber numberWithFloat:0.0];
        rotation        = [NSNumber numberWithInteger:labelRotationTypeNone];
        backgroundColor = [UIColor clearColor];
        
        
        
    }
    
    if (shouldSaveCenter == nil) {
        shouldSaveCenter = [NSNumber numberWithBool:NO];
    }
    
    return @{@"textColor"   : textColor,
             @"fontSize"    : fontSize,
             @"heightMod"   : heightMod,
             @"fontFamily"  : @"DINAlternate-Bold",
             @"yearString"  : yearString,
             @"finalAlpha"  : finalAlpha,
             @"xOffset"     : xOffSet,
             @"rotation"    : rotation,
             @"background"  : backgroundColor,
             @"lineHeight"  : lineHeight,
             @"shouldSaveCenter" : shouldSaveCenter};
}
-(NSArray*)createYearsArrayWithStart:(NSNumber*) start andEnd:(NSNumber*) end
{
    int startInt          = [start intValue];
    int endInt            = [end intValue];

    NSMutableArray *years = [NSMutableArray array];
    
    for (int i = startInt; i <= endInt; i++) {
        
        if (i % 5 == 0) {
            
            [years addObject:[NSNumber numberWithInt:i]];
            
        }
    }
    
    return [NSArray arrayWithArray:years];
}
-(UILabel*)labelCopy:(UILabel*) orgLabel
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:orgLabel.frame];
    
    newLabel.font = orgLabel.font;
    newLabel.textColor = orgLabel.textColor;
    newLabel.backgroundColor = orgLabel.backgroundColor;
    
    
    return newLabel;
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [imageInformationVClist indexOfObject:viewController];
    
    if (index >= [imageInformationVClist count] - 1) {
        return nil;
    }
    else
    {
        
        return [imageInformationVClist objectAtIndex:index + 1];
        
    }
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [imageInformationVClist indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    }
    else{
        return [imageInformationVClist objectAtIndex:index - 1];
    }
}
-(void)findPointInView:(CGPoint) point
{
//    if(!triggerLocked)
//    {
        CGPoint newPoint = [self.view convertPoint:point fromView:mainScrollView];
        
        //NSLog(@"The Point: %@", NSStringFromCGPoint(newPoint));
        
        if (CGRectContainsPoint(scrollTrigger.leftTrigger, newPoint)) {
            
           // NSLog(@"%@", @"LEFT TRIGGER");
            
            
        }
        else if (CGRectContainsPoint(scrollTrigger.rightTrigger, newPoint))
        {
            //NSLog(@"%@", @"RIGHT TRIGGER");
            
            
            
            [rightTrigFrame start];
            
            /*
            if (scrollTrigger.isRightTriggered == NO) {
                
                scrollTrigger.isRightTriggered = YES;
                
                
                triggerTime = 0;
                
                [moveScreenTimer invalidate];
                moveScreenTimer = nil;
                [self resetTriggerViews];
                
                moveScreenTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTriggerTimer:) userInfo:nil repeats:YES];
                
            }
         */
        }
        else
        {
            //NSLog(@"NO TRIGGER");
            [rightTrigFrame stop];
            scrollTrigger.isLeftTriggered = NO;
            scrollTrigger.isRightTriggered = NO;
        }
//    }
}
-(void)goRight:(id)sender
{
    
            CGRect scrollToFrame;
            
            
            
            CGPoint frameCenter = [grabbedFrame center];
            
            
            CGFloat nudgeDist = 200.0;
            CGFloat newXOrigin = mainScrollView.frame.origin.x + nudgeDist + mainScrollView.contentOffset.x;
            
            scrollToFrame.origin.x = newXOrigin;
            scrollToFrame.origin.y = 0.0;
            
            scrollToFrame.size = mainScrollView.frame.size;
            
            CGPoint newCenter = CGPointMake(frameCenter.x + nudgeDist, frameCenter.y);
            
            newGrabbedCenter = newCenter;
            
            [mainScrollView scrollRectToVisible:scrollToFrame animated:YES];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [grabbedFrame setCenter:newGrabbedCenter];
            }];
            
           // NSLog(@"\n\n\n\nMOVED THINGS\n\n\n\n\n");
            
            
            firstX += nudgeDist;
            


            
            scrollTrigger.isRightTriggered = NO;
       
}
-(void)updateTriggerTimer:(id) sender
{
    triggerTime++;
    
    NSUInteger stopPoint = 600;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateRightAlphaWithMilliseconds:triggerTime andMax:stopPoint];
        
    });
    
    
    if (triggerTime == stopPoint) {
        
        [self goRight:nil];
        
        [moveScreenTimer invalidate];
        moveScreenTimer = nil;
        
        [self dimTriggers];
        [self resetTriggerViews];
        [self lockTrigger];
    }
}
-(void)updateRightAlphaWithMilliseconds:(NSUInteger) milli andMax:(NSUInteger) max
{
    CGFloat topAlpha = 0.7;
    
    CGFloat scalingFactor = topAlpha / (CGFloat)max;
    
    CGFloat newAlpha = scalingFactor * (CGFloat)milli;
    
    //NSLog(@"\n\nNew Alpha: %f", newAlpha);
    
    rightTriggerView.alpha = newAlpha;
    
    
}
-(void)lockTrigger
{
    NSTimeInterval triggerLockTime = 2.0;
    
    triggerLockTimer = [NSTimer scheduledTimerWithTimeInterval:triggerLockTime target:self selector:@selector(unlockTrigger:) userInfo:nil repeats:NO];
    
    triggerLocked = YES;
    
}
-(void)unlockTrigger:(id) sender
{
    [triggerLockTimer invalidate];
    triggerLockTimer = nil;
    
    triggerLocked = NO;
}
-(void)resetTriggerViews
{
    [self dimTriggers];
    [leftTriggerView removeFromSuperview];
    [rightTriggerView removeFromSuperview];
    
    leftTriggerView = nil;
    rightTriggerView = nil;
    
    [self setupTriggerViews];
}
-(void)dimTriggers
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self dimView:leftTriggerView];
        [self dimView:rightTriggerView];

    });
    
}
-(void)dimView:(UIView*) viewToDim
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [viewToDim setAlpha:0.0];
    }];
}
-(void)blurEdgeOfView:(UIView*) theView
{
    /*
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    maskLayer.colors = [NSArray arrayWithObjects: (__bridge id)(outerColor), (__bridge id)(innerColor), (__bridge id)(innerColor), outerColor, nil];
    
    maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.2],
                           [NSNumber numberWithFloat:0.8],
                           [NSNumber numberWithFloat:1.0], nil];
    
    maskLayer.bounds = CGRectMake(0, 0,
                                  theView.frame.size.width,
                                  theView.frame.size.height);
    
    maskLayer.anchorPoint = CGPointZero;
    
    [theView.layer addSublayer:maskLayer];
     */
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = theView.bounds;
    
    l.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor, nil];

    
    l.startPoint = CGPointMake(0.9f , 1.0f);
    l.endPoint = CGPointMake(1.0f, 1.0f);
    
    [theView.layer insertSublayer:l above:theView.layer];
    
}
-(void)testLayer
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    [layer setBounds:self.view.bounds];
    [layer setPosition:self.view.center];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[[UIColor redColor] CGColor]];
    [layer setLineWidth:3.0];
    [layer setLineJoin:kCALineJoinRound];
    [layer setLineDashPattern:@[@(10) , @(5)]];
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 100, 100);
    CGPathAddLineToPoint(path, NULL, 300, 300);
    
    [layer setPath:path];
    CGPathRelease(path);
    
    
    [self.view.layer addSublayer:layer];
    
}
-(void)testProgressView
{
    customProgressView = [[TAProgressView alloc] init];
    
    customProgressView.delegate = self;
    
    [self.view addSubview:customProgressView];
    [customProgressView setBackgroundColor:[UIColor clearColor]];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.3] afterDelay:0.0];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.75] afterDelay:2.0];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:1.0] afterDelay:4.0];
}
-(void)setProgress:(NSNumber*)value
{
    [customProgressView performSelectorOnMainThread:@selector(setProgress:) withObject:value waitUntilDone:NO];
}
-(void)shouldDismiss
{
    
//    NSLog(@"Current media status...%@", _mediaControlChannel.mediaStatus)
    [self dismissViewControllerAnimated:YES completion:^{
        [_mediaControlChannel stop];
        //[_deviceManager removeChannel:_mediaControlChannel];
    }];
}

#pragma mark - Chromecast Things

#pragma mark Setup
-(void)chromecastThings
{
    //You can add your own app id here that you get by registering with the Google Cast SDK Developer Console https://cast.google.com/publish
    kReceiverAppID= @"94B7DFA1";
    
    //Create chromecast button
    _btnImage = [UIImage imageNamed:@"icon-cast-identified.png"];
    _btnImageSelected = [UIImage imageNamed:@"icon-cast-connected.png"];
    
    _chromecastButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_chromecastButton addTarget:self
                          action:@selector(chooseDevice:)
                forControlEvents:UIControlEventTouchDown];
    _chromecastButton.frame = CGRectMake(0, 0, _btnImage.size.width, _btnImage.size.height);
    [_chromecastButton setImage:nil forState:UIControlStateNormal];
    _chromecastButton.hidden = YES;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:_chromecastButton];
    
    //Initialize device scanner
    self.deviceScanner = [[GCKDeviceScanner alloc] init];
    
    [self.deviceScanner addListener:self];
    [self.deviceScanner startScan];
}

#pragma mark Updating Things
- (void)updateStatsFromDevice {
    
    if (self.mediaControlChannel && self.isConnected) {
        _mediaInformation = self.mediaControlChannel.mediaStatus.mediaInformation;
    }
}
- (void)updateButtonStates {
    if (self.deviceScanner.devices.count == 0) {
        //Hide the cast button
        _chromecastButton.hidden = YES;
    } else {
        //Show cast button
        [_chromecastButton setImage:_btnImage forState:UIControlStateNormal];
        _chromecastButton.hidden = NO;
        
        if (self.deviceManager && self.deviceManager.isConnected) {
            //Show cast button in enabled state
            [_chromecastButton setTintColor:[UIColor fadedBlueColor]];
        } else {
            //Show cast button in disabled state
            [_chromecastButton setTintColor:[UIColor grayColor]];
            
        }
    }
    
}

#pragma mark Device Connection

- (void)chooseDevice:(id)sender {
    //Choose device
    if (self.selectedDevice == nil) {
        //Choose device
        UIActionSheet *sheet =
        [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Connect to Device", nil)
                                    delegate:self
                           cancelButtonTitle:nil
                      destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        for (GCKDevice *device in self.deviceScanner.devices) {
            [sheet addButtonWithTitle:device.friendlyName];
        }
        
        [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        sheet.cancelButtonIndex = sheet.numberOfButtons;
        
        //show device selection
        [sheet showInView:_chromecastButton];
    } else {
        // Gather stats from device.
        [self updateStatsFromDevice];
        
        NSString *friendlyName = [NSString stringWithFormat:NSLocalizedString(@"Casting to %@", nil),
                                  self.selectedDevice.friendlyName];
        
        NSString *mediaTitle = [self.mediaInformation.metadata stringForKey:kGCKMetadataKeyTitle];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        sheet.title = friendlyName;
        sheet.delegate = self;
        if (mediaTitle != nil) {
            [sheet addButtonWithTitle:mediaTitle];
        }
        
        //Offer disconnect option
        [sheet addButtonWithTitle:@"Disconnect"];
        [sheet addButtonWithTitle:@"Cancel"];
        sheet.destructiveButtonIndex = (mediaTitle != nil ? 1 : 0);
        sheet.cancelButtonIndex = (mediaTitle != nil ? 2 : 1);
        
        [sheet showInView:_chromecastButton];
    }
}



- (BOOL)isConnected {
    return self.deviceManager.isConnected;
}

- (void)connectToDevice {
    
    
    if (self.selectedDevice == nil)
        return;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.deviceManager =
    [[GCKDeviceManager alloc] initWithDevice:self.selectedDevice
                           clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    self.deviceManager.delegate = self;
    [self.deviceManager connect];
    
    
}

- (void)deviceDisconnected {
    self.mediaControlChannel = nil;
    self.deviceManager = nil;
    self.selectedDevice = nil;
}

#pragma mark Media Sending

-(void)sendImage:(imageObject*) image
{
    
    NSString *urlString = [[image photoURL] absoluteString];
    
    if (!self.deviceManager || !self.deviceManager.isConnected) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not Connected", nil)
                                   message:NSLocalizedString(@"Please connect to Cast device", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
    
    [metadata setString:([image title] ? [image title] : @"untitled") forKey:kGCKMetadataKeyTitle];
    
    
    GCKMediaInformation *mediaInformation =
    [[GCKMediaInformation alloc] initWithContentID:
     urlString
                                        streamType:GCKMediaStreamTypeUnknown
                                       contentType:@"image/jpg"
                                          metadata:metadata
                                    streamDuration:0
                                        customData:nil];
    
    
    
    [_mediaControlChannel loadMedia:mediaInformation autoplay:TRUE playPosition:0];

    imageSent = YES;
    prevImage = image;

    
}
-(void)playAudioFromStory:(Story*) audioStory
{
    
    
    
    //Show alert if not connected
    if (!self.deviceManager || !self.deviceManager.isConnected) {
        /*
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not Connected", nil)
                                   message:NSLocalizedString(@"Please connect to Cast device", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
                         otherButtonTitles:nil];
        [alert show];
        return;
         */
        NSData *_objectData = [NSData dataWithContentsOfURL:audioStory.audioRecording.s3URL];
        
        NSError *error;
        
        
        player = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
        player.delegate = self;
        
        
        player.numberOfLoops = 0.0;
        player.volume = 1.0;
        [player prepareToPlay];
        [player play];
        
    

        
    }
    else {
        
    NSLog(@"\nCast audio stream");
    GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
    
    [metadata setString:( audioStory.title ? audioStory.title : @"Untitled") forKey:kGCKMetadataKeyTitle];
    
    [metadata setString:( audioStory.storyDate ? [audioStory.storyDate displayDateOfType:sDateTypPretty] : @"")
                 forKey:kGCKMetadataKeySubtitle];
    
    CGSize displayImageSize;
    
    NSURL *imageURL;
    
    if (_displayImageInformation.thumbnailImage) {
        
//        displayImageSize = _displayImageInformation.thumbnailImage.size;
        displayImageSize = CGSizeMake(700.0, 700.0);
        imageURL = _displayImageInformation.thumbNailURL;
        
    } else
    {
        displayImageSize = _displayImageInformation.largeImage.size;
        imageURL = _displayImageInformation.photoURL;
    }
        imageURL = _displayImageInformation.photoURL;
        displayImageSize = _displayImageInformation.largeImage.size;
        
    [metadata addImage:[[GCKImage alloc]
                        initWithURL:imageURL
                        width:displayImageSize.width
                        height:displayImageSize.height
                        ]];
    
    NSString *urlString;
    
    if (audioStory.audioRecording.s3URL.absoluteString != nil) {
        urlString = audioStory.audioRecording.s3URL.absoluteString;
    }
    else if(audioStory.recordingS3Url.absoluteString != nil)
    {
        urlString = audioStory.recordingS3Url.absoluteString;
    }
    else
    {
        return;
    }
    
    
    GCKMediaInformation *mediaInformation =
    [[GCKMediaInformation alloc] initWithContentID:urlString
                                        streamType:GCKMediaStreamTypeUnknown
                                       contentType:@"audio/mp4"
                                          metadata:metadata
                                    streamDuration:0
                                        customData:nil];
    
    [_mediaControlChannel loadMedia:mediaInformation autoplay:TRUE playPosition:0];
        
        currentAudioSession = [[AVAudioSession alloc] init];
        NSError* error;
        
        [currentAudioSession setActive:YES error:&error];
        [currentAudioSession addObserver:self forKeyPath:@"outputVolume" options:0 context:nil];
        
        if (error) {
            NSLog(@"There was an error settup up the chromecast audio session:\n%@", error);
        }
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"outputVolume"]) {
        
        if (currentAudioSession) {
            float newVolume = [currentAudioSession outputVolume];

            if (newVolume <= 1.0 && newVolume >= 0) {
                NSLog(@"I'm setting the stream volume to %lf", newVolume);
                [_mediaControlChannel setStreamVolume:newVolume];
            }
            else
            {
                NSLog(@"The stream volume was weird: %lf", newVolume);
            }
            
        }
    }
}
-(void)updatePlayerVolumeTo:(float)newVolume
{
    BOOL connectedToChromecast = !(!self.deviceManager || !self.deviceManager.isConnected);
    
    if (connectedToChromecast) {
        
        [_mediaControlChannel setStreamVolume:newVolume];
    }
    else
    {
        player.volume = newVolume;
    }
}
#pragma mark GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
    NSLog(@"device found!! %@", device.friendlyName);
    [self updateButtonStates];
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
    [self updateButtonStates];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (self.selectedDevice == nil) {
        if (buttonIndex < self.deviceScanner.devices.count) {
            self.selectedDevice = self.deviceScanner.devices[buttonIndex];
            NSLog(@"Selecting device:%@", self.selectedDevice.friendlyName);
            [self connectToDevice];
        }
    } else {
        
        if (buttonIndex == 1) {  //Disconnect button
            
            //  Somehow the disconnect is breaking everything
            
            NSLog(@"Disconnecting device:%@", self.selectedDevice.friendlyName);
            // New way of doing things: We're not going to stop the applicaton. We're just going
            // to leave it.
            [self.deviceManager leaveApplication];
            // If you want to force application to stop, uncomment below
            //[self.deviceManager stopApplicationWithSessionID:self.applicationMetadata.sessionID];
            [self.deviceManager disconnect];
            
            [self deviceDisconnected];
            [self updateButtonStates];
            
        } else if (buttonIndex == 0) {
            // Join the existing session.
            
        }
    }
}

#pragma mark GCKDeviceManagerDelegate

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    NSLog(@"connected!!");
    
    [self updateButtonStates];
    [self.deviceManager launchApplication:kReceiverAppID];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApplication {
    
    NSLog(@"application has launched");
    self.mediaControlChannel = [[GCKMediaControlChannel alloc] init];
    self.mediaControlChannel.delegate = self;
    [self.deviceManager addChannel:self.mediaControlChannel];
    [self.mediaControlChannel requestStatus];
    
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectWithError:(GCKError *)error {
    
    [self showError:error];
    
    [self deviceDisconnected];
    [self updateButtonStates];
    
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(GCKError *)error {
    NSLog(@"Received notification that device disconnected");
    
    if (error != nil) {
        [self showError:error];
    }
    
    [self deviceDisconnected];
    [self updateButtonStates];
    
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    
    self.applicationMetadata = applicationMetadata;
}

-(void)mediaControlChannelDidUpdateStatus:(GCKMediaControlChannel *)mediaControlChannel {

    if( mediaControlChannel.mediaStatus.idleReason == GCKMediaPlayerIdleReasonFinished) {
        
        if (imageSent) {
            if (prevImage) {
                
                NSLog(@"Sending the image");
                
                if (sentNum == 0) {
                    sentNum += 1;
                    [self sendImage:prevImage];
                }
                else {
                    sentNum = 0;
                }
                
               
            }
        }
        
    }
     
}
#pragma mark - Misc.

-(void)sendTheImage {
    [self sendImage:prevImage];
}
- (void)showError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:NSLocalizedString(error.description, nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Date Updater Methods

#pragma mark Setup Methods
-(void)addDateUpdateLabelForFrame:(pictureFrame*) Pframe
{
   
    DateLineLayoutVals newVals = [self getNewLabelCenterForFrame:Pframe];
    NSString *labelString = [self getUpdatedDateLabelTextForFrame:Pframe];
    
    if (!dateUpdaterLabel) {
        [dateUpdaterLabel removeFromSuperview];
        dateUpdaterLabel = nil;
    }
    
    NSString *fontFamily = @"DINAlternate-Bold";
    CGFloat fontSize = 15.1;
    
    UIFont *labelFont = [UIFont fontWithName:fontFamily size:fontSize];
    UIColor *fontcolor = [UIColor whiteColor];
    
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 100.0)];
    
    [newLabel setFont:labelFont];
    [newLabel setTextColor:fontcolor];
    [newLabel setTextAlignment:NSTextAlignmentCenter];
    
    [newLabel setText:labelString];
    
    [newLabel sizeToFit];
    
    [newLabel setCenter:newVals.center];
    
    if (newVals.shouldShow) {
        newLabel.alpha = 1.0;
    }
    else{
        newLabel.alpha = 0.0;
    }
    
    if (dateUpdaterLine) {
        [mainScrollView insertSubview:newLabel aboveSubview:dateUpdaterLine];
    }
    else
    {
        [mainScrollView addSubview:newLabel];
    }
    
    dateUpdaterLabel = newLabel;
    
    
}

-(void)addDateUpdateDayLabelForFrame:(pictureFrame*) Pframe
{
    
    if(dateUpdaterDayLabel)
    {
        [dateUpdaterDayLabel removeFromSuperview];
        dateUpdaterDayLabel = nil;
    }
    
    NSString *fontFamily = @"DINAlternate-Bold";
    CGFloat fontSize = 125.0;
    
    UIFont *labelFont = [UIFont fontWithName:fontFamily size:fontSize];
    UIColor *fontColor = [UIColor whiteColor];
    
    CGFloat labelWidth, labelHeight;
    
    CGFloat timelineCenter = mainScrollView.center.y;
    
    labelHeight = timelineCenter * 0.75;
    
    labelWidth = labelHeight * 1.2;
    
    CGRect dayLabelFrame = CGRectMake(0.0, 0.0, labelWidth, labelHeight);
    
    dateUpdaterDayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
    
    CGFloat dayLabelFrameCenter = timelineCenter / 2.0;
    
    
    
    dateUpdaterDayLabel.font = labelFont;
    dateUpdaterDayLabel.textColor = fontColor;
    dateUpdaterDayLabel.numberOfLines = 1.0;
    dateUpdaterDayLabel.minimumScaleFactor = 8.0 / dateUpdaterDayLabel.font.pointSize;
    dateUpdaterDayLabel.adjustsFontSizeToFitWidth = YES;
    dateUpdaterDayLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *newDayString = [self getUpdatedDayLabelTextForFrame:Pframe];
    CGFloat newDayAlpha = [self getAlphaValueForFrame:Pframe];
    
    dateUpdaterDayLabel.text = newDayString;
    dateUpdaterDayLabel.alpha = newDayAlpha;
    
    [self.view addSubview:dateUpdaterDayLabel];
    
    dateUpdaterDayLabel.center = CGPointMake(self.view.center.x, dayLabelFrameCenter);
    
}
#pragma mark Update Methods
-(void)updateDateUpdaterLabelWithFrame:(pictureFrame*) Pframe
{
    DateLineLayoutVals newVals = [self getNewLabelCenterForFrame:Pframe];
    NSString *newTime = [self getUpdatedDateLabelTextForFrame:Pframe];
    
    
    if (dateUpdaterLabel) {
        
        [dateUpdaterLabel setText:newTime];
        [dateUpdaterLabel sizeToFit];
        [dateUpdaterLabel setCenter:newVals.center];
        
        if (newVals.shouldShow) {
            dateUpdaterLabel.alpha = 1.0;
        }
        else
        {
            dateUpdaterLabel.alpha = 0.0;
        }
    }
}
-(void)tearDownDateUpdaterLabel
{
    if (dateUpdaterLabel) {
        
        POPSpringAnimation *tearDown = [POPSpringAnimation animation];
        
        tearDown.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        
        tearDown.toValue = @(0.0);
        tearDown.springBounciness = 14.0;
        tearDown.springSpeed = 14.0;
        
        
        [tearDown setCompletionBlock:^(POPAnimation *hi, BOOL basdf) {
            [dateUpdaterLabel removeFromSuperview];
            dateUpdaterLabel = nil;
        }];
        
        [dateUpdaterLabel pop_addAnimation:tearDown forKey:@"labelTear"];
        
    }
}
-(NSString*)getUpdatedDateLabelTextForFrame:(pictureFrame*) Pframe
{
    NSString *newDateString = @"";
    NSDate *newDate;
    CGPoint newPoint = CGPointMake(0.0, 0.0);
    
    if (Pframe) {
        newPoint = Pframe.center;
    }
    
    if (TLManager) {
        newDate = [TLManager createDateObjectFromPoint:newPoint];
        
        newDateString = [newDate displayDateOfType:sDateTypeMonthAndYear];
    }
    
    
    return newDateString;
}

-(NSString*)getUpdatedDayLabelTextForFrame:(pictureFrame*) Pframe
{
    NSString *newDayString = @"";
    NSDate *newDate;
    
    CGPoint newPoint = CGPointMake(0.0, 0.0);
    
    if (Pframe) {
        newPoint = Pframe.center;
    }
    
    if (TLManager) {
        newDate = [TLManager createDateObjectFromPoint:newPoint];
        
        newDayString = [newDate dayFromDateWithType:sDayTypeSuffix];
    }
    //NSLog(@"\nNew Day String:\t%@\n", newDayString);
    return newDayString;
}
-(CGFloat)getAlphaValueForFrame:(pictureFrame*) Pframe
{
    CGFloat scrollViewCenterY, newAlpha, frameCenterY;
    
    frameCenterY = Pframe.center.y;
    scrollViewCenterY = mainScrollView.center.y;
    
    
    CGFloat dist = fabsf(scrollViewCenterY - frameCenterY);
    
    newAlpha = 1 - ((dist / scrollViewCenterY) * 1) ;
    
    //NSLog(@"\nScrollview center:\t%f\nframeCenterY:\t%f\ndist:\t%f\nnewAlpha:\t%f\n", scrollViewCenterY, frameCenterY, dist, newAlpha);
    
    return newAlpha;
    
}
-(void)updateDayLabelForFrame:(pictureFrame*) Pframe
{
    CGFloat newAlpha = [self getAlphaValueForFrame:Pframe];
    NSString *newText = [self getUpdatedDayLabelTextForFrame:Pframe];
    

    
    [mainScrollView bringSubviewToFront:dateUpdaterDayLabel];
    dateUpdaterDayLabel.alpha = newAlpha;
    dateUpdaterDayLabel.text = newText;
}
-(void)tearDownDayLabel
{
    if (dateUpdaterDayLabel) {
        
        POPSpringAnimation *tearDown = [POPSpringAnimation animation];
        
        tearDown.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleY];
        
        tearDown.toValue = @(0.01);
        tearDown.velocity = @(20.0);
        tearDown.springBounciness = 2.0;
        
        [tearDown setCompletionBlock:^(POPAnimation *adf, BOOL asdf) {
            [dateUpdaterDayLabel removeFromSuperview];
            dateUpdaterDayLabel = nil;
        }];
        
        [dateUpdaterDayLabel pop_addAnimation:tearDown forKey:@"tearDownDayLabel"];

    }
}
-(DateLineLayoutVals)getNewLabelCenterForFrame:(pictureFrame*) Pframe
{
    CGFloat timelineCenterY = mainScrollView.center.y;
    CGFloat frameCenterY = Pframe.center.y;
    CGFloat frameCenterX = Pframe.center.x;
    
    
    CGFloat offsetValue = 15.0;
    
    CGFloat centerYDiff = frameCenterY - timelineCenterY;
    
    BOOL shouldShowTime = YES;
    
    CGFloat labelShowRange = 20.0;
    
    if (centerYDiff < labelShowRange) {
        
    }
    else if( centerYDiff > (0.0 - labelShowRange))
    {
        offsetValue = (0 - offsetValue);
    }
    else{
        offsetValue = 0.0;
        shouldShowTime = NO;
    }
    
    CGFloat newYCenter = timelineCenterY + offsetValue;
    
    DateLineLayoutVals newVals;
    
    newVals.center = CGPointMake(frameCenterX, newYCenter);
    newVals.shouldShow = shouldShowTime;
    
    return newVals;
    
}
-(void)drawLineFromFrame:(pictureFrame*) Pframe
{
    CGPoint initialPoint, finalPoint;
    
    initialPoint = [Pframe center];
    
    finalPoint = CGPointMake([Pframe center].x, [mainScrollView center].y);
    
    UIView *line = [self createLineFromStartPoint:initialPoint toEndPoint:finalPoint];
    
    [mainScrollView insertSubview:line belowSubview:Pframe.theImage];
    
    dateUpdaterLine = line;
}
-(UIView*)createLineFromStartPoint:(CGPoint) startPoint toEndPoint:(CGPoint) endPoint
{
    CGFloat yDistance = (CGFloat)fabsf(startPoint.y - endPoint.x);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, yDistance)];
    
    [line setBackgroundColor:[UIColor whiteColor]];
    
    [line setCenter:CGPointMake(startPoint.x, ((startPoint.y + endPoint.y) / 2.0))];
    
    return line;
}
-(void)tearDownDateLine
{
    if (dateUpdaterLine) {
        
        
        POPSpringAnimation *tearDown = [POPSpringAnimation animation];
        
        tearDown.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleY];
        
        tearDown.toValue = @(0.01);
        tearDown.velocity = @(14.0);
        tearDown.springBounciness = 2.0;
        
        [tearDown setCompletionBlock:^(POPAnimation *adf, BOOL asdf) {
            [dateUpdaterLine removeFromSuperview];
            dateUpdaterLine = nil;
        }];
        
        [dateUpdaterLine pop_addAnimation:tearDown forKey:@"tearDownLine"];
        
        
    }
}
-(void)updateDateLineWithFrame:(pictureFrame*) Pframe
{
    DateLineLayoutVals newLayout = [self getNewCenterForDateUpdateLineWithFrame:Pframe];
    if (dateUpdaterLine) {
        
        [dateUpdaterLine setFrame:CGRectMake(0.0, 0.0, 1.0, newLayout.height)];
        [dateUpdaterLine setCenter:newLayout.center];
        [mainScrollView insertSubview:Pframe belowSubview:Pframe.theImage];
        
    }
    else{
        
        [self drawLineFromFrame:Pframe];
    }
}
-(DateLineLayoutVals)getNewCenterForDateUpdateLineWithFrame:(pictureFrame*) Pframe
{
    
    CGFloat scrollviewCenterY = mainScrollView.center.y;
    CGFloat pFrameCenterY = Pframe.center.y;
    CGFloat centerX = Pframe.center.x;
    
    DateLineLayoutVals newVals;
    
    newVals.center = CGPointMake(centerX, ((scrollviewCenterY + pFrameCenterY) / 2.0));
    newVals.height = fabsf(scrollviewCenterY - pFrameCenterY);
    
    return newVals;
}
-(void)showTempAlertWithTitle:(NSString*) title andMessage:(NSString*) message
{

    NSDictionary *options = @{
                              kCRToastTextKey : message,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor redColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
}

-(void)showAlertView
{
    if (alertView) {
        
        [mainScrollView addSubview:alertView];
        [mainScrollView bringSubviewToFront:alertView];
        [alertView setCenter:CGPointMake(self.view.center.x, (alertView.frame.size.height) + 40.0)];

    }
}
-(void)tearDownAlertView
{
    if (alertView) {

        [UIView animateWithDuration:0.3 animations:^{
            [alertView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
            alertView = nil;
        }];
        
        
    }
}
-(UIView*)createAlertViewWithTitle:(NSString*) title andMessage:(NSString*) message
{
    CGFloat titleSpacingY = 5.0;
    
    CGFloat cornerRad = 10.0;
    
    CGFloat alertHeight = 140.0,
    alertWidth  = 300.0;
    
    CGFloat titleHeight = alertHeight * 0.35 - titleSpacingY;
    CGFloat messageHeight = alertHeight - titleHeight;
    
    
    CGRect alertFrame, titleFrame, messageFrame;
    
    alertFrame = CGRectMake(mainScrollView.center.x, mainScrollView.center.y, alertWidth, alertHeight);
    
    titleFrame = CGRectMake(0.0, titleSpacingY, alertWidth, titleHeight);
    
    messageFrame = CGRectMake(0.0, titleHeight, alertWidth, messageHeight);
    
    
    NSString *fontFamily = @"DINAlternate-Bold";
    
    UIColor *titleBackgroundColor = [UIColor Evernote];
    UIColor *messageBackgroundColor = [UIColor charcoalColor];
    
    
    //  Create the view
    
    UIView *aView = [[UIView alloc] initWithFrame:alertFrame];
    aView.layer.cornerRadius = cornerRad;
    
    aView.backgroundColor = [UIColor charcoalColor];
    
    
    //  Title label
    CGFloat titleFontSize = 20.0;
    
    UIFont *titleFont = [UIFont fontWithName:fontFamily size:titleFontSize];
    
    UIColor *titleFontColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    
    titleLabel.textColor = titleFontColor;
    titleLabel.font = titleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    titleLabel.text = title;
    
    titleLabel.backgroundColor = titleBackgroundColor;
    
    
    //  Message Label
    
    CGFloat messageFontSize = titleFontSize * .75;
    
    UIFont *messageFont = [UIFont fontWithName:fontFamily size:messageFontSize];
    
    UIColor *messageFontColor = [UIColor whiteColor];
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:messageFrame];


    messageLabel.textColor = messageFontColor;
    messageLabel.font = messageFont;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    
    messageLabel.text = message;
    
    messageLabel.backgroundColor = messageBackgroundColor;
    
    //  Add views
    
    [aView addSubview:titleLabel];
    [aView addSubview:messageLabel];
    
    return aView;
}
-(void)updateDateForFrame:(pictureFrame*) Pframe
{
    
    UIColor *progress = [UIColor warningColor];
    
    [dateUpdaterLabel setTextColor:progress];
    [dateUpdaterLine setBackgroundColor:progress];
    
    updateLineColorTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(changeToRed) userInfo:nil repeats:NO];
    
    
    NSDate *newDate = [TLManager getNewDateForFrame:Pframe];
    
    imageObject *pFrameData = Pframe.imageObject;
    
    ImagePackage *newPackage = [ImagePackage new];
    
    [newPackage setContentsWithImageObject:pFrameData];
    
    newPackage.dateTaken = newDate;
    
    updatingImageObject = pFrameData;
    
    [mainDataCom updateBabbagePhotoDateWithImagePackage:newPackage];
    
}
-(void)changeToGreen
{
    UIColor *green = [UIColor Evernote];
    
    POPSpringAnimation *ani = [POPSpringAnimation animation];
    POPSpringAnimation *aniLine = [POPSpringAnimation animation];
    
    ani.property = [POPAnimatableProperty propertyWithName:kPOPLabelTextColor];
    aniLine.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
    
    ani.toValue = green;
    aniLine.toValue = green;
    
    [dateUpdaterLine pop_addAnimation:aniLine forKey:@"ani"];
    [dateUpdaterLabel pop_addAnimation:ani forKey:@"aniLabel"];
    incompleteTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tearItAllDown) userInfo:nil repeats:NO];
}
-(void)changeToRed
{
    [dateUpdaterLine setBackgroundColor:[UIColor dangerColor]];
    [dateUpdaterLabel setTextColor:[UIColor dangerColor]];
    [updateLineColorTimer invalidate];
    updateLineColorTimer = nil;
    
    incompleteTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tearItAllDown) userInfo:nil repeats:NO];
}
-(void)tearItAllDown
{
    [self tearDownDateLine];
    [self tearDownDateUpdaterLabel];
    [self tearDownDayLabel];
    
    [incompleteTimer invalidate];
    incompleteTimer = nil;
    
    isDateUpdateLockOn = NO;
}
-(void)didFinishUpdatingImageWithCode:(NSInteger)code
{
    if (code == 200) {
        [self showTempAlertWithTitle:@"Updated!" andMessage:@"All good"];
    }
    else
    {
        [self showTempAlertWithTitle:@"Error" andMessage:@"uhoh"];
    }
}
-(void)finishedUpdatingPhotoDateWithStatusCode:(NSInteger)statusCode
{
    [updateLineColorTimer invalidate];
    updateLineColorTimer = nil;
    
    [incompleteTimer invalidate];
    incompleteTimer = nil;
    
    
    if (statusCode == 200) {
        
        
        [self performSelectorOnMainThread:@selector(changeToGreen) withObject:nil waitUntilDone:NO];
        if (updatingImageObject) {
            
            updatingImageObject.date = updatingImagePackage.dateTaken;
            updatingImageObject = nil;
            updatingImagePackage = nil;
            
        }
    }
    else
    {
        [self changeToRed];
        updatingImageObject = nil;
        updatingImagePackage = nil;
    }
}
-(CGPoint)dampenPoint:(CGPoint) point withFactor:(CGFloat) factor
{
    CGPoint dampenedPoint;
    
    CGFloat pointX = point.x;
    CGFloat pointY = point.y;
    
    
    pointX *= factor;
    pointY *= factor;
    
    dampenedPoint.x = pointX;
    dampenedPoint.y = pointY;
    
    return dampenedPoint;
}

-(CGFloat)findDampFactorWithYPoint:(CGFloat) point
{
    CGFloat newPoint = 1.0;
    
    CGFloat center = [mainScrollView center].y;
    
    CGFloat dist = fabsf(center - point);
    
    if (dist >= 20.0) {
        
        newPoint = dist / center;
    }
    
    
    NSLog(@"\nDamp Factor:\t%f\n", newPoint);
    
    return newPoint;
}
@end
