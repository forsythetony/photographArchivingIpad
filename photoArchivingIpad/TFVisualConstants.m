//
//  TFVisualConstants.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/8/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFVisualConstants.h"
#import "UIColor+testingColors.h"

@implementation UIColor (TFColors)

+(instancetype)TFFieldTextDisabled
{
    CGFloat white = 0.2;
    CGFloat alpha = 0.3;
    
    return [UIColor colorWithWhite:white alpha:alpha];
}
+(instancetype)TFFieldTextEnabled
{
    CGFloat white = 0.2;
    CGFloat alpha = 0.8;
    
    return [UIColor colorWithWhite:white alpha:alpha];
}

+(instancetype)TFPaperTextureOne
{
    NSString *imagePath = @"paper.png";
    
    return [UIColor colorWithPatternImage:[UIImage imageNamed:imagePath]];
}
@end

@implementation TFVisualConstants

+(NSString *)TFFontFamilyOne
{
    NSString *fontFamily = @"Avenir";
    
    return fontFamily;
}
@end
