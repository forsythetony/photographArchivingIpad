//
//  NSString+Helpers.h
//  Pocket Binder
//
//  Created by Tony Forsythe on 2/19/15.
//  Copyright (c) 2015 Architech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NewLineWrapping) {
    NewLineWrappingFirst,
    NewLineWrappingLast,
    NewLineWrappingBoth
};

@interface NSString (Helpers)

-(BOOL)isValidFilePath;
-(BOOL)equalsString:(NSString*) otherString;
-(NSString*)getFirstChar;
-(BOOL)isEmpty;
-(NSString*)wrapInNewLinesWithType:(NewLineWrapping) t_type;
-(BOOL)convertToBoolValue;
-(NSUInteger)convertToNSUinteger;
-(NSString*)PBAppendString:(NSString*) t_string delimiter:(NSString*) t_delimiter;
-(NSString*)PBAppendString:(NSString*) t_string;

+(NSString*)PBStringWithBoolNumber:(NSNumber*) t_boolNumber;
+(NSString*)stringByCopyingCharacter:(NSString*) t_char x:(NSInteger) t_times;
+(BOOL)isStringNotNullOrEmpty:(NSString*) t_string;
+(NSString*)randomString;
+(NSString*)pbCurrencyStringWithNumber:(NSNumber*) t_num;

@end

@interface NSString (Scanners)

-(BOOL)containsSpace;

@end
