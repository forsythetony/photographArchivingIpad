//
//  TFVisualConstants.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/8/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (TFColors)

+(instancetype)TFFieldTextEnabled;
+(instancetype)TFFieldTextDisabled;

//  Textures
+(instancetype)TFPaperTextureOne;
+(instancetype)TFCarbonTextureOne;

@end


@interface TFDefaults : NSObject

//  Fonts
+ (NSString*)TFDefaultFontFamily;

//  Basic View Properties
+(CGFloat)TFDefaultBorderWidth;
+(CGFloat)TFDefaultCornerRadius;
+(CGFloat)TFDefaultAlphaValue;

+(UIColor*)TFDefaultBackgroundColor;
+(UIColor*)TFDefaultBorderColor;
+(UIColor*)TFDefaultTextColor;

+(NSTextAlignment)TFDefaultTextAlignment;
+(CGFloat)TFDefaultFontSize;

+(NSString*)TFDefaultPlaceholderText;
+(NSString*)TFDefaultText;

+(UIBlurEffectStyle)TFDefaultBlurStyle;
@end

@interface TFVisualConstants : NSObject

//  Fonts
+(NSString*)TFFontFamilyOne;
+(NSString*)TFFontFamilyOneBold;
+(NSString*)TFFontFamilyOneMedium;

@end

