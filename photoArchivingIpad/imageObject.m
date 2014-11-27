//
//  imageObject.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "imageObject.h"
#import "updatedConstants.h"

@implementation imageObject

-(NSMutableDictionary *)informationAsMutableDictionary
{
    return [NSMutableDictionary dictionaryWithObjects:@[(_title ? _title : @"empty")
                                                        ]
                                              forKeys:@[[updatedConstants getFieldTypeTitle]]];
    
}
-(void)addStory:(Story *)newStory
{
    
    if (_stories == nil) {
        _stories = [NSArray arrayWithObject:newStory];
    }
    else
    {
        NSMutableArray *storiesArr = [NSMutableArray arrayWithArray:_stories];
        
        [storiesArr addObject:newStory];
        
        _stories = [NSArray arrayWithArray:storiesArr];
       
        
    }
}


@end
