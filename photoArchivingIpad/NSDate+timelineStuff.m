//
//  NSDate+timelineStuff.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "NSDate+timelineStuff.h"

@implementation NSArray (HelperMen)

-(NSArray *)insertObjectInSecondPosition:(id)t_object
{
    NSUInteger count = self.count;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self];
    
    if (count == 0) {
        
        [arr addObject:t_object];
        
    }
    else
    {
        [arr insertObject:t_object atIndex:1];
    }
    
    return [NSArray arrayWithArray:arr];
}
-(NSArray *)insertObjectAtPenultimatePos:(id)t_object
{
    NSUInteger count = self.count;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self];
    
    if (count == 0) {
        
        [arr addObject:t_object];
        
    }
    else
    {
        [arr insertObject:t_object atIndex:count-2];
    }
    
    return [NSArray arrayWithArray:arr];
}
-(NSArray *)insertObjectAtFirstPos:(id)t_object
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self];
    
    [arr insertObject:t_object atIndex:0];
    
    return [NSArray arrayWithArray:arr];
}
-(NSArray *)insertObjectAtLastPos:(id)t_object
{
    NSUInteger count = self.count;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self];
    
    if (count == 0) {
        
        [arr addObject:t_object];
        
    }
    else
    {
        [arr insertObject:t_object atIndex:count-1];
    }
    
    return [NSArray arrayWithArray:arr];
}
@end
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
            case sDateTypeMonthOnly:
            dateFormat = @"MMMM";
            break;
            case sDateTypeYearAbbreviation:
            dateFormat = @"yy";
            break;
            case sDateTypeMonthAbbreviation:
            dateFormat = @"MMM";
            break;
            
        default:
            break;
    }
    
    NSDateFormatter *fm = [NSDateFormatter new];
    
    [fm setDateFormat:dateFormat];
    
    NSString *dateString = [fm stringFromDate:self];
    
    if (dateType == sDateTypeYearAbbreviation) {
        dateString = [NSString stringWithFormat:@"'%@", dateString];
    }
    
    return dateString;
    
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
-(NSDate *)nearestBeforeYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    if (comps.day == 1 && comps.month == 1) {
        comps.year -= 1;
    }
    
    comps.month = 1;
    comps.day = 1;
    
    return [gregorian dateFromComponents:comps];
    
}
-(NSDate *)nearestNextYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    
    comps.year += 1;
    comps.month = 1;
    comps.day = 1;
    
    return [gregorian dateFromComponents:comps];
}
+(NSArray *)getAllMonthDatesBetweenStart:(NSDate *)t_start finish:(NSDate *)t_finish
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDate *tempDate = t_start;
    
    while (YES) {
        

        tempDate = [tempDate getNextMonth];
        
        
        
        if ([tempDate compare:t_finish] == NSOrderedDescending) {
            break;
        }
        
        [array addObject:tempDate];
    }
    
    return [NSArray arrayWithArray:array];
}
-(NSDate *)getNextMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    if (comps.month + 1 == 13) {
        comps.year += 1;
        comps.month = 1;
    }
    else
    {
        comps.month += 1;
    }
    
    comps.day = 1;
    
    return [gregorian dateFromComponents:comps];
}
-(BOOL)isBeginningOfYear
{
    BOOL    isBegin = NO;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    if (comps.month == 1) {
        isBegin = YES;
    }
    
    
    return isBegin;
}
-(BOOL)isBeforeData:(NSDate *)t_date
{
    BOOL isBefore = NO;
    
    if ([self compare:t_date] == NSOrderedAscending) {
        isBefore = YES;
    }
    
    return isBefore;
}
+(NSUInteger)yearsBetweenDateOne:(NSDate *)t_one andDateTwo:(NSDate *)t_two
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *comp_one = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:t_one];
    
    NSDateComponents *comp_two = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:t_two];
    
    
    return (NSUInteger)labs((comp_one.year - comp_two.year));
}
-(BOOL)isOddMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *comp_one = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    return (comp_one.month % 2 != 0);
}
@end
