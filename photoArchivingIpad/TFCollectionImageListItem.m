//
//  TFCollectionImageListItem.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFCollectionImageListItem.h"

static NSString* const kJSON_COLLECTION_ITEM_PHOTO_ID = @"photo_id";
static NSString* const kJSON_COLLECTION_ITEM_COLLECTION_ID = @"collection_id";

@implementation TFCollectionImageListItem

+(instancetype)CollectionImageListingWithDict:(NSDictionary *)t_dict
{
    TFCollectionImageListItem *coll = [[TFCollectionImageListItem alloc] init];
    
    NSString *photoid = t_dict[kJSON_COLLECTION_ITEM_PHOTO_ID];
    NSString *collId = t_dict[kJSON_COLLECTION_ITEM_COLLECTION_ID];
    
    if (photoid) coll.photo_id = photoid;
    if (collId) coll.collection_id = collId;
    
    return coll;
}
@end
