//
//  TFViewProperties.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFViewProperties.h"
#import "TFVisualConstants.h"

@interface TFViewProperties ()

@property (nonatomic, strong) NSNumber  *alphaValue_num;
@property (nonatomic, strong) NSNumber  *borderWidth_num;
@property (nonatomic, strong) NSNumber  *cornderRadius_num;
@property (nonatomic, strong) NSValue   *frame_value;
@property (nonatomic, strong) NSNumber  *useTransBackground_num;
@property (nonatomic, strong) NSNumber  *blurStyle_num;

@end

static CGRect DEFAULTFRAME()
{
    CGRect default_val = CGRectMake(0.0, 0.0, 30.0, 30.0);
    
    return default_val;
}

static CGRect squareFrameWithVal(CGFloat val)
{
    return CGRectMake(0.0, 0.0, val, val);
}
@implementation TFViewProperties

#pragma mark - Methods
-(void)setSquareFrameWithValue:(CGFloat)t_value
{
    self.frame = squareFrameWithVal(t_value);
}
#pragma mark - Getters
-(CGRect)frame
{
    return [self.frame_value CGRectValue];
}
-(NSValue *)frame_value
{
    if (!_frame_value) {
        _frame_value = [NSValue valueWithCGRect:DEFAULTFRAME()];
    }
    
    return _frame_value;
}
-(CGFloat)alphaValue
{
    return [self.alphaValue_num floatValue];
}
-(NSNumber *)alphaValue_num
{
    if (!_alphaValue_num) {
        _alphaValue_num = [NSNumber numberWithFloat:[TFDefaults TFDefaultAlphaValue]];
    }
    
    return _alphaValue_num;
}
-(CGFloat)cornerRadius
{
    return [self.cornderRadius_num floatValue];
}
-(NSNumber *)cornderRadius_num
{
    if (!_cornderRadius_num) {
        _cornderRadius_num = [NSNumber numberWithFloat:[TFDefaults TFDefaultCornerRadius]];
    }
    
    return _cornderRadius_num;
}
-(CGFloat)borderWidth
{
    return [self.borderWidth_num floatValue];
}
-(NSNumber *)borderWidth_num
{
    if (!_borderWidth_num) {
        _borderWidth_num = [NSNumber numberWithFloat:[TFDefaults TFDefaultBorderWidth]];
    }
    
    return _borderWidth_num;
}
-(UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = [TFDefaults TFDefaultBackgroundColor];
    }
    
    return _backgroundColor;
}
-(UIColor *)borderColor
{
    if (!_borderColor) {
        _borderColor = [TFDefaults TFDefaultBorderColor];
    }
    
    return _borderColor;
}
-(BOOL)useTransparentBackground
{
    return [self.useTransBackground_num boolValue];
}
-(NSNumber *)useTransBackground_num
{
    if (!_useTransBackground_num) {
        _useTransBackground_num = [NSNumber numberWithBool:NO];
    }
    
    return _useTransBackground_num;
}
-(UIBlurEffectStyle)blurStyle
{
    return (UIBlurEffectStyle)[self.blurStyle_num integerValue];
}
-(NSNumber *)blurStyle_num
{
    if (!_blurStyle_num) {
        _blurStyle_num = [NSNumber numberWithInteger:(UIBlurEffectStyle)[TFDefaults TFDefaultBlurStyle]];
    }
    
    return _blurStyle_num;
}
#pragma mark - Setters
-(void)setBlurStyle:(UIBlurEffectStyle)blurStyle
{
    self.blurStyle_num = [NSNumber numberWithInteger:(UIBlurEffectStyle)blurStyle];
}
-(void)setUseTransparentBackground:(BOOL)useTransparentBackground
{
    self.useTransBackground_num = [NSNumber numberWithBool:useTransparentBackground];
}
-(void)setFrame:(CGRect)frame
{
    self.frame_value = [NSValue valueWithCGRect:frame];
}
-(void)setAlphaValue:(CGFloat)alphaValue
{
    self.alphaValue_num = [NSNumber numberWithFloat:alphaValue];
}
-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.borderWidth_num = [NSNumber numberWithFloat:borderWidth];
}
-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.cornderRadius_num = [NSNumber numberWithFloat:cornerRadius];
}
@end

@implementation UIView (TFViewPropertiesConfigurator)

-(void)TFConfigureViewWithProperties:(TFViewProperties *)t_properties
{
    self.backgroundColor = t_properties.backgroundColor;
    
    if (t_properties.useTransparentBackground) {
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:t_properties.blurStyle];
        UIVisualEffectView *ev = [[UIVisualEffectView alloc] initWithEffect:blur];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.contentMode = UIViewContentModeTopLeft;
        
        imgView.image = [UIImage imageNamed:@"CollageThing_light.jpg"];
        
        [self addSubview:imgView];
        self.clipsToBounds = YES;
        
        ev.frame = imgView.bounds;
        
        [imgView addSubview:ev];
    }
    
    
    
    
    self.layer.cornerRadius = t_properties.cornerRadius;
    self.layer.borderWidth = t_properties.borderWidth;
    self.layer.borderColor = t_properties.borderColor.CGColor;
    self.alpha = t_properties.alphaValue;
}

@end
