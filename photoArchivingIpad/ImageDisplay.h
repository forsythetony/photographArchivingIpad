//
//  ImageDisplay.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageInformationForm/imageObject.h>
#import "ImageDispaySubviews.h"

@interface ImageDisplay : UIViewController

@property (nonatomic, strong) imageObject* imageInformation;
@property (weak, nonatomic) IBOutlet UIView *imageDisplaySliderCont;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *storyCreationContainer;
@property (weak, nonatomic) IBOutlet UIView *largeImageDisplayContainer;

@end
