//
//  imageInfoPagerVC.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ImageInformationForm/ImageObject.h>
#import "WorkspaceViewController.h"
#import "pageViewControllers.h"
#import "StoriesDisplayTable.h"



@interface imageInfoPagerVC : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) imageObject* imageInformation;

-(void)updateImageInformation:(imageObject*) theImage;

@end
