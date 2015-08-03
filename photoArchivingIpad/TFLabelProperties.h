//
//  TFLabelProperties.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFViewProperties.h"

@interface TFLabelProperties : TFViewProperties

@property (nonatomic, strong, readonly) UIFont *font;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;


-(void)TFSetFontWithFamily:(NSString*)  t_family
                      size:(CGFloat)    t_size;

@end

@interface UILabel (TFLabelPropertiesConfigurator)

-(void)TFConfigureLabelWithProperties:(TFLabelProperties*)  t_properties;

@end

@interface UILabel (Helpers)


-(void)TFSetTextWithNumber:(NSNumber*) t_num;
@end