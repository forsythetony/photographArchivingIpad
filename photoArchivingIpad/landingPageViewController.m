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
    
}
-(void)initialSetup
{
    //  Set the title of the page
    
    self.title = @"Prototyping Landing Page";
    
    //  Set the button to be invisible
    
    self.buttonTimeline.alpha   = 0.0;
    self.buttonServer.alpha     = 0.0;
    
}
- (void)aestheticsConfiguration
{
    //  Set the 'Go to Timeline' button's visual properties
    
    UIColor *btnTimelineTextColor = [UIColor indigoColor];
    
    [self.buttonTimeline setTitleColor:btnTimelineTextColor
                              forState:UIControlStateNormal];
    
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
        
        
        
        
        [self.buttonServer setTitleColor:btnTimelineTextColor
                                forState:UIControlStateNormal];
        
        btnTimelineDidSpring = YES;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self aestheticsConfiguration];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
