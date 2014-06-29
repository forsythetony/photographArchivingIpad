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
    sdatetypeURL
    
};

@interface NSDate (timelineStuff)

+(NSDate*)referenceDate;
+(NSDate*)dateWithv1String:(NSString*) v1String;
+(NSDate*)dateWithYear:(NSNumber*) year;
+(NSDate*)dateWithTimeIntervalSinceUserReferencePoint:(NSTimeInterval) interval;

-(NSTimeInterval)timeIntervalSinceBeginning;

-(NSString*)displayDateOfType:(sDateType) dateType;

-(NSNumber*)yearAsNumber;


@end
