//
//  Story+Converters.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "Story+Converters.h"
#import "NSDate+timelineStuff.h"

NSString* const kJSON_STORY_DATE_UPLOADED = @"date_uploaded";
NSString* const kJSON_STORY_FORMAT = @"format";
NSString* const kJSON_STORY_LENGTH_S = @"length_s";
NSString* const kJSON_STORY_PHOTO_ID = @"photo_id";
NSString* const kJSON_STORY_ID = @"story_id";
NSString* const kJSON_STORY_STORYTELLER = @"storyteller";
NSString* const kJSON_STORY_TITLE = @"title";
NSString* const kJSON_STORY_UPLOADER = @"uploader";
NSString* const kJSON_STORY_URL = @"url";
NSString* const kJSON_STORY_DATE = @"date";

@implementation Story (Converters)

-(void)updateValues
{
    NSString *title = [self.updatedValues objectForKey:kJSON_STORY_TITLE];
    NSString *storyteller = [self.updatedValues objectForKeyedSubscript:kJSON_STORY_STORYTELLER];
    
    if (storyteller) {
        self.storyTeller = storyteller;
        [self.updatedValues removeObjectForKey:kJSON_STORY_STORYTELLER];
    }
    if (title) {
        self.title = title;
        [self.updatedValues removeObjectForKey:kJSON_STORY_TITLE];
    }
}
-(NSString *)getValueUpdatesString
{
    NSMutableString *valuesString = [[NSMutableString alloc] initWithString:@""];
    
    
    [self.updatedValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        [valuesString appendString:[NSString stringWithFormat:@"&%@=%@", key, obj]];
        
    }];
    
    
    return [NSString stringWithString:valuesString];
}
-(void)updateToNewStoryTeller:(NSString *)t_newStoryteller
{
    [self.updatedValues setObject:t_newStoryteller forKey:kJSON_STORY_STORYTELLER];
}
-(void)updateToNewTitle:(NSString *)t_newTitle
{
    [self.updatedValues setObject:t_newTitle forKey:kJSON_STORY_TITLE];
}
-(NSDictionary *)ConvertToUploadableDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.storyTeller) {
        [dict setObject:self.storyTeller forKey:kJSON_STORY_STORYTELLER];
    }
    
    if (self.title) {
        [dict setObject:self.title forKey:kJSON_STORY_TITLE];
    }
    
    if (self.recordingLength) {
        [dict setObject:self.recordingLength forKey:kJSON_STORY_LENGTH_S];
    }
    
    if (self.storyDate) {
        
        [dict setObject:[self.storyDate displayDateOfType:sDateTypeBabbageURL] forKey:kJSON_STORY_DATE];
    }
    
    if (self.recordingS3Url) {
        [dict setObject:[self.recordingS3Url absoluteString] forKey:kJSON_STORY_URL];
    }
    
    if (self.format) {
        [dict setObject:self.format forKey:kJSON_STORY_FORMAT];
    }
    
    if (self.uploader) {
        [dict setObject:self.uploader forKey:kJSON_STORY_UPLOADER];
    }
    
    
    return [NSDictionary dictionaryWithDictionary:dict];

}
+(instancetype)StoryFromDictionary:(NSDictionary *)t_dict
{
    Story *story = [[Story alloc] init];
    
    NSString *title = t_dict[kJSON_STORY_TITLE];
    NSString *dateUploaded = t_dict[kJSON_STORY_DATE_UPLOADED];
    NSString *format = t_dict[kJSON_STORY_FORMAT];
    NSString *storyID = t_dict[kJSON_STORY_ID];
    NSString *uploader = t_dict[kJSON_STORY_UPLOADER];
    NSString *url = t_dict[kJSON_STORY_URL];
    NSNumber *length_s = t_dict[kJSON_STORY_LENGTH_S];
    
    if (t_dict[kJSON_STORY_STORYTELLER] == [NSNull null])
    {
        
    }
    else
    {
        story.storyTeller = t_dict[kJSON_STORY_STORYTELLER];
    }
    
    if (title) {
        story.title = title;
    }
    
    if (dateUploaded) {
        story.dateUploaded = [NSDate dateWithv2String:dateUploaded];
    }
    
    if (format) {
    }
    
    if (storyID) {
        story.stringId = storyID;
    }
    
    if (uploader) {
    
    }
    
    if (url) {
        story.recordingS3Url = [NSURL URLWithString:url];
    }
    
    
    if (length_s) {
        story.recordingLength = length_s;
    }
    
    
    
    return story;
}

@end
