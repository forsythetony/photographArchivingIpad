//
//  cellAttributesDictionary.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "cellAttributesDictionary.h"

@implementation cellAttributesDictionary

+(instancetype)defaultAttributes
{
    NSDictionary *dict = [[self class] new];
    
    NSArray *keys = @[keyFont,
                      keyFrame,
                      keyBackgroundColor,
                      keyTextColor,
                      keyTestingBackground,
                      keyTestingTextColor,
                      keytextAlignment,
                      key]
}
@end
