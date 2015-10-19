//
//  TFPopOverPageViewController.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 8/3/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFStoryCreationViewController.h"
#import "TFImageInformationViewController.h"
#import "imageObject.h"

@interface TFPopOverPageViewController : UIPageViewController

@property (nonatomic, strong) imageObject *image;

@end
