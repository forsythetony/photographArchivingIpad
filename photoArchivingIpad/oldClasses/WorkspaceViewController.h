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

#import "imageHandling.h"


typedef NS_ENUM(NSInteger, labelRotationType) {
    
    labelRotationTypeLeft,
    labelRotationTypeRight,
    labelRotationTypeNone
    
};

@interface WorkspaceViewController : UIViewController < UIGestureRecognizerDelegate, timelineManagerDelegate, TFCommunicatorDelegate >

@property (strong, nonatomic) NSDictionary* rangeInformation;


@end
