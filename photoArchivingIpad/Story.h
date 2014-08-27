//
//  Story.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Story : NSObject

@property (nonatomic, strong) NSString *storyTeller;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *recordingURL;
@property (nonatomic, strong) NSDate *storyDate;

@property (nonatomic, strong) NSURL *recordingS3Url;
@property (nonatomic, strong) NSNumber *recordingLength;
@property (nonatomic, strong) NSString *stringId;


@end
