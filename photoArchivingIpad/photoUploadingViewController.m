//
//  photoUploadingViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "photoUploadingViewController.h"

@interface photoUploadingViewController () {

    NSDictionary *imageTakerStyle, *imageInfoStyle;
    PhotoUploadManager *uploadingManager;
}

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
#pragma mark Custom
-(void)initialConfiguration {

//  Set up containers
    
    _imageTakerContainer.backgroundColor = imageTakerStyle[keyContainerBackgroundColor];
    _imageInformationContainer.backgroundColor = imageInfoStyle[keyContainerBackgroundColor];
    
    
}
-(void)variableSetup {
    
//  Container style setup

    UIColor *takerContainerBackground, *informationContainerBackground;
    
    takerContainerBackground = [UIColor yellowColor];
    informationContainerBackground = [UIColor clearColor];
    

//  Set Dictionaries
    
    imageTakerStyle = @{keyContainerBackgroundColor: takerContainerBackground};
    imageInfoStyle  = @{keyContainerBackgroundColor: informationContainerBackground};
    
}
@end
