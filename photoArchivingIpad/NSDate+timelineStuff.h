//
//  NSDate+timelineStuff.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, sDateType) {
    
    sDateTypeSimple,
    sDateTypPretty,
    sDateTypeWithTime,
    sDateTypeMonthAndYear,
    sDateTypeYearOnly,
    sdatetypeURL,
    sDateTypeBabbageURL,
    sDateTypeDayOnly,
    sDateTypeMonthOnly,
    sDateTypeYearAbbreviation,
    sDateTypeMonthAbbreviation
    
};

typedef NS_ENUM(NSInteger, sDayType) {
    
    sDayTypePure,
    sDayTypeSuffix
};

@interface NSArray (HelperMen)

-(NSArray*)insertObjectInSecondPosition:(id)    t_object;
-(NSArray*)insertObjectAtPenultimatePos:(id)    t_object;
-(NSArray*)insertObjectAtLastPos:(id)           t_object;
-(NSArray*)insertObjectAtFirstPos:(id)          t_object;

@end
@interface NSDate (timelineStuff)

+(NSDate*)referenceDate;
+(NSDate*)dateWithv1String:(NSString*) v1String;
+(NSDate*)dateWithYear:(NSNumber*) year;
+(NSDate*)dateWithTimeIntervalSinceUserReferencePoint:(NSTimeInterval) interval;
+(NSDate *)dateWithv2String:(NSString *)v2String;

-(NSDate*)nearestBeforeYear;
-(NSDate*)nearestNextYear;
+(NSUInteger)yearsBetweenDateOne:(NSDate*) t_one andDateTwo:(NSDate*) t_two;
-(NSTimeInterval)timeIntervalSinceBeginning;

-(NSString*)displayDateOfType:(sDateType) dateType;

-(NSNumber*)yearAsNumber;

-(NSString*)dayFromDateWithType:(sDayType) type;
+(NSArray*)getAllMonthDatesBetweenStart:(NSDate*) t_start
                                 finish:(NSDate*)   t_finish;
-(NSDate*)getNextMonth;

-(BOOL)isBeginningOfYear;
-(BOOL)isBeforeData:(NSDate*) t_date;
-(BOOL)isOddMonth;

@end
