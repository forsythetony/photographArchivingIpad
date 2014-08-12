//
//  TFDataCommunicator+Helpers.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TFDataCommunicator+Helpers.h"
#import <SBJson4.h>

@implementation TFDataCommunicator (Helpers)

-(NSArray *)getDummyArray
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return json;
    
}

-(imageObject *)createImageObjectWithDictionary:(NSDictionary *)dict
{
    imageObject *newImage = [imageObject new];
    
    newImage.photoURL = [NSURL URLWithString:[dict objectForKey:jsonKeyImageLargeURL]];
    newImage.thumbNailURL = [NSURL URLWithString:dict[jsonKeyImageThumbnailURL]];
    
    newImage.date = [NSDate dateWithv1String:dict[jsonKeyImageInformation][jsonKeyImageInformation_dateTaken][jsonKeyImageInformation_dateTaken_dateString]];
    
    newImage.title = dict[jsonKeyImageInformation][jsonKeyImageInformation_title];
    
    newImage.uploader = dict[jsonKeyUploadInformation][jsonKeyUploadInformation_uploader];
    newImage.confidence = [NSString stringWithFormat:@"%@", [[[dict objectForKey:@"imageInformation"] objectForKey:@"dateTaken"] objectForKey:@"confidence"]];
    
    newImage.id = [NSString stringWithFormat:@"%@", dict[@"_id"]];
  
    return newImage;
    
}

@end
