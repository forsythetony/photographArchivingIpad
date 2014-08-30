//
//  photoUploadingConstants.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

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

//  JSON Package Constants

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

extern NSString * const APIAddStoryURLParam;
extern NSString * const APISetupStoryURLParam;
extern NSString * const APIDeleteStoryWithID;


@class photoUploadingConstants;

@interface photoUploadingConstants : NSObject


+(NSString*)getLabelDateTaken;
+(NSString*)getLabelDateUploaded;
+(NSString*)getLabelTakenBy;
+(NSString*)getLabelTitle;
+(NSString*)getLabelUploadedBy;
+(NSString*)getLabelConfidence;

+(NSString*)getKeyDateTaken;
+(NSString*)getKeyDateUploaded;
+(NSString*)getKeyPhotographerName;
+(NSString*)getKeyTitle;


/*
 Image Information Constants
 */
+(NSString*)getFieldTypeTitle;
+(NSString*)getFieldTypeDateTaken;
+(NSString*)getFieldTypeHasEdited;


@end