//
//  attributesDictionary.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "attributesDictionary.h"

@implementation attributesDictionary

+ (instancetype) createDefault
{
    
    UIFont *defaultFont = [UIFont fontWithName:@"DINAlternate-Bold" size:13.0];
    
    UIColor *defaultTextColor = [UIColor whiteColor];
    UIColor *defaultBackground = [UIColor clearColor];
    UIColor *defaultTestingBackground = [UIColor testMainBackground];
    UIColor *defaultTestingTextColor = [UIColor whiteColor];
    
    CGRect defaultFrame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    
    NSTextAlignment defaultTextAlignment = NSTextAlignmentLeft;
    
    
    NSArray *keys = @[keyFont,
                      keyFrame,
                      keyBackgroundColor,
                      keyTextColor,
                      keyTestingBackground,
                      keyTestingTextColor,
                      keytextAlignment];
    
    NSArray *values = @[defaultFont,
                        [NSValue valueWithCGRect:defaultFrame],
                        defaultBackground,
                        defaultTextColor,
                        defaultTestingBackground,
                        defaultTestingTextColor,
                        [NSNumber numberWithInteger:defaultTextAlignment]];
    
    return [attributesDictionary dictionaryWithObjects:values forKeys:keys];
    
}
-(void)updateValues:(NSArray *) values forKeys:(NSArray *)keys
{
    
    NSInteger valuesCount = [values count];
    NSInteger keysCount = [keys count];
    
    if (valuesCount == keysCount) {
        
        for (int i = 0; i < keysCount; i++) {
            [self setObject:values[i] forKey:keys[i]];
        }
    }
    
}
-(id)objectForConstKey:(NSString *)key
{
    id object = [self objectForKey:key];
    
    return object;
}
@end
