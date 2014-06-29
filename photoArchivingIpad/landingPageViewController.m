//
//  landingPageViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "landingPageViewController.h"

@interface landingPageViewController () {
    
    BOOL btnTimelineDidSpring;
    NSMutableDictionary *buttonStyle;
    
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
}
-(void)varSetup
{
    buttonStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeButtonDefault];
}
- (void)aestheticsConfiguration
{
    //  Set the 'Go to Timeline' button's visual properties
    
    
    [_buttonTimeline setTitleColor:buttonStyle[keyTextColor] forState:UIControlStateNormal];
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

@end
