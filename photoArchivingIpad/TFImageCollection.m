//
//  TFImageCollection.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFImageCollection.h"
#import "NSDate+timelineStuff.h"

@interface TFImageCollection ()

@end

@implementation TFImageCollection

+(instancetype)new
{
    TFImageCollection *coll = [[TFImageCollection alloc] init];
    
    coll.completedDownloadingImages = NO;
    
    return coll;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.completedDownloadingImages = NO;
    }
    
    return self;
}
-(NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray new];
    }
    
    return _images;
}
-(void)addImage:(imageObject *)t_image
{
    if ([self.delegate respondsToSelector:@selector(TFImageCollectionDidAddImageObject:)]) {
        [self.delegate TFImageCollectionDidAddImageObject:t_image];
    }
    
    [self.images addObject:t_image];
    [self sortImagesByDate];
}
-(void)sortImagesByDate
{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"pureDate" ascending:YES];
    [self.images sortUsingDescriptors:@[sorter]];
}
-(imageObject *)firstImage
{
    return self.images.firstObject;
}
-(NSUInteger)imageCount
{
    return self.images.count;
}
-(NSDate *)firstDate
{
    NSDate *firstDate = nil;
    
    firstDate = [(imageObject*)self.images.firstObject date];
    
    return firstDate;
}
-(NSDate *)lastDate
{
    NSDate *lastDate = nil;
    
    lastDate = [(imageObject*)self.images.lastObject date];
    
    return lastDate;
}
@end
