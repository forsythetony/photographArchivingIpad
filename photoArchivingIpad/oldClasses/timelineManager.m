//
//  timelineManager.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/1/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "timelineManager.h"
#import <math.h>
#import <POP.h>
#import "TFDataCommunicator.h"




#define HORIZONTALMOD 8.0
#define DISTANCETHRESHOLD 50.0

@interface timelineManager  () <TFCommunicatorDelegate>

@property (nonatomic, strong) TFImageCollection *testCollection;
@property (nonatomic, strong) NSMutableArray *collections;
@property (nonatomic, strong) NSMutableArray *readyCollections;
@property (nonatomic, strong) NSMutableArray *collectionImages;

@end
@implementation timelineManager

-(NSMutableArray *)collectionImages
{
    if (!_collectionImages) {
        _collectionImages = [NSMutableArray new];
    }
    
    return _collectionImages;
}
-(NSMutableArray *)readyCollections
{
    if (!_readyCollections) {
        _readyCollections = [NSMutableArray new];
        
        
    }
    
    return _readyCollections;
}
-(NSMutableArray *)collections
{
    if (!_collections) {
        _collections = [NSMutableArray new];
    }
    
    return _collections;
}
-(TFImageCollection *)testCollection
{
    if (!_testCollection) {
        _testCollection = [TFImageCollection new];
        _testCollection.title = @"Test";
    }
    
    return _testCollection;
}
-(NSNumber *)makeDuration
{
    NSNumber        *duration;
    NSTimeInterval  timeDuration;
    
    if (_startDate && _endDate) {
        
        timeDuration    = [_startDate timeIntervalSinceDate:_endDate];
        duration        = [NSNumber numberWithDouble:timeDuration];
        
    }
    
    return duration;
    
}
-(void)bringSubyearsToFront
{
    for (UILabel *lbl in _savedYears) {
        [_TLView bringSubviewToFront:lbl];
        
    }
}
-(CGPoint)createPointWithDate:(NSDate *)date
{
    CGPoint centerPoint;
    BOOL goodValue = NO;
    while (goodValue == NO) {
        NSString *yearString;
        
        NSTimeInterval pureDate = [date timeIntervalSinceBeginning];
        
        float specNumber    = _viewSpan / _duration;
        
        float   lowerYBound     =   _TLView.frame.size.height - 45.0,
        upperYBound     =   90.0;
        
        centerPoint.y = [self randomFloatBetween:lowerYBound and:upperYBound];
        
        centerPoint.x = _xOffset + (( pureDate - _pureStart ) * specNumber) - HORIZONTALMOD;
        
        BOOL isFar = YES;
        
        for (NSDictionary* pointDict in _savedCenters) {
            
            CGPoint thePoint = [pointDict[@"point"] CGPointValue];
            
            float distance = [self getDistanceBetweenPoints:thePoint andTwo:centerPoint];
            

                float lineDist = [self distanceFromLineToPoint:thePoint];
                
                if (lineDist < DISTANCETHRESHOLD && distance < DISTANCETHRESHOLD) {
                    isFar = NO;
                }
            
            else
            {
                yearString = pointDict[@"year"];
                
            }
        }
        
        if (isFar == YES) {
            goodValue = YES;
            
            NSLog(@"\nFound good value for year %@ at point %@\n", yearString, NSStringFromCGPoint(centerPoint));
            
        
        }

    }
    
    NSDate *dt = date;
    
    [_savedCenters addObject:@{@"point": [NSValue valueWithCGPoint:centerPoint],
                               @"year" : [dt displayDateOfType:sDateTypeYearOnly]}];
    return centerPoint;
    
}
-(void)setStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate andView:(UIView *)tlview andXOffsert:(float)offset
{
    _startDate  = startDate;
    _endDate    = endDate;
    
    
    _pureStart  = [_startDate timeIntervalSinceBeginning];
    
    
    _pureEnd    = [_endDate timeIntervalSinceBeginning];
    
    _TLView     = tlview;
    
    _duration   = [endDate timeIntervalSinceDate:startDate];
    _viewSpan   = tlview.frame.size.width - (offset * 2.0);
    _xOffset    = offset;
    
}
-(void)testing_addCollectionView
{
//    TFImageCollectionView *collView = [[TFImageCollectionView alloc] initWithImageCollection:self.testCollection];
//    
//    //  Test Date
//    
//    NSDate *date = [NSDate dateWithYear:@(1905)];
//    
//    CGPoint mainPoint = [self createPointWithDate:date];
//    
//    [_TLView addSubview:collView];
//    [self.collectionsList addObject:collView];
//    
//    [collView setCenter:mainPoint];
}
-(void)addCollectionsFromArray:(NSArray *)t_collections
{
    for (TFImageCollection *coll in t_collections) {
        
        [self createCollectionViewWithCollection:coll];

        
    }
    
    [self.delegate doneLoadingCollections];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[TFImageCollection class]]) {
        
        if ([keyPath isEqualToString:@"completedDownloadingImages"]) {
            
            BOOL newValue = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            
            if (newValue) {
                
                TFImageCollection *coll = (TFImageCollection*)object;
                
                [self.collections removeObject:coll];
                [self.readyCollections addObject:coll];
                [self checkCounts];
            }
        }
    }
}
-(void)checkCounts
{
    if (self.collections.count == 0 && self.readyCollections.count >= 1) {
        [self createCollectionViews];
    }
}
-(void)createCollectionViewWithCollection:(TFImageCollection*) t_coll
{
    [self.collections addObject:t_coll];
    TFImageCollectionView *collView = [[TFImageCollectionView alloc] initWithImageCollection:t_coll];
    [self.collectionsList addObject:collView];
    
    if ([self.delegate respondsToSelector:@selector(shouldAddPanGestureRecognizerForCollectionView:)]) {
        [self.delegate shouldAddPanGestureRecognizerForCollectionView:collView];
    }
    
    CGPoint centerPoint = [self createPointWithDate:collView.collection.approx_date];
    
    [_TLView addSubview:collView];
    
    collView.center = centerPoint;
    
}
-(void)createCollectionViews
{
    [self.collectionsList removeAllObjects];
    
    for (TFImageCollection *coll in self.readyCollections) {
        
        TFImageCollectionView *collView = [[TFImageCollectionView alloc] initWithImageCollection:coll];
        
        if ([self.delegate respondsToSelector:@selector(shouldAddPanGestureRecognizerForCollectionView:)]) {
            [self.delegate shouldAddPanGestureRecognizerForCollectionView:collView];
        }
        CGPoint centerPoint = [self createPointWithDate:collView.collection.approx_date];
        
        [_TLView addSubview:collView];
        
        collView.center = centerPoint;
        
        [self.collectionsList addObject:collView];
    }
    
    [self.delegate doneLoadingCollections];
}
-(void)setInitialPhotographs:(NSArray *)thePhotographs
{
    
    _theImages = thePhotographs;
    
    NSInteger i = 0;
    
    for(pictureFrame* theFrame in _theImages) {
        
        imageObject *img    = theFrame.imageObject;
        
        NSLog(@"Show me the date: %@", [[img date] displayDateOfType:sDateTypeSimple]);
        
        
        CGPoint theCenter   = [self createPointWithDate:[img date]];
        
        theFrame.center = theCenter;
        
        theFrame.alpha = 0.0;
        
        [theFrame.theImage sd_setImageWithURL:img.thumbNailURL];
        
        [_TLView addSubview:theFrame];
        
        [theFrame.theImage sd_setImageWithURL:img.thumbNailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            theFrame.theImage.image = image;
            
            
            POPSpringAnimation *scaleAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            
            scaleAni.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.3, 0.3)];
            scaleAni.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
            
            POPSpringAnimation *alphaAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
            
            alphaAni.toValue = @(1.0);
            
            [theFrame.layer pop_addAnimation:scaleAni forKey:@"scaleAni"];
            [theFrame pop_addAnimation:alphaAni forKey:@"alphaAni"];
        }];
        
        if (i >= 0 && i < 1) {
            [self.testCollection addImage:img];
        }
        
        i++;
        
    }
    
    [self testing_addCollectionView];
}
-(NSDate *)getNewDateForFrame:(pictureFrame *)Pframe
{
    CGPoint newCenter = [Pframe center];
    
    NSDate *pointDate = [self createDateObjectFromPoint:newCenter];
    
    return pointDate;
}
-(NSDate*)createDateObjectFromPoint:(CGPoint) point
{
    
    double modifier = _duration / _viewSpan;
    
    double thePoint = point.x - _xOffset;
    
    double pointAsPureDate = thePoint * modifier;
    
    //pointAsPureDate *= (double)1.052;
    
    NSDate *newDate = [NSDate dateWithTimeInterval:pointAsPureDate sinceDate:_startDate];
    
    return newDate;
    
}
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    
    float diff = bigNumber - smallNumber;
    
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
    
}
-(float)getRandomFloatWithDate:(NSDate*) theDate
{
    
    float timeInt = (float)[theDate timeIntervalSinceBeginning];
    
    float result = fmod(timeInt, 2.0);
    
    NSLog(@"THE FLOAT IS %f", result);
    
    return result;
}
-(float)getDistanceBetweenPoints:(CGPoint) pointOne andTwo:(CGPoint) pointTwo
{
    
    float xDiff = fabsf(pointTwo.x - pointOne.x);
    float yDiff = fabsf(pointTwo.y - pointOne.y);
    
    float distance = sqrtf(powf(xDiff, 2.0) + powf(yDiff, 2.0));
    
    return distance;

}
-(float)distanceFromLineToPoint:(CGPoint) thePoint
{
    
    CGPoint linePoint = [_lineCenter CGPointValue];
    
    float distance = fabsf(thePoint.y - linePoint.y);
    
    return distance;
}
-(NSMutableArray *)collectionsList
{
    if (!_collectionsList) {
        _collectionsList = [NSMutableArray new];
    }
    
    return _collectionsList;
}
-(void)setTransPoint:(CGPoint)t_trans withImage:(imageObject *)t_img
{
    for (TFImageCollectionView *collViews in self.collectionsList) {
        
        CGPoint translationPoint = [collViews convertPoint:t_trans fromView:_timelineScrollView];
        
        NSLog(@"\n\nColl Title:\t%@\nTrans Point:\t%@\nColl Bounds:\t%@\n\n", collViews.collection.title, NSStringFromCGPoint(translationPoint), NSStringFromCGRect(collViews.bounds));
        
        if ([collViews pointInside:translationPoint withEvent:nil]) {
            [collViews.collection TFAddImage:t_img];
        }
        
    }
}
@end
