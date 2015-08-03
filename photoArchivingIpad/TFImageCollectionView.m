//
//  TFImageCollectionView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFImageCollectionView.h"
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>
#import "TFVisualConstants.h"
#import <Colours/Colours.h>
#import "updatedConstants.h"

#import <POP.h>

typedef NS_ENUM(NSInteger, TFImageCollectionViewLayoutStyle) {
    TFImageCollectionViewLayoutStyleSingle,
    TFImageCollectionViewLayoutStyleSideBySide,
    TFImageCollectionViewLayoutStyleTrifecta,
    TFImageCollectionViewLayoutStyleQuadSymmetry,
    TFImageCollectionViewLayoutStyleCrazy,
    TFImageCollectionViewLayoutStyleNone
};

@interface TFImageCollectionImageLayout : NSObject

@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGPoint   center;
@property (nonatomic, strong) imageObject *image;


+(instancetype)TFImageCollectionImageLayoutWithSize:(CGSize) t_size
                                             center:(CGPoint) t_center;

@end


static NSUInteger const MAX_IMAGES_TO_SHOW = 5;


@implementation TFImageCollectionImageLayout

+(instancetype)TFImageCollectionImageLayoutWithSize:(CGSize)t_size center:(CGPoint)t_center
{
    TFImageCollectionImageLayout *layout = [TFImageCollectionImageLayout new];
    
    layout.size = t_size;
    layout.center = t_center;
    
    return layout;
}

@end
@interface TFImageCollectionView () 
{
    CGRect  frame_titleContainer,
            frame_imagesContainer,
            frame_backgroundImageView;
    
    UIView  *container_title, *container_images, *contentView;
    
    UIImageView *imgView_background;
    
    UILabel *lbl_title;
    
    BOOL    hasChangedColor;
    
    NSUInteger currentIndex;
    
}
@property (nonatomic, assign) CGFloat   imageSizeFactor;
@property (nonatomic, assign) TFImageCollectionViewLayoutStyle layoutStyle;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, assign) CGSize imageSize;
@end

static CGFloat const HEIGHT_TITLE_CONTAINER = 30.0;
static CGFloat const WIDTH_MAIN_VIEW = 150.0;
static NSUInteger const MAX_IMAGES_IN_VIEW = 13;

CGRect  getQuadrantOfRectangle(CGRect rect, NSInteger quad)
{
    CGRect quadrant;
    
    if (quad == 0) {
        
        quadrant = rect;
        
        quadrant.size.width /= 2.0;
        quadrant.size.height /= 2.0;
        
    }
    else if (quad == 1)
    {
        quadrant = rect;
        
        quadrant.origin.x += rect.size.width / 2.0;
        
        quadrant.size.width /= 2.0;
        quadrant.size.height /= 2.0;
    }
    else if (quad == 2)
    {
        quadrant = rect;
        
        quadrant.origin.x += rect.size.width / 2.0;
        quadrant.origin.y += rect.size.height / 2.0;
        
        quadrant.size.width /= 2.0;
        quadrant.size.height /= 2.0;
    }
    else if (quad == 3)
    {
        quadrant = rect;
        
        quadrant.origin.y += rect.size.height / 2.0;
        
        quadrant.size.width /= 2.0;
        quadrant.size.height /= 2.0;
    }
    else
    {
        quadrant = rect;
        
        quadrant.size.width /= 2.0;
        quadrant.size.height /= 2.0;
        
        
    }
    
    return quadrant;
}
CGRect reduceOriginalRectByFactor(CGRect originalRect, CGFloat factor)
{
    CGRect newRect = originalRect;
    
    newRect.size.height *= factor;
    newRect.size.width *= factor;
    
    CGFloat horizontalDiff = originalRect.size.width - newRect.size.width;
    CGFloat verticalDiff = originalRect.size.height - newRect.size.height;
    
    newRect.origin.x += horizontalDiff / 2.0;
    newRect.origin.y += verticalDiff / 2.0;
    
    return newRect;
}
CGPoint findCenterOfFrame(CGRect frame)
{
    CGPoint center;
    
    CGFloat centerX = frame.origin.x + frame.size.width / 2.0;
    CGFloat centerY = frame.origin.y + frame.size.height / 2.0;
    
    center = CGPointMake(centerX, centerY);
    
    return center;
}
static CGRect halfOfBounds(CGRect bounds, BOOL topHalf)
{
    CGRect newBounds = bounds;
    
    if (topHalf) {
        newBounds.size.height /= 2.0;
    }
    else
    {
        newBounds.origin.y = newBounds.size.height / 2.0;
        newBounds.size.height /= 2.0;
    }
    
    return newBounds;
}
@implementation TFImageCollectionView

