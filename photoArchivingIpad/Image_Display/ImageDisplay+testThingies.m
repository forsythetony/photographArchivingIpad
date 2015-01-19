//
//  ImageDisplay+testThingies.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "ImageDisplay+testThingies.h"

@implementation ImageDisplay (testThingies)

-(NSArray *)getTestStories
{
    Story *storyOne = [ Story new];
    
    storyOne.title = @"hi";
    storyOne.storyTeller = @"Anthony";
    storyOne.storyDate = [NSDate date];
    
    Story *storyTwo = [ Story new];
    
    storyTwo.title = @"Bye";
    storyTwo.storyTeller = @"Mike";
    storyTwo.storyDate = [NSDate date];
    
    return @[storyOne, storyTwo];
    
}
@end
