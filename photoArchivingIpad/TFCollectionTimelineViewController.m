//
//  TFCollectionTimelineViewController.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFCollectionTimelineViewController.h"
#import <Masonry/Masonry.h>
#import <POP.h>
#import "TFTimelineView.h"
#import "NSDate+timelineStuff.h"
#import "TFVisualConstants.h"
#import "TFPopOverBasicView.h"
#import "TFCollectionViewHeader.h"
#import "TFProperties.h"

/**
 *  CONSTANTS
 */

//static CGFloat const MAX_SCROLLVIEW_HEIGHT = 5000.0;
static CGFloat const HEIGHT_PER_YEAR = 250.0 ;
static CGFloat const HEIGHT_TOP_BAR = 100.0;

typedef struct tfRange {
    CGFloat lower;
    CGFloat upper;
    CGFloat dist;
} TFRange;

TFRange CreateRange(CGFloat low, CGFloat high)
{
    TFRange newRange;
    
    newRange.lower = low;
    newRange.upper = high;
    newRange.dist = high - 1;
    
    return newRange;
}
@interface TFCollectionTimelineViewController () <TFTimelineViewDataSource, TFCollectionViewHeaderDataSource, TFCollectionViewHeaderDelegate> {
    TFPopOverBasicView *popOver;
    UIView *topPanel;
    
    TFCollectionViewHeader *header;
    TFViewProperties    *header_props;
    
    
}

@property  (nonatomic, strong) TFTimelineView *timelineView;
@property (nonatomic, assign) CGFloat   timelineWidth;
@property (nonatomic, assign) CGFloat   heightPerYear;
@property (nonatomic, assign) CGFloat   heightMod;

@end

@implementation TFCollectionTimelineViewController

