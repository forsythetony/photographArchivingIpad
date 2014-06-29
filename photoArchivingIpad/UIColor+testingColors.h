//
//  UIColor+testingColors.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "attributesDictionaryConstants.h"
#import <Colours.h>

typedef NS_ENUM(NSInteger, tstColorType) {
    tstColorTypeTitleBackground,
    tstColorTypeTitleText,
    tstColorTypeInfoBackground1,
    tstColorTypeInfoText1,
    tstColorTypeInfoBackground2,
    tstColorTypeInfoText2,
};
@interface UIColor (testingColors)

+ (instancetype) testTitleBackground;
+ (instancetype) testTitleText;
+ (instancetype) testInfoBackgroundOne;
+ (instancetype) testInfoTextOne;
+ (instancetype) testInfoBackgroundTwo;
+ (instancetype) testInfoTextTwo;
+ (instancetype) testMainBackground;
@end
