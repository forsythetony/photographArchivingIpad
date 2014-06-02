//
//  timelineManager.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "timelineManager.h"

#define HORIZONTALMOD 8.0


@implementation timelineManager

-(NSNumber *)makeDuration
{
    NSNumber* duration;
    NSTimeInterval timeDuration;
    
    if (_startDate && _endDate) {
        timeDuration = [_startDate timeIntervalSinceDate:_endDate];
        duration = [NSNumber numberWithDouble:timeDuration];
    }
    return duration;
}
-(CGPoint)createPointWithDate:(NSDate *)date
{
    CGPoint centerPoint;
    
    NSTimeInterval pureDate = [date timeIntervalSinceBeginning];
    
    float specNumber = _viewSpan / _duration;
    
    centerPoint.y = _TLView.center.y - 100.0;
    
    centerPoint.x = _xOffset + ((pureDate - _pureStart) * specNumber) - HORIZONTALMOD;
    
    return centerPoint;
}
-(void)setStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate andView:(UIView *)tlview andXOffsert:(float)offset
{
    _startDate = startDate;
    _endDate = endDate;
    
    _pureStart = [_startDate timeIntervalSinceBeginning];
    _pureEnd = [_endDate timeIntervalSinceBeginning];
    
    _TLView = tlview;
    
    _duration = [endDate timeIntervalSinceDate:startDate];
    _viewSpan = tlview.frame.size.width - (offset * 2.0);
    _xOffset = offset;
    
}
-(void)setInitialPhotographs:(NSArray *)thePhotographs
{
    _theImages = thePhotographs;
    
    UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(_TLView.center.x, _TLView.center.y, 40.0, 40.0)];
    
    [testview setBackgroundColor:[UIColor yellowColor]];
    
    [_TLView addSubview:testview];
    
    
    
    for(pictureFrame* theFrame in _theImages)
    {
        imageObject *img = theFrame.imageObject;
        
        CGPoint theCenter = [self createPointWithDate:[img date]];
        
        [theFrame setCenter:theCenter];
        [_TLView addSubview:theFrame];
        
        
    }
}
-(void)updateDateForPicture:(pictureFrame *)picture
{
    CGPoint newCenter = [picture center];
    
    [self createDateObjectFromPoint:newCenter];
    
    [self.delegate finishedUpdatedFrame:picture withNewInformation:@{@"newDate": NSStringFromCGPoint(newCenter), @"otherInfo" : @"hahaha"}];
}
-(void)createDateObjectFromPoint:(CGPoint) point
{
    double modifier = _duration / _viewSpan;
    
    double thePoint = point.x - _xOffset;
    
    double pointAsPureDate = thePoint * modifier;
    
    pointAsPureDate *= (double)1.052;
    
    NSDate *newDate = [NSDate dateWithTimeInterval:pointAsPureDate sinceDate:_startDate];
    
    NSString *dateAsString = [newDate getDisplayDate];
    
    
}
@end
