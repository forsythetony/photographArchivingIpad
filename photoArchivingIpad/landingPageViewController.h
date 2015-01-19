//
//  landingPageViewController.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "updatedConstants.h"
#import "NSMutableDictionary+attributesDictionary.h"
#import <Colours.h>
#import <pop/POP.h>
#import "updatedConstants.h"

#define segueTimeline @"segue_timeline"
#define segueUploader @"segue_uploader"

typedef NS_ENUM(NSInteger, testingSegueType) {
    testingSegueTypeTimeline,
    testingSegueTypeUploader,
    testingSegueTypeNone
};

@interface landingPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *buttonTimeline;
@property (weak, nonatomic) IBOutlet UIButton *buttonServer;
@property (weak, nonatomic) IBOutlet UIButton *buttonUploading;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
@property (nonatomic, assign) testingSegueType testType;
@property (weak, nonatomic) IBOutlet UIView *menuViewContainer;

@end
