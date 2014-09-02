//
//  imageObject.h
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

@interface imageObject : NSObject

@property (nonatomic, strong) Story* myStory;

@property (nonatomic, strong) NSArray* stories;

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *uploader;
@property (nonatomic, strong) NSString *confidence;

@property (nonatomic, strong) NSURL* photoURL;
@property (nonatomic, strong) NSURL* thumbNailURL;
@property (nonatomic, strong) UIImage *largeImage;
@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, strong) NSURL* recordingURL;
@property (nonatomic, assign) BOOL isDateKnown;
@property (nonatomic, strong) NSDictionary *imageInformation;
@property (nonatomic, strong) NSNumber* centerXoffset;

-(NSMutableDictionary*)informationAsMutableDictionary;
-(void)addStory:(Story*) newStory;

@end
