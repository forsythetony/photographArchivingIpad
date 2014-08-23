//
//  ImagePackage.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+timelineStuff.h"
#import "UIImage+imageAdditions.h"
#import "photoUploadingConstants.h"
#import "imageObject.h"


@interface ImagePackage : NSObject

@property (nonatomic, strong) UIImage* image_large;
@property (nonatomic, strong) UIImage* image_thumbnail;

@property (nonatomic, strong) NSURL* imageURL_large;
@property (nonatomic, strong) NSURL* imageURL_thumbnail;

@property (nonatomic, strong) NSDate* dateTaken;
@property (nonatomic, strong) NSNumber* dateConfidence;

@property (nonatomic, strong) NSDate* dateUploaded;
@property (nonatomic, strong) NSString* uploader;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* contentType;

@property (nonatomic, strong) NSArray* stories;

@property (nonatomic, strong) NSString* imageID;

-(void)setDateWithString:(NSString*) dateString;
-(void)setDateConfidenceWithInt:(NSInteger) dateConfidence;
-(void)setThumbnailURLWithString:(NSString*) urlString;
-(void)setLargeImageURLWithString:(NSString*) urlString;
-(void)setImageIDWithNumber:(NSInteger) idNumber;
-(void)setContentsWithImageObject:(imageObject*) imageObject;
-(NSData*)createJSONReadyDict;
-(NSDictionary*)createJSONReadyDict2;

@end
