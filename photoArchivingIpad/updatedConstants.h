//
//  updatedConstants.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  Testing
//
#define USELOCALHOST NO



//
//  Notification Stuff
//
extern NSString * const notify_userDidReturn;



//
//  API
//
extern NSString * const api_localhostBaseURL;
extern NSString * const api_ec2BaseURL;

extern NSString * const api_photosEndpoint;
extern NSString * const api_usersEndpoint;

extern NSString * const api_testUser;

extern NSString * const api_cleanFlagKey;
extern NSString * const api_cleanFlagValue;

extern NSString * const APIAddStoryURLParam;
extern NSString * const APISetupStoryURLParam;
extern NSString * const APIDeleteStoryWithID;
extern NSString * const APIUpdatePhotoDateWithID;

//  Babbage API

extern NSString * const api_babbage_baseURL;
extern NSString * const api_babbage_photos_endpoint;
extern NSString * const api_babbage_stories_endpoint;
//
//  API Package Keys
//
extern NSString * const keyDateTaken;
extern NSString * const keyDateConfidence;
extern NSString * const keyInformation;
extern NSString * const keyTitle;
extern NSString * const keyImage;
extern NSString * const keyThumbnail;
extern NSString * const keyDateUploaded;
extern NSString * const keyImage_largeURL;
extern NSString * const keyImage_thumbnailURL;
extern NSString * const keyImageURL;

extern NSString * const jsonKeyImageInformation;
extern NSString * const jsonKeyImageInformation_title;
extern NSString * const jsonKeyImageInformation_dateTaken;
extern NSString * const jsonKeyImageInformation_dateTaken_dateString;
extern NSString * const jsonKeyImageInformation_dateTaken_dateConfidence;
extern NSString * const jsonKeyUploadInformation;
extern NSString * const jsonKeyUploadInformation_uploader;
extern NSString * const jsonKeyUploadInformation_uploadDate;
extern NSString * const jsonKeyContentType;
extern NSString * const jsonKeyImageLargeURL;
extern NSString * const jsonKeyImageThumbnailURL;

extern NSString * const jsonKeyStories;
extern NSString * const jsonKeyStories_Date;
extern NSString * const jsonKeyStories_StoryTeller;
extern NSString * const jsonKeyStories_RecordingURL;
extern NSString * const jsonKeyStories_title;
extern NSString * const jsonKeyStories_stringID;
extern NSString * const jsonKeyStories_recordingLength;

extern NSString * const jsonKeyStories_AudioLength_milliseconds;
extern NSString * const jsonKeyStories_AudioLength_seconds;
extern NSString * const jsonKeyStories_AudioLength_minutes;
extern NSString * const jsonKeyStories_AudioLength_hours;


//
//  Response Status
//
extern NSString * const respKeys_responseStatus;
extern NSString * const respKeys_responseMessage;



//
//  Style
//
extern NSString * const global_font_family;



//
//  S3
//

extern NSString * const s3_bucket_name;
extern NSString * const s3_bucket_key;

extern NSString * const s3_error_already_owned;


#define kSmallFileSize 1024*1024*4.8

#define S3TRANSFERMANAGER_BUCKET         @"s3-bucket-test"
#define kKeyForSmallFile                @"tm-small-file-0"



//
//  Misc.
//
extern NSString * const contentTypeJPEG;
extern NSString * const contentTypePNG;



@interface updatedConstants : NSObject

//
//  S3
//
+ (NSString *) transferManagerBucket;


//
//  Labels
//
+(NSString*)getLabelDateTaken;
+(NSString*)getLabelDateUploaded;
+(NSString*)getLabelTakenBy;
+(NSString*)getLabelTitle;
+(NSString*)getLabelUploadedBy;
+(NSString*)getLabelConfidence;


//
//  JSON Keys
//
+(NSString*)getKeyDateTaken;
+(NSString*)getKeyDateUploaded;
+(NSString*)getKeyPhotographerName;
+(NSString*)getKeyTitle;


//
//  Misc.
//
+(NSString*)getFieldTypeTitle;
+(NSString*)getFieldTypeDateTaken;
+(NSString*)getFieldTypeHasEdited;

+(NSString*)getURLForUpdatingPhotoWithID:(NSString*) photoID andNewDate:(NSString*) newDateString;
+(NSString*)getURLForBabbageUpdateWithID:(NSString*) photoID andNewDate:(NSString*) newDateString;
@end