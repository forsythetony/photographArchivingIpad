//
//  pictureFrame.m
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "pictureFrame.h"

#define CORNERRAD 4.0


@implementation pictureFrame {
    
    NSArray *containerViews;
    
}
+ (id)createFrame
{
    pictureFrame *picture = [[[NSBundle mainBundle] loadNibNamed:@"testing"
                                                           owner:nil
                                                         options:nil] lastObject];
    
    if ([picture isKindOfClass:[pictureFrame class]]) {
        
        picture.theImage.layer.cornerRadius     = CORNERRAD;
        picture.theImage.layer.masksToBounds    = YES;
        picture.layer.cornerRadius              = CORNERRAD;
        picture.backgroundColor                 = [UIColor clearColor];
        
        picture.containerView.layer.cornerRadius    = CORNERRAD;
        picture.containerView.backgroundColor       = [UIColor clearColor];
        
        return picture;
        
    }
    else
        return nil;
}
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    NSLog(@"Things are happening!");
    
}
-(void)resize
{
    [[self superview] bringSubviewToFront:self];
    
    float generalSpringSpeed        = 2.0;
    float generalSpringBounciness   = 1.0;
    
    float fastSpringBounce  = 0.1;
    float fastSpringSpeed   = 0.1;
    
    float imageXChange = 20.0;
    float imageYChange = 20.0;
    
    if (!_expanded || _expanded == NO) {
        
        
        POPSpringAnimation *cornerChange = [POPSpringAnimation animation];
        
        
        cornerChange.property   = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
        
        cornerChange.toValue    = @(15.0);
        
        cornerChange.springBounciness   = generalSpringBounciness;
        cornerChange.springSpeed        = generalSpringSpeed;
        
        
        
        
        POPSpringAnimation *grow = [POPSpringAnimation animation];
        
        
        grow.property   = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
        
        grow.toValue    = [NSValue valueWithCGSize:CGSizeMake(400.0, 250.0)];
        
        grow.springBounciness   = generalSpringBounciness;
        grow.springSpeed        = generalSpringSpeed;
        
        
        
        
        POPSpringAnimation *imageMove = [POPSpringAnimation animation];
        
        
        imageMove.property  = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationXY];
        
        imageMove.toValue   = [NSValue valueWithCGPoint:CGPointMake(imageXChange, imageYChange)];
        
        imageMove.springBounciness  = generalSpringBounciness;
        imageMove.springSpeed       = generalSpringSpeed;

        
        
        
        POPSpringAnimation *imageCorners = [POPSpringAnimation animation];
        
        
        imageCorners.property   = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
        
        imageCorners.toValue    = @(5.0);
        
        imageCorners.springBounciness   = generalSpringBounciness;
        
        imageCorners.name       = @"imageCorners";
        imageCorners.delegate   = self;
        
        
        [self.theImage.layer        pop_addAnimation:imageMove
                                              forKey:@"moveImage"];
        
        [self.theImage.layer        pop_addAnimation:imageCorners
                                              forKey:@"changeCorners"];
        
        [self.containerView.layer   pop_addAnimation:grow
                                              forKey:@"layerGrow"];
        
        [self.containerView.layer   pop_addAnimation:cornerChange
                                            forKey:@"cornerChange"];
        
        
        _expanded = YES;
        
    }
    else {
        
        [self removeContainerViewsForResize];
     
        
        
        
        POPBasicAnimation *shrink = [POPBasicAnimation animation];
        
        
        shrink.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
        
        shrink.toValue  = [NSValue valueWithCGSize:CGSizeMake(100.0, 100.0)];
    
        shrink.duration = 0.5;
        
        
        [self.containerView.layer pop_addAnimation:shrink
                                            forKey:@"layerShrink"];
        
        
        
        
        POPSpringAnimation *moveIn = [POPSpringAnimation animation];
        
        
        moveIn.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationXY];
        
        moveIn.toValue  = [NSValue valueWithCGPoint:CGPointMake(0.0  ,0.0)];
        
        moveIn.springBounciness     = fastSpringSpeed;
        moveIn.springSpeed          = fastSpringSpeed;
    
        
        [self.theImage.layer pop_addAnimation:moveIn
                                       forKey:@"imageResetXY"];
        
        
        
        
        POPSpringAnimation *imageCornerReset = [POPSpringAnimation animation];
        
        
        imageCornerReset.property   = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
        
        imageCornerReset.toValue    = @(CORNERRAD);
        
        imageCornerReset.springBounciness   = fastSpringBounce;
        imageCornerReset.springSpeed        = fastSpringSpeed;
        
        
        [self.theImage.layer pop_addAnimation:imageCornerReset
                                       forKey:@"imgCornerReset"];
        
        
        
        
        POPSpringAnimation *containerCornerReset = [POPSpringAnimation animation];
        
        
        containerCornerReset.property   = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
        
        containerCornerReset.toValue    = @(CORNERRAD);
        
        containerCornerReset.springBounciness   = fastSpringBounce;
        containerCornerReset.springSpeed        = fastSpringSpeed;
        
        
        [self.containerView.layer pop_addAnimation:containerCornerReset
                                            forKey:@"containerCornerReset"];
        
        
        _expanded = NO;
        
    }
    
}

