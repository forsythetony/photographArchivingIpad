//
//  NSString+Helpers.m
//  Pocket Binder
//
//  Created by Tony Forsythe on 2/19/15.
//  Copyright (c) 2015 Architech. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

-(BOOL)isValidFilePath
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* filePath = [documentsPath stringByAppendingPathComponent:self];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
}
-(NSString *)getFirstChar
{
     unichar firstChar = [self characterAtIndex:0];
    
    return [NSString stringWithFormat:@"%c", firstChar];
}
-(BOOL)isEmpty
{
    return [self isEqualToString:@""];
}
+(NSString *)stringByCopyingCharacter:(NSString *)t_char x:(NSInteger)t_times
{
    NSString* newString = @"";
    
    for (NSInteger i = 0; i < t_times; i++) {
        newString = [newString stringByAppendingString:t_char];
    }
    
    return newString;
}
-(NSString*)wrapInNewLinesWithType:(NewLineWrapping)t_type
{
    NSString *newString;
    
    switch (t_type) {
        case NewLineWrappingFirst:
        {
            newString = [NSString stringWithFormat:@"\n%@", self];
        }
            break;
            
        case NewLineWrappingBoth: {
            newString = [NSString stringWithFormat:@"\n%@\n", self];
        }
            break;
        case NewLineWrappingLast: {
            newString = [NSString stringWithFormat:@"%@\n", self];
        }
            break;
        default:
            newString = [NSString stringWithString:self];
            break;
    }
    return newString;
}
+(BOOL)isStringNotNullOrEmpty:(NSString *)t_string
{
    BOOL isNotNullOrEmpty = YES;
    
    if (t_string) {
        
        if ([t_string isEqualToString:@""]) {
            isNotNullOrEmpty = NO;
        }
        
    }
    else
    {
        isNotNullOrEmpty = NO;
    }
    
    
    return isNotNullOrEmpty;
}
-(NSUInteger)convertToNSUinteger
{
    NSNumberFormatter *fm = [NSNumberFormatter new];
    
    fm.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber* num = [fm numberFromString:self];
    
    if (num) {
        return (NSUInteger)[num integerValue];
    }
    else
    {
        return 0;
    }
}
-(BOOL)convertToBoolValue
{
    if ([self isEqualToString:@"0"]) {
        return NO;
    }
    else
    {
        return YES;
    }
}
+(NSString *)randomString
{
    int r = arc4random_uniform(1000000);
    
    return [@(r) stringValue];
}
+(NSString *)pbCurrencyStringWithNumber:(NSNumber *)t_num
{
    NSString *str;
    
    NSNumberFormatter *fm = [[NSNumberFormatter alloc] init];
    
    [fm setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    str = [fm stringFromNumber:t_num];

    return str;
}
@end

@implementation NSString (Scanners)

-(BOOL)containsSpace
{
    BOOL foundSpace = NO;
    
    NSString *searchString = @" ";
    
    NSRange spaceRange = [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (spaceRange.location != NSNotFound) {
        foundSpace = YES;
    }
    else
    {
        foundSpace = NO;
    }
    
    return foundSpace;
}
-(NSString *)PBAppendString:(NSString *)t_string
{
    NSString *delim = @"...";
    
    return [self PBAppendString:t_string delimiter:delim];
}
-(NSString *)PBAppendString:(NSString *)t_string delimiter:(NSString *)t_delimiter
{
    return [self stringByAppendingString:[NSString stringWithFormat:@"%@%@", t_delimiter, t_string]];
}
+(NSString *)PBStringWithBoolNumber:(NSNumber *)t_boolNumber
{
    BOOL boolValue = [t_boolNumber boolValue];
    
    return (boolValue ? @"1" : @"0");
}
@end
