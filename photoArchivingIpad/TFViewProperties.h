//
//  TFViewProperties.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFViewProperties : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat alphaValue;

@property (nonatomic, assign) CGRect frame;

@property (nonatomic, assign) BOOL useTransparentBackground;

@property (nonatomic, assign) UIBlurEffectStyle blurStyle;

-(void)setSquareFrameWithValue:(CGFloat)    t_value;

@end

@interface UIView (TFViewPropertiesConfigurator)

-(void)TFConfigureViewWithProperties:(TFViewProperties*) t_properties;

@end