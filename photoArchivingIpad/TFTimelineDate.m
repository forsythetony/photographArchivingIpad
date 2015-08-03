//
//  TFTimelineDate.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFTimelineDate.h"
#import "NSDate+timelineStuff.h"

@implementation TFTimelineDate
+(instancetype)new
{
    TFTimelineDate *tlDate = [[TFTimelineDate alloc] init];
    
    tlDate.isBackground = YES;
    
    return tlDate;
}
-(TFTimelineDateType)dateType
{
    if (_date) {
        if ([_date isBeginningOfYear]) {
            return TFTimelineDateTypeYear;
        }
        else
        {
            return TFTimelineDateTypeMonth;
        }
    }
    else
    {
        return TFTimelineDateTypeNone;
    }
}
@end
