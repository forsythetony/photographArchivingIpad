//
//  TFTimelineView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFTimelineView.h"
#import <Masonry/Masonry.h>
#import "TFTimelineDataView.h"
#import "NSDate+timelineStuff.h"
#import "TFVisualConstants.h"
#import <POP.h>

@interface TFTimelineView () <PictureFrameDelegate> {
    NSUInteger currentIndex;
    NSUInteger totalCount;
    
    NSTimer *aniTimer;
    
    POPSpringAnimation *alphaAni, *transAni;
    
    TFTimelineDataView *prevDataView;
    
    CGFloat firstX, firstY;
    
    pictureFrame *grabbedFrame;
    
    CGPoint transPoint;
}

@property (nonatomic, strong) UIColor           *mainBackgroundColor;
@property (nonatomic, assign) CGFloat           mainInterdateSpacing;
@property (nonatomic, strong) UIScrollView      *timelineScrollView;
@property (nonatomic, strong) NSMutableArray    *dateViews;
@property (nonatomic, strong) NSMutableArray    *dates;
@property (nonatomic, strong) NSDate            *usedStart;
@property (nonatomic, strong) NSDate            *usedEnd;
@property (nonatomic, assign) CGFloat           viewSpan;
@property (nonatomic, assign) CGFloat           duration;
@property (nonatomic, strong) NSMutableArray    *pictureFrames;

@end

static CGFloat  const   VERTICAL_PADDING = 30.0;

@implementation TFTimelineView
@synthesize timelineScrollView;


