//
//  WorkspaceViewController.h
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "dummyDataProvider.h"
#import "timelineManager.h"
#import "workspaceAuxView.h"
#import "TFDataCommunicator.h"
#import "timelineLabelView.h"

#import "pagerInformationVC.h"
#import "pagerSocialVC.h"
#import "imageInfoPagerVC.h"

#import "imageHandling.h"
@class imageInfoPagerVC;

typedef NS_ENUM(NSInteger, labelRotationType) {
    
    labelRotationTypeLeft,
    labelRotationTypeRight,
    labelRotationTypeNone
    
};

typedef NS_ENUM(NSInteger, buttonIconType) {
    buttonIconTypeStory,
    buttonIconTypeRecording,
    buttonIconTypeOther
};

@interface WorkspaceViewController : UIViewController < UIGestureRecognizerDelegate, timelineManagerDelegate, TFCommunicatorDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate >

@property (strong, nonatomic) NSDictionary* rangeInformation;

@property (strong, nonatomic) imageInfoPagerVC* infPager;

@property (strong, nonatomic) UIImageView*  displayedImage;
@property (strong, nonatomic) imageObject* displayImageInformation;
@property (strong, nonatomic) UITextView* imageInfoDisplay;

@property (strong, nonatomic) UIButton* addStoryButton;
@property (strong, nonatomic) UIButton* addRecording;
@property (strong, nonatomic) UIButton* addOtherInfo;

@property (strong, nonatomic) UIPageViewController* infoPager;

@end
