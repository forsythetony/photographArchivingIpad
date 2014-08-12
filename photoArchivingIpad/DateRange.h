//
//  DateRange.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const *keyStartYear;
extern NSString const *keyEndYear;

@interface DateRange : NSObject

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

+(id)createRangeWithDefaultValues;
+(id)createRangeWithStartYear:(NSInteger) startYear andEndYear:(NSInteger) endYear;

@end
