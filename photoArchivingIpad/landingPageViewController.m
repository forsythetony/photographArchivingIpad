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
    // Do any additional setup after loading the view.
    
    [self initialSetup];
    
    btnTimelineDidSpring = NO;
    
}
-(void)initialSetup
{
    //  Set the title of the page
    
    self.title = @"Prototyping Landing Page";
    
    //  Set the button to be invisible
    
    [self.buttonTimeline setAlpha:0.0];
    [self.buttonServer setAlpha:0.0];
}
- (void)aestheticsConfiguration
{
    //  Set the 'Go to Timeline' button's visual properties
    
    UIColor *btnTimelineTextColor = [UIColor indigoColor];
    
    [self.buttonTimeline setTitleColor:btnTimelineTextColor forState:UIControlStateNormal];
    if (btnTimelineDidSpring == NO) {

        //  Add spring animation to button
        
        float buttonToValue = 200.0;
        
        POPSpringAnimation *springFromBelow = [POPSpringAnimation animation];
        
        springFromBelow.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        
        springFromBelow.fromValue = @(1000);
        springFromBelow.toValue = @(buttonToValue);
        springFromBelow.springSpeed = 10.0;
        
        [self.buttonTimeline.layer pop_addAnimation:springFromBelow forKey:@"springFromBelow"];
        
        //  Add alpha animation to button
        
        POPSpringAnimation *alphaSpring = [POPSpringAnimation animation];
        
        alphaSpring.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        
        alphaSpring.toValue = @(1.0);
        
        [self.buttonTimeline pop_addAnimation:alphaSpring forKey:@"alphaSpring"];
        
        //  Add animations to server button
        
        buttonToValue += 50.0;
        
        POPSpringAnimation *springFromBelowServer = [POPSpringAnimation animation];
        
        springFromBelowServer.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        
        springFromBelowServer.fromValue = @(1000);
        springFromBelowServer.toValue = @(buttonToValue);
        springFromBelowServer.springSpeed = 7.0;
        
        
        [self.buttonServer.layer pop_addAnimation:springFromBelowServer forKey:@"springFromBelowServer"];
        
        [self.buttonServer pop_addAnimation:alphaSpring forKey:@"alphaSpringServer"];
        
        
        //  Change color of server button
        
        [self.buttonServer setTitleColor:btnTimelineTextColor forState:UIControlStateNormal];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
