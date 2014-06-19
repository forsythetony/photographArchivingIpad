//
//  updatedConstants.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "updatedConstants.h"

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

NSString * const S3_secret_key = @"tXi3+4Ve3jjlFO5m39x81qTXqA8ry8JXCWOhndZF";
NSString * const S3_access_Key_ID = @"AKIAJM7QSXPIIZFS4IUQ";

NSString * const s3_bucket_name;
NSString * const s3_bucket_key;

NSString * const s3_error_already_owned = @"BucketAlreadyOwnedByYou";



@implementation updatedConstants

+ (NSString *)transferManagerBucket
{
    return [[NSString stringWithFormat:@"%@-%@", S3TRANSFERMANAGER_BUCKET, S3_access_Key_ID] lowercaseString];
}

@end
