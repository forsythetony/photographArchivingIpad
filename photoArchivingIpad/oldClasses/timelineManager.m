//
//  timelineManager.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "timelineManager.h"
#import <math.h>

#define HORIZONTALMOD 8.0


@implementation timelineManager

-(NSNumber *)makeDuration
{
    NSNumber        *duration;
    NSTimeInterval  timeDuration;
    
    if (_startDate && _endDate) {
        
        timeDuration    = [_startDate timeIntervalSinceDate:_endDate];
        duration        = [NSNumber numberWithDouble:timeDuration];
        
    }
    
    return duration;
    
}
-(CGPoint)createPointWithDate:(NSDate *)date
{
    
    CGPoint centerPoint;
    
    NSTimeInterval pureDate = [date timeIntervalSinceBeginning];
    
    float specNumber    = _viewSpan / _duration;
    
    float   lowerYBound     =   _TLView.center.y - 100.0,
            upperYBound     =   75.0;
    
    centerPoint.y = [self randomFloatBetween:lowerYBound and:upperYBound];
    
    centerPoint.x = _xOffset + (( pureDate - _pureStart ) * specNumber) - HORIZONTALMOD;
    
    float attempt = [self getRandomFloatWithDate:date];
    
    return centerPoint;
    
}
-(void)setStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate andView:(UIView *)tlview andXOffsert:(float)offset
{
    _startDate  = startDate;
    _endDate    = endDate;
    
    _pureStart  = [_startDate timeIntervalSinceBeginning];
    _pureEnd    = [_endDate timeIntervalSinceBeginning];
    
    _TLView     = tlview;
    
    _duration   = [endDate timeIntervalSinceDate:startDate];
    _viewSpan   = tlview.frame.size.width - (offset * 2.0);
    _xOffset    = offset;
    
}
-(void)setInitialPhotographs:(NSArray *)thePhotographs
{
    
    _theImages = thePhotographs;
    
    for(pictureFrame* theFrame in _theImages) {
        
        imageObject *img    = theFrame.imageObject;
        
        
        CGPoint theCenter   = [self createPointWithDate:[img date]];
        
        theFrame.center = theCenter;
        
        [theFrame.theImage setImageWithURL:img.thumbNailURL];
        
        [_TLView addSubview:theFrame];
        
    }
}
-(void)updateDateForPicture:(pictureFrame *)picture
{
    
    CGPoint newCenter = [picture center];
    
    NSDate *pointDate = [self createDateObjectFromPoint:newCenter];
    
    picture.imageObject.date = pointDate;
    
    [self.delegate finishedUpdatedFrame:picture
                     withNewInformation:@{@"newDate": pointDate}];
    
}
-(NSDate*)createDateObjectFromPoint:(CGPoint) point
{
    
    double modifier = _duration / _viewSpan;
    
    double thePoint = point.x - _xOffset;
    
    double pointAsPureDate = thePoint * modifier;
    
    pointAsPureDate *= (double)1.052;
    
    NSDate *newDate = [NSDate dateWithTimeInterval:pointAsPureDate sinceDate:_startDate];
    
    return newDate;
    
}
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    
    float diff = bigNumber - smallNumber;
    
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
    
}
-(float)getRandomFloatWithDate:(NSDate*) theDate
{
    float timeInt = (float)[theDate timeIntervalSinceBeginning];
    
    float result = fmod(timeInt, 2.0);
    
    NSLog(@"THE FLOAT IS %f", result);
    
    return result;
}
@end
