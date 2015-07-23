//
//  Story+Converters.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "Story.h"

@interface Story (Converters)
+(instancetype)StoryFromDictionary:(NSDictionary*) t_dict;
-(NSDictionary*)ConvertToUploadableDictionary;
-(NSString*)getValueUpdatesString;
-(void)updateToNewTitle:(NSString *)t_newTitle;
-(void)updateToNewStoryTeller:(NSString*)t_newStoryteller;

-(void)updateValues;

@end
