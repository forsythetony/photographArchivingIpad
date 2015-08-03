//
//  TFCounterView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFCounterView.h"
#import "TFProperties.h"
#import <Masonry/Masonry.h>


@interface TFCounterView () {
    
    UILabel *lbl_value;
    UILabel *lbl_title;
    
    TFLabelProperties *lbl_value_props;
    TFLabelProperties *lbl_title_props;
}

@end

@implementation TFCounterView
@synthesize currentValue = _currentValue;

-(instancetype)initWithHeight:(CGFloat)t_height
{
    CGRect  frame = CGRectMake(0.0, 0.0, t_height, t_height);
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        [self setupViews];
    }
    
    return self;
}
-(void)setupViews
{
    [self setupLook];
    
    lbl_value = [[UILabel alloc] initWithFrame:lbl_value_props.frame];
    [lbl_value TFConfigureLabelWithProperties:lbl_value_props];
    
    [self addSubview:lbl_value];
    
    
    lbl_title = [[UILabel alloc] initWithFrame:lbl_title_props.frame];
    [lbl_title TFConfigureLabelWithProperties:lbl_title_props];
    
    [self addSubview:lbl_title];
    
    
    [lbl_value mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(lbl_value_props.frame.size.height);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lbl_value.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
-(void)setupLook
{
    lbl_value_props.fontSize = 25.0;
    
    CGFloat lbl_value_height_mod = 0.8;
    CGFloat lbl_value_height = self.frame.size.height * lbl_value_height_mod;
    CGFloat lbl_value_width = self.frame.size.width;
    
    lbl_value_props.frame = CGRectMake(0.0, 0.0, lbl_value_width, lbl_value_height);
    
    
    
    lbl_title_props.fontSize = 11.0;
    
    CGFloat lbl_title_height = self.frame.size.height - lbl_value_height;
    CGFloat lbl_title_width = self.frame.size.width;
    
    lbl_title_props.frame = CGRectMake(0.0, 0.0, lbl_title_width, lbl_title_height);
}
-(NSNumber *)currentValue
{
    if (!_currentValue) {
        _currentValue = @(0);
    }
    
    return _currentValue;
}
-(void)setCurrentValue:(NSNumber *)currentValue
{
    _currentValue = currentValue;
    
    if (lbl_value) {
        [lbl_value TFSetTextWithNumber:currentValue];
    }
}
@end
