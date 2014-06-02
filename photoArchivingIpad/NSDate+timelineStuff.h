//
//  NSDate+timelineStuff.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (timelineStuff)

+(NSDate*)referenceDate;
+(NSDate*)dateWithv1String:(NSString*) v1String;
+(NSDate*)dateWithYear:(NSNumber*) year;

-(NSString*)simpleDateString;
-(NSTimeInterval)timeIntervalSinceBeginning;
-(NSString*)getDisplayDate;

+(NSDate*)dateWithTimeIntervalSinceUserReferencePoint:(NSTimeInterval) interval;

@end