-(id)initWithImageCollection:(TFImageCollection *)t_collection
{
    CGRect frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    frame.size = [TFImageCollectionView TFDefaultSize];
    
    if (self = [super initWithFrame:frame]) {
        t_collection.delegate = self;
        self.frame = frame;
        self.collection = t_collection;
        hasChangedColor = NO;
        [self setupViews];
        currentIndex = 0;
        
    }
    
    return self;
}
-(void)setupFrames
{
    frame_titleContainer = CGRectZero;
    frame_titleContainer.size = CGSizeMake([TFImageCollectionView TFDefaultSize].width, HEIGHT_TITLE_CONTAINER);
    
    frame_imagesContainer = CGRectZero;
    
    frame_imagesContainer.size.width = WIDTH_MAIN_VIEW;
    frame_imagesContainer.size.height = [TFImageCollectionView TFDefaultSize].height - HEIGHT_TITLE_CONTAINER;
    
    frame_backgroundImageView = CGRectZero;
    frame_backgroundImageView.size = [TFImageCollectionView TFDefaultSize];
}
-(void)setupViews
{
    [self setupFrames];
    
    //  Setup Background Image View
    
    imgView_background = [[UIImageView alloc] initWithFrame:frame_backgroundImageView];
    imgView_background.contentMode = UIViewContentModeScaleToFill;
    
    NSURL   *thumbURL = self.collection.firstImage.thumbNailURL;
    
    [imgView_background sd_setImageWithURL:thumbURL];
    
    [self addSubview:imgView_background];
    
    //  Add Visual Effect View
    
    UIVisualEffectView *ev = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    ev.frame = imgView_background.bounds;
    
    contentView = ev.contentView;
    
    [imgView_background addSubview:ev];
    
    
    //  Add Containers
    
    container_title = [[UIView alloc] initWithFrame:frame_titleContainer];
    
    [self addSubview:container_title];
    container_title.backgroundColor = [UIColor charcoalColor];
    
    container_images = [[UIView alloc] initWithFrame:frame_imagesContainer];
    container_images.clipsToBounds = YES;
    container_images.backgroundColor = [UIColor charcoalColor];
    
    [self addSubview:container_images];
    
    
    
    //  Add Title Label
    
    
    lbl_title = [[UILabel alloc] initWithFrame:container_title.bounds];
    
    lbl_title.textColor = [UIColor whiteColor];
    CGFloat fontSize = 14.0;
    
    lbl_title.font = [UIFont fontWithName:[TFVisualConstants TFFontFamilyOne] size:fontSize];
    lbl_title.textAlignment = NSTextAlignmentCenter;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        lbl_title.text = self.collection.title;
    });
    
    
    [container_title addSubview:lbl_title];
