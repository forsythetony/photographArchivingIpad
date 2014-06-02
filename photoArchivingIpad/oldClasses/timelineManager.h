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

@class timelineManager;
@protocol timelineManagerDelegate <NSObject>

@optional
-(void)finishedUpdatedFrame:(pictureFrame*) frame withNewInformation:(NSDictionary*) info;



@end
@interface timelineManager : NSObject

@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* endDate;
@property (strong, nonatomic) UIView* TLView;

@property (nonatomic, assign) NSTimeInterval pureStart;
@property (nonatomic, assign) NSTimeInterval pureEnd;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) float viewSpan;

@property (nonatomic, assign) float xOffset;

@property (nonatomic, strong) NSMutableSet *imagesAdded;

@property (nonatomic, strong) NSArray* theImages;


@property (nonatomic, weak) id <timelineManagerDelegate> delegate;

-(NSNumber*)makeDuration;
-(CGPoint)createPointWithDate:(NSDate*) date;
-(void)setStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate andView:(UIView*) tlview andXOffsert:(float) offset;
-(void)setInitialPhotographs:(NSArray*) thePhotographs;
-(void)updateDateForPicture:(pictureFrame*) picture;




@end
