//
//  TFImageCollection+Converters.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFImageCollection.h"

@interface TFImageCollection (Converters)

+(instancetype)CollectionFromJSONDictionary:(NSDictionary *)t_dict;
-(void)populateImages;
-(void)TFAddImage:(imageObject*) t_img;

@end
