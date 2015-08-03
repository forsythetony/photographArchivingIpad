//
//  TFCollectionTimelineViewController.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFImageCollection.h"

@protocol TFCollectionTimelineViewControllerDelegate <NSObject>

-(void)TFCollectionTimelineViewControllerDelegateDismiss;

@end
@interface TFCollectionTimelineViewController : UIViewController

@property (nonatomic, weak) id<TFCollectionTimelineViewControllerDelegate> delegate;
@property (nonatomic, strong) UIScrollView *timelineScrollView;
@property (nonatomic, strong) TFImageCollection *collection;

-(void)animate;

@end
