//
//  timelineManager.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+timelineStuff.h"
#import "pictureFrame.h"
#import "TFDataCommunicator.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFImageCollectionView.h"
#import "TFImageCollection+Converters.h"


@class timelineManager;

@protocol timelineManagerDelegate <NSObject>

@optional

-(void)finishedUpdatedFrame:(pictureFrame*) frame withNewInformation:(NSDictionary*) info;
-(void)shouldAddPanGestureRecognizerForCollectionView:(TFImageCollectionView*) t_collView;
-(void)doneLoadingCollections;

@end


@interface timelineManager : NSObject


@property (strong, nonatomic) NSMutableSet  *imagesAdded;
@property (strong, nonatomic) NSArray       *theImages;
@property (strong, nonatomic) NSDate        *startDate;
@property (strong, nonatomic) NSDate        *endDate;
@property (strong, nonatomic) UIView        *TLView;
@property (nonatomic, weak) UIScrollView  *timelineScrollView;

@property (nonatomic, assign, readonly) BOOL isOverCollectionView;

@property (nonatomic, assign) CGPoint transPoint;

@property (nonatomic, assign) NSTimeInterval pureStart;
@property (nonatomic, assign) NSTimeInterval pureEnd;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) float viewSpan;
@property (nonatomic, assign) float xOffset;

@property (nonatomic, strong) NSMutableArray *savedCenters;

@property (nonatomic, strong) NSValue *lineCenter;

@property (nonatomic, strong) NSArray  *savedYears;
@property (nonatomic, strong) NSMutableArray *collectionsList;

@property (nonatomic, weak) id <timelineManagerDelegate> delegate;

-(void)bringSubyearsToFront;
-(NSNumber*)makeDuration;
-(CGPoint)createPointWithDate:(NSDate*) date;
-(void)setStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate andView:(UIView*) tlview andXOffsert:(float) offset;
-(void)setInitialPhotographs:(NSArray*) thePhotographs;
-(NSDate*)createDateObjectFromPoint:(CGPoint) point;
-(NSDate*)getNewDateForFrame:(pictureFrame*) Pframe;
-(void)addCollectionsFromArray:(NSArray*) t_collections;
-(void)setTransPoint:(CGPoint) t_trans withImage:(imageObject*) t_img;
@end
