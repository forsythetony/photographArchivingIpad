//
//  imageObject.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "imageObject.h"
#import "updatedConstants.h"
#import "TFDataCommunicator.h"

@interface imageObject () <TFCommunicatorDelegate, StoryDelegate> {
    
    Story *storyBeingAdded;
    
}

@property (nonatomic, strong) TFDataCommunicator    *dataCom;


@end
@implementation imageObject

-(NSMutableDictionary *)informationAsMutableDictionary
{
    return [NSMutableDictionary dictionaryWithObjects:@[(_title ? _title : @"empty")
                                                        ]
                                              forKeys:@[[updatedConstants getFieldTypeTitle]]];
    
}
-(void)addStory:(Story *)newStory
{
    
    storyBeingAdded = newStory;
    newStory.delegate = self;
    
    self.dataCom.delegate = self;
    [self.dataCom addStoryToImage:newStory imageObject:self];

    
}
-(void)populateStories
{
    [self.dataCom pullStoriesListForPhoto:self.id];
}
-(void)finishedAddingStoryWithNewId:(NSString *)t_newID
{
    if (t_newID) {
        NSMutableArray *stories = [NSMutableArray arrayWithArray:self.stories];
        
        storyBeingAdded.stringId = t_newID;
        [stories addObject:storyBeingAdded];
        
        self.stories = [NSArray arrayWithArray:stories];
        
        [self.delegate didFinishAddingStoryWithSuccess:YES];

    }
    else
    {
        [self.delegate didFinishAddingStoryWithSuccess:NO];
    }
}
-(void)finishedAddingStoryWithHTTPResponseCode:(NSInteger)responseCode
{
    if (responseCode == 201 || responseCode == 200) {
        
        NSMutableArray *stories = [NSMutableArray arrayWithArray:self.stories];
        [stories addObject:storyBeingAdded];
        
        self.stories = [NSArray arrayWithArray:stories];
        
        [self.delegate didFinishAddingStoryWithSuccess:YES];
    }
    else
    {
        [self.delegate didFinishAddingStoryWithSuccess:NO];
    }
}
-(void)finishedPullingStoriesList:(NSArray *)list
{
    self.stories = list;
    
    if ([self.delegate respondsToSelector:@selector(didFinishPopulatingStories:)]) {
        [self.delegate didFinishPopulatingStories:self];
    }
}
-(TFDataCommunicator *)dataCom
{
    if (!_dataCom) {
        _dataCom = [TFDataCommunicator sharedCommunicator];
        _dataCom.delegate = self;
    }
    
    return _dataCom;
}
-(void)deleteStoryAtIndex:(NSInteger)t_index
{
    Story *deletedStory = self.stories[t_index];

    if (deletedStory) {
        [self deleteStoryWithId:deletedStory.stringId];
    }
}
-(void)deleteStoryWithId:(NSString *)t_id
{
    __block BOOL idExists = NO;
    self.dataCom.delegate = self;
    
    [self.stories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Story *story = (Story*)obj;
        
        if ([t_id isEqualToString:story.stringId]) {
            idExists = YES;
        }
        
    }];
    
    if (idExists) {
        [self.dataCom deleteStoryWithID:t_id];
    }
}
-(void)finishedDeletingStoryWithID:(NSString *)t_id didDelete:(BOOL)t_didDelete
{
    if (t_didDelete) {
        
        NSInteger deletionIndex = -1;
        NSInteger index = 0;
        
        for (Story *story in self.stories) {
            if ([story.stringId isEqualToString:t_id]) {
                deletionIndex = index;
            }
            index++;
        }
        
        
        [self.delegate didFinishDeletingStoryAtIndex:deletionIndex];
    }
}
-(void)didUpdateValues:(Story *)t_story
{
    [self.delegate shouldUpdateStories];
}
-(void)localDeleteStoryAtIndex:(NSInteger)t_index
{
    NSMutableArray *stories = [NSMutableArray arrayWithArray:self.stories];

    [stories removeObjectAtIndex:t_index];
    
    self.stories = [NSArray arrayWithArray:stories];
    
}
-(void)setDate:(NSDate *)date
{
    _date = date;
    
    _pureDate = @([date timeIntervalSinceBeginning]);
}
@end
