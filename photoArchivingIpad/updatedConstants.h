//
//  updatedConstants.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USELOCALHOST NO

//  Notification Stuff

extern NSString * const notify_userDidReturn;


//  Networking Stuff

extern NSString * const api_localhostBaseURL;
extern NSString * const api_ec2BaseURL;

extern NSString * const api_photosEndpoint;
extern NSString * const api_testUser;
extern NSString * const api_usersEndpoint;

extern NSString * const api_cleanFlagKey;
extern NSString * const api_cleanFlagValue;

//  Response Status Stuff

extern NSString * const respKeys_responseStatus;
extern NSString * const respKeys_responseMessage;

//  Style stuff
extern NSString * const global_font_family;

//  S3 Bucket Stuff

extern NSString * const S3_secret_key;
extern NSString * const S3_access_Key_ID;

extern NSString * const s3_bucket_name;
extern NSString * const s3_bucket_key;

//  HTTP Stuff

extern NSString * const contentTypeJPEG;
extern NSString * const contentTypePNG;

#define kSmallFileSize 1024*1024*4.8

#define S3TRANSFERMANAGER_BUCKET         @"s3-bucket-test"
#define kKeyForSmallFile                @"tm-small-file-0"

extern NSString * const s3_error_already_owned;

@interface updatedConstants : NSObject

+ (NSString *) transferManagerBucket;

@end