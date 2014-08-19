//
//  NSDictionary+ObjectCreationHelpers.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/18/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "NSDictionary+ObjectCreationHelpers.h"
#import "NSDate+timelineStuff.h"

//  Constants

//  Image Information
NSString * const KEYImageInformation    = @"imageInformation";

    NSString * const KEYImageInformation_Title = @"title";

    //  Date Taken
    NSString * const KEYImageInformation_DateTaken = @"dateTaken";
    NSString * const KEYImageInformation_DateTaken_Confidence = @"confidence";
    NSString * const KEYImageInformation_DateTaken_DateString = @"dateString";

//  Upload Information
NSString * const KEYUploadInformation   = @"uploadInformation";

    NSString * const KEYUploadInformation_Uploader      = @"uploader";
    NSString * const KEYUploadInformation_ContentType   = @"contentType";

//  Stories
NSString * const KEYStories             = @"Stories";

    //  Stories Keys
    NSString * const KEYStories_Title   = @"title";
    NSString * const KEYStories_Storyteller = @"storyTeller";
    NSString * const KEYStories_RecordingURL = @"recordingUrl";
    NSString * const KEYStories_StringID = @"stringId";
    NSString * const KEYStories_Date    = @"date";

//  Other Information
NSString * const KEYImageURL            = @"imageURL";
NSString * const KEYThumbnailURL        = @"thumbnailURL";

@implementation NSDictionary (ObjectCreationHelpers)

-(imageObject *)convertToImageObject
{
    imageObject *newObject;
    
    NSDictionary *imageInfoDictionary, *uploadInfoDictionary;
    NSArray *storiesArray;
    
    newObject = [imageObject new];
    
    
    imageInfoDictionary     = [self objectForKey:KEYImageInformation];
    uploadInfoDictionary    = [self objectForKey:KEYUploadInformation];
    storiesArray            = [self objectForKey:KEYStories];
    
    //  Set Properties
    
    newObject.title = imageInfoDictionary[KEYImageInformation_Title];
    newObject.date  = imageInfoDictionary[KEYImageInformation_DateTaken][KEYImageInformation_DateTaken_DateString];
    newObject.confidence = imageInfoDictionary[KEYImageInformation_DateTaken][KEYImageInformation_DateTaken_Confidence];
    
    newObject.photoURL = [NSURL URLWithString:self[KEYImageURL]];
    newObject.thumbNailURL = [NSURL URLWithString:self[KEYThumbnailURL]];
    
    newObject.stories = [self createStoriesArrayWithArray:self[KEYStories]];
    
    return newObject;
}
-(NSArray*)createStoriesArrayWithArray:(NSArray*) storiesArray
{
    NSArray *newStoriesArray;
    
    NSMutableArray *storiesArr = [NSMutableArray new];
    
    if (!storiesArray) {
        return nil;
    }
    
    for (NSDictionary *dict in storiesArray) {
        
        Story *newStory = [Story new];
        
        newStory.title = dict[KEYStories_Title];
        newStory.recordingS3Url = [NSURL URLWithString:dict[KEYStories_RecordingURL]];
        newStory.storyTeller = [NSURL URLWithString:dict[KEYStories_Storyteller]];
        newStory.stringId = dict[KEYStories_StringID];
        newStory.storyDate = [NSDate dateWithv1String:dict[KEYStories_Date]];
        
        [storiesArr addObject:newStory];
        
    }
    
    newStoriesArray = [NSArray arrayWithArray:storiesArr];
    
    return newStoriesArray;
}
@end
