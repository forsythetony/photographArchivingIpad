//
//  dummyDataProvider.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "dummyDataProvider.h"

@implementation dummyDataProvider

-(NSDictionary*)getDummyRange
{
    return @{   @"startDate": [NSDate dateWithYear:@1900],
                @"endDate" : [NSDate dateWithYear:@1945]
            };
}

@end
