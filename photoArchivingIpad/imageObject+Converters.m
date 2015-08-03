//
//  imageObject+Converters.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "imageObject+Converters.h"
#import "NSDate+timelineStuff.h"

static NSString* const kJSON_IMAGEOBJ_LARGE_URL = @"large_url";
static NSString* const kJSON_IMAGEOBJ_THUMB_URL = @"thumbnail_url";
static NSString* const kJSON_IMAGEOBJ_PHOTO_ID = @"photo_id";
static NSString* const kJSON_IMAGEOBJ_TITLE = @"title";
static NSString* const kJSON_IMAGEOBJ_DATE_TAKEN = @"date_taken";
static NSString* const kJSON_IMAGEOBJ_DATE_CONFIDENCE = @"date_confidence";
static NSString* const kJSON_IMAGEOBJ_UPLOADER = @"uploader_id";

@implementation imageObject (Converters)

+(instancetype)ImageObjectFromDictionary:(NSDictionary *)t_dict
{
    imageObject *image = [imageObject new];
    
    NSString *largeURL = t_dict[kJSON_IMAGEOBJ_LARGE_URL];
    NSString *thumbURL = t_dict[kJSON_IMAGEOBJ_THUMB_URL];
    NSString *uuid = t_dict[kJSON_IMAGEOBJ_PHOTO_ID];
    NSString *title = t_dict[kJSON_IMAGEOBJ_TITLE];
    NSString *uploader = t_dict[kJSON_IMAGEOBJ_UPLOADER];
    NSString *date_conf = t_dict[kJSON_IMAGEOBJ_DATE_CONFIDENCE];
    NSString *date_taken = t_dict[kJSON_IMAGEOBJ_DATE_TAKEN];
    
    if (largeURL) image.photoURL = [NSURL URLWithString:largeURL];
    if (thumbURL) image.thumbNailURL = [NSURL URLWithString:thumbURL];
    if (uuid) image.id = uuid;
    if (title) image.title = title;
    if (uploader) image.uploader = uploader;
    if (date_conf) image.confidence = date_conf;
    if (date_taken) image.date = [NSDate dateWithv2String:date_taken];
    
    return image;
}
@end
