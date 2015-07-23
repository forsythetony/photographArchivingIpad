//
//  Story.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAARecording.h"

@protocol StoryDelegate;

@interface Story : NSObject

@property (nonatomic, weak) id<StoryDelegate> delegate;
@property (nonatomic, strong) NSString *storyTeller;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *recordingURL;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *uploader;

@property (nonatomic, strong) NSMutableDictionary *updatedValues;

@property (nonatomic, strong) NSDate *storyDate;

@property (nonatomic, strong) NSDate *dateUploaded;
@property (nonatomic, strong) NSString *dateUploadedString;

@property (nonatomic, strong) NSURL *recordingS3Url;
@property (nonatomic, strong) NSNumber *recordingLength;
@property (nonatomic, strong) NSString *stringId;

@property (nonatomic, strong) PAARecording *audioRecording;

-(void)persistUpdates;

@end

@protocol StoryDelegate <NSObject>

@optional
-(void)didUpdateValues:(Story*) t_story;

@end