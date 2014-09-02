//
//  TADuration.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/31/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DurationDisplayType) {

    DurationDisplayTypeMinSec,
    DurationDisplayTypeHrMin,
    DurationDisplayTypeHrMinSec,
    DurationDisplayTypeFull
    
};
@interface TADuration : NSObject

@property (nonatomic, assign) NSInteger milliseconds;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger hours;

/*
    Methods
*/
+(id)createWithMilliseconds:(NSInteger) milliseconds Seconds:(NSInteger) seconds Minutes:(NSInteger) minutes andHours:(NSInteger) hours;

-(NSDictionary*)convertToDictionary;
-(NSString*)getDisplayStringOfType:(DurationDisplayType) type;
-(NSString*)getTimeWithPercentage:(CGFloat) percentage;

@end
