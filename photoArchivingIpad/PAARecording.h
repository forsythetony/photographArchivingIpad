//
//  PAARecording.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAARecording : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *s3URL;
@property (nonatomic, strong) NSURL *localURL;
@property (nonatomic, assign) NSTimeInterval recordingLength;

@end
