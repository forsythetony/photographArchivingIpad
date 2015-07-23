//
//  Story.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "Story.h"
#import "NSDate+timelineStuff.h"
#import "TFDataCommunicator.h"
#import "Story+Converters.h"

NSString* const STORY_DEFAULT_NULL_VALUE = @"Untitled";
@interface Story () <TFCommunicatorDelegate>

@property (nonatomic, strong) TFDataCommunicator *dataCom;

@end

@implementation Story
-(TFDataCommunicator *)dataCom
{
    if (!_dataCom) {
        _dataCom = [TFDataCommunicator sharedCommunicator];
    }
    
    return _dataCom;
}
-(NSString *)title
{
    if (!_title || [_title isEqualToString:@""]) {
        _title = STORY_DEFAULT_NULL_VALUE;
    }
    
    return _title;
}
-(NSString *)dateUploadedString
{
    if (_dateUploaded) {
        _dateUploadedString = [_dateUploaded displayDateOfType:sDateTypeSimple];
    }
    else
    {
        _dateUploadedString = @"xx/xx/xxxx";
    }
    
    return _dateUploadedString;
}

-(NSMutableDictionary *)updatedValues
{
    if (!_updatedValues) {
        _updatedValues = [NSMutableDictionary new];
    }
    
    return _updatedValues;
}
-(void)persistUpdates
{
    self.dataCom.delegate = self;
    [self.dataCom updateStory:self withUpdatedValues:[self getValueUpdatesString]];
    
}
-(void)didUpdateValuesForStory:(Story *)t_story
{
    [self updateValues];
    
    if ([self.delegate respondsToSelector:@selector(didUpdateValues:)]) {
        [self.delegate didUpdateValues:self];
    }
}

@end
