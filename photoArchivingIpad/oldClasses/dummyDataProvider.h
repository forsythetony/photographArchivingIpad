//
//  dummyDataProvider.h
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imageObject.h"
#import "pictureFrame.h"
#import "NSDate+timelineStuff.h"

@interface dummyDataProvider : NSObject


-(NSArray*)getImageObjects;
-(NSDictionary*)getDummyRange;

@end
