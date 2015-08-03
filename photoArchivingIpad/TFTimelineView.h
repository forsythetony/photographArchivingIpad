//
//  TFTimelineView.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pictureFrame.h"
#import "TFImageCollection.h"

typedef NS_ENUM(NSInteger, TFTimelineMonthDisplayType) {
    TFTimelineMonthDisplayTypeAll,
    TFTimelineMonthDisplayTypeNone,
    TFTimelineMonthDisplayTypeHalf
};
@protocol TFTimelineViewDataSource;
@protocol TFTimelineViewDelegate;

@interface TFTimelineView : UIView

@property (nonatomic, weak) id<TFTimelineViewDataSource> dataSource;
@property (nonatomic, weak) id<TFTimelineViewDelegate> delegate;


-(id)initWithFrame:(CGRect)     t_frame
        datasource:(id<TFTimelineViewDataSource>)   t_datasource;

-(void)reloadData;
-(void)animateAll;

@end

@protocol TFTimelineViewDataSource <NSObject>

@optional
-(void)TFTimelineDidTapPictureFrameAtIndex:(NSUInteger) t_index;
@required
-(NSDate*)TFTimelineStartDate;
-(NSDate*)TFTimelineEndDate;
-(pictureFrame*)TFTimelinePictureFrameForObjectAtIndex:(NSUInteger) index;
-(UIColor*)TFTimelineBackgroundColor;
-(CGFloat)TFTimelineInterdateSpacing;
-(CGFloat)TFTimelineHeight;
-(CGFloat)TFTimelineWidth;
-(NSUInteger)TFTimelineNumberOfImages;
-(void)TFTimelineDidTapPictureFrame:(pictureFrame*) t_frame;
-(BOOL)TFTimelineShouldShowMonths;
-(TFTimelineMonthDisplayType)TFTimelineMonthDisplayType;

@end