//
//  TADuration.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/31/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TADuration.h"
#import "updatedConstants.h"

typedef struct tfDurationS {
    
    NSInteger milliseconds;
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    
} tfDuration;

@implementation TADuration

+(id)createWithMilliseconds:(NSInteger)milliseconds Seconds:(NSInteger)seconds Minutes:(NSInteger)minutes andHours:(NSInteger)hours
{
    TADuration *newDuration = [[self class] new];
    
    newDuration.milliseconds = milliseconds;
    newDuration.seconds = seconds;
    newDuration.minutes = minutes;
    newDuration.hours = hours;
    
    return newDuration;
    
}
-(NSDictionary *)convertToDictionary
{
    NSString    *milliString,
                *secString,
                *minString,
                *hourString;
    
    
    milliString = [NSString stringWithFormat:@"%d", self.milliseconds];
    secString = [NSString stringWithFormat:@"%d", self.seconds];
    minString = [NSString stringWithFormat:@"%d", self.minutes];
    hourString = [NSString stringWithFormat:@"%d", self.hours];
    
    
    
    
    return @{jsonKeyStories_AudioLength_milliseconds: milliString,
             jsonKeyStories_AudioLength_seconds: secString,
             jsonKeyStories_AudioLength_minutes: minString,
             jsonKeyStories_AudioLength_hours: hourString};
    
}
-(NSString*)getDisplayStringOfType:(DurationDisplayType) type
{
    NSString *displayString;
    
    NSString    *secString,
                *milliString,
                *minString,
                *hourString;
    
    
    switch (type) {

        case DurationDisplayTypeHrMin: {
            
            minString = [ self stringWithValue:self.minutes];
            hourString = [ self stringWithValue:self.hours];
            
            displayString = [NSString stringWithFormat:@"%@:%@", hourString , minString];
            
        }
            break;
        
        case DurationDisplayTypeMinSec: {
            
            secString = [ self stringWithValue:self.seconds];
            minString = [ self stringWithValue:self.minutes];
            
            displayString = [NSString stringWithFormat:@"%@:%@", minString , secString];
            
        }
            break;
            
        case DurationDisplayTypeFull: {
            
            milliString = [ NSString stringWithFormat:@"%4d", self.milliseconds ];
            secString = [ self stringWithValue:self.seconds];
            minString = [ self stringWithValue:self.minutes];
            hourString = [ self stringWithValue:self.hours];
            
            displayString = [NSString stringWithFormat:@"%@:%@:%@.%@", hourString , minString , secString , milliString];
            
            
        }
            break;
            
        default: {
            
            displayString = @"displayTypeError";
            
        }
            break;
    }
    
    
    return displayString;
    
}
-(NSString*)stringWithValue:(NSInteger) value
{
    NSString *newString;
    
    if ( value < 10) {
        
        newString = [NSString stringWithFormat:@"0%1d", value];
        
    }
    else
    {
        newString = [NSString stringWithFormat:@"%2d", value];
    }
    
    return newString;
}
-(NSString *)getTimeWithPercentage:(CGFloat)percentage
{
    NSInteger absoluteTime = [self absoluteTime];
    
    NSInteger percentageDuration = absoluteTime * percentage;
    
    TADuration *scrubDuration = [self getDurationFromAbsoluteTime:percentageDuration];
    
    return [scrubDuration getDisplayStringOfType:DurationDisplayTypeMinSec];
    
}
-(NSInteger)absoluteTime
{
    NSInteger absoluteTime = 0;
    
    absoluteTime += self.milliseconds;
    
    absoluteTime += self.seconds * 1000;
    
    absoluteTime += (self.minutes * 60 * 1000);
    
    absoluteTime += (self.hours * 60 * 60 * 1000);
    
    return absoluteTime;
    
}
-(TADuration*)getDurationFromAbsoluteTime:(NSInteger) absoluteTime
{
   
    NSInteger millisecondsCounter = 0;
    NSInteger secondsCounter = 0;
    NSInteger minutesCounter = 0;
    NSInteger hoursCounter = 0;
    
    for (NSInteger i = 0; i <= absoluteTime; i++) {
        
        millisecondsCounter++;
        
        if (millisecondsCounter == 1000) {
            
            secondsCounter++;
            millisecondsCounter = 0;
            
            if (secondsCounter == 60) {
                
                minutesCounter++;
                secondsCounter = 0;
                
                if (minutesCounter == 60) {
                    
                    hoursCounter++;
                    minutesCounter = 0;
                    
                }
            }
        }
    }
    
    TADuration *newDuration = [TADuration createWithMilliseconds:millisecondsCounter Seconds:secondsCounter Minutes:minutesCounter andHours:hoursCounter];
    
    return newDuration;
}
@end
