//
//  Story+StoryHelpers.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/12/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "Story+StoryHelpers.h"
#import "photoUploadingConstants.h"
#import "NSDate+timelineStuff.h"

@implementation Story (StoryHelpers)

-(NSDictionary *)convertToDictionary
{
    NSString *dateString = [self.storyDate displayDateOfType:sDateTypeSimple];
    NSString *recordingURL = [self.audioRecording.s3URL absoluteString];
    NSString *storyTeller = (self.storyTeller ? self.storyTeller : @"Noone");
    NSString *titleString = (self.title ? self.title : @"Untitled");
    NSString *stringID = self.stringId;
    NSString *recordingLength = [NSString stringWithFormat:@"%d", self.audioRecording.recordingLength];
    
    NSDictionary *mainDict = @{jsonKeyStories_Date: dateString,
                               jsonKeyStories_RecordingURL: recordingURL,
                               jsonKeyStories_StoryTeller: storyTeller,
                               jsonKeyStories_title : titleString,
                               jsonKeyStories_stringID : stringID,
                               jsonKeyStories_recordingLength : recordingLength};
    
    return mainDict;
    
}
-(void)setRandomId
{
    self.stringId = [self generateRandomID];
}
-(NSString*)generateRandomID
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return [NSString stringWithString:s];
}
+(id)setupWithRandomID
{
    Story* newStory = [[self class] new];
    
    newStory.stringId = [newStory generateRandomID];
    
    return newStory;
}

@end
