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
-(NSTimeInterval)timeIntervalSinceBeginning
{
    NSString* formatString = @"M/dd/yyyy";
    NSString* dateString = @"1/01/0001";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:formatString];
    
    NSDate *refDate = [fm dateFromString:dateString];
    
    return [self timeIntervalSinceDate:refDate];

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
-(NSString*)displayDateOfType:(sDateType) dateType
{
    NSString *dateFormat;
    
    switch (dateType) {
        case sDateTypeSimple:
            dateFormat = @"M/dd/yyyy";
            break;
        case sDateTypPretty:
            dateFormat = @"EEE, MMM d yyyy";
            break;
        case sDateTypeWithTime:
            dateFormat = @"M/dd/yyyy h:mm a";
            break;
        case sDateTypeMonthAndYear:
            dateFormat = @"MM yyyy";
            break;
            
        default:
            break;
    }
    
    NSDateFormatter *fm = [NSDateFormatter new];
    
    [fm setDateFormat:dateFormat];
    
    return [fm stringFromDate:self];
}
-(NSNumber *)yearAsNumber
{
    NSString *dateFormat = @"yyyy";
    
    NSDateFormatter *fm = [NSDateFormatter new];
    
    [fm setDateFormat:dateFormat];
    
    NSString *yearString = [fm stringFromDate:self];
    
    NSInteger year = [yearString integerValue];
    
    return [NSNumber numberWithInteger:year];
    
}
@end
