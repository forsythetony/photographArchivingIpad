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
    [self.delegate TFImageCollectionDidAddImageObject:t_image];
    [self.images addObject:t_image];
}
-(imageObject *)firstImage
{
    return self.images.firstObject;
}
-(NSUInteger)imageCount
{
    return [self.totalImages integerValue];
}
-(NSDate *)firstDate
{
    NSDate *firstDate = nil;
    
    for (imageObject *img in self.images) {
        
        NSDate *tempDate = img.date;
        
        if (!firstDate) {
            firstDate = tempDate;
        }
        else
        {
            if ([tempDate isBeforeData:firstDate])
            {
                firstDate = tempDate;
            }
        }
    }
    
    return firstDate;
}
-(NSDate *)lastDate
{
    NSDate *lastDate = nil;
    
    for (imageObject *img in self.images) {
        
        NSDate *temp = img.date;
        
        if (lastDate == nil) {
            lastDate = temp;
        }
        else
        {
            if (![temp isBeforeData:lastDate]) {
                lastDate = temp;
            }
        }
    }
    
    return lastDate;
}
@end
