//
//  NSMutableDictionary+attributesDictionary.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "NSMutableDictionary+attributesDictionary.h"

@implementation NSMutableDictionary (attributesDictionary)
-(id)objectForConstKey:(NSString *)key
{
    id object = [self objectForKey:key];
    
    return object;
}
+(instancetype)cellAttributesDictionaryForType:(attrDictType) dictType
{
    UIFont *defaultFont = [UIFont fontWithName:@"DINAlternate-Bold" size:13.0];
    
    UIColor *defaultTextColor = [UIColor whiteColor];
    UIColor *defaultBackground = [UIColor clearColor];
    UIColor *defaultTestingBackground;
    UIColor *defaultTestingTextColor;
    
    switch (dictType) {
        case attrDictTypeDefault:
            defaultTestingBackground = [UIColor testInfoBackgroundOne];
            defaultTestingTextColor = [UIColor testInfoTextOne];
            break;
            
            case attrDictTypeLabel1:
            defaultTestingBackground = [UIColor testInfoBackgroundOne];
            defaultTestingTextColor = [UIColor testInfoTextOne];
            break;
            
            case attrDictTypeLabel2:
            defaultTestingBackground = [UIColor testInfoBackgroundTwo];
            defaultTestingTextColor = [UIColor testInfoTextTwo];
            break;
            
            case attrDictTypeTitle:
            defaultTestingBackground = [UIColor testTitleBackground];
            defaultTestingTextColor = [UIColor testTitleText];
            break;
            
            case attrDictTypeView1:
            defaultTestingBackground = [UIColor testMainBackground];
            defaultTestingTextColor = [UIColor blackColor];
            break;
            
        
        default:
            defaultTestingBackground = [UIColor testMainBackground];
            defaultTestingTextColor = [UIColor blackColor];
            break;
    }
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
    
    return [[self class] dictionaryWithObjects:values forKeys:keys];
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

@end
