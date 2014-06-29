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
+(instancetype)attributesDictionaryForType:(attrDictType) dictType
{
    UIFont *defaultFont;
    
    UIColor *defaultTextColor;
    UIColor *defaultBackground;
    UIColor *defaultTestingBackground;
    UIColor *defaultTestingTextColor;
    NSTextAlignment defaultTextAlignment;
    
    NSString *textValue = @"";
    NSString *testingTextValue = @"testing";
    
    switch (dictType) {
        case attrDictTypeDefault:
            defaultTextColor = [UIColor blackColor];
            defaultBackground = [UIColor clearColor];
            defaultTestingBackground = [UIColor testInfoBackgroundOne];
            defaultTestingTextColor = [UIColor testInfoTextOne];
            defaultTextAlignment = NSTextAlignmentLeft;
            defaultFont = [UIFont fontWithName:global_font_family size:13.0];
            
            break;
            
            case attrDictTypeLabel1:
            defaultTextColor = [UIColor blackColor];
            defaultBackground = [UIColor clearColor];
            
            defaultTestingBackground = [UIColor testInfoBackgroundOne];
            defaultTestingTextColor = [UIColor testInfoTextOne];
            defaultTextAlignment = NSTextAlignmentLeft;
            defaultFont = [UIFont fontWithName:global_font_family size:13.0];
            break;
            
            case attrDictTypeLabel2:
            defaultTextColor = [UIColor blackColor];
            defaultBackground = [UIColor clearColor];
            
            defaultTestingBackground = [UIColor testInfoBackgroundTwo];
            defaultTestingTextColor = [UIColor testInfoTextTwo];
            defaultTextAlignment = NSTextAlignmentLeft;
            defaultFont = [UIFont fontWithName:global_font_family size:13.0];
            break;
            
            case attrDictTypeTitle:
            defaultTextColor = [UIColor blackColor];
            defaultBackground = [UIColor clearColor];
            defaultTestingBackground = [UIColor testTitleBackground];
            defaultTestingTextColor = [UIColor testTitleText];
            defaultTextAlignment = NSTextAlignmentLeft;
            defaultFont = [UIFont fontWithName:global_font_family size:13.0];
            break;
            
            case attrDictTypeView1:
            defaultTextColor = [UIColor blackColor];
            defaultBackground = [UIColor clearColor];
            defaultTestingBackground = [UIColor testMainBackground];
            defaultTestingTextColor = [UIColor blackColor];
            defaultTextAlignment = NSTextAlignmentLeft;
            defaultFont = [UIFont fontWithName:global_font_family size:13.0];
            break;
            
            case attrDictTypeButtonDefault:
            defaultTextColor = [UIColor indigoColor];
            defaultBackground = [UIColor clearColor];
            
            defaultTestingBackground = [UIColor testInfoBackgroundOne];
            defaultTestingTextColor = [UIColor testInfoTextOne];
            defaultTextAlignment = NSTextAlignmentCenter;
            defaultFont = [UIFont fontWithName:global_font_family size:18.0];
            break;
            
            case attrDictTypeTableFooter:
            
            defaultTextColor = [UIColor black25PercentColor];
            defaultBackground = [UIColor blueberryColor];
            
            defaultTestingBackground = [UIColor yellowColor];
            defaultTestingTextColor = [UIColor black25PercentColor];
            defaultFont = [UIFont fontWithName:global_font_family size:18.0];
            defaultTextAlignment = NSTextAlignmentCenter;
            break;
        
        default:
            defaultTextColor = [UIColor blackColor];
            defaultBackground = [UIColor clearColor];
            defaultTestingBackground = [UIColor testMainBackground];
            defaultTestingTextColor = [UIColor blackColor];
            defaultTextAlignment = NSTextAlignmentLeft;
            defaultFont = [UIFont fontWithName:global_font_family size:13.0];
            break;
    }
    CGRect defaultFrame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    
    
    NSArray *keys = @[keyFont,
                      keyFrame,
                      keyBackgroundColor,
                      keyTextColor,
                      keyTestingBackground,
                      keyTestingTextColor,
                      keytextAlignment,
                      keyTextValue,
                      keyTestingTextValue];
    
    NSArray *values = @[defaultFont,
                        [NSValue valueWithCGRect:defaultFrame],
                        defaultBackground,
                        defaultTextColor,
                        defaultTestingBackground,
                        defaultTestingTextColor,
                        [NSNumber numberWithInteger:defaultTextAlignment],
                        textValue,
                        testingTextValue];
    
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
