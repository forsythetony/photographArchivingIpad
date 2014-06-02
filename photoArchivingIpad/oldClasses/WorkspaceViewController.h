//
//  WorkspaceViewController.h
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dummyDataProvider.h"
#import <pop/POP.h>
#import <Colours.h>
#import "NSDate+timelineStuff.h"
#import "timelineManager.h"
#import <CRToast.h>

typedef NS_ENUM(NSInteger, labelRotationType) {
    labelRotationTypeLeft,
    labelRotationTypeRight,
    labelRotationTypeNone
};

@interface WorkspaceViewController : UIViewController <UIGestureRecognizerDelegate, timelineManagerDelegate>

@property (strong, nonatomic) NSDictionary* rangeInformation;


@end