-(void)removeContainerViewsForResize
{
    if (containerViews && containerViews.count > 0) {
        
        NSInteger containerViewsCount = [containerViews count];
        
        for (int i = 0; i < containerViewsCount; i++) {
            
            UIView *view = (UIView*)containerViews[i];
            
            [view removeFromSuperview];
            view = nil;
            
        }
        
        containerViews = nil;
        
    }
}
-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    if ([anim.name isEqualToString:@"imageCorners"]) {
        
        [self showImageInformation];
        
    }
}

-(void)showImageInformation
{
    
    NSMutableArray *theViews = [NSMutableArray new];
    
    float horizMargin   = 10.0;
    float contXOrg      = self.theImage.frame.origin.x + self.theImage.frame.size.width + horizMargin + 20.0;
    float contHeight    = self.theImage.frame.size.height + 10.0;
    float contWidth     = 400.0 - contXOrg - horizMargin;
    
    
    CGRect titleInfoContainerRect = CGRectMake(
                                               contXOrg ,   10.0,
                                               contWidth,   contHeight
                                               );
    
    
    UIView *titleInfoContainer = [[UIView alloc] initWithFrame:titleInfoContainerRect];
    

    [self.containerView addSubview:titleInfoContainer];
    
    [theViews addObject:titleInfoContainer];
    
    
    
    CGRect titleRect = CGRectMake(
                                  0.0                               , 0.0,
                                  titleInfoContainerRect.size.width , titleInfoContainerRect.size.height
                                  );
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    
    titleLabel.text             = self.imageObject.title;
    titleLabel.font             = [self fontForLabelType:pLabelTypeTitle];
    titleLabel.textAlignment    = NSTextAlignmentLeft;
    titleLabel.textColor        = [UIColor grayColor];
    titleLabel.numberOfLines    = 0;
    titleLabel.alpha            = 0.0;
    
    [theViews addObject:titleLabel];
    
    
    
    
    POPBasicAnimation *alphaAni = [self alphaAnimation];
    
    
    [titleLabel pop_addAnimation:alphaAni
                          forKey:@"titleAlphaAni"];
    
    
    
    
    POPSpringAnimation *titleSpring = [POPSpringAnimation animation];
    
    
    titleSpring.property    = [POPAnimatableProperty propertyWithName:kPOPLabelTextColor];
    
    titleSpring.fromValue   = [UIColor clearColor];
    titleSpring.toValue     = [UIColor warmGrayColor];
    
    titleSpring.springBounciness = 3.0;
    titleSpring.springSpeed = 3.0;
    
    
    
    
    POPSpringAnimation *motionSpring = [POPSpringAnimation animation];
    
    motionSpring.property   = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
    
    motionSpring.fromValue  = @(-50.0);
    motionSpring.toValue    = @(0);
    
    motionSpring.springBounciness   = 1.5;
    motionSpring.springSpeed        = 0.4;
    
    
    
    
    float mainInfoXOrigin   = self.theImage.frame.origin.x;
    float mainInfoYOrigin   = self.theImage.frame.origin.y + self.theImage.frame.size.height + 10.0;
    float mainInfoWith      = self.containerView.bounds.size.width - (mainInfoXOrigin * 2.0);
    float mainInfoHeight    = self.containerView.bounds.size.height - mainInfoYOrigin - 10.0;
    
    CGRect mainInfoRect = CGRectMake(
                                     mainInfoXOrigin    , mainInfoYOrigin,
                                     mainInfoWith       , mainInfoHeight
                                     );
    
    UIView *mainInfoContainer = [[UIView alloc] initWithFrame:mainInfoRect];
    
    [theViews addObject:mainInfoContainer];
    
    
    UIColor *labelCatColor      = [UIColor whiteColor];
    
    float labelCategoryWidth    = 40.0;
    float dateLabelXOffset      = 10.0;
    
    CGRect dateLabelCatRect = CGRectMake(
                                         0.0    , 0.0,
                                         40.0   , 40.0
                                         );
    
    UILabel *dateLabelCat = [[UILabel alloc] initWithFrame:dateLabelCatRect];
    
    dateLabelCat.text           = @"Date: ";
    dateLabelCat.textAlignment  = NSTextAlignmentRight;
    dateLabelCat.textColor      = labelCatColor;
    dateLabelCat.font           = [self fontForLabelType:pLabelTypeCategory];
    dateLabelCat.alpha          = 0.0;
    
    [theViews addObject:dateLabelCat];
    [mainInfoContainer addSubview:dateLabelCat];

    [dateLabelCat pop_addAnimation:alphaAni
                            forKey:@"dateAlphaAni"];
    
    
    
    CGRect dateLabelRect = CGRectMake(
                                      labelCategoryWidth + dateLabelXOffset                             , 0.0,
                                      mainInfoRect.size.width - labelCategoryWidth - dateLabelXOffset   , 40.0
                                      );

    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelRect];
    
    dateLabel.text          = [[self.imageObject date] displayDateOfType:sDateTypeWithTime];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.textColor     = [UIColor warmGrayColor];
    dateLabel.font          = [self fontForLabelType:pLabelTypeBasic];
    dateLabel.alpha         = 0.0;
    
    [theViews addObject:dateLabel];
    [mainInfoContainer addSubview:dateLabel];

    
    [dateLabel pop_addAnimation:alphaAni
                         forKey:@"dateStringAlphaAni"];
    
    
    
    containerViews = [NSArray arrayWithArray:theViews];
    
    [self.containerView addSubview:mainInfoContainer];
    
    [titleInfoContainer addSubview:titleLabel];
    
}
-(void)subtleBounce
{
    
    POPSpringAnimation *springAni = [POPSpringAnimation animation];
    
    springAni.property  = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    
    springAni.toValue   = @(2.0);
    
    springAni.springBounciness  = 14.0;
    springAni.springSpeed       = 3.0;
    
    [self pop_addAnimation:springAni
                    forKey:@"subtleBounce"];
    
}
-(void)handleTapGesture:(id) sender
{
    
    [self resize];

}
-(void)bounceInFromPoint:(CGFloat) startPoint toPoint:(CGFloat) endPoint
{
    
    POPSpringAnimation *springy = [POPSpringAnimation animation];
    
    springy.property    = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    
    springy.fromValue   = @(startPoint);
    springy.toValue     = @(endPoint);
    
    springy.springBounciness    = 15.0;
    springy.springSpeed         = 2.0;
    
    [self pop_addAnimation:springy
                    forKey:@"pop"];
    
}
-(void)setImageObject:(imageObject *)imageObject
{
    _imageObject = imageObject;
    
    [self performSelectorOnMainThread:@selector(updateImage) withObject:nil waitUntilDone:NO];

}
-(void)updateImage
{
    
    //FAKFontAwesome *picture = [FAKFontAwesome pictureOIconWithSize:30.0];

    //UIImage *picImage       = [picture imageWithSize:CGSizeMake(30.0, 30.0)];
    
    [self.theImage setImageWithURL:[_imageObject thumbNailURL]];
    
}
#pragma mark Utility Functions -

