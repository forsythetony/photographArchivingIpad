//
//  DateRange.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "DateRange.h"
#import "NSDate+timelineStuff.h"

NSString const *keyStartYear = @"keyStartYear";
NSString const *keyEndYear = @"keyEndYear";

int defaultStartYear = 1900;
int defaultEndYear = 1950;

int earliestStartYear = 1400;

@implementation DateRange

+(id)createRangeWithDefaultValues
{
    DateRange *newRange = [[DateRange class] new];
    
    newRange.startDate = [NSDate dateWithYear:@(1900)];
    newRange.endDate = [NSDate dateWithYear:@(1950)];
    
    return newRange;
    
}
+(id)createRangeWithStartYear:(NSInteger)startYear andEndYear:(NSInteger)endYear
{
    
    DateRange *newRange = [[DateRange class] new];
    
    NSDictionary *yearDict = [[self class] checkStartYear:startYear andEndYear:endYear];
    
    newRange.startDate = [NSDate dateWithYear:yearDict[keyStartYear]];
    newRange.endDate = [NSDate dateWithYear:yearDict[keyEndYear]];
    
    return newRange;
    
    
}
+(NSDictionary*)checkStartYear:(NSInteger) startyear andEndYear:(NSInteger) endYear
{
    if (startyear < (NSInteger)1400 || startyear > [[[NSDate date] yearAsNumber] integerValue]) {
        
        startyear = (NSInteger)defaultStartYear;
        
    }
    
    if (endYear < (NSInteger)earliestStartYear || endYear > [[[NSDate date] yearAsNumber] integerValue] + 1) {
        
        endYear = (NSInteger)defaultEndYear;
        
        
        
    }
    
    if (endYear <= startyear) {
        
        startyear = (NSInteger)defaultStartYear;
        endYear = (NSInteger)defaultEndYear;
        
    }
    
    
    return @{keyStartYear: [NSNumber numberWithInteger:startyear],
             keyEndYear: [NSNumber numberWithInteger:endYear]};
}
@end
