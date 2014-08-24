//
//  landingPageViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "landingPageViewController.h"
#import "DateRange.h"
#import "WorkspaceViewController.h"

NSString* const timelineSegue = @"showTimeline";


NSString* const keyTimeline = @"keyTimeline";

@interface landingPageViewController () <UIActionSheetDelegate>
{
    
    BOOL btnTimelineDidSpring;
    NSMutableDictionary *buttonStyle;
    
    
    DateRange *timelineDateRange;
    
    NSArray *dateRanges;
    
    UIActionSheet *timelineChooser;
    
}

@end

@implementation landingPageViewController

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

    
    [self initialSetup];
    
    btnTimelineDidSpring = NO;
    
    _testType = testingSegueTypeNone;
    
    
    timelineDateRange = [DateRange createRangeWithStartYear:1850 andEndYear:1900];
    
}
- (IBAction)goToTimeline:(id)sender {
    
    
    [timelineChooser showInView:self.view];
    
    
    
   // [self performSegueWithIdentifier:timelineSegue sender:nil];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[WorkspaceViewController class]]) {
        
        WorkspaceViewController *dest = (WorkspaceViewController*)segue.destinationViewController;
        
        dest.timelineDateRange = timelineDateRange;
        
    }
}
-(void)initialSetup
{
    //  Set the title of the page
    
    self.title = @"Prototyping Landing Page";
    
    //  Set the button to be invisible
    
    /*
    self.buttonTimeline.alpha   = 0.0;
    self.buttonServer.alpha     = 0.0;
    _buttonUploading.alpha       = 0.0;
    */
    
    [self varSetup];
    [self aestheticsConfiguration];
    [self setupActionSheet];
}
-(void)varSetup
{
    buttonStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeButtonDefault];
    [self setupTimelines];
}
- (void)aestheticsConfiguration
{
    //  Set the 'Go to Timeline' button's visual properties
    
    
    [_buttonTimeline setTitleColor:[UIColor tonyColor] forState:UIControlStateNormal];
    [_buttonServer setTitleColor:buttonStyle[keyTextColor] forState:UIControlStateNormal];
    [_buttonUploading setTitleColor:buttonStyle[keyTextColor] forState:UIControlStateNormal];
    
    
    _buttonTimeline.titleLabel.font = buttonStyle[keyFont];
    _buttonServer.titleLabel.font = buttonStyle[keyFont];
    _buttonUploading.titleLabel.font = buttonStyle[keyFont];
    
    /*
    if (btnTimelineDidSpring == NO) {
        
        float buttonToValue = 200.0;
        
        
        POPSpringAnimation *springFromBelow = [POPSpringAnimation animation];
        
        springFromBelow.property    = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        
        springFromBelow.fromValue   = @(1000);
        springFromBelow.toValue     = @(buttonToValue);
        
        springFromBelow.springSpeed = 10.0;
        
        [self.buttonTimeline.layer pop_addAnimation:springFromBelow
                                             forKey:@"springFromBelow"];
        
        
        
        
        POPSpringAnimation *alphaSpring = [POPSpringAnimation animation];
        
        alphaSpring.property    = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        
        alphaSpring.toValue     = @(1.0);
        
        [self.buttonTimeline pop_addAnimation:alphaSpring
                                       forKey:@"alphaSpring"];
        
        
        
        
        buttonToValue += 50.0;
        
        POPSpringAnimation *springFromBelowServer = [POPSpringAnimation animation];
        
        springFromBelowServer.property      = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        
        springFromBelowServer.fromValue     = @(1000);
        springFromBelowServer.toValue       = @(buttonToValue);
        
        springFromBelowServer.springSpeed   = 7.0;
        
        [self.buttonServer.layer pop_addAnimation:springFromBelowServer
                                           forKey:@"springFromBelowServer"];
        
        [self.buttonServer pop_addAnimation:alphaSpring
                                     forKey:@"alphaSpringServer"];
        
        
        
        buttonToValue += 50.0;
        
        
        POPSpringAnimation *springFromBelowUploading = [POPSpringAnimation animation];
        
        springFromBelowUploading.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        
        springFromBelowUploading.fromValue = @(1000);
        springFromBelowUploading.toValue = @(buttonToValue);
        
        springFromBelowServer.springSpeed = 10.0;
        
        [_buttonUploading.layer pop_addAnimation:springFromBelowUploading forKey:@"springFromBelowUploading"];
        
        [_buttonUploading pop_addAnimation:alphaSpring forKey:@"alphaSpringUploading"];
        
        btnTimelineDidSpring = YES;
    }
     
     */
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self testingCheck];
}
-(void)testingCheck
{
    switch (_testType) {
        case testingSegueTypeTimeline:
            
            [self performSegueWithIdentifier:segueTimeline sender:nil];
            break;
            
        case testingSegueTypeUploader:
            [self performSegueWithIdentifier:segueUploader sender:nil];
            break;
            
        case testingSegueTypeNone:
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTimelines
{
    NSMutableArray *timelineArray = [NSMutableArray new];
    
    [timelineArray addObject:@{keyTitle: @"1850 - 1900",
                               keyTimeline: [DateRange createRangeWithStartYear:1850 andEndYear:1900]}];
    
    [timelineArray addObject:@{keyTitle: @"1900 - 1950",
                               keyTimeline: [DateRange createRangeWithStartYear:1900 andEndYear:1950]}];
    
    [timelineArray addObject:@{keyTitle: @"1950 - 2000",
                               keyTimeline: [DateRange createRangeWithStartYear:1950 andEndYear:2000]}];
    
    [timelineArray addObject:@{keyTitle: @"1900 - 2000",
                               keyTimeline: [DateRange createRangeWithStartYear:1900 andEndYear:2000]}];
    
    dateRanges = [NSArray arrayWithArray:timelineArray];
    
    
}
-(void)setupActionSheet
{
    timelineChooser = [[UIActionSheet alloc] init];
    [timelineChooser setTitle:@"Choose Timeline"];
    [timelineChooser setDelegate:self];
    
    for (NSDictionary* dict in dateRanges) {
        
        [timelineChooser addButtonWithTitle:dict[keyTitle]];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != -1) {
        

    timelineDateRange = dateRanges[buttonIndex][keyTimeline];
    
    [self performSegueWithIdentifier:timelineSegue sender:nil];
        
    }
}
@end
