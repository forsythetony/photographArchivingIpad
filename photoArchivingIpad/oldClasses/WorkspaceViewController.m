//
//  WorkspaceViewController.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
#import "WorkspaceViewController.h"
#import "pictureFrame.h"
#import "imageObject.h"
#import <objc/message.h>
#import "timelineLabelView.h"

#define TLWALLSPACING 100.0
#define MAINSCROLLVIEWSIZE 4000.0


@interface WorkspaceViewController () {
    dummyDataProvider *dataProvider;
    UIScrollView *mainScrollView;
    float TLSpacing;
    double pureStartDate, pureEndDate;
    NSDate *startDate, *endDate;
    timelineManager *TLManager;
    float xDelta, yDelta, firstX, firstY;
    CGPoint startingPoint;
    
    
}

@property (strong, nonatomic) NSArray* photographs;

@end

@implementation WorkspaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)createImagesArray
{
    NSBundle *theBundle = [NSBundle mainBundle];
    
    NSLog(@"Bundle path is: %@", theBundle.resourcePath);
    
}
-(void)viewDidAppear:(BOOL)animated
{
   // [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    
    CGRect mainBounds = self.view.bounds;
    CGRect mainFrame = self.view.frame;
    
    NSLog(@"Screen Bounds: %@", NSStringFromCGRect(mainBounds));
    NSLog(@"Frame: %@", NSStringFromCGRect(mainFrame));
    
    [self createScrollView];
    
   // NSArray *images = [dataProvider getImageObjects];
    
    [TLManager setInitialPhotographs:_photographs];
    
    
}
-(void)mainAestheticsConfiguration
{
    UIColor *MVBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    
    [self.view setBackgroundColor:MVBackground];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self mainAestheticsConfiguration];
    
    dataProvider = [dummyDataProvider new];
    
    _photographs = [dataProvider getImageObjects];
    [self addGestureRecognizers];
    
    //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(testMove) userInfo:nil repeats:NO];
    
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    CGRect mainBounds = self.view.bounds;
    CGRect mainFrame = self.view.frame;
    
    NSLog(@"Screen Bounds: %@", NSStringFromCGRect(mainBounds));
    NSLog(@"Frame: %@", NSStringFromCGRect(mainFrame));
    
    [self createScrollView];
    
}
-(void)createSmallViewsWithImages:(NSArray*) images
{
    CGPoint centerOfView = self.view.center;
    
    
    for (imageObject* obj in images) {
        pictureFrame *frame = [pictureFrame createFrame];
        [frame.theImage setImage:[obj image]];
        
        CGPoint frameCenter = centerOfView;
        frameCenter.x += [[obj centerXoffset] floatValue];
        frameCenter.y = mainScrollView.bounds.size.height + 100.0;
        frame.center = frameCenter;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        [panRecognizer setDelegate:self];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        
        [tapRecognizer setDelegate:self];
        
        [frame addGestureRecognizer:panRecognizer];
        [frame addGestureRecognizer:tapRecognizer];
        
        [frame bounceInFromPoint:mainScrollView.bounds.size.height toPoint:mainScrollView.center.y];
        
        [mainScrollView addSubview:frame];
        
    }
}

