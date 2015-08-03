//
//  TFImageCollection.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imageObject.h"

@protocol TFImageCollectionDelegate <NSObject>

-(void)TFImageCollectionDidAddImageObject:(imageObject*) t_obj;

@end

@interface TFImageCollection : NSObject

@property (nonatomic, weak) id<TFImageCollectionDelegate> delegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSDate *date_created;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSDate *approx_date;
@property (nonatomic, strong) NSNumber *totalImages;
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, assign) BOOL completedDownloadingImages;

@property (nonatomic, assign, readonly) NSUInteger imageCount;
@property (nonatomic, strong) NSMutableArray    *images;
@property (nonatomic, strong) imageObject *firstImage;

-(void)addImage:(imageObject*)  t_image;

@end
