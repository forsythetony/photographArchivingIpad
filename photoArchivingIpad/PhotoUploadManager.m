//
//  PhotoUploadManager.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 7/17/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "PhotoUploadManager.h"

@implementation PhotoUploadManager

-(id)initWithInfoContainer:(UIView *)infoContainer andImageTakerContainer:(UIView *)takerContainer
{
    self = [super init];
    
    if (self) {
        /*
        [self addInfoFormToView:infoContainer];
        [self addImageTakerToView:takerContainer];
        */
    }
    
    return self;
}

#pragma mark Helper Functions - 
/*
-(void)addInfoFormToView:(UIView*) container
{
    _infoForm = [[InformationForm alloc] init];
    
    _infoForm.view.frame = container.bounds;
    
    [container addSubview:_infoForm.view];
    
    [_infoForm addTestCells];
    
}
*/
-(void)addImageTakerToView:(UIView*) container
{
    _imageTaker = [[ImageTakerViewController alloc] init];
    _imageTaker.view.frame = container.bounds;

    [container addSubview:_imageTaker.view];
}
@end
