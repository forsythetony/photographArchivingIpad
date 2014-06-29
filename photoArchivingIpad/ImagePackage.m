//
//  ImagePackage.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "ImagePackage.h"
#import <SBJson4.h>

@implementation ImagePackage

-(void)setDateWithString:(NSString *)dateString
{
    _dateTaken = [NSDate dateWithv1String:dateString];
}
-(void)setDateConfidenceWithInt:(NSInteger)dateConfidence
{
    _dateConfidence = [NSNumber numberWithInteger:dateConfidence];
}
-(void)setThumbnailURLWithString:(NSString *)urlString
{
    _imageURL_thumbnail = [NSURL URLWithString:urlString];
}
-(void)setLargeImageURLWithString:(NSString *)urlString
{
    _imageURL_large = [NSURL URLWithString:urlString];
}
-(void)setImageIDWithNumber:(NSInteger)idNumber
{
    _imageID = [NSNumber numberWithInteger:idNumber];
    
}
-(void)setContentsWithImageObject:(imageObject *)imageObject
{
    _imageID = imageObject.id;
    _title = imageObject.title;
    
    _dateTaken = imageObject.date;
    _dateConfidence = [NSNumber numberWithInteger:[imageObject.confidence integerValue]];
    
    _uploader = imageObject.uploader;
    
    _imageURL_large = imageObject.photoURL;
    _imageURL_thumbnail = imageObject.thumbNailURL;
    
    
}
-(NSData*)createJSONReadyDict
{
    NSDictionary *dateTaken = @{jsonKeyImageInformation_dateTaken_dateString: (_dateTaken ? [_dateTaken displayDateOfType:sDateTypeSimple] : @"xx/xx/xxxx"),
                                jsonKeyImageInformation_dateTaken_dateConfidence : (_dateConfidence ? [_dateConfidence stringValue] : @"x")};
    
    
    NSDictionary *imageInformation = @{jsonKeyImageInformation_title: ( _title ? _title : @"No Title"),
                                       jsonKeyImageInformation_dateTaken : dateTaken};
    NSDictionary *uploadInformation = @{jsonKeyUploadInformation_uploader: (_uploader ? _uploader : @"unknown"),
                                        jsonKeyUploadInformation_uploadDate: (_dateUploaded ? [_dateUploaded displayDateOfType:sDateTypeSimple] : @"unknown")};
    
    NSDictionary *mainDictionary = @{jsonKeyImageInformation : imageInformation,
                                     jsonKeyUploadInformation : uploadInformation,
                                     jsonKeyContentType: (_contentType ? _contentType : @"unknown"),
                                     jsonKeyImageLargeURL : (_imageURL_large ? _imageURL_large.absoluteString : @"none"),
                                     jsonKeyImageThumbnailURL : (_imageURL_thumbnail ? _imageURL_thumbnail.absoluteString : @"none")};
    
    SBJson4Writer *dataWriter = [SBJson4Writer new];
    
    NSData *dataObj = [dataWriter dataWithObject:mainDictionary];
    
    return dataObj;
}
@end

