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
    NSString *formatString  = @"M/dd/yyyy";
    NSString *dateString    = @"1/01/0001";
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:formatString];
    
    return [fm dateFromString:dateString];
    
}
+(NSDate *)dateWithv1String:(NSString *)v1String
{
    NSString *formatString = @"MM/dd/yyyy";
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:formatString];
    
    NSDate *returnDate = [fm dateFromString:v1String];
    
    NSString *dateDescription = [returnDate description];
    
    NSLog(@"\nDescription of the date is: %@\n", dateDescription);
    
    return returnDate;
}

+(NSDate *)dateWithv2String:(NSString *)v2String
{
    NSString *formatString = @"yyyy-MM-dd";
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:formatString];
    
    NSDate *returnDate = [fm dateFromString:v2String];
    
    NSString *dateDescription = [returnDate description];
    
    NSLog(@"\nDescription of the date is: %@\n", dateDescription);
    
    return returnDate;
}


+(NSDate*)dateWithYear:(NSNumber*) year
{
    
    NSString *formatString  = @"MM/dd/yyyy";
    NSString *dateString    = [NSString stringWithFormat:@"01/01/%li", (long)[year integerValue]];
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:formatString];
    
    return [fm dateFromString:dateString];
    
}
-(NSTimeInterval)timeIntervalSinceBeginning
{
    
    NSString *formatString  = @"M/dd/yyyy";
    NSString *dateString    = @"1/01/0001";
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:formatString];
    
    NSDate *refDate = [fm dateFromString:dateString];
    
    return [self timeIntervalSinceDate:refDate];

}
+(NSDate *)dateWithTimeIntervalSinceUserReferencePoint:(NSTimeInterval)interval
{
    NSString *formatString  = @"M/dd/yyyy";
    NSString *dateString    = @"1/01/0001";
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:formatString];
    
    NSDate *refDate = [fm dateFromString:dateString];
    
    return [NSDate dateWithTimeInterval:interval
                              sinceDate:refDate];
    
}
-(NSString*)findSuffixForDay:(NSString*) day
{
    NSInteger dayInt = [day integerValue];
    
    NSString *suffixString;
    
    if (dayInt >= 10 && dayInt <= 20) {

        suffixString = @"th";
        
    }
    else
    {
        while( dayInt > 10 )
        {
            dayInt -= 10;
        }
        
        switch (dayInt) {
            case 1:
            {
                suffixString = @"st";
            }
            break;
                
            case 2:
            {
                suffixString = @"nd";
            }
            break;
                
                case 3:
            {
                suffixString = @"rd";
            }
                break;
                
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
            {
                suffixString = @"th";
            }
                break;
                
            default:
                suffixString = @"";
                break;
        }
        
    }
    
    return suffixString;
}
-(NSString*)displayDateOfType:(sDateType) dateType
{
    
    NSString *dateFormat;
    
    switch (dateType) {
            
        case sDateTypeSimple:
            dateFormat = @"M/dd/yyyy";
            break;
            
        case sDateTypPretty:
            dateFormat = @"EEEE MMMM d yyyy";
            break;
            
        case sDateTypeWithTime:
            dateFormat = @"M/dd/yyyy h:mm a";
            break;
            
        case sDateTypeMonthAndYear:
            dateFormat = @"MMMM yyyy";
            break;
            
            case sDateTypeYearOnly:
            dateFormat = @"yyyy";
            break;
            
        case sdatetypeURL:
            dateFormat = @"M-dd-yyyy-hh-mm";
            break;

        case sDateTypeBabbageURL:
            dateFormat = @"yyyy-MM-dd";
            break;
        case sDateTypeDayOnly:
            dateFormat = @"d";
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
    
    NSString *dateFormat    = @"yyyy";
    
    NSDateFormatter *fm     = [NSDateFormatter new];
    
    [fm setDateFormat:dateFormat];
    
    NSString *yearString    = [fm stringFromDate:self];
    NSInteger year          = [yearString integerValue];
    
    return [NSNumber numberWithInteger:year];
    
}
-(NSString*)dayFromDateWithType:(sDayType) type
{
    NSString *dayString = [self displayDateOfType:sDateTypeDayOnly];
    
    
    switch (type) {
        case sDayTypePure:
            
            break;
        case sDayTypeSuffix:
        {
            NSString *suffixString = [self findSuffixForDay:dayString];
            
            dayString = [NSString stringWithFormat:@"%@%@", dayString, suffixString];
        }
        default:
            break;
    }
    
    return dayString;
}

@end