-(UIFont*)fontForLabelType:(pLabelType) labelType
{
    float       fontSize;
    NSString    *fontFamily;
    
    switch (labelType) {
            
        case pLabelTypeTitle:
            fontSize = 27.0;
            fontFamily = @"DINAlternate-Bold";
            break;
            
        case pLabelTypeCategory:
            fontSize = 18.0;
            fontFamily = @"DINAlternate-Bold";
            break;
            
        case pLabelTypeBasic:
            fontSize = 20.0;
            fontFamily = @"DINAlternate-Bold";
            break;
            
        default:
            fontSize = 15.0;
            fontFamily = @"Papyrus";
            break;
            
    }
    
    return [UIFont fontWithName:fontFamily
                           size:fontSize];
    
}
-(void)stopAllTheGlowing
{
    _expanded = YES;
    
    [self largeResize];
}
-(void)largeResize
{
    

    
    if (!_expanded) {
        
        UIColor *glowColor  =   [UIColor whiteColor];
        float   glowIntensity   =   0.2;
        
        [self.containerView startGlowingWithColor:glowColor intensity:glowIntensity];
        
        _expanded = YES;
        
    }
    else
    {
        
        [self.containerView stopGlowing];
        
        _expanded = NO;
        
    }
    
}
-(POPSpringAnimation*)fromLeftAnimation
{
    
    POPSpringAnimation *motionSpring = [POPSpringAnimation animation];
    
    motionSpring.property   = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
    
    motionSpring.fromValue  = @(-200.0);
    motionSpring.toValue    = @(0);
    
    motionSpring.springBounciness   = 1.5;
    motionSpring.springSpeed        = 0.4;
    
    return motionSpring;
    
}
-(POPBasicAnimation*)alphaAnimation
{
    POPBasicAnimation *ani = [POPBasicAnimation animation];
    
    ani.property    = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    
    ani.fromValue   = @(0.0);
    ani.toValue     = @(1.0);
    
    ani.duration    = 0.35;
    
    return ani;
    
}

@end
