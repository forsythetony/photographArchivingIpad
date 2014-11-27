//
//  updatedConstants.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "updatedConstants.h"

//  Notification Stuff

NSString * const notify_userDidReturn = @"userDidReturnTextfieldCustomNotification";

//
//  S3 Stuff
//

NSString * const S3_secret_key = @"tXi3+4Ve3jjlFO5m39x81qTXqA8ry8JXCWOhndZF";
NSString * const S3_access_Key_ID = @"AKIAJM7QSXPIIZFS4IUQ";

NSString * const s3_bucket_name;
NSString * const s3_bucket_key;

NSString * const s3_error_already_owned = @"BucketAlreadyOwnedByYou";


//
//  API Stuff
//

NSString * const api_localhostBaseURL = @"http://localhost:3000";
NSString * const api_ec2BaseURL = @"http://54.187.204.201:3000";
NSString * const api_photosEndpoint = @"/photos";
NSString * const api_testUser = @"forsythetony";
NSString * const global_font_family = @"DINAlternate-Bold";
NSString * const api_usersEndpoint = @"/users";

NSString * const api_cleanFlagKey = @"cleanflag";
NSString * const api_cleanFlagValue = @"true";

NSString * const respKeys_responseStatus = @"responseStatus";
NSString * const respKeys_responseMessage = @"responseMessage";


//
//  Babbage
//

NSString * const api_babbage_baseURL = @"http://babbage.cs.missouri.edu/~arfv2b/photoArchiving";
NSString * const api_babbage_photos_endpoint = @"/photos";
NSString * const api_babbage_stories_endpoint = @"/stories";

//
//  API Keys
//

NSString * const keyDateTaken = @"dateTaken";
NSString * const keyDateConfidence = @"dateConfidence";
NSString * const keyInformation = @"imageInformation";
NSString * const keyTitle = @"title";
NSString * const keyImage = @"theImage";
NSString * const keyThumbnail = @"theThumbnail";
NSString * const keyDateUploaded = @"dateUploaded";
NSString * const keyImage_largeURL = @"largeImageURL";
NSString * const keyImage_thumbnailURL = @"thumbnailImageURL";
NSString * const keyImageURL = @"imageURL";

NSString * const jsonKeyImageInformation = @"imageInformation";
NSString * const jsonKeyImageInformation_title = @"title";
NSString * const jsonKeyImageInformation_dateTaken = @"dateTaken";
NSString * const jsonKeyImageInformation_dateTaken_dateString = @"dateString";
NSString * const jsonKeyImageInformation_dateTaken_dateConfidence = @"confidence";
NSString * const jsonKeyUploadInformation = @"uploadInformation";
NSString * const jsonKeyUploadInformation_uploader = @"uploader";
NSString * const jsonKeyUploadInformation_uploadDate = @"contentType";
NSString * const jsonKeyContentType = @"contentType";
NSString * const jsonKeyImageLargeURL = @"imageURL";
NSString * const jsonKeyImageThumbnailURL = @"thumbnailURL";

NSString * const jsonKeyStories = @"Stories";

NSString * const jsonKeyStories_Date = @"date";
NSString * const jsonKeyStories_StoryTeller = @"storyTeller";
NSString * const jsonKeyStories_RecordingURL = @"recordingUrl";
NSString * const jsonKeyStories_title = @"title";
NSString * const jsonKeyStories_recordingLength = @"recordingLength";

NSString * const APIAddStoryURLParam = @"?addStory=true";
NSString * const APISetupStoryURLParam = @"?addStory=setup";
NSString * const APIDeleteStoryWithID = @"?deleteStoryWithID=";
NSString * const jsonKeyStories_stringID = @"stringId";

NSString * const jsonKeyStories_AudioLength_milliseconds = @"milliseconds";
NSString * const jsonKeyStories_AudioLength_seconds = @"seconds";
NSString * const jsonKeyStories_AudioLength_minutes = @"minutes";
NSString * const jsonKeyStories_AudioLength_hours = @"hours";


//
//  Misc.
//
NSString * const contentTypeJPEG = @"image/jpeg";
NSString * const contentTypePNG = @"image/PNG";

@implementation updatedConstants

+ (NSString *)transferManagerBucket
{
    return [[NSString stringWithFormat:@"%@-%@", S3TRANSFERMANAGER_BUCKET, S3_access_Key_ID] lowercaseString];
}


//
//  Keys
//
+(NSString *)getKeyDateTaken
{
    return @"keyDateTakenJSON";
}

+(NSString *)getKeyDateUploaded
{
    return @"keyDateUploadedJSON";
}

+(NSString *)getKeyPhotographerName
{
    return @"keyPhotographerNameJSON";
}

+(NSString *)getKeyTitle
{
    return @"keyTitleJSON";
}


//
//  Labels
//
+(NSString *)getLabelDateTaken
{
    return @"Date Taken";
}
+(NSString *)getLabelTakenBy
{
    return @"Taken By";
}
+(NSString *)getLabelDateUploaded
{
    return @"Date Uploaded";
}
+(NSString *)getLabelTitle
{
    return @"Title";
}
+(NSString *)getLabelConfidence
{
    return @"Confidence";
}
+(NSString *)getLabelUploadedBy
{
    return @"Uploaded By";
}

//
//  Image Information Constants
//
+(NSString *)getFieldTypeTitle
{
    return @"fieldTitle";
}
+(NSString *)getFieldTypeDateTaken
{
    return @"fieldDateTaken";
}
+(NSString *)getFieldTypeHasEdited
{
    return @"fieldTypeHasEdited";
}


+(NSString*)getURLForUpdatingPhotoWithID:(NSString*) photoID andNewDate:(NSString*) newDateString
{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@?updateFlag=date&newValue=%@", api_ec2BaseURL , api_photosEndpoint , photoID , newDateString ];
    
    return url;
}
+(NSString*)getURLForBabbageUpdateWithID:(NSString*) photoID andNewDate:(NSString*) newDateString
{
    NSString *url = [NSString stringWithFormat:@"%@%@?photo_id=%@&action=update_date&new_date=%@", api_babbage_baseURL, api_babbage_photos_endpoint, photoID, newDateString];
    
    return url;
}
@end
