//
//  Story+StoryHelpers.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/12/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "Story.h"

@interface Story (StoryHelpers)

-(NSDictionary*)convertToDictionary;
-(void)setRandomId;

+(id)setupWithRandomID;
@end
