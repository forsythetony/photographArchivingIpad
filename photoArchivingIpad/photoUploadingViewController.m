//
//  photoUploadingViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "photoUploadingViewController.h"

@interface photoUploadingViewController () {

    NSDictionary *imageTakerStyle, *imageInfoStyle, *imageTakerButtonsStyle;
    PhotoUploadManager *uploadingManager;
}

@property (nonatomic, strong) UIButton *takePictureButton;

@end

@implementation photoUploadingViewController

#pragma mark Initial Config -

#pragma mark System
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad
{
    [self variableSetup];
    [self initialConfiguration];
    
    
    uploadingManager = [[PhotoUploadManager alloc] initWithInfoContainer:_imageInformationContainer andImageTakerContainer:_imageTakerContainer];
    
    
    
}
#pragma mark Custom -

-(void)initialConfiguration {

//  Set up containers
    
    _imageTakerContainer.backgroundColor = imageTakerStyle[keyContainerBackgroundColor];
    _imageInformationContainer.backgroundColor = imageInfoStyle[keyContainerBackgroundColor];
    

//  Set up image taking container
    
    CGFloat buttonsContainerHeight = 40.0;
    
    CGRect buttonsContainerRect = CGRectMake(0.0, _imageTakerContainer.bounds.size.height - buttonsContainerHeight, _imageTakerContainer.bounds.size.width, buttonsContainerHeight);
    
    UIView *buttonsContainerView = [[UIView alloc] initWithFrame:buttonsContainerRect];
    

    //  Configure buttons container view
    
    buttonsContainerView.backgroundColor = [UIColor orangeColor];
    
    [_imageTakerContainer addSubview:buttonsContainerView];
    

//  Set up buttons
    
    CGFloat buttonWidth = 120.0;
    CGFloat buttonHeight = 30.0;
    
    CGFloat buttonOriginX = 0.0;//(_imageTakerContainer.bounds.size.width / 2.0) - (buttonWidth / 2.0);
    CGFloat buttonOriginY = 0.0;//(_imageTakerContainer.bounds.size.height / 2.0) - (buttonHeight / 2.0);
    
    CGRect captureImageButtonFrame = CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, buttonHeight);
    
    _takePictureButton = [[UIButton alloc] initWithFrame:captureImageButtonFrame];
    [_takePictureButton setTitle:@"Take Picture" forState:UIControlStateNormal];
    [_takePictureButton addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
    
    _takePictureButton.titleLabel.font = imageTakerButtonsStyle[keyFont];
    _takePictureButton.titleLabel.textColor = imageTakerButtonsStyle[keyTextColor];
    
//  Add buttons to container view
    
    [buttonsContainerView addSubview:_takePictureButton];
    
    
}
-(void)variableSetup {
    
//  Container style setup

    UIColor *takerContainerBackground, *informationContainerBackground;
    
    takerContainerBackground = [UIColor yellowColor];
    informationContainerBackground = [UIColor clearColor];
    
    CGFloat buttonFontSize = 20.0;
    NSString *buttonFontFamily = @"DINAlternate-Bold";
    
    
//  Set Dictionaries
    
    imageTakerStyle = @{keyContainerBackgroundColor: takerContainerBackground};
    imageInfoStyle  = @{keyContainerBackgroundColor: informationContainerBackground};
    imageTakerButtonsStyle = @{keyTextColor: [UIColor black50PercentColor],
                               keyFont: [UIFont fontWithName:buttonFontFamily size:buttonFontSize]};
    
}

#pragma Button Methods - 

- (void)captureImage:(id)sender
{
    NSLog(@"%@", @"I'm doing it!");
}

@end