-(id)initWithFrame:(CGRect)t_frame datasource:(id<TFTimelineViewDataSource>)t_datasource
{
    if (self = [super initWithFrame:t_frame]) {
        self.dataSource = t_datasource;
        
        [self setupViews];
    }
    
    return self;
}
-(void)setupViews
{
    timelineScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    [self addSubview:timelineScrollView];
    
    timelineScrollView.backgroundColor = [self.dataSource TFTimelineBackgroundColor];
    
    
    
    [self setupScrollView];
    
    
    //  Constraints
    
    [timelineScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(self).with.offset(topPad);
        make.bottom.equalTo(self).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
    
}
-(void)setupScrollView
{
    [self populateScrollViews];
    
}
-(void)populateScrollViews
{
    if ([self.dataSource TFTimelineNumberOfImages] > 0 ) {
        CGSize  scrollViewContentSize = CGSizeMake([self.dataSource TFTimelineWidth], 0.0);
        
        NSDate  *startDate = [self.dataSource TFTimelineStartDate];
        
        NSDate  *endDate = [self.dataSource TFTimelineEndDate];
        
        NSDate *usedStartDate = [startDate nearestBeforeYear];
        NSDate *usedEndDate = [endDate nearestNextYear];
        
        sDateType dType = sDateTypeSimple;
        
        NSString *logString = [NSString stringWithFormat:@"\n\nStart:\t%@\nEnd:\t%@\nUsedStart:\t%@\nUsedEnd:\t%@\n\n", [startDate displayDateOfType:dType], [endDate displayDateOfType:dType], [usedStartDate displayDateOfType:dType], [usedEndDate displayDateOfType:dType]];
        
        NSLog(@"%@", logString);
        
        NSArray *datesArray = [NSDate getAllMonthDatesBetweenStart:self.usedStart finish:self.usedEnd];
        
        CGFloat y_cursor = VERTICAL_PADDING;
        CGFloat y_inc = [self.dataSource TFTimelineInterdateSpacing];
        
        NSUInteger  datesCount = [datesArray count];
        NSUInteger  index = 0;
        
        datesArray = [datesArray insertObjectAtFirstPos:self.usedStart];
        
        for (NSDate *date in datesArray) {
            
            TFTimelineDate *tfDate = [TFTimelineDate new];
            
            tfDate.date = date;
            tfDate.y_center = [self yCenterForDateInScrollView:date];
            
            if (date == startDate || date == endDate) {
                tfDate.isBackground = NO;
            }
            
            [self.dates addObject:tfDate];
            
            if (index == datesCount - 1) {
                
                
                y_cursor += VERTICAL_PADDING;
            }
            else
            {
                y_cursor += y_inc;
            }
            
            index++;
            
        }
        scrollViewContentSize.height = [self.dataSource TFTimelineHeight];
        
        [timelineScrollView setContentSize:scrollViewContentSize];
        
        
        for (TFTimelineDate *timelineDate in self.dates) {
            
            TFTimelineDataView *dateView = [[TFTimelineDataView alloc] initWithFrame:CGRectZero date:timelineDate];
            dateView.shouldShow = YES;
            
            switch ([self.dataSource TFTimelineMonthDisplayType]) {

                    case TFTimelineMonthDisplayTypeHalf:
                {
                    if (dateView.date.dateType == TFTimelineDateTypeMonth) {
                        if (![dateView.date.date isOddMonth]) {
                            dateView.shouldShow = NO;
                        }
                    }
                }
                    break;
                    
                    case TFTimelineMonthDisplayTypeNone:
                {
                    if (dateView.date.dateType == TFTimelineDateTypeMonth) {
                        dateView.shouldShow = NO;
                    }
                }
                    break;
                case TFTimelineMonthDisplayTypeAll:
                default:
                    break;
            }
            dateView.alpha = 0.0;
            
            [timelineScrollView addSubview:dateView];
            
            
            
            CGRect rect = dateView.frame;
            
            
            dateView.center = CGPointMake(dateView.frame.size.width / 2.0, dateView.date.y_center);
            
            rect = dateView.frame;
            
            NSLog(@"\n\n%@:\t%@\nCenter:\t%@\n\n", [dateView.date.date displayDateOfType:sDateTypeSimple], NSStringFromCGRect(dateView.frame), NSStringFromCGPoint(dateView.center));
            [self.dateViews addObject:dateView];
        }
        
        
        
        
        
        
        
        
        for (NSInteger i = 0; i < [self.dataSource TFTimelineNumberOfImages]; i++) {
            
            pictureFrame *frame = [self.dataSource TFTimelinePictureFrameForObjectAtIndex:i];
            frame.delegate = self;
            
            UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            
            [frame addGestureRecognizer:panner];
            
            
            CGPoint newCenter = [self pointForDate:frame.imageObject.date];
            
            
            [timelineScrollView addSubview:frame];
            
            [frame setCenter:newCenter];
            
            [self.pictureFrames addObject:frame];
            
        }
    }
    
}
-(void)handlePan:(UIPanGestureRecognizer*) t_sender
{
    
    id sender_view = [t_sender view];
    
    pictureFrame *frame;
    
    if ([sender_view isKindOfClass:[pictureFrame class]]) {
        
        frame = (pictureFrame*)sender_view;
        
        [timelineScrollView bringSubviewToFront:frame];
        
        CGPoint translatedPoint = [t_sender translationInView:timelineScrollView];
        
        if (t_sender.state == UIGestureRecognizerStateBegan)
        {
            firstX = [[t_sender view] center].x;
            firstY = [[t_sender view] center].y;
            
            grabbedFrame = frame;
            
        }
        
        translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
        
        
        transPoint = translatedPoint;
        
        [frame setCenter:translatedPoint];
        
        
        
        
        if (t_sender.state == UIGestureRecognizerStateEnded)
        {
            CGFloat velocityX   = (([(UIPanGestureRecognizer*)t_sender velocityInView:timelineScrollView].x) / 1);
            
            CGFloat finalX      = translatedPoint.x;
            CGFloat finalY      = translatedPoint.y;
            
            if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
                
                if (finalX < 0) {
                    
                    //finalX = 0;
                    
                } else if (finalX > 768) {
                    
                    //finalX = 768;
                }
                
                if (finalY < 0) {
                    
                    finalY = 0;
                    
                } else if (finalY > 1024) {
                    
                    finalY = 1024;
                }
                
            } else {
                
                if (finalX < 0) {
                    
                    //finalX = 0;
                    
                } else if (finalX > 1024) {
                    
                    //finalX = 768;
                }
                
                if (finalY < 0) {
                    
                    finalY = 0;
                    
                } else if (finalY > 768) {
                    
                    finalY = 1024;
                }
            }
            
            
            
            CGFloat animationDuration = (ABS(velocityX) * .0002) + .2;
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [frame setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
            
        }
    }
    
}
-(void)updateFrame:(pictureFrame*) t_frame
{
    
    
}
-(void)resetTimeline
{
    if (self.dateViews.count > 0) {
        for (TFTimelineDataView *view in self.dateViews) {
            [view removeFromSuperview];
        }
    }
    
    if (self.pictureFrames.count > 0) {
        for (pictureFrame *frame in self.pictureFrames) {
            [frame removeFromSuperview];
        }
    }
    
    [self.pictureFrames removeAllObjects];
    [self.dateViews removeAllObjects];
    [self.dates removeAllObjects];
}
-(void)reloadData
{
    [self resetTimeline];
    
    [self populateScrollViews];
    
}
-(NSMutableArray *)dateViews
{
    if (!_dateViews) {
        _dateViews = [NSMutableArray new];
    }
    
    return _dateViews;
}
-(NSMutableArray *)dates
{
    if (!_dates) {
        _dates = [NSMutableArray new];
    }
    
    return _dates;
}
-(CGPoint)pointForDate:(NSDate*)    t_date
{
    CGPoint point = CGPointZero;
    
    point.y = [self yCenterForDateInScrollView:t_date];
    point.x = [self xRandom];
    
    return point;
}
-(CGFloat)xRandom
{
    CGFloat horizPadMod = 0.4;
    
    CGFloat horizontalPad = self.frame.size.width * horizPadMod;
    
    int leftBound = 140.0;
    int rightBound = (int)(self.frame.size.width - horizontalPad);
    
    int randX = arc4random_uniform(rightBound) + leftBound;
    
    return (CGFloat)randX;
}
-(CGFloat)yCenterForDateInScrollView:(NSDate*) t_date;
{
    double duration = self.duration;
    double viewSpan = self.viewSpan;
    
    
    double mod = viewSpan / duration;
    
    return ([t_date timeIntervalSinceDate:self.usedStart] * mod) + VERTICAL_PADDING;
}
-(NSDate *)usedEnd
{
    return [[self.dataSource TFTimelineEndDate] nearestNextYear];
}
-(NSDate *)usedStart
{
    return [[self.dataSource TFTimelineStartDate] nearestBeforeYear];
}
-(CGFloat)viewSpan
{
    return [self.dataSource TFTimelineHeight] - (VERTICAL_PADDING * 2.0);
}
-(CGFloat)duration
{
    return [self.usedEnd timeIntervalSinceDate:self.usedStart];
}
-(NSMutableArray *)pictureFrames
{
    if (!_pictureFrames) {
        _pictureFrames = [NSMutableArray new];
    }
    
    return _pictureFrames;
}
-(void)handlePictureFrameTap:(UITapGestureRecognizer*)  t_sender
{
    id sender_view = [t_sender view];
    
    if ([sender_view isKindOfClass:[pictureFrame class]]) {
        
        [self.dataSource TFTimelineDidTapPictureFrame:(pictureFrame*)sender_view];
        
    }    
}
-(void)animateAll
{
    
    alphaAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    transAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    
    alphaAni.fromValue = @(0.0);
    alphaAni.toValue = @(1.0);
    
    transAni.fromValue = @(-100);
    transAni.toValue = @(0.0);
    
    transAni.springSpeed = 18.0;
    transAni.springBounciness = 15.0;
    
    for (TFTimelineDataView *view in self.dateViews) {
        if (view.shouldShow) {
            [view pop_addAnimation:alphaAni forKey:@"alpha"];
            [view.layer pop_addAnimation:transAni forKey:@"trans"];
        }
        
    }
    

    
}
-(void)fireAniTimer:(NSTimer*)  t_sender
{
    
}
-(BOOL)isViewVisibleInTimeline:(TFTimelineDataView*) t_view
{
    CGRect  viewRect = t_view.frame;
    
    CGRect  timelineFrame = timelineScrollView.frame;
    
    BOOL intersect = CGRectIntersectsRect(viewRect, timelineFrame);
    
    return intersect;
    
    
}
-(void)PictureFrameDidTap:(pictureFrame *)t_frame
{
    [timelineScrollView bringSubviewToFront:t_frame];
    
    [self.dataSource TFTimelineDidTapPictureFrame:t_frame];
}
@end
