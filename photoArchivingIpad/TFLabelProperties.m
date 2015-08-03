//
//  TFLabelProperties.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFLabelProperties.h"
#import "TFVisualConstants.h"

@interface TFLabelProperties ()

@property (nonatomic, strong)   UIFont *font_backing_store;
@property (nonatomic, strong) NSNumber *textAlignment_num;
@property (nonatomic, strong) NSNumber *fontSize_num;


@end



@implementation TFLabelProperties

#pragma mark - Methods
-(void)TFSetFontWithFamily:(NSString *)t_family size:(CGFloat)t_size
{
    self.fontSize = t_size;
    self.fontFamily = t_family;
}
#pragma mark - Getters

-(NSString *)text
{
    if (!_text) {
        _text = [TFDefaults TFDefaultText];
    }
    
    return _text;
}
-(NSString *)fontFamily
{
    if (!_fontFamily) {
        _fontFamily = [TFDefaults TFDefaultFontFamily];
    }
    
    return _fontFamily;
}
-(CGFloat)fontSize
{
    return [self.fontSize_num floatValue];
}
-(NSNumber *)fontSize_num
{
    if (!_fontSize_num) {
        _fontSize_num = [NSNumber numberWithFloat:[TFDefaults TFDefaultFontSize]];
    }
    
    return _fontSize_num;
}
-(NSTextAlignment)textAlignment
{
    return (NSTextAlignment)[self.textAlignment_num integerValue];
}
-(NSNumber *)textAlignment_num
{
    if (!_textAlignment_num) {
        _textAlignment_num = [NSNumber numberWithInteger:(NSTextAlignment)[TFDefaults TFDefaultTextAlignment]];
    }
    
    return _textAlignment_num;
}
-(UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [TFDefaults TFDefaultTextColor];
    }
    
    return _textColor;
}
-(UIFont *)font
{
    return [UIFont fontWithName:self.fontFamily size:self.fontSize];
}
#pragma mark - Setters
-(void)setFontSize:(CGFloat)fontSize
{
    self.fontSize_num = [NSNumber numberWithFloat:fontSize];
}
-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.textAlignment_num = [NSNumber numberWithInteger:(NSTextAlignment)textAlignment];
}
@end


@implementation UILabel (TFLabelPropertiesConfigurator)

-(void)TFConfigureLabelWithProperties:(TFLabelProperties *)t_properties
{
    self.backgroundColor = t_properties.backgroundColor;
    self.layer.cornerRadius = t_properties.cornerRadius;
    self.layer.borderWidth = t_properties.borderWidth;
    self.layer.borderColor = t_properties.borderColor.CGColor;
    self.alpha = t_properties.alphaValue;
    
    self.font = t_properties.font;
    self.textColor = t_properties.textColor;
    self.textAlignment = t_properties.textAlignment;
    self.text = t_properties.text;
}

@end

@implementation UILabel (Helpers)

-(void)TFSetTextWithNumber:(NSNumber *)t_num
{
    self.text = [t_num stringValue];
}

@end
