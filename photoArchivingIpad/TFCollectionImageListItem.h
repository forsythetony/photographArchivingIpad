//
//  TFCollectionImageListItem.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFCollectionImageListItem : NSObject

@property (nonatomic, strong) NSString *photo_id;
@property (nonatomic, strong) NSString *collection_id;

+(instancetype)CollectionImageListingWithDict:(NSDictionary*) t_dict;

@end
