//
//  WorkspaceViewController.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
#import "WorkspaceViewController.h"
#import <objc/message.h>

#define TLWALLSPACING 100.0
#define MAINSCROLLVIEWSIZE 4000.0

@interface WorkspaceViewController () {
    
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
    
}

@end

@implementation WorkspaceViewController

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
-(void)viewDidAppear:(BOOL)animated
{
    
    if (shouldLoadAgain == YES) {
        [self createScrollView];
        [self createAuxViews];

        
        if (useDummyData == NO) {
            
            [mainDataCom getPhotosForUser:@"forsythetony"];
        }
        else
        {
            [self dummyDataGenerator];
        }
        
        shouldLoadAgain = NO;
    }
    
    
    
}
-(void)initialSetup
{
    
    UIColor *MVBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    
    self.modalPresentationStyle = UIModalTransitionStylePartialCurl;
    
    self.view.backgroundColor   =[UIColor clearColor];// MVBackground;
    self.title                  = @"Timeline";
    
    
    dataProvider = [dummyDataProvider new];
    
    if (!self.rangeInformation) {
        
        self.rangeInformation = [dataProvider getDummyRange];
        
    }
    
    photoList = [NSArray new];
    
    useDummyData = NO;
    
    
    mainDataCom = [[TFDataCommunicator alloc] init];

    mainDataCom.delegate    = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
  
}
-(void)finishedPullingPhotoList:(NSArray *)list
{
    
    if (list.count > 0) {
        
        NSMutableArray *framez = [NSMutableArray new];
        
        for (NSDictionary* dict in list)
        {
            
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
- (void)viewDidLoad
{
    shouldLoadAgain = YES;
    
    [super viewDidLoad];
    
    [self initialSetup];
    
    
    [mainDataCom saveImageToCameraRoll];
    
}
#pragma mark Create Views
-(void)createAuxViews
{
    float auxViewHeight     = self.view.bounds.size.height * 0.4;
    float auxViewYOrg       = self.view.bounds.size.height * 0.6;
    float auxViewWidth      = self.view.bounds.size.width;
    
    CGRect auxViewFrame = CGRectMake(
                                     0.0            , auxViewYOrg,
                                     auxViewWidth   , auxViewHeight
                                     );
    
    workspaceAuxView* auxView = [[workspaceAuxView alloc] initWithFrame:auxViewFrame];
    
    [self.view addSubview:auxView];
    
    float imageContainerViewWidth = auxViewWidth / 3.0;
    
    CGRect  imageContainerFrame =   CGRectMake(
                                               0.0                      , 0.0,
                                               imageContainerViewWidth  , auxViewHeight
                                               );
    
    UIView *imageContainerView = [[UIView alloc] initWithFrame:imageContainerFrame];
    
    imageContainerView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"suble_carbon.png"]];
    
    [auxView addSubview:imageContainerView];
    
    float sideSpacing = 10.0;
    
    CGRect imageViewFrame;
    
    imageViewFrame.origin.x = sideSpacing;
    imageViewFrame.origin.y = sideSpacing;
    imageViewFrame.size.width = imageContainerFrame.size.width - (sideSpacing * 2.0);
    imageViewFrame.size.height = imageContainerFrame.size.height - (sideSpacing * 2.0);
    
    
    _displayedImage = [[UIImageView alloc] initWithFrame:imageViewFrame];
    
    UITapGestureRecognizer *imagetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageSectionFrom:)];
    
    imagetap.numberOfTapsRequired =  2.0;
    
    [imageContainerView addGestureRecognizer:imagetap];
    [imageContainerView addSubview:_displayedImage];
    
    float addContentContainerWidth = 200.0;
    
    CGRect infoViewContainerFrame;
    
    infoViewContainerFrame.origin.x = imageViewFrame.size.width;
    infoViewContainerFrame.origin.y = 0.0;
    infoViewContainerFrame.size.width = (auxViewWidth - imageContainerViewWidth) - addContentContainerWidth;
    infoViewContainerFrame.size.height = imageContainerFrame.size.height;
    
    UIView *infoViewContainer = [[UIView alloc] initWithFrame:infoViewContainerFrame];
    
    infoViewContainer.backgroundColor = [UIColor clearColor];
    
    [auxView addSubview:infoViewContainer];
    
    
    float textViewWallSpacing = 15.0;
    
    CGRect imageInfoTextFrame;
    
    imageInfoTextFrame.origin.x = textViewWallSpacing;
    imageInfoTextFrame.origin.y = textViewWallSpacing;
    imageInfoTextFrame.size.width = infoViewContainerFrame.size.width - (textViewWallSpacing * 2.0);
    imageInfoTextFrame.size.height = infoViewContainerFrame.size.height - (textViewWallSpacing * 2.0);
    
    
    
    _infoPager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                   options:nil];
    
    
    _infoPager.delegate = self;
    _infoPager.dataSource = self;
    
    NSMutableArray *pagerVCs = [NSMutableArray new];
    
    pagerInformationVC *imageInformation = [pagerInformationVC new];
    
    [pagerVCs addObject:imageInformation];
    
    pagerSocialVC *socialInfo = [pagerSocialVC new];
    
    [pagerVCs addObject:socialInfo];

    imageInformationVClist = [NSArray arrayWithArray:pagerVCs];
    
    NSArray *initialVCs = [NSArray arrayWithObject:imageInformation];
    
    [_infoPager setViewControllers:initialVCs direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:_infoPager];
    
    //[infoViewContainer addSubview:_infoPager.view];

    
    _infoPager.view.frame = imageInfoTextFrame;
    
    [_infoPager didMoveToParentViewController:self];
    
    
    
    _infPager = [[imageInfoPagerVC alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [self addChildViewController:_infPager];
    
    [infoViewContainer addSubview:_infPager.view];
    
    _infPager.view.frame = imageInfoTextFrame;
    
    [_infPager didMoveToParentViewController:self];
    
    
    
    _imageInfoDisplay = [[UITextView alloc] initWithFrame:imageInfoTextFrame];
    
    _imageInfoDisplay.text              = @"";
    _imageInfoDisplay.backgroundColor   = [UIColor clearColor];
    _imageInfoDisplay.font              = [UIFont fontWithName:@"CourierNewPSMT" size:13.0];
    _imageInfoDisplay.textColor         = [UIColor ghostWhiteColor];
    _imageInfoDisplay.editable          = NO;
    _imageInfoDisplay.layer.cornerRadius= 8.0;
    
    //[infoViewContainer addSubview:_imageInfoDisplay];
    
    float addContentWallSpacing = 10.0;
    
    CGRect addContentViewContainerFrame;
    
    addContentViewContainerFrame.origin.x = infoViewContainerFrame.origin.x + infoViewContainerFrame.size.width;
    addContentViewContainerFrame.origin.y = addContentWallSpacing;
    addContentViewContainerFrame.size.width = addContentContainerWidth - addContentWallSpacing;
    addContentViewContainerFrame.size.height = infoViewContainerFrame.size.height - (addContentWallSpacing * 2);

    UIView *addcontentViewContainer = [[UIView alloc] initWithFrame:addContentViewContainerFrame];
    
    addcontentViewContainer.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"tweed.png"]];
    
    addcontentViewContainer.layer.cornerRadius = 4.0;
    
    [auxView addSubview:addcontentViewContainer];
    
    float buttonStartHeight = 10.0;
    float buttonWidth = addContentContainerWidth - 30.0;
    CGSize buttonSize;
    buttonSize.width    = buttonWidth;
    buttonSize.height   = 40.0;
    
    
    UIColor *buttonBackgroundColor = [UIColor whiteColor];
    UIColor *buttonTextColor = [UIColor black25PercentColor];
    
    UIFont *buttonFont = [UIFont fontWithName:@"DINAlternate-Bold" size:18.0];
    
    float buttonIconSize = buttonSize.height * .8;
    
    CGRect buttonIconRect = CGRectMake(10.0, 0.0, buttonIconSize, buttonIconSize);
    
    
    
    
    
    CGRect addStoryButtonFrame;
    
    addStoryButtonFrame.origin.x = (addContentViewContainerFrame.size.width - buttonSize.width) / 2.0;
    addStoryButtonFrame.origin.y = buttonStartHeight;
    addStoryButtonFrame.size = buttonSize;
    
    _addStoryButton = [[UIButton alloc] initWithFrame:addStoryButtonFrame];
    
    [_addStoryButton addTarget:self action:@selector(handleStoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _addStoryButton.backgroundColor = buttonBackgroundColor;
    _addStoryButton.layer.cornerRadius = 8.0;
    _addStoryButton.alpha = 0.0;
    
        FAKFontAwesome *storyIcon = [FAKFontAwesome bookIconWithSize:buttonIconSize];
    
    
    UIImageView *addStoryButtonImageView = [[UIImageView alloc] initWithFrame:buttonIconRect];
    
    [addStoryButtonImageView setImage:[storyIcon imageWithSize:CGSizeMake(buttonIconSize, buttonIconSize)]];
    
    
    CGSize buttonLabelSize;
    
    buttonLabelSize.width = buttonSize.width * 0.75;
    buttonLabelSize.height = buttonSize.height;
    
    CGRect buttonLabelFrame;
    
    buttonLabelFrame.size = buttonLabelSize;
    
    buttonLabelFrame.origin.x = addStoryButtonImageView.frame.origin.x + addStoryButtonImageView.frame.size.width + 7.0;
    
    buttonLabelFrame.origin.y = 0.0;

    
    UILabel *addStoryText = [[UILabel alloc] initWithFrame:buttonLabelFrame];
    
    addStoryText.font = buttonFont;
    addStoryText.backgroundColor = [UIColor clearColor];
    addStoryText.textColor = buttonTextColor;
    addStoryText.text = @"Add Story";
    
    CGRect iconRect = CGRectMake(10.0, 4.0, buttonIconSize, buttonIconSize);
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:iconRect];
    
    [iconImage setBackgroundColor:[UIColor clearColor]];
    [iconImage setImage:[self getImageViewForStoryType:buttonIconTypeStory withButtonHeight:buttonIconSize]];
    
    
    CGRect addRecordingButtonFrame = addStoryButtonFrame;
    
    addRecordingButtonFrame.origin.y += 20.0;
    
    _addRecording = [[UIButton alloc ]initWithFrame:addRecordingButtonFrame];
    
    _addRecording.backgroundColor = [UIColor whiteColor];
    _addRecording.alpha = 0.0;
    _addRecording.layer.cornerRadius = 8.0;
    

    [_addRecording addSubview:addStoryText];
    
    UIImageView *recordingIcon = [[UIImageView alloc] initWithFrame:iconRect];
    
    [recordingIcon setImage:[self getImageViewForStoryType:buttonIconTypeRecording withButtonHeight:buttonIconSize]];
    
    [_addRecording addSubview:recordingIcon];
    
    
    UILabel *addRecordingText = [self labelCopy:addStoryText];
    
    addRecordingText.text = @"Add Recording";
    
    [_addRecording addSubview:addRecordingText];
    
    [_addStoryButton addSubview:iconImage];
    
    [_addStoryButton addSubview:addStoryText];
    
    
    CGRect addOtherInfoRect = addRecordingButtonFrame;
    
    addRecordingButtonFrame.origin.y += 20.0;
    
    _addOtherInfo = [[UIButton alloc ] initWithFrame:addOtherInfoRect];
    
    _addOtherInfo.backgroundColor = [UIColor whiteColor];
    
    _addOtherInfo.layer.cornerRadius = 8.0;
    _addOtherInfo.alpha = 0.0;
    
    UIImageView *addOtherIcon = [[UIImageView alloc] initWithFrame:iconRect];
    
    [addOtherIcon setImage:[self getImageViewForStoryType:buttonIconTypeOther withButtonHeight:buttonIconSize]];
    
    UILabel *addOtherText = [self labelCopy:addRecordingText];
    
    addOtherText.text = @"Add Other";
    
    [_addOtherInfo addSubview:addOtherText];
    [_addOtherInfo addSubview:addOtherIcon];
    [_addOtherInfo addTarget:self action:@selector(handleOtherInfoClickFromSender:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [addcontentViewContainer addSubview:_addOtherInfo];
    
    
    [addcontentViewContainer addSubview:_addStoryButton];
    
    [addcontentViewContainer addSubview:_addRecording];
    
    
    
    
}
-(void)handleOtherInfoClickFromSender:(id) sender
{
    if (_displayedImage) {
        [mainDataCom deletePhoto:_displayImageInformation];
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
    float scrollViewHeight = (self.view.bounds.size.height * .6);
    
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
    mainScrollView.scrollEnabled    = YES;
    mainScrollView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    mainScrollView.showsHorizontalScrollIndicator  = NO;
    mainScrollView.maximumZoomScale = 4.0;
    mainScrollView.minimumZoomScale = 1.0;
    mainScrollView.delegate = self;
    
    
    [self.view addSubview:mainScrollView];
    
    [self createTimelineWithValues];
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return TLManager.TLView;
    
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}
-(void)createTimelineWithValues
{
    startDate   = [self.rangeInformation objectForKey:@"startDate"];
    endDate     = [self.rangeInformation objectForKey:@"endDate"];
    
    NSNumber *startYear = [startDate yearAsNumber];
    NSNumber *endYear   = [endDate yearAsNumber];
    
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
    
    [self createYearPointsWithYearData:@{@"startYear": startYear,@"endYear" : endYear}
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
-(void)createYearPointsWithYearData:(NSDictionary*) yearData andContentSize:(CGSize) contentSize toView:(UIView*) timelineView
{
    NSMutableArray *savedPoints = [NSMutableArray new];
    NSMutableArray *savedYears = [NSMutableArray new];
    
    NSInteger startYear = [[self.rangeInformation[@"startDate"] yearAsNumber] integerValue];
    NSInteger endYear   = [[self.rangeInformation[@"endDate"] yearAsNumber] integerValue];
    
    float sizeOfTL = contentSize.width - (TLWALLSPACING * 2.0);
    
    NSInteger yearDiff = abs(startYear - endYear);
    
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
        
        UIPanGestureRecognizer *panRecog = [UIPanGestureRecognizer new];
        
        [panRecog addTarget:self
                     action:@selector(handlePanFrom:)];
        
        [theFrame addGestureRecognizer:panRecog];
        
        
        
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
    
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY + translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        
        CGFloat velocityX   = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        
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
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
        
        pictureFrame *frame = (pictureFrame*)[sender view];
        
        [TLManager updateDateForPicture:frame];
        
    }
    
}

-(void)handleTapFrom:(UIGestureRecognizer*) recognizer
{
    
    UITapGestureRecognizer *gestRecog = (UITapGestureRecognizer*)recognizer;

    NSInteger touchNum = [gestRecog numberOfTouches];
    
    NSLog(@"\nNumber of touches: %d", touchNum);
    
    
    pictureFrame *frame = (pictureFrame*)recognizer.view;

    [frame resize];
    
    
}
-(void)handleDoubleTap:(UITapGestureRecognizer*) recognizer
{
    
    pictureFrame *frame = (pictureFrame*)[recognizer view];
    
    [TLManager.TLView bringSubviewToFront:frame];
    
    
    imageObject *obj = frame.imageObject;
    
    NSURL *fullSizeURL = obj.photoURL;
    
    [_displayedImage setImageWithURL:fullSizeURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        float sizeDelta = 10.0;
        
        
        POPSpringAnimation *imageSizeChange = [POPSpringAnimation animation];
        
        imageSizeChange.property = [POPAnimatableProperty propertyWithName:kPOPViewSize];
        
        imageSizeChange.fromValue = [NSValue valueWithCGSize:CGSizeMake(self.displayedImage.frame.size.width - sizeDelta, self.displayedImage.frame.size.height - sizeDelta)];
        
        imageSizeChange.toValue = [NSValue valueWithCGSize:CGSizeMake(self.displayedImage.frame.size.width, self.displayedImage.frame.size.height)];
        
        [self.displayedImage pop_addAnimation:imageSizeChange forKey:@"imageResizeLarger"];
        
        POPSpringAnimation *alphaChange = [POPSpringAnimation animation];
        
        alphaChange.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        
        alphaChange.fromValue = @(0.0);
        alphaChange.toValue = @(1.0);
        
        [self.displayedImage pop_addAnimation:alphaChange forKey:@"alphaChange"];
        
        
        
        
        
    }];
    
    for (pictureFrame* frm in photoList) {
        
        if (frm != frame) {
            [frm stopAllTheGlowing];
        }
        else
        {
            [frm largeResize];
        }
    }
    
    [self displayInformationForImage:frame.imageObject];
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
    
    float   slideDelta      = 300.0,
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
    
    
}
#pragma mark Delegate Methods
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
                              kCRToastAnimationInTimeIntervalKey    : @(2.0),
                              kCRToastAnimationOutTimeIntervalKey   : @(1.0),
                              kCRToastTimeIntervalKey               : @(2.0)
                              };
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
    
}

#pragma mark Utility Methods -

-(NSTimeInterval)getTimeIntervalWithDate:(NSDate*) date
{
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate referenceDate]];
    
    NSLog(@"\nThe time interval is: %f\n", interval);
    
    return interval;
    
}