//    
//    switch (self.layoutStyle) {
//        case TFImageCollectionViewLayoutStyleSingle:
//        {
//            [self layoutSingle];
//        }
//            break;
//            
//            case TFImageCollectionViewLayoutStyleSideBySide:
//        {
//            [self layoutDouble];
//        }
//            break;
//            
//            case TFImageCollectionViewLayoutStyleTrifecta:
//        {
//            [self layoutTriple];
//        }
//            break;
//            
//            case TFImageCollectionViewLayoutStyleQuadSymmetry:
//        {
//            [self layoutQuad];
//        }
//            break;
//            
//            case TFImageCollectionViewLayoutStyleCrazy:
//        {
//            [self layoutCrazy];
//        }
//            break;
//            
//        case TFImageCollectionViewLayoutStyleNone:
//        default:
//            break;
//    }
//    
//    
    
    [container_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_TITLE_CONTAINER);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [container_images mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(container_title.mas_bottom).with.offset(topPad);
        make.bottom.equalTo(self).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
    
    [lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(container_title).with.offset(topPad);
        make.bottom.equalTo(container_title).with.offset(-bottomPad);
        make.left.equalTo(container_title).with.offset(leftPad);
        make.right.equalTo(container_title).with.offset(-rightPad);
    }];
}
-(void)TFImageCollectionDidAddImageObject:(imageObject *)t_obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger imageCount = self.imageViews.count;
        
        NSLog(@"\n\nImage Count:\t%lu\nTitle:\t%@\n\n", imageCount, self.collection.title);
        
        if (imageCount < MAX_IMAGES_TO_SHOW)
        {

            CGPoint randOrigin = [self randomPointInBounds:container_images.bounds];
            CGSize  imgViewSize = self.imageSize;
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(randOrigin.x, randOrigin.y, imgViewSize.width, imgViewSize.height)];
            imgView.alpha = 0.0;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            
            [container_images addSubview:imgView];
            
            [imgView sd_setImageWithURL:t_obj.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                imgView.image = image;
                
                POPSpringAnimation *alphaAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
                POPSpringAnimation *scaleAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                
                alphaAni.toValue = @(1.0);
                
                
                scaleAni.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.1, 0.1)];
                scaleAni.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                
                
                [imgView pop_addAnimation:alphaAni forKey:@"alphaAni"];
                [imgView.layer pop_addAnimation:scaleAni forKey:@"scaleAni"];

                
            }];
            
            [self.imageViews addObject:imgView];
            
            
            
        }
    });
        
        
            
        
    

}
-(void)layoutSingle
{
    CGPoint center = findCenterOfFrame(container_images.bounds);
    CGRect  frame = reduceOriginalRectByFactor(container_images.bounds, 0.7);
    
    TFImageCollectionImageLayout *layout = [TFImageCollectionImageLayout TFImageCollectionImageLayoutWithSize:frame.size center:center];
    
    layout.image = self.collection.firstImage;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, layout.size.width, layout.size.height)];
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    imgView.center = layout.center;
    
    [imgView sd_setImageWithURL:layout.image.thumbNailURL];
    
    [container_images addSubview:imgView];
    
    [self.imageViews addObject:imgView];
}
-(void)layoutDouble
{
    for (int i = 0; i < 2; i++) {
        
        imageObject *obj = self.collection.images[i];
        
        CGRect frame =  getQuadrantOfRectangle(container_images.bounds, i);
        
        CGPoint center = findCenterOfFrame(frame);
        
        if (i == 0) {
            center.y += frame.size.height / 3.0;
        }
        else if (i == 1)
        {
            center.y += frame.size.height - (frame.size.height / 3.0);
        }
        
        TFImageCollectionImageLayout *layout = [TFImageCollectionImageLayout TFImageCollectionImageLayoutWithSize:frame.size center:center];
        layout.image = obj;
        
        [self.layouts addObject:layout];
        
    }
    
    for (TFImageCollectionImageLayout *layout in self.layouts) {
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, layout.size.width, layout.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        imgView.center = layout.center;
        
        [imgView sd_setImageWithURL:layout.image.thumbNailURL];
        
        [container_images addSubview:imgView];
        
        [self.imageViews addObject:imgView];
    }
}
-(void)layoutTriple
{
    for (int i = 0; i < 3; i++) {
        
        imageObject *obj = self.collection.images[i];
        
        CGRect frame =  getQuadrantOfRectangle(container_images.bounds, i);
        
        CGPoint center = findCenterOfFrame(frame);
        
        if (i == 2) {
            center.x -= frame.size.width / 2.0;
        }
        
        TFImageCollectionImageLayout *layout = [TFImageCollectionImageLayout TFImageCollectionImageLayoutWithSize:frame.size center:center];
        layout.image = obj;
        
        [self.layouts addObject:layout];
        
    }
    
    for (TFImageCollectionImageLayout *layout in self.layouts) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, layout.size.width, layout.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        imgView.center = layout.center;
        
        [imgView sd_setImageWithURL:layout.image.thumbNailURL];
        
        [container_images addSubview:imgView];
        
        [self.imageViews addObject:imgView];
    }
}
-(void)layoutQuad
{
    for (int i = 0; i < 4; i++) {
        
        imageObject *obj = self.collection.images[i];
        
        CGRect frame =  getQuadrantOfRectangle(container_images.bounds, i);
        
        CGPoint center = findCenterOfFrame(frame);
        
        TFImageCollectionImageLayout *layout = [TFImageCollectionImageLayout TFImageCollectionImageLayoutWithSize:frame.size center:center];
        layout.image = obj;
        
        [self.layouts addObject:layout];
        
    }
    
    
    for (TFImageCollectionImageLayout *layout in self.layouts) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, layout.size.width, layout.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        imgView.center = layout.center;
        
        [imgView sd_setImageWithURL:layout.image.thumbNailURL];
        
        [container_images addSubview:imgView];
        
        [self.imageViews addObject:imgView];
    }
}
-(void)layoutCrazy
{
    CGFloat mod_dimensions = 0.7;
    
    CGFloat dimensions = container_images.frame.size.width * mod_dimensions;
    dimensions *= self.imageSizeFactor;
    
    CGSize  imageSize = CGSizeMake(dimensions, dimensions);
    
    
    for (NSUInteger i = 0; i < MIN(MAX_IMAGES_IN_VIEW, self.collection.imageCount); i++) {
        
        NSValue *oldPoint;
        
        NSUInteger quadNumber = i % 4;
        
        CGRect  quadrant = getQuadrantOfRectangle(container_images.bounds, quadNumber);
        
        if (i == 0) {
            oldPoint = nil;
        }
        else
        {
            TFImageCollectionImageLayout *layout = self.layouts[i - 1];
            
            oldPoint = [NSValue valueWithCGPoint:layout.center];
        }
        

        CGPoint newCenter = [self findCenterPointWithPreviousPoint:oldPoint andRectangle:quadrant];
        NSLog(@"\nQuadrant:\t%@\nNew Center:\t%@\n", NSStringFromCGRect(quadrant), NSStringFromCGPoint(newCenter));
        
        TFImageCollectionImageLayout *newLayout = [TFImageCollectionImageLayout TFImageCollectionImageLayoutWithSize:imageSize center:newCenter];
        
        newLayout.image = self.collection.images[i];
        
        [self.layouts addObject:newLayout];
        
    }
    
    
    for (TFImageCollectionImageLayout *layout in self.layouts) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, layout.size.width, layout.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        imgView.center = layout.center;
        
        [imgView sd_setImageWithURL:layout.image.thumbNailURL];
        
        [container_images addSubview:imgView];
        
        [self.imageViews addObject:imgView];
    }
    
}
-(CGPoint)findCenterPointWithPreviousPoint:(NSValue*) t_previousPoint andRectangle:(CGRect) t_rect
{
    CGRect  largeFrame = container_images.bounds;
    
    CGFloat minDist = largeFrame.size.width * 0.0;
    
    
    if (t_previousPoint) {
    
        CGPoint oldPoint = [t_previousPoint CGPointValue];
        
        
        CGPoint newRandomPoint;
        
        CGFloat dist;
        
        do {
            newRandomPoint  = [self findRandomPointInRect:t_rect];
            dist = [self distanceBetweenPoints:oldPoint two:newRandomPoint];
        } while (dist < minDist);
        
        return newRandomPoint;
    }
    else
    {
        return [self findRandomPointInRect:t_rect];
    }
    
}
-(CGFloat)distanceBetweenPoints:(CGPoint) t_one two:(CGPoint) t_two
{
    return hypotf(t_one.x - t_two.x, t_one.y - t_two.y);
}
-(CGPoint)findRandomPointInRect:(CGRect) t_frame
{
    CGFloat nearX = t_frame.origin.x;
    CGFloat farX = t_frame.origin.x + t_frame.size.width;
    
    CGFloat randX = [self randomFloatBetween:(float)nearX and:(float)farX];
    
    CGFloat nearY = t_frame.origin.y;
    CGFloat farY = t_frame.origin.y + t_frame.size.height;
    
    CGFloat randY = [self randomFloatBetween:(float)nearY and:(float)farY];
    
    return CGPointMake(randX, randY);
}
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
+(CGSize)TFDefaultSize
{
    CGFloat height = 150.0 + HEIGHT_TITLE_CONTAINER;
    CGFloat width = WIDTH_MAIN_VIEW;
    
    return CGSizeMake(width, height);
}
-(TFImageCollectionViewLayoutStyle)layoutStyle
{
    NSUInteger count = [self.collection.totalImages integerValue];
    TFImageCollectionViewLayoutStyle style = TFImageCollectionViewLayoutStyleNone;
    
    if (count > 4) {
        style = TFImageCollectionViewLayoutStyleCrazy;
    }
    else if (count > 3)
    {
        style = TFImageCollectionViewLayoutStyleQuadSymmetry;
    }
    else if (count > 2)
    {
        style = TFImageCollectionViewLayoutStyleTrifecta;
    }
    else if (count > 1)
    {
        style = TFImageCollectionViewLayoutStyleSideBySide;
    }
    else if (count > 0)
    {
        style = TFImageCollectionViewLayoutStyleSingle;
    }
    
    return style;
}
-(NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
    }
    
    return _imageViews;
}
-(NSMutableArray *)layouts
{
    if (!_layouts) {
        _layouts = [NSMutableArray new];
    }
    
    return _layouts;
}
-(CGFloat)imageSizeFactor
{
    NSUInteger count = self.collection.imageCount;
    CGFloat factor;
    
    if (count >= 5 && count <= 8) {
        factor = 1.0;
    }
    else if (count > 8 && count <= 12)
    {
        factor = 0.6;
    }
    else if (count > 12 && count <= 16)
    {
        factor = 0.4;
    }
    else if (count > 17 && count <= 25)
    {
        factor = 0.3;
    }
    else if (count > 25)
    {
        factor = 0.2;
    }
    else
    {
        factor = 1.0;
    }
    
    return factor;
}
-(void)addImageObject:(imageObject *)t_image
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?photo_id=%@&collection_id=%@", [updatedConstants api_babbage_baseURL], @"/collectionImages", t_image.id, self.collection.uuid];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    req.HTTPMethod = @"PUT";
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        
        if (resp.statusCode == 200 || resp.statusCode == 201) {
            
            NSLog(@"\n\nSuccess\n\n");
        }
    }];
}
-(void)changeColor
{
    if (!hasChangedColor) {
        container_title.backgroundColor = [UIColor orangeColor];
        hasChangedColor = YES;
    }
}
-(CGSize)imageSize
{
    CGFloat img_dim = container_images.frame.size.width * 0.8;
    
    return CGSizeMake(img_dim, img_dim);
}
-(CGPoint)randomPointInBounds:(CGRect) t_bounds
{
    NSInteger quadNumber = currentIndex % 4;
    
    t_bounds = getQuadrantOfRectangle(t_bounds, quadNumber);
    
    currentIndex++;
    return t_bounds.origin;
    
    CGFloat xStart = t_bounds.origin.x;
    CGFloat xEnd = t_bounds.origin.x + t_bounds.size.width;
    
    CGFloat yStart = t_bounds.origin.y;
    CGFloat yEnd = yStart + t_bounds.size.height;
    
    
    int leftBoundX = (int)xStart;
    int rightBoundX = (int)xEnd;
    
    int randX = arc4random_uniform(rightBoundX) + leftBoundX;
    
    int leftBoundY = (int)yStart;
    int rightBoundY = (int)yEnd;
    
    int randY = arc4random_uniform(rightBoundY) + leftBoundY;
    
    return CGPointMake((CGFloat)randX, (CGFloat)randY);
    

    
}
-(BOOL)randomBool
{
    int upperBound = 10000;
    int lowerBound = 1;
    
    int rand = arc4random_uniform(upperBound) + lowerBound;
    
    return (rand % 2 == 0);
}
@end
