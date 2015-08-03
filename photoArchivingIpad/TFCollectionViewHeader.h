//
//  TFCollectionViewHeader.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFCollectionViewHeaderDataSource;
@protocol TFCollectionViewHeaderDelegate;

typedef NS_ENUM(NSInteger, TFTransparentViewImageType) {
    TFTransparentViewImageTypeScrapbook,
    TFTransparentViewImageTypeNone
};


@interface TFCollectionViewHeader : UIView

@property (nonatomic, weak) id<TFCollectionViewHeaderDataSource> datasource;
@property (nonatomic, weak) id<TFCollectionViewHeaderDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *contentView;

-(instancetype)initWithFrame:(CGRect)   t_frame
                  datasource:(id<TFCollectionViewHeaderDataSource>) t_datasource
                    delegate:(id<TFCollectionViewHeaderDelegate>) t_delegate
transparentViewType:(TFTransparentViewImageType) t_imageType;


-(void)reloadData;

@end
@protocol TFCollectionViewHeaderDelegate <NSObject>

-(void)TFCollectionViewHeaderDidClickExit;

@end
@protocol TFCollectionViewHeaderDataSource <NSObject>

-(NSUInteger)TFCollectionViewHeaderCurrentImageCount;
-(NSDate*)TFCollectionViewHeaderStartDate;
-(NSDate*)TFCollectionViewHeaderEndDate;
-(NSString*)TFCollectionViewHeaderTitle;

@end