-(void)createScrollView
{
    
    CGRect scrollViewFrame;
    
    scrollViewFrame.origin = CGPointMake(0.0, 0.0);
    
    scrollViewFrame.size.width = MAINSCROLLVIEWSIZE;
    scrollViewFrame.size.height = self.view.bounds.size.height;
    
    CGRect screenRect = self.view.bounds;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height)];
    
    [mainScrollView setContentSize:scrollViewFrame.size];
    [mainScrollView setScrollEnabled:YES];
    
    [mainScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]]];
    
    [self.view addSubview:mainScrollView];
    
    [self createTimelineWithValues];
    
    /*
    mainScrollView = [UIScrollView new];
    mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:mainScrollView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainScrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"mainScrollView": mainScrollView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mainScrollView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"mainScrollView": mainScrollView}]];
    
    UILabel *previousLabel = nil;
    
    for (int i = 0; i < 30; i++) {
        UILabel *lab = [UILabel new];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        
        lab.text = [NSString stringWithFormat:@"This is label %i", i+1];
        [mainScrollView addSubview:lab];
        
        [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[lab]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"lab": lab}]];
        if (!previousLabel)
        {
            [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[lab]" options:0 metrics:nil views:@{@"lab": lab}]];
            
        }
        else
        {
            [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev]-(10)-[lab]" options:0 metrics:nil views:@{@"lab": lab, @"prev" : previousLabel}]];
            
        }
        
        previousLabel = lab;
        
    }
    
    [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab]-(10)-|" options:0 metrics:nil views:@{@"lab": previousLabel}]];
    [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lab]-(10)-|" options:0 metrics:nil views:@{@"lab": previousLabel}]];
    
     */
}
-(void)createTimelineWithValues
{
    NSNumber *startYear = [NSNumber numberWithInt:1950];
    NSNumber *endYear = [NSNumber numberWithInt:2014];
    
    startDate = [NSDate dateWithYear:startYear];
    endDate = [NSDate dateWithYear:endYear];
    
    //NSArray *years = [self createYearsArrayWithStart:startYear andEnd:endYear];
    
    
    UIColor *TLbackground = [UIColor midnightBlueColor];
    CGRect scrollViewRect = mainScrollView.frame;
    CGSize scrollViewContentSize = mainScrollView.contentSize;
    CGPoint scrollCenter = mainScrollView.center;
    
    UIView *timelineView = [[UIView alloc] initWithFrame:CGRectMake(scrollViewRect.origin.x,
                                                                    scrollViewRect.origin.y,
                                                                    scrollViewContentSize.width,
                                                                    scrollViewContentSize.height)];
    [timelineView setBackgroundColor:TLbackground];
    
    [mainScrollView addSubview:timelineView];
    TLManager = [timelineManager new];

    TLManager.delegate = self;
    
    [TLManager setStartDate:startDate andEndDate:endDate andView:timelineView andXOffsert:TLWALLSPACING];
    
    NSDate *testDate = [NSDate dateWithv1String:@"01/01/1975"];
    
    CGPoint somePoint = [TLManager createPointWithDate:testDate];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    
    [testView setBackgroundColor:[UIColor yellowColor]];
    
    [timelineView addSubview:testView];
    
    [testView setCenter:somePoint];
    [self addTimelineLine];
    
    
    [self createYearPointsWithYearData:@{@"startYear": startYear,@"endYear" : endYear} andContentSize:mainScrollView.contentSize toView:timelineView];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)addTimelineLine
{

    float animationDuration = 1.5;
    
    CGRect TLStartFrame = CGRectMake(TLWALLSPACING,
                                           mainScrollView.center.y,
                                           1.0,
                                           2.0);
    
    CGRect TLFinalFrame = CGRectMake(TLWALLSPACING,
                                           mainScrollView.center.y,
                                           mainScrollView.contentSize.width - (TLWALLSPACING * 2.0),
                                           2.0);
    
    UIColor *TLLineColor = [UIColor black25PercentColor];
    
    UIView *TLLine = [[UIView alloc] initWithFrame:TLStartFrame];
    
    [TLLine setBackgroundColor:TLLineColor];
    
    [mainScrollView addSubview:TLLine];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [TLLine setFrame:TLFinalFrame];
    }];
    
}
-(void)createYearPointsWithYearData:(NSDictionary*) yearData andContentSize:(CGSize) contentSize toView:(UIView*) timelineView
{
    float labelFontSize = 13.0;
    NSString *labelFontFamily = @"DINAlternateBold-Bold";
    UIFont *labelFont = [UIFont fontWithName:labelFontFamily size:labelFontSize];
    
    UIColor *labelTextColor = [UIColor warmGrayColor];
    
    NSInteger startYear = [yearData[@"startYear"] integerValue];
    NSInteger endYear = [yearData[@"endYear"] integerValue];
    
    
    float sizeOfTL = contentSize.width - (TLWALLSPACING * 2.0);
    
    NSInteger yearDiff = abs(startYear - endYear);
    
    TLSpacing = sizeOfTL / (float)yearDiff;
    
    NSInteger frameDiff = (NSInteger)sizeOfTL / yearDiff;
    
    NSLog(@"\nFrameDiff = %d", frameDiff);
    
    CGRect labelFrame = CGRectMake(0.0, 0.0, 50.0, 30.0);
    CGPoint labelCenter = CGPointMake(TLWALLSPACING, timelineView.center.y);
    
    NSInteger yr = startYear;
    
    float labelYOffset = 15.0;
    float fiveModifier = 30.0;
    float animationDuration = 0.2;
    
    for (int i = 0; i <= yearDiff; i++) {
        
        
        NSDictionary *labelAttributes = [self getTextAttributesWithYear:yr withInfo:yearData];
        
        
        //  Create labelstring
        
        //  Create label
        
        UILabel *yrLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [yrLabel setText:labelAttributes[@"yearString"]];
        [yrLabel setTextAlignment:NSTextAlignmentCenter];
        
        [yrLabel setFont:[UIFont fontWithName:labelAttributes[@"fontFamily"]
                                         size:[labelAttributes[@"fontSize"] floatValue]]];
        
        [yrLabel setTextColor:labelAttributes[@"textColor"]];
        [yrLabel sizeToFit];

        [timelineView addSubview:yrLabel];
        
        float heightMod = [labelAttributes[@"heightMod"] floatValue];
        
        if (labelYOffset < 0) {
            heightMod *= -1;
        }
        
        [yrLabel setCenter:CGPointMake(labelCenter.x + [labelAttributes[@"xOffset"] floatValue], labelCenter.y + labelYOffset + heightMod)];
        
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
        
        float lineHeight = [labelAttributes[@"lineHeight"] floatValue];
        float startingLineHeight = 1.0;
        
        if (labelYOffset < 0) {
            lineHeight *= -1;
            startingLineHeight *= -1;
        }
        
        CGRect lineFrame = CGRectMake(labelCenter.x, timelineView.center.y, 1.0, startingLineHeight);
        
        UIView *labelLine = [[UIView alloc] initWithFrame:lineFrame];
        [labelLine setBackgroundColor:[UIColor black25PercentColor]];
        lineFrame.size.height = lineHeight;
        
        [UIView animateWithDuration:animationDuration animations:^{
            [labelLine setFrame:lineFrame];
        }];
    
        [timelineView addSubview:labelLine];
        
        [yrLabel setBackgroundColor:labelAttributes[@"background"]];
        
        
        
        
        
        //  Update values
        
        labelCenter.x += frameDiff;
        labelYOffset *= -1;
        
        yr++;
        
        
    }

}
-(NSDictionary*)getTextAttributesWithYear:(NSInteger) year withInfo:(NSDictionary*) info
{
    UIColor *textColor, *backgroundColor;
    NSNumber *fontSize, *heightMod, *finalAlpha, *xOffSet, *rotation, *lineHeight;
    NSString *yearString;
    
    NSInteger startYear = [[info valueForKey:@"startYear"] integerValue];
    NSInteger endYear = [[info valueForKey:@"endYear"] integerValue];
    
    float lineHeightPrim = 0.0;
    
    if (year == startYear || year == endYear)
    {
        lineHeightPrim = 0.0;
        
        textColor = [UIColor warmGrayColor];
        fontSize = [NSNumber numberWithFloat:75.0];
        heightMod = [NSNumber numberWithFloat:0.0];
        yearString = [NSString stringWithFormat:@"%i", year];
        finalAlpha = [NSNumber numberWithFloat:0.3];
        backgroundColor = [UIColor clearColor];
        lineHeight = [NSNumber numberWithFloat:lineHeightPrim];
        
        if (year ==  startYear) {
            xOffSet = [NSNumber numberWithFloat:-60.0];
            rotation = [NSNumber numberWithInteger:labelRotationTypeLeft];
        }
        else{
            xOffSet = [NSNumber numberWithFloat:80.0];
            rotation = [NSNumber numberWithInteger:labelRotationTypeRight];
            heightMod = [NSNumber numberWithFloat:-10.0];
        }
    }
    else
    {
        if (year % 5 == 0) {
            
            if (year % 10 == 0) {
                lineHeightPrim = 70.0;
                
                textColor = [UIColor warmGrayColor];
                fontSize = [NSNumber numberWithFloat:30.0];
                heightMod = [NSNumber numberWithFloat:lineHeightPrim];
                lineHeight = [NSNumber numberWithFloat:lineHeightPrim - 10.0];
                yearString = [NSString stringWithFormat:@"%i", year];
            }
            else
            {
                lineHeightPrim = 30.0;
                
                textColor = [UIColor warmGrayColor];
                fontSize = [NSNumber numberWithFloat:lineHeightPrim - 5.0];
                heightMod = [NSNumber numberWithFloat:lineHeightPrim];
                yearString = [NSString stringWithFormat:@"%i", year];
                lineHeight = [NSNumber numberWithFloat:lineHeightPrim - 7.5];
            }
            
            finalAlpha = [NSNumber numberWithFloat:1.0];
            
        }
        else
        {
            textColor = [UIColor warmGrayColor];
            fontSize = [NSNumber numberWithFloat:15.0];
            heightMod = [NSNumber numberWithFloat:0];
            
            if(year < 2000)
            {
                year -= 1900;
            }
            else if(year >= 2000)
            {
                year -= 2000;
            }
            
            if (year >= 10) {
                yearString = [NSString stringWithFormat:@"'%i", year];
            }
            else
            {
                yearString = [NSString stringWithFormat:@"'0%i", year];
            }
            
            finalAlpha = [NSNumber numberWithFloat:0.6];
            lineHeight = [NSNumber numberWithFloat:0.0];
            
        }
        
        xOffSet = [NSNumber numberWithFloat:0.0];
        rotation = [NSNumber numberWithInteger:labelRotationTypeNone];
        backgroundColor = [UIColor clearColor];
        
        
    }
    
    return @{@"textColor"   : textColor,
             @"fontSize"    : fontSize,
             @"heightMod"   : heightMod,
             @"fontFamily"  : @"DINAlternate-Bold",
             @"yearString"  : yearString,
             @"finalAlpha"  : finalAlpha,
             @"xOffset"     : xOffSet,
             @"rotation"      : rotation,
             @"background"  : backgroundColor,
             @"lineHeight"  : lineHeight};
}
-(NSArray*)createYearsArrayWithStart:(NSNumber*) start andEnd:(NSNumber*) end
{
    int startInt = [start intValue];
    int endInt = [end intValue];
    
    NSMutableArray *years = [NSMutableArray array];
    
    for (int i = startInt; i <= endInt; i++) {
        if (i % 5 == 0) {
            [years addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return [NSArray arrayWithArray:years];
}
-(NSTimeInterval)getTimeIntervalWithDate:(NSDate*) date
{
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate referenceDate]];
    
    NSLog(@"\nThe time interval is: %f\n", interval);
    
    return interval;
}
-(void)testMove
{
    NSLog(@"I fired!");
    
    pictureFrame *theFrame = [_photographs objectAtIndex:0];
    
    CGPoint oldCenter = [theFrame center];
    
    CGPoint trans = CGPointMake(50.0, 50.0);
    
    CGPoint newCenter = CGPointMake(oldCenter.x + trans.x, oldCenter.y + trans.y);
    
    [theFrame setCenter:newCenter];
}
-(void)finishedUpdatedFrame:(pictureFrame *)frame withNewInformation:(NSDictionary *)info
{
    
    
    
    
    
    NSString *notificationString = [NSString stringWithFormat:@"The date for the frame has been updated to %@", info[@"newDate"]];
    
    
    
    
    
    
    
    
    NSDictionary *options = @{
                              kCRToastTextKey : notificationString,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor charcoalColor],
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
#pragma mark Gesture Recognizer Methods -
-(void)addGestureRecognizers
{
    for (pictureFrame* theFrame in _photographs)
    {
        
        UIPanGestureRecognizer *panRecog = [UIPanGestureRecognizer new];
        
        [panRecog addTarget:self action:@selector(handlePanFrom:)];
        
        [theFrame addGestureRecognizer:panRecog];
         
        UITapGestureRecognizer *tapRecog = [UITapGestureRecognizer new];
        
        [tapRecog addTarget:self action:@selector(handleTapFrom:)];
        
        [theFrame addGestureRecognizer:tapRecog];
    }
}
-(void)handlePanFrom:(id) sender
{
    /*
     
     CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:TLManager.TLView];
     CGPoint transPoint = [(UIPanGestureRecognizer*)sender translationInView:mainScrollView];
     
     NSLog(@"\nVelocity: %@\nTranslation: %@\nIn view: %@\nSender Center: %@", NSStringFromCGPoint(velocity), NSStringFromCGPoint(transPoint), NSStringFromCGRect(TLManager.TLView.frame), NSStringFromCGPoint([[sender view] center]));
     
     UIView *senderView = [sender view];
     
     switch ([(UIPanGestureRecognizer*)sender state]) {
     case UIGestureRecognizerStateBegan:
     xDelta = 0.0;
     yDelta = 0.0;
     
     //Somehting
     startingPoint = [[sender view] center];
     
     break;
     case UIGestureRecognizerStateChanged:
     //[senderView setCenter:CGPointMake(startingPoint.x + transPoint.x, startingPoint.y + transPoint.y)];
     yDelta += transPoint.y;
     xDelta += transPoint.x;
     
     NSLog(@"Y Delta: %f\nX Delta: %f", yDelta, xDelta);
     
     startingPoint = [senderView center];
     
     //Something else
     break;
     case UIGestureRecognizerStateEnded:
     //  Ended
     break;
     
     default:
     break;
     }
     
     */
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
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        
        
        CGFloat finalX = translatedPoint.x;// + velocityX;
        CGFloat finalY = translatedPoint.y;// + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
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
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
        
        pictureFrame *frame = (pictureFrame*)[sender view];
        
        [TLManager updateDateForPicture:frame];
    }
    
}

-(void)handleTapFrom:(UIGestureRecognizer*) recognizer
{
    pictureFrame *frame = (pictureFrame*)recognizer.view;
    
    
    [frame resize];
    
    
}
@end
