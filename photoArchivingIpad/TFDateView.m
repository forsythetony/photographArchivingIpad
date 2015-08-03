//
//  TFDateView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFDateView.h"
#import "TFProperties.h"
#import <Masonry/Masonry.h>
#import "NSDate+timelineStuff.h"
#import "TFVisualConstants.h"
#import <FAKFoundationIcons.h>

@interface TFDateView () {
    
    UILabel *lbl_year, *lbl_day, *lbl_month;
    TFLabelProperties *lbl_year_props, *lbl_day_props, *lbl_month_props;
    
    UIImageView *imgView_cal;
    
}

@end
@implementation TFDateView
@synthesize date = _date;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        [self setupViews];
        
    }
    
    return self;
}
-(void)setupLooks
{
    CGFloat    mod_year_height = 0.4;
    CGFloat     height_year = self.frame.size.height * mod_year_height;
    CGFloat     width_all = self.frame.size.width;
    
    UIColor *textColor = [UIColor whiteColor];
    
    lbl_year_props = [TFLabelProperties new];
    lbl_year_props.frame = CGRectMake(0.0, 0.0, width_all, height_year);
    lbl_year_props.backgroundColor = [UIColor clearColor];
    lbl_year_props.fontSize = 25.0;
    lbl_year_props.fontFamily = [TFVisualConstants TFFontFamilyOneBold];
    lbl_year_props.textColor = textColor;
    
    CGFloat height_month_day = (self.frame.size.height - height_year) / 2.0;
    
    lbl_month_props = [TFLabelProperties new];
    
    lbl_month_props.frame = CGRectMake(0.0, 0.0, width_all, height_month_day);
    lbl_month_props.backgroundColor = [UIColor clearColor];
    lbl_month_props.fontSize = 15.0;
    lbl_month_props.fontFamily = [TFVisualConstants TFFontFamilyOneMedium];
    lbl_month_props.textColor = textColor;
    
    lbl_day_props = [TFLabelProperties new];
    
    lbl_day_props.frame = CGRectMake(0.0, 0.0, width_all, height_month_day);
    lbl_day_props.backgroundColor = [UIColor clearColor];
    lbl_day_props.fontSize = 15.0;
    lbl_day_props.fontFamily = [TFVisualConstants TFFontFamilyOneMedium];
    lbl_day_props.textColor = textColor;
}
-(void)setupViews
{
    [self setupLooks];
    
//    UIVisualEffectView *ev = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    
//    ev.frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];
//    [self addSubview:ev];
    
    
    
    
    lbl_day = [[UILabel alloc] initWithFrame:lbl_day_props.frame];
    [lbl_day TFConfigureLabelWithProperties:lbl_day_props];
    
    [self addSubview:lbl_day];
    
    
    
    
    lbl_year = [[UILabel alloc] initWithFrame:lbl_year_props.frame];
    [lbl_year TFConfigureLabelWithProperties:lbl_year_props];
    
    [self addSubview:lbl_year];
    
    
    
    lbl_month = [[UILabel alloc] initWithFrame:lbl_month_props.frame];
    [lbl_month TFConfigureLabelWithProperties:lbl_month_props];
    
    [self addSubview:lbl_month];
    
    [self setLabelsWithDate:self.date];
    
    UIImageView *imgView = [self getCalImageView];
    
    [self addSubview:imgView];
    
    [self sendSubviewToBack:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat topPad = 20.0;
        CGFloat bottomPad = 20.0;
        CGFloat leftPad = 20.0;
        CGFloat rightPad = 20.0;
        
        make.top.equalTo(self).with.offset(topPad);
        make.bottom.equalTo(self).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
    
    [lbl_day mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat topPad = 5.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(self).with.offset(topPad);
        make.bottom.equalTo(lbl_year.mas_top).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
    
    [lbl_year mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.centerY.equalTo(self);
        make.height.mas_equalTo(lbl_year_props.frame.size.height);
        make.bottom.equalTo(lbl_month.mas_top).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
    
    [lbl_month mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 5.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(lbl_year.mas_bottom).with.offset(topPad);
        make.bottom.equalTo(self).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
}
-(NSDate *)date
{
    if (!_date) {
        _date = [NSDate new];
    }
    
    return _date;
}
-(void)setDate:(NSDate *)date
{
    _date = date;
    
    [self setLabelsWithDate:date];
}
-(void)setLabelsWithDate:(NSDate*) t_date
{
    if (lbl_month) {
        lbl_month.text = [t_date displayDateOfType:sDateTypeMonthOnly];
    }
    
    if (lbl_year) {
        lbl_year.text = [t_date displayDateOfType:sDateTypeYearOnly];
    }
    
    if (lbl_day) {
        lbl_day.text = [t_date displayDateOfType:sDateTypeDayOnly];
    }
}
-(UIImageView*)getCalImageView
{
    FAKFoundationIcons *icon = [FAKFoundationIcons calendarIconWithSize:self.bounds.size.height];
    
    [icon setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.7 alpha:0.3]}];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[icon imageWithSize:self.bounds.size]];
    
    imgView.alpha = 0.4;
    
    return imgView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
