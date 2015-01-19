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
#define DISTANCETHRESHOLD 50.0

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
-(void)bringSubyearsToFront
{
    for (UILabel *lbl in _savedYears) {
        [_TLView bringSubviewToFront:lbl];
        
    }
}
-(CGPoint)createPointWithDate:(NSDate *)date
{
    CGPoint centerPoint;
    BOOL goodValue = NO;
    while (goodValue == NO) {
        NSString *yearString;
        
        NSTimeInterval pureDate = [date timeIntervalSinceBeginning];
        
        float specNumber    = _viewSpan / _duration;
        
        float   lowerYBound     =   _TLView.frame.size.height - 45.0,
        upperYBound     =   90.0;
        
        centerPoint.y = [self randomFloatBetween:lowerYBound and:upperYBound];
        
        centerPoint.x = _xOffset + (( pureDate - _pureStart ) * specNumber) - HORIZONTALMOD;
        
        BOOL isFar = YES;
        
        for (NSDictionary* pointDict in _savedCenters) {
            
            CGPoint thePoint = [pointDict[@"point"] CGPointValue];
            
            float distance = [self getDistanceBetweenPoints:thePoint andTwo:centerPoint];
            

                float lineDist = [self distanceFromLineToPoint:thePoint];
                
                if (lineDist < DISTANCETHRESHOLD && distance < DISTANCETHRESHOLD) {
                    isFar = NO;
                }
            
            else
            {
                yearString = pointDict[@"year"];
                
            }
        }
        
        if (isFar == YES) {
            goodValue = YES;
            
            NSLog(@"\nFound good value for year %@ at point %@\n", yearString, NSStringFromCGPoint(centerPoint));
            
        
        }

    }
    
    NSDate *dt = date;
    
    [_savedCenters addObject:@{@"point": [NSValue valueWithCGPoint:centerPoint],
                               @"year" : [dt displayDateOfType:sDateTypeYearOnly]}];
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
        
        NSLog(@"Show me the date: %@", [[img date] displayDateOfType:sDateTypeSimple]);
        
        
        CGPoint theCenter   = [self createPointWithDate:[img date]];
        
        theFrame.center = theCenter;
        
//        [theFrame.theImage setImageWithURL:img.thumbNailURL];
        [theFrame.theImage sd_setImageWithURL:img.thumbNailURL];
        [_TLView addSubview:theFrame];
        
    }
    
}
-(NSDate *)getNewDateForFrame:(pictureFrame *)Pframe
{
    CGPoint newCenter = [Pframe center];
    
    NSDate *pointDate = [self createDateObjectFromPoint:newCenter];
    
    return pointDate;
}
-(NSDate*)createDateObjectFromPoint:(CGPoint) point
{
    
    double modifier = _duration / _viewSpan;
    
    double thePoint = point.x - _xOffset;
    
    double pointAsPureDate = thePoint * modifier;
    
    //pointAsPureDate *= (double)1.052;
    
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
-(float)getDistanceBetweenPoints:(CGPoint) pointOne andTwo:(CGPoint) pointTwo
{
    
    float xDiff = fabsf(pointTwo.x - pointOne.x);
    float yDiff = fabsf(pointTwo.y - pointOne.y);
    
    float distance = sqrtf(powf(xDiff, 2.0) + powf(yDiff, 2.0));
    
    return distance;

}
-(float)distanceFromLineToPoint:(CGPoint) thePoint
{
    
    CGPoint linePoint = [_lineCenter CGPointValue];
    
    float distance = fabsf(thePoint.y - linePoint.y);
    
    return distance;
}
@end
