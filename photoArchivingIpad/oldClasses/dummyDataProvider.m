//
//  dummyDataProvider.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "dummyDataProvider.h"

@implementation dummyDataProvider

-(NSArray *)getImageObjects
{
    NSMutableArray *imageObjects = [NSMutableArray new];
    NSMutableArray *imageFrames = [NSMutableArray new];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"M/dd/yyyy"];
    
    
    
    NSArray *imageData = @[ @{@"imageName": @"christmas.JPG",
                              @"thumbName" : @"christmas_tn.png",
                              @"title" : @"Christmas with the family",
                              @"offset" : [NSNumber numberWithFloat:0.0],
                              @"date"       : [formatter dateFromString:@"6/22/1954"]},
                            
                            @{@"imageName"  : @"fredAndFreddie.JPG",
                              @"thumbName"  : @"fredAndFreddie_tn.png",
                              @"title"      : @"Freddie and his Father",
                              @"offset"     : [NSNumber numberWithFloat:300.0],
                              @"date"       : [formatter dateFromString:@"5/22/1957"]}
                            ];
    
    
    
    for (NSDictionary* dataEntry in imageData) {
        imageObject *obj = [imageObject new];
        pictureFrame *frame = [pictureFrame createFrame];
        
        obj.image = [UIImage imageNamed:[dataEntry objectForKey:@"thumbName"]];
        obj.centerXoffset = [dataEntry objectForKey:@"offset"];
        obj.title = [dataEntry objectForKey:@"title"];
        obj.date = [dataEntry objectForKey:@"date"];
        
        [frame setImageObject:obj];
        [frame.theImage setImage:obj.image];
        
        [frame setFrame:CGRectMake(0.0, 0.0, 75.0, 75.0)];
        [imageFrames addObject:frame];
    }
    
    
    return [NSArray arrayWithArray:imageFrames];
}
@end