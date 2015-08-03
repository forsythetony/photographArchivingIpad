//
//  TFVisualConstants.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/8/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFVisualConstants.h"
#import "UIColor+testingColors.h"


static NSString* const DEFAULT_FONT_FAMILY = @"Avenir";

@implementation UIColor (TFColors)
+(instancetype)TFCarbonTextureOne
{
    return [UIColor charcoalColor];
}
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

@implementation TFDefaults

+(CGFloat)TFDefaultAlphaValue
{
    CGFloat default_val = 1.0;
    
    return default_val;
}
+(UIColor *)TFDefaultBackgroundColor
{
    UIColor *default_val = [UIColor clearColor];
    
    return default_val;
}
+(UIColor *)TFDefaultBorderColor
{
    UIColor *default_val = [UIColor blackColor];
    
    return default_val;
}
+(CGFloat)TFDefaultBorderWidth
{
    CGFloat default_val = 0.0;
    
    return default_val;
}
+(CGFloat)TFDefaultCornerRadius
{
    CGFloat default_val = 0.0;
    
    return default_val;
}
+(NSString *)TFDefaultFontFamily
{
    return DEFAULT_FONT_FAMILY;
}
+(UIColor *)TFDefaultTextColor
{
    UIColor *default_val = [UIColor black25PercentColor];
    
    return default_val;
}
+(CGFloat)TFDefaultFontSize
{
    CGFloat default_val = 13.0;
    
    return default_val;
}
+(NSTextAlignment)TFDefaultTextAlignment
{
    NSTextAlignment default_val = NSTextAlignmentCenter;
    
    return default_val;
}
+(NSString *)TFDefaultPlaceholderText
{
    NSString    *default_val = @"n/a";
    
    return default_val;
}
+(NSString *)TFDefaultText
{
    NSString    *default_val = @"";
    
    return default_val;
}
+(UIBlurEffectStyle)TFDefaultBlurStyle
{
    UIBlurEffectStyle default_val = UIBlurEffectStyleDark;
    
    return default_val;
}
@end
@implementation TFVisualConstants

+(NSString *)TFFontFamilyOne
{
    NSString *fontFamily = @"Avenir";
    
    return fontFamily;
}
+(NSString *)TFFontFamilyOneBold
{
    NSString *fontFamily = @"Avenir-Heavy";
    
    return fontFamily;

}
+(NSString *)TFFontFamilyOneMedium
{
    NSString *fontFamily = @"Avenir-Medium";
    
    return fontFamily;
}
@end