@synthesize timelineScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupViews];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
-(void)setupLooks
{
    header_props = [TFViewProperties new];
    
    header_props.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, HEIGHT_TOP_BAR);
    
    header_props.useTransparentBackground = NO;
    
}
-(void)setupViews
{
    [self setupLooks];
    
    //  Header
    
    header = [[TFCollectionViewHeader alloc] initWithFrame:header_props.frame datasource:self delegate:self transparentViewType:TFTransparentViewImageTypeScrapbook];
    
    [header TFConfigureViewWithProperties:header_props];
    
    [self.view addSubview:header];
    
    
    
    
    //  Scroll View
    CGRect timelineRect = self.view.bounds;
    
    timelineRect.size.width = self.timelineWidth;
    
    _timelineView = [[TFTimelineView alloc] initWithFrame:timelineRect datasource:self];
    
    [self.view addSubview:_timelineView];
    
    
    
    popOver = [[TFPopOverBasicView alloc] initWithFrame:CGRectMake(_timelineView.frame.size.width, 0.0, self.view.frame.size.width - self.timelineWidth, self.view.frame.size.height)];
    
    [self.view addSubview:popOver];
    
    
    
    
    //  Add Constraints
    
    [_timelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        
        make.top.equalTo(header.mas_bottom).with.offset(topPad);
        make.bottom.equalTo(self.view).with.offset(-bottomPad);
        make.left.equalTo(self.view).with.offset(leftPad);
        make.width.mas_equalTo(self.timelineWidth);
    }];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(self.view).with.offset(topPad);
        make.height.mas_equalTo(HEIGHT_TOP_BAR);
        make.left.equalTo(self.view).with.offset(leftPad);
        make.right.equalTo(self.view).with.offset(-rightPad);
    }];
    
    [popOver mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        
        make.top.equalTo(header.mas_bottom).with.offset(topPad);
        make.bottom.equalTo(self.view).with.offset(-bottomPad);
        make.left.equalTo(_timelineView.mas_right).with.offset(leftPad);
        make.right.equalTo(self.view);

    }];
    
}
-(pictureFrame *)TFTimelinePictureFrameForObjectAtIndex:(NSUInteger)index
{
    imageObject *obj = [_collection.images objectAtIndex:index];
    pictureFrame *frame;
    
    if (obj) {
        frame = [pictureFrame createFrame];
        
        [frame setImageObject:obj];
        
    }
    
    return frame;
}
-(UIColor *)TFTimelineBackgroundColor
{
    return [UIColor TFCarbonTextureOne];
}
-(NSDate *)TFTimelineEndDate
{
    NSDate *last = nil;
    
    if (_collection) {
        last = _collection.lastDate;
    }
    
    return last;
}
-(NSDate *)TFTimelineStartDate
{
    NSDate *start = nil;
    
    if (_collection) {
        start = _collection.firstDate;
    }
    
    return start;
}
-(CGFloat)TFTimelineInterdateSpacing
{
    return 10.0;
}
-(NSUInteger)TFTimelineNumberOfImages
{
    if (_collection) {
        return _collection.imageCount;
    }
    else
    {
        return 0;
    }
}
-(CGFloat)TFTimelineHeight
{
    return self.heightPerYear * (CGFloat)[NSDate yearsBetweenDateOne:_collection.firstDate andDateTwo:_collection.lastDate];
}
-(CGFloat)TFTimelineWidth
{
    return self.timelineWidth;
}
-(CGFloat)timelineWidth
{
    return self.view.bounds.size.width - 500.0;
}
-(void)setCollection:(TFImageCollection *)collection
{
    _collection = collection;
    
    [_timelineView reloadData];
    [header reloadData];
}
-(void)TFTimelineDidTapPictureFrame:(pictureFrame *)t_frame
{
    NSLog(@"\n\nDid tap image with id:\t%@\n\n", t_frame.imageObject.id);
    
    [popOver setImg:t_frame.imageObject];
    
}
-(BOOL)TFTimelineShouldShowMonths
{
    return (self.heightMod >= 1.0);
}
-(CGFloat)heightPerYear
{
    if (!_collection) {
        return HEIGHT_PER_YEAR;
    }
    else
    {
        
        return HEIGHT_PER_YEAR * self.heightMod;
        
    }
}
-(CGFloat)heightMod
{
    if (!_collection) {
        return 1.0;
    }
    else
    {
        CGFloat imageCount = (CGFloat)_collection.imageCount;
        
        CGFloat upperImageBound = 15.0;
        
        if (upperImageBound < (CGFloat)imageCount) {
            upperImageBound = (CGFloat)imageCount;
        }
        
        TFRange targetRange = CreateRange(0.25, 1.25);
        TFRange imageRange = CreateRange(0.0, upperImageBound);
        
        CGFloat height_mod = [self mapFloat:(CGFloat)imageCount betweenRangeOne:imageRange andTwo:targetRange];
        
        return height_mod;
        
    }
}
-(CGFloat)mapFloat:(CGFloat)    t_float betweenRangeOne:(TFRange) t_rangeOne andTwo:(TFRange) t_rangeTwo
{
    CGFloat mapped = 0.0;
    
    if ([self isFloat:t_float inRange:t_rangeOne]) {
        
        mapped = (((t_float - t_rangeOne.lower) * t_rangeTwo.dist) / t_rangeOne.dist) + t_rangeTwo.lower;
    }
    
    return mapped;
}
-(BOOL)isFloat:(CGFloat) t_float inRange:(TFRange) t_range
{
    BOOL isIn = YES;
    
    if (t_float > t_range.upper || t_float < t_range.lower) {
        isIn = NO;
    }
    
    
    return isIn;
}
-(TFTimelineMonthDisplayType)TFTimelineMonthDisplayType
{
    CGFloat mod = self.heightMod;
    
    if (mod >= 0.25 && mod < 0.75) {
        return TFTimelineMonthDisplayTypeNone;
    }
    else if (mod >= 0.75 && mod < 1.25)
    {
        return TFTimelineMonthDisplayTypeHalf;
    }
    else
    {
        return TFTimelineMonthDisplayTypeAll;
    }
}
-(void)animate
{
    [_timelineView animateAll];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Header Delegate
-(NSString *)TFCollectionViewHeaderTitle
{
    return _collection.title;
}
-(NSDate *)TFCollectionViewHeaderStartDate
{
    return _collection.firstDate;
}
-(NSDate *)TFCollectionViewHeaderEndDate
{
    return _collection.lastDate;
}
-(NSUInteger)TFCollectionViewHeaderCurrentImageCount
{
    return _collection.imageCount;
}
-(void)TFCollectionViewHeaderDidClickExit
{
    [self.delegate TFCollectionTimelineViewControllerDelegateDismiss];
}
@end
