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
    _imageID = [[NSNumber numberWithInteger:idNumber] stringValue];
    
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
    
    _stories = imageObject.stories;
    
}
-(NSData*)createJSONReadyDict
{
    NSDictionary *dateTaken = @{jsonKeyImageInformation_dateTaken_dateString: (_dateTaken ? [_dateTaken displayDateOfType:sDateTypeSimple] : @"xx/xx/xxxx"),
                                jsonKeyImageInformation_dateTaken_dateConfidence : (_dateConfidence ? [_dateConfidence stringValue] : @"x")};
    
    
    NSDictionary *imageInformation = @{jsonKeyImageInformation_title: ( _title ? _title : @"No Title"),
                                       jsonKeyImageInformation_dateTaken : dateTaken};
    NSDictionary *uploadInformation = @{jsonKeyUploadInformation_uploader: (_uploader ? _uploader : @"unknown"),
                                        jsonKeyUploadInformation_uploadDate: (_dateUploaded ? [_dateUploaded displayDateOfType:sDateTypeSimple] : @"unknown")};
    
    NSMutableArray *storiesArray = [NSMutableArray new];
    

    if (_stories) {
        for (Story* story in _stories) {
            
            [storiesArray addObject:@{@"title": (story.title ? story.title : @"Untitled"),
                                     jsonKeyStories_StoryTeller : (story.storyTeller ? story.storyTeller : @"No Storyteller"),
                                     jsonKeyStories_Date : story.storyDate ? [story.storyDate displayDateOfType:sDateTypeSimple] : @"xx/xx/xxxx",
                                      jsonKeyStories_RecordingURL : story.recordingS3Url ? [story.recordingS3Url absoluteString] : @"invalid" }];
        }
    }
    
    
    
    NSDictionary *mainDictionary = @{jsonKeyImageInformation : imageInformation,
                                     jsonKeyUploadInformation : uploadInformation,
                                     jsonKeyContentType: (_contentType ? _contentType : @"unknown"),
                                     jsonKeyImageLargeURL : (_imageURL_large ? _imageURL_large.absoluteString : @"none"),
                                     jsonKeyImageThumbnailURL : (_imageURL_thumbnail ? _imageURL_thumbnail.absoluteString : @"none"),
                                     jsonKeyStories : (storiesArray ? [NSArray arrayWithArray:storiesArray] : @"none") };
    
    SBJson4Writer *dataWriter = [SBJson4Writer new];
    
    NSData *dataObj = [dataWriter dataWithObject:mainDictionary];
    
    return dataObj;
}
-(NSDictionary *)createJSONReadyDict2
{
    NSDictionary *dateTaken = @{jsonKeyImageInformation_dateTaken_dateString: (_dateTaken ? [_dateTaken displayDateOfType:sDateTypeSimple] : @"xx/xx/xxxx"),
                                jsonKeyImageInformation_dateTaken_dateConfidence : (_dateConfidence ? [_dateConfidence stringValue] : @"x")};
    
    
    NSDictionary *imageInformation = @{jsonKeyImageInformation_title: ( _title ? _title : @"No Title"),
                                       jsonKeyImageInformation_dateTaken : dateTaken};
    NSDictionary *uploadInformation = @{jsonKeyUploadInformation_uploader: (_uploader ? _uploader : @"unknown"),
                                        jsonKeyUploadInformation_uploadDate: (_dateUploaded ? [_dateUploaded displayDateOfType:sDateTypeSimple] : @"unknown")};
    
    NSMutableArray *storiesArray = [NSMutableArray new];
    
    
    if (_stories) {
        for (Story* story in _stories) {
            
            [storiesArray addObject:@{@"title": (story.title ? story.title : @"Untitled"),
                                      jsonKeyStories_StoryTeller : (story.storyTeller ? story.storyTeller : @"No Storyteller"),
                                      jsonKeyStories_Date : story.storyDate ? [story.storyDate displayDateOfType:sDateTypeSimple] : @"xx/xx/xxxx",
                                      jsonKeyStories_RecordingURL : story.recordingS3Url ? [story.recordingS3Url absoluteString] : @"invalid" }];
        }
    }
    
    
    
    NSDictionary *mainDictionary = @{jsonKeyImageInformation : imageInformation,
                                     jsonKeyUploadInformation : uploadInformation,
                                     jsonKeyContentType: (_contentType ? _contentType : @"unknown"),
                                     jsonKeyImageLargeURL : (_imageURL_large ? _imageURL_large.absoluteString : @"none"),
                                     jsonKeyImageThumbnailURL : (_imageURL_thumbnail ? _imageURL_thumbnail.absoluteString : @"none"),
                                     jsonKeyStories : (storiesArray ? [NSArray arrayWithArray:storiesArray] : @"none") };
    

    return mainDictionary;
}
@end

