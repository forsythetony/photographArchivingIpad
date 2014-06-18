//
//  attributesDictionary.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "attributesDictionaryConstants.h"
#import "UIColor+testingColors.h"

@interface attributesDictionary : NSMutableDictionary

+ (instancetype) createDefault;
-(void)updateValues:(NSArray*) values forKeys:(NSArray*) keys;
-(id)objectForConstKey:(NSString*) key;

@end
