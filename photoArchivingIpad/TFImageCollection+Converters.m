//
//  TFImageCollection+Converters.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFImageCollection+Converters.h"
#import "imageObject.h"
#import "imageObject+Converters.h"
#import "TFDataCommunicator.h"
#import "updatedConstants.h"


static  NSString* const kJSON_COLLECTION_ID = @"collection_id";
static  NSString* const kJSON_COLLECTION_TITLE = @"title";
static  NSString* const kJSON_COLLECTION_DATE_CREATED = @"date_created";
static  NSString* const kJSON_COLLECTION_CREATOR = @"creator";
static  NSString* const kJSON_COLLECTION_TOTAL_IMAGES = @"total_images";
static  NSString* const kJSON_COLLECTION_APPROX_DATE = @"approx_date";

@implementation TFImageCollection (Converters)

+(instancetype)CollectionFromJSONDictionary:(NSDictionary *)t_dict
{

    
    NSString *uuid = [t_dict objectForKey:kJSON_COLLECTION_ID];
    NSString *title = [t_dict objectForKey:kJSON_COLLECTION_TITLE];
    NSString *date = [t_dict objectForKey:kJSON_COLLECTION_DATE_CREATED];
    NSString *creator = [t_dict objectForKey:kJSON_COLLECTION_CREATOR];
    NSString *totalImages = [t_dict objectForKey:kJSON_COLLECTION_TOTAL_IMAGES];
    
    NSString *approxDate = [t_dict objectForKey:kJSON_COLLECTION_APPROX_DATE];
    
    TFImageCollection *coll = [TFImageCollection new];
    
    if (uuid) {
        coll.uuid = uuid;
    }
    
    if (title) coll.title = title;
    if (date) coll.date_created = [NSDate dateWithv2String:date];
    if (creator) coll.creator = creator;
    if (approxDate) coll.approx_date = [NSDate dateWithv2String:approxDate];
    if (totalImages) coll.totalImages = @([totalImages integerValue]);
    
    return coll;
}
-(void)populateImages
{
    
    NSString *babbage_urlString = [NSString stringWithFormat:@"%@?collection_id=%@", [NSString EC2CollectionsEndpoint], self.uuid];
    
    NSURL           *url        = [NSURL URLWithString:babbage_urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.HTTPMethod = @"GET";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if ((httpResponse.statusCode == 201 || httpResponse.statusCode == 200) && data ) {
            [self parsePhotosFromData:data];
        }
        
    }];
}
-(void)TFAddImage:(imageObject *)t_img
{
    NSString *urlString = [NSString stringWithFormat:@"%@?collection_id=%@&photo_id=%@", [NSString EC2CollectionsEndpoint], self.uuid, t_img.id];
    
    NSURL   *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    req.HTTPMethod = @"PUT";
    
    NSOperationQueue *op = [NSOperationQueue new];
    
    __weak typeof(self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:req queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        
        if (resp.statusCode == 201 || resp.statusCode == 200) {
            
            NSDictionary    *notificationDict = @{ @"image" : t_img, @"collection" : self};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADDED_IMAGE_TO_STORY object:weakSelf userInfo:notificationDict];
            
            [weakSelf addImage:t_img];
        }
    }];
    
    
}
-(void)parsePhotosFromData:(NSData*) t_data
{
    if (t_data) {
        
        NSError *err;
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:t_data options:0 error:&err];
        
        for (NSDictionary *dict in arr) {
            imageObject *obj = [imageObject ImageObjectFromDictionary:dict];
            
            [self addImage:obj];
        }
    }
}

@end
