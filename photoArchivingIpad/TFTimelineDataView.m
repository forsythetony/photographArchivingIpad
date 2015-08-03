//
//  TFTimelineDataView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFTimelineDataView.h"
#import <Masonry/Masonry.h>
#import "NSDate+timelineStuff.h"
#import "TFVisualConstants.h"
#import <Colours/Colours.h>
#import <POP.h>

static CGFloat const    VIEW_HEIGHT = 100.0;
static CGFloat const    VIEW_WIDTH = 200.0;
static CGFloat const    VIEW_WIDTH_LARGE = 300.0;
static CGFloat const    FONT_SIZE_MONTH = 18.0;
static CGFloat const    FONT_SIZE_YEAR   = 25.0;

static CGFloat const    DEFAULT_MAIN_LINE_SIZE_FACTOR = 0.3;

@interface TFTimelineDataView () {
    UILabel *mainLabel;
    
    UIView  *mainLine;
}

@property (nonatomic, strong) NSString  *dateText;
@property (nonatomic, assign) CGFloat   mainWidth;
@property (nonatomic, strong) UIFont    *mainFont;
@property (nonatomic, strong) UIColor   *fontColor;
@property (nonatomic, assign) CGFloat   mainFontSize;
@property (nonatomic, strong) UIColor   *mainFontColor;
@property (nonatomic, strong) NSNumber   *mainLineSizeFactor_num;
@property (nonatomic, assign) CGFloat   mainLineSizeFactor;
@property (nonatomic, strong) UIColor   *mainLineColor;
@property (nonatomic, assign) CGFloat   mainLabelTextHeight;

@end
@implementation TFTimelineDataView

-(instancetype)initWithFrame:(CGRect)t_frame date:(TFTimelineDate *)t_date
{
    if (self = [super initWithFrame:t_frame]) {
        
        
        _date = t_date;
        
        t_frame.size.width = self.mainWidth;
        self.shouldShow = YES;
        t_frame.size.height = VIEW_HEIGHT;
        
        self.frame = t_frame;
        
        [self setupViews];
    }
    
    
    return self;
}
-(void)setupViews
{
    mainLabel = [[UILabel alloc] initWithFrame:self.bounds];
    
    mainLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:mainLabel];
    
    mainLabel.text = self.dateText;
    mainLabel.font = self.mainFont;
    mainLabel.textColor = self.mainFontColor;
//    mainLabel.backgroundColor = [UIColor purpleColor];
    
    [mainLabel sizeToFit];
    
    
    mainLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width * self.mainLineSizeFactor, 1.0)];
    mainLine.backgroundColor = self.mainLineColor;
    mainLine.alpha = 1.0;
    
    [self addSubview:mainLine];
    
    
    
    [mainLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainLabel.mas_right).with.offset(3.0);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(mainLine.frame.size.width * self.mainLineSizeFactor);
        make.height.mas_equalTo(1.0);
    }];
    
    [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat height = self.mainLabelTextHeight;
        CGFloat leftPad = 10.0;
        CGFloat rightPad = 0.0;
        
        make.centerY.equalTo(self);
        make.height.mas_equalTo(height);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.lessThanOrEqualTo(self).with.offset(-rightPad);
    }];
}
-(NSString *)dateText
{
    if (_date) {
        if (_date.dateType == TFTimelineDateTypeYear) {
            return [_date.date displayDateOfType:sDateTypeYearOnly];
        }
        else
        {
            return [_date.date displayDateOfType:sDateTypeMonthAbbreviation];
        }
        
    }
    else
    {
        return @"n/a";
    }
}
-(CGFloat)mainWidth
{
    if (!_date) {
        return VIEW_WIDTH;
    }
    else
    {
        if (_date.dateType == TFTimelineDateTypeYear) {
            return VIEW_WIDTH_LARGE;
        }
        else
        {
            return VIEW_WIDTH;
        }
    }
}
-(CGFloat)mainFontSize
{
    if (_date && _date.dateType == TFTimelineDateTypeYear) {
        return FONT_SIZE_YEAR;
    }
    else
    {
        return FONT_SIZE_MONTH;
    }
}
-(UIFont *)mainFont
{
    return [UIFont fontWithName:[TFVisualConstants TFFontFamilyOne] size:self.mainFontSize];
}
-(UIColor *)mainFontColor
{
    if (!_date && _date.dateType == TFTimelineDateTypeMonth) {
        return [UIColor black75PercentColor];
    }
    else
    {
        return [UIColor black75PercentColor];
    }
}
-(CGFloat)mainLineSizeFactor
{
    return [self.mainLineSizeFactor_num floatValue];
}
-(NSNumber *)mainLineSizeFactor_num
{
    if (!_mainLineSizeFactor_num) {
        _mainLineSizeFactor_num = [NSNumber numberWithFloat:DEFAULT_MAIN_LINE_SIZE_FACTOR];
    }
    
    return _mainLineSizeFactor_num;
}
-(UIColor *)mainLineColor
{
    return [UIColor black75PercentColor];
}
-(CGFloat)mainLabelTextHeight
{
    return 50.0;
}
-(void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: pointA];
    [linePath addLineToPoint:pointB];
    line.path=linePath.CGPath;
    line.fillColor = nil;
    line.opacity = 1.0;
    line.strokeColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:line];
}
-(CAShapeLayer*)drawLineLayer
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setLineWidth:3.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
      [NSNumber numberWithInt:5],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10, 10);
    CGPathAddLineToPoint(path, NULL, 100,100);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    return shapeLayer;
}
-(void)animate
{
    POPSpringAnimation *widthAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleX];
    POPSpringAnimation *alphaAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    alphaAni.toValue = @(1.0);
    alphaAni.fromValue = @(0.0);
    
    widthAni.fromValue = @(0.0);
    widthAni.toValue = @(1.0);
    
    [mainLine pop_addAnimation:alphaAni forKey:@"alphaAni"];
    [mainLine.layer pop_addAnimation:widthAni forKey:@"widthAni"];
}
@end
