//
//  NSDictionary+dictionaryAccessors.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "attributesDictionaryConstants.h"
#import "UIColor+testingColors.h"

@interface NSDictionary (dictionaryAccessors)

+(instancetype) cellAttributesDictionary;

-(id)objectForConstKey:(NSString*) key;

@end
