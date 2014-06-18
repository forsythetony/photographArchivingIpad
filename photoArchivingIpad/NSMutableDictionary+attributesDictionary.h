//
//  NSMutableDictionary+attributesDictionary.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "attributesDictionaryConstants.h"
#import "UIColor+testingColors.h"

typedef NS_ENUM(NSInteger, attrDictType) {
    attrDictTypeView1,
    attrDictTypeView2,
    attrDictTypeDefault,
    attrDictTypeTitle,
    attrDictTypeLabel1,
    attrDictTypeLabel2
};
@interface NSMutableDictionary (attributesDictionary)

+(instancetype) cellAttributesDictionaryForType:(attrDictType) dictType;

-(id)objectForConstKey:(NSString*) key;
-(void)updateValues:(NSArray *) values forKeys:(NSArray *)keys;

@end
