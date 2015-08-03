//
//  TFTimelineDate.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TFTimelineDateType) {
    TFTimelineDateTypeYear,
    TFTimelineDateTypeMonth,
    TFTimelineDateTypeNone
};
@interface TFTimelineDate : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CGFloat y_center;
@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, assign) TFTimelineDateType dateType;

@end
