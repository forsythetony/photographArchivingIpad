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

@interface ImageDisplay () <ImageDisplayRecordingSliderViewDelegate, TFCommunicatorDelegate> {
    
    StoryCreationViewController *formController;
    LargeImageDisplayView *displayView;
    TFDataCommunicator *mainCom;
}


@end

@implementation ImageDisplay
@synthesize imageInformation;
@synthesize imageDisplaySliderCont, largeImageDisplayContainer;

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
    mainCom.delegate = self;
    
    
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", imageInformation.title);
    
    ImageDisplayRecordingSliderView *sliderView = [[ImageDisplayRecordingSliderView alloc] initWithFrame:imageDisplaySliderCont.bounds];
    sliderView.delegate = self;
    
    [imageDisplaySliderCont addSubview:sliderView];
    
    _testLabel.text = @"";

    StoryCreationViewController *form = [[StoryCreationViewController alloc] initWithNibName:@"AddStoryForm" bundle:[NSBundle mainBundle]];

    
    form.view.frame = CGRectMake(1000.0, 0.0, _storyCreationContainer.bounds.size.width, _storyCreationContainer.bounds.size.height);
    
    [_storyCreationContainer addSubview:form.view];
    [self addChildViewController:form];
    [form didMoveToParentViewController:self];
    
    

    displayView = [[LargeImageDisplayView alloc] initWithFrame:largeImageDisplayContainer.bounds];
    
    [largeImageDisplayContainer addSubview:displayView];
    [mainCom retrieveImageWithURL:[imageInformation.photoURL absoluteString]];
    
    
    
    formController = form;
    
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
    _testLabel.text = @"Recording";
    [self moveFormToView];
    
}
-(void)didUnlockSlider
{
    _testLabel.text = @"Stopped Recording";
}
-(void)finishedPullingImageFromUrl:(UIImage *)image
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [displayView setDisplayedImage:image];
    });
}


@end
