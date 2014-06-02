//
//  NSDate+timelineStuff.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "NSDate+timelineStuff.h"

@implementation NSDate (timelineStuff)

+(NSDate *)referenceDate
{
    NSString* formatString = @"M/dd/yyyy";
    NSString* dateString = @"1/01/0001";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    return [fm dateFromString:dateString];
}
+(NSDate *)dateWithv1String:(NSString *)v1String
{
    NSString *formatString = @"MM/dd/yyyy";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    return [fm dateFromString:v1String];
}
+(NSDate*)dateWithYear:(NSNumber*) year
{
    NSString *dateString = [NSString stringWithFormat:@"01/01/%i", [year integerValue]];
    
    NSString *formatString = @"MM/dd/yyyy";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    return [fm dateFromString:dateString];
}
-(NSString *)simpleDateString
{
    
    NSString *formatString = @"MM/dd/yyyy";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    return [fm stringFromDate:self];
}
-(NSTimeInterval)timeIntervalSinceBeginning
{
    NSString* formatString = @"M/dd/yyyy";
    NSString* dateString = @"1/01/0001";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    NSDate *refDate = [fm dateFromString:dateString];
    
    return [self timeIntervalSinceDate:refDate];

}
-(NSString *)getDisplayDate
{
    NSString *formatString = @"MM/dd/yyyy h:mm a";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    return [fm stringFromDate:self];
}
+(NSDate *)dateWithTimeIntervalSinceUserReferencePoint:(NSTimeInterval)interval
{
    NSString* formatString = @"M/dd/yyyy";
    NSString* dateString = @"1/01/0001";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    NSDate *refDate = [fm dateFromString:dateString];
    
    return [NSDate dateWithTimeInterval:interval sinceDate:refDate];
}
@end