-(NSDictionary*)getTextAttributesWithYear:(NSInteger) year withInfo:(NSDictionary*) info
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

    NSInteger startYear = [[info valueForKey:@"startYear"] integerValue];
    NSInteger endYear   = [[info valueForKey:@"endYear"] integerValue];
    
    float lineHeightPrim = 0.0;
    
    if (year == startYear || year == endYear) {
        
        lineHeightPrim  = 0.0;

        textColor       = [UIColor warmGrayColor];
        fontSize        = [NSNumber numberWithFloat:75.0];
        heightMod       = [NSNumber numberWithFloat:0.0];
        yearString      = [NSString stringWithFormat:@"%i", year];
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
                yearString     = [NSString stringWithFormat:@"%i", year];
                
            }
            else {
                
                lineHeightPrim = 30.0;

                textColor      = [UIColor warmGrayColor];
                fontSize       = [NSNumber numberWithFloat:lineHeightPrim - 5.0];
                heightMod      = [NSNumber numberWithFloat:lineHeightPrim];
                yearString     = [NSString stringWithFormat:@"%i", year];
                lineHeight     = [NSNumber numberWithFloat:lineHeightPrim - 7.5];
                
            }
            
            finalAlpha = [NSNumber numberWithFloat:1.0];
            shouldSaveCenter = [NSNumber numberWithBool:YES];
            
        }
        else {
            
            textColor = [UIColor warmGrayColor];
            fontSize  = [NSNumber numberWithFloat:15.0];
            heightMod = [NSNumber numberWithFloat:0];
            
            if(year < 2000) {
                
                year -= 1900;
            }
            else if(year >= 2000) {
                
                year -= 2000;
            }
            
            if (year >= 10) {
                
                yearString = [NSString stringWithFormat:@"'%i", year];
            }
            else {
                
                yearString = [NSString stringWithFormat:@"'0%i", year];
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
-(void)keyboardDidHide:(NSNotification*) notification
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)keyboardDidShow:(NSNotification*) notification
{
    //[self.view setFrame:CGRectMake(0.0, -(self.view.frame.size.height / 2.0), self.view.frame.size.width, self.view.frame.size.height)];
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect newViewRect = self.view.frame;
    
    newViewRect.origin.y -= keyboardRect.size.width;
    
    NSLog(@"\nKeyboard Frame: %@\nNew View Frame: %@", NSStringFromCGRect(keyboardRect), NSStringFromCGRect(newViewRect));
    [self.view setFrame:newViewRect];
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
-(void)shouldDismissImageViewer:(id)imageViewer
{
    largeImageViewer *imgViewer = (largeImageViewer*)imageViewer;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
