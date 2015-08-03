//
//  imageObject+Converters.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "imageObject.h"

@interface imageObject (Converters)

+(instancetype)ImageObjectFromDictionary:(NSDictionary*) t_dict;

@end
