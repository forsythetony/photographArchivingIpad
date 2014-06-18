//
//  UIColor+testingColors.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "UIColor+testingColors.h"

@implementation UIColor (testingColors)

+(instancetype)testTitleBackground
{
    return [[self class] yellowColor];
}

+ (instancetype) testTitleText
{
    return [[self class] blackColor];
}

+ (instancetype) testInfoBackgroundOne
{
    return [[self class] orangeColor];
}

+ (instancetype) testInfoTextOne
{
    return [[self class] blackColor];
}

+ (instancetype) testInfoBackgroundTwo
{
    return [[self class] purpleColor];
}

+ (instancetype) testInfoTextTwo
{
    return [[self class] whiteColor];
}
+ (instancetype) testMainBackground
{
    return [[self class] blueColor];
}

@end
