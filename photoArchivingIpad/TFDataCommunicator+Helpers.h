//
//  TFDataCommunicator+Helpers.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TFDataCommunicator.h"

@interface TFDataCommunicator (Helpers)

-(NSArray*)getDummyArray;
-(imageObject*)createImageObjectWithDictionary:(NSDictionary*) dict;

@end
