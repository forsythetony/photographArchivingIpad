//
//  ImageDisplayRecordingSliderView.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "ImageDisplayRecordingSliderView.h"
#import <pop/POP.h>
#import <Colours.h>

#define CORNERRADIUS 45.0

typedef struct SliderBounds_t {
    
    CGFloat leftBound;
    CGFloat rightBound;
    
    CGFloat recordingAreaLeftBound;
    
    

    
} SliderBounds;


CGPoint getNewOrigin( CGSize frameSize , CGSize viewSize)
{
    CGPoint newOrigin;
    
    newOrigin.x = (frameSize.width / 2.0) - (viewSize.width / 2.0);
    newOrigin.y = (frameSize.height / 2.0) - (viewSize.height / 2.0);
    
    return newOrigin;
};


@interface ImageDisplayRecordingSliderView () {
    
    SliderBounds recSliderBounds;
    CGPoint firstPoint;
    
    UIView *recSlider;
    UIView *recSliderLine;
    
    BOOL isSliderLocker;
    BOOL releaseToRecord;
    
    UILabel *recSliderLabel;
    UILabel *recSliderTimeLabel;
    
    NSTimer *recordingTimer;
    NSInteger secondsPassed;
    
}

@end
@implementation ImageDisplayRecordingSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self variableSetup];
        [self setupViews];
    }
    return self;
}
-(void)variableSetup
{
    isSliderLocker = NO;
    releaseToRecord = NO;
}
-(void)aestheticsConfiguration
{
    
}

//  View Creation
-(void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    
    recSliderLine = [self createSliderLine];
    recSlider = [self createRecordingSlider];
    
    recSlider.center = [self findInitialCenterWithSlideView:recSliderLine andRecView:recSlider];
    
    [self addSubview:recSliderLine];
    [self addSubview:recSlider];
    
}
-(UIView*)createSliderLine
{
    //  New View
    UIView *sliderLineView;
    
    CGFloat sliderLineHeight, sliderLineWidth;
    CGPoint sliderOrigin;
    
    CGRect sliderFrame;
    //  New View properties
    
    UIColor *sliderLineColor = [UIColor charcoalColor];
    
    
    sliderLineHeight = self.frame.size.height * 0.75;
    sliderLineWidth = self.frame.size.width * .75;
    
    sliderOrigin = getNewOrigin(self.frame.size, CGSizeMake(sliderLineWidth, sliderLineHeight));
    
    sliderFrame.size.width = sliderLineWidth;
    sliderFrame.size.height = sliderLineHeight;
    sliderFrame.origin = sliderOrigin;
    
    
    sliderLineView = [[UIView alloc] initWithFrame:sliderFrame];
    sliderLineView.backgroundColor = sliderLineColor;
    
    UILabel *relLabel;
    
    CGRect labelFrame = sliderLineView.bounds;
    

    
    CGFloat widthOfRecSlider = self.frame.size.height * 0.8;
    
    CGFloat widthOfLabel = sliderLineView.bounds.size.width - widthOfRecSlider - 5.0;
    CGFloat xOriginOfLabel = widthOfRecSlider + 5.0;
    
    labelFrame.size.width = widthOfLabel;
    labelFrame.origin.x = xOriginOfLabel;
    
    relLabel = [[UILabel alloc] initWithFrame:labelFrame];
    

    //  Set label Properties
    
    relLabel.text = @"Slide to Record";
    
    relLabel.textAlignment = NSTextAlignmentLeft;
    relLabel.alpha = 1.0;
    relLabel.textColor = [UIColor whiteColor];
    [sliderLineView addSubview:relLabel];
    recSliderLabel = relLabel;
    
    
    sliderLineView.layer.cornerRadius = CORNERRADIUS;
    
    return sliderLineView;
}
-(UIView*)createRecordingSlider
{
    //  New View
    
    UIView *recordingSlider;
    
    CGFloat recSliderWidth, recSliderHeight;
    CGPoint recSliderOrigin;
    
    CGRect recSliderFrame;
    
    //  New View Properties
    
    UIColor *recSliderColor = [UIColor fadedBlueColor];
    
    recSliderWidth = self.frame.size.height * 0.8;
    recSliderHeight = self.frame.size.height * 0.8;
    
    recSliderOrigin = CGPointMake(0.0, 0.0);
    
    recSliderFrame.origin = recSliderOrigin;
    recSliderFrame.size = CGSizeMake(recSliderWidth, recSliderHeight);
    
    
    recordingSlider = [[UIView alloc] initWithFrame:recSliderFrame];
    recordingSlider.backgroundColor = recSliderColor;
    
    
    
    CGFloat sliderTimeLabelHeight = recSliderFrame.size.height / 3;
    
    CGFloat sliderTimeLabelWidth = recSliderFrame.size.width * 0.8;
    
    CGRect sliderTimeLabelFrame = CGRectMake(0.0, 0.0, sliderTimeLabelWidth, sliderTimeLabelHeight);
    
    recSliderTimeLabel = [[UILabel alloc] initWithFrame:sliderTimeLabelFrame];
    [recordingSlider addSubview:recSliderTimeLabel];
    recSliderTimeLabel.center = recordingSlider.center;
    
    recSliderTimeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:20.0];
    recSliderTimeLabel.textColor = [UIColor whiteColor];
    recSliderTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    recSliderTimeLabel.alpha = 0.0;
    
    
    //  Add gesture recognizer
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateRecordingSliderPosition:)];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSliderButton:)];
    
    
    [recordingSlider addGestureRecognizer:panGestureRecognizer];
    [recordingSlider addGestureRecognizer:tapGest];
    
    recordingSlider.layer.cornerRadius = CORNERRADIUS;
    
    return recordingSlider;
    
}
-(CGPoint)findInitialCenterWithSlideView:(UIView*) sliderView andRecView:(UIView*) recView
{
    CGFloat newY, newX;
    
    newY = sliderView.center.y;
    
    newX = sliderView.frame.origin.x + (recView.bounds.size.width / 2.0);
    
    recSliderBounds.leftBound = newX;
    recSliderBounds.rightBound = sliderView.frame.origin.x + sliderView.frame.size.width - (recView.bounds.size.width / 2.0);
    
    recSliderBounds.recordingAreaLeftBound = recSliderBounds.rightBound - 20.0;
    
    return CGPointMake(newX, newY);
}
-(CGPoint)findFinalCenterWithSliderView:(UIView*) sliderView andRecView:(UIView*) recView
{
    CGFloat newY, newX;
    
    newY = sliderView.center.y;
    
    newX = sliderView.frame.origin.x + sliderView.frame.size.width - (recView.bounds.size.width / 2.0);
    
    recSliderBounds.leftBound = newX;
    recSliderBounds.rightBound = sliderView.frame.origin.x + sliderView.frame.size.width - (recView.bounds.size.width / 2.0);
    
    recSliderBounds.recordingAreaLeftBound = recSliderBounds.rightBound - (recSlider.frame.size.width / 2.0);
    
    return CGPointMake(newX, newY);
}
-(void)updateRecordingSliderPosition:(UIPanGestureRecognizer*) sender
{
    
    if (!isSliderLocker) {
    
    
    CGPoint trans = [sender translationInView:self];

    
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        firstPoint.x = [[sender view] center].x;
        firstPoint.y = [[sender view] center].y;
        
    }
    
    CGFloat newXTrans = firstPoint.x + trans.x;
    
    if (newXTrans >= recSliderBounds.leftBound && newXTrans <= recSliderBounds.recordingAreaLeftBound) {
        
        
        [self performSelectorOnMainThread:@selector(addSlideToRecord:) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(addReleaseToRecordLabel:) withObject:nil waitUntilDone:NO];
    }
    
    if (newXTrans >= recSliderBounds.leftBound && newXTrans <= recSliderBounds.rightBound) {
        trans = CGPointMake(firstPoint.x + trans.x, [[sender view] center].y);
        
        [[sender view] setCenter:trans];
        CGFloat newAlpha = [self calculateAlphaValueForPoint:trans.x];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            recSliderLabel.alpha = newAlpha;
            
        });
        
    }
    
    
    if ([sender state] == UIGestureRecognizerStateEnded)
    {
        
        CGFloat velocityX   = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self].x);
        
        CGFloat finalX      = trans.x;// + velocityX;
        CGFloat finalY      = trans.y;// + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            
            if (finalX < 0) {
                
                //finalX = 0;
                
            } else if (finalX > 768) {
                
                //finalX = 768;
            }
            
            if (finalY < 0) {
                
                finalY = 0;
                
            } else if (finalY > 1024) {
                
                finalY = 1024;
            }
            
        } else {
            
            if (finalX < 0) {
                
                //finalX = 0;
                
            } else if (finalX > 1024) {
                
                //finalX = 768;
            }
            
            if (finalY < 0) {
                
                finalY = 0;
                
            } else if (finalY > 768) {
                
                finalY = 1024;
            }
        }
        /*
        NSLog(@"\nRecording Area Bounds are: {%f , %f}", recSliderBounds.recordingAreaLeftBound, recSliderBounds.rightBound);
        
        NSLog(@"\nFinal X: %f\nFinal Y: %f", finalX, finalY);
        NSLog(@"\nNew X trans %f", newXTrans);
        */
        
        if (newXTrans >= recSliderBounds.recordingAreaLeftBound) {
            [self performSelectorOnMainThread:@selector(lockRecSliderAtEnd:) withObject:nil waitUntilDone:NO];
        }
        else
        {
              [self performSelectorOnMainThread:@selector(sendRecSliderBackToStart:) withObject:nil waitUntilDone:NO];
        }
        
        
    }

    }
}
-(void)startedRecording
{
    [self startTimer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        recSliderLabel.text = @"Recording";
        
    });
    
    [self.updaterDelegate shouldChangeButtonToState:ButtonStateDisabled];
    

}
-(void)stoppedRecording
{
    [self stopTimer];
    [self.updaterDelegate shouldChangeButtonToState:ButtonStateUploading];
}
-(void)stopTimer
{
    [recordingTimer invalidate];
    recordingTimer = nil;
    recSliderTimeLabel.alpha = 0.0;
    
}
-(void)startTimer
{
    recSliderTimeLabel.alpha = 1.0;
    secondsPassed = 0;
    
    recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}
-(void)updateTimer:(id) sender
{
    secondsPassed += 1;
    
    
    NSString *timerText = [NSString stringWithFormat:@"%d", secondsPassed];
    
    NSString *labelText = [NSString stringWithFormat:@"%@s", timerText];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [recSliderTimeLabel setText:labelText];
        
    });
    
    
}
-(void)sendRecSliderBackToStart:(id) sender
{
    POPSpringAnimation *sliderUpdate = [POPSpringAnimation animation];
    sliderUpdate.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    
    sliderUpdate.toValue = [NSValue valueWithCGPoint:[self findInitialCenterWithSlideView:recSliderLine andRecView:recSlider]];
    
    [recSlider pop_addAnimation:sliderUpdate forKey:@"sendSliderToStart"];
    
    
    POPSpringAnimation *shrinkAni = [POPSpringAnimation animation];
    shrinkAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    
    shrinkAni.fromValue = [self shrinkPoint];
    shrinkAni.toValue = [self fullPoint];
    
    [self setAnimationSpeedFast:shrinkAni];
    
    POPSpringAnimation *growAni = [POPSpringAnimation animation];
    growAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    
    growAni.fromValue = [self shrinkPoint];
    growAni.toValue = [self fullPoint];
    
    [self setAnimationSpeedFast:growAni];
    
    
    POPSpringAnimation *colorChange = [POPSpringAnimation animation];
    colorChange.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
    
    colorChange.toValue = [UIColor chartreuseColor];
    
    [self setAnimationSpeedFast:colorChange];
    
    [shrinkAni setCompletionBlock:^(POPAnimation *ani, BOOL maybe) {
        
    }];
    
    
    [recSliderLabel.layer pop_addAnimation:shrinkAni forKey:@"shrinkMe111"];
    [recSlider pop_addAnimation:colorChange forKey:@"colorC11"];
    
    recSliderLabel.text = @"Slide to Record";
    
    
    isSliderLocker = NO;
    
}
-(void)lockRecSliderAtEnd:(id) sender
{
    POPSpringAnimation *sliderUpdate = [POPSpringAnimation animation];
    sliderUpdate.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    
    sliderUpdate.toValue = [NSValue valueWithCGPoint:[self findFinalCenterWithSliderView:recSliderLine andRecView:recSlider]];
    
    [recSlider pop_addAnimation:sliderUpdate forKey:@"sendSliderToEnd"];

    [self.delegate didSlideToRecordLock];
    
    

    POPSpringAnimation *alphaChange = [POPSpringAnimation animation];
    alphaChange.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    alphaChange.fromValue = @(0.0);
    alphaChange.toValue = @(1.0);
    
    [self setAnimationSpeedFast:alphaChange];
    
    
    
    POPSpringAnimation *colorChange = [POPSpringAnimation animation];
    colorChange.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
    
    colorChange.toValue = [UIColor redColor];
    
    [self setAnimationSpeedFast:colorChange];
    

    [recSliderLabel pop_addAnimation:alphaChange forKey:@"alphaing"];
    [recSlider pop_addAnimation:colorChange forKey:@"colorC1"];
    
    recSliderLabel.text = @"Recording";
    
    
    isSliderLocker = YES;
}
-(void)tappedSliderButton:(id) sender
{
    UITapGestureRecognizer *gest = (UITapGestureRecognizer*)sender;
    
    if (isSliderLocker) {
        
        [self performSelectorOnMainThread:@selector(sendRecSliderBackToStart:) withObject:nil waitUntilDone:NO];
        [self.delegate didUnlockSliderWithRecordingTime:secondsPassed];
        
        POPSpringAnimation *shrinkAni = [POPSpringAnimation animation];
        shrinkAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        
        shrinkAni.fromValue = [self shrinkPoint];
        shrinkAni.toValue = [self fullPoint];
        
        [self setAnimationSpeedFast:shrinkAni];
        
        POPSpringAnimation *growAni = [POPSpringAnimation animation];
        growAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        
        growAni.fromValue = [self shrinkPoint];
        growAni.toValue = [self fullPoint];
        
        [self setAnimationSpeedFast:growAni];
        
        
        
        POPSpringAnimation *colorChange = [POPSpringAnimation animation];
        colorChange.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
        
        colorChange.toValue = [UIColor fadedBlueColor];
        
        [self setAnimationSpeedFast:colorChange];
        
        
        [shrinkAni setCompletionBlock:^(POPAnimation *ani, BOOL maybe) {
            
            //[recSliderLabel.layer pop_addAnimation:growAni forKey:@"growAni"];
            
        }];
        
        
        [recSliderLabel.layer pop_addAnimation:shrinkAni forKey:@"shrinkMe1"];
        [recSlider pop_addAnimation:colorChange forKey:@"changeCOLOR2"];
        recSliderLabel.text = @"Slide to Record";
        
        
        
        releaseToRecord = NO;
        
    }
    else
    {
        
    }
}
-(void)addReleaseToRecordLabel:(id) sender
{
    if (!releaseToRecord) {
    
        POPSpringAnimation *shrinkAni = [POPSpringAnimation animation];
        shrinkAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        
        shrinkAni.fromValue = [self shrinkPoint];
        shrinkAni.toValue = [self fullPoint];
        
        [self setAnimationSpeedFast:shrinkAni];
        
        POPSpringAnimation *growAni = [POPSpringAnimation animation];
        growAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        
        growAni.fromValue = [self shrinkPoint];
        growAni.toValue = [self fullPoint];
        
        [self setAnimationSpeedFast:growAni];
        
        
        POPSpringAnimation *colorChange = [POPSpringAnimation animation];
        colorChange.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
        
        colorChange.toValue = [UIColor chartreuseColor];
        
        [self setAnimationSpeedFast:colorChange];
        
        [shrinkAni setCompletionBlock:^(POPAnimation *ani, BOOL maybe) {

        }];
        
        
        [recSliderLabel.layer pop_addAnimation:shrinkAni forKey:@"shrinkMe1"];
        [recSlider pop_addAnimation:colorChange forKey:@"colorC"];
        
        recSliderLabel.text = @"Release to Record";
    releaseToRecord = YES;
    }
    
}
-(void)addSlideToRecord:(id) sender
{
    if (releaseToRecord) {
        
        
        POPSpringAnimation *shrinkAni = [POPSpringAnimation animation];
        shrinkAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        
        shrinkAni.fromValue = [self shrinkPoint];
        shrinkAni.toValue = [self fullPoint];
        
        [self setAnimationSpeedFast:shrinkAni];
        
        POPSpringAnimation *growAni = [POPSpringAnimation animation];
        growAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        
        growAni.fromValue = [self shrinkPoint];
        growAni.toValue = [self fullPoint];
        
        [self setAnimationSpeedFast:growAni];
        
        
        
        POPSpringAnimation *colorChange = [POPSpringAnimation animation];
        colorChange.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
        
        colorChange.toValue = [UIColor fadedBlueColor];
        
        [self setAnimationSpeedFast:colorChange];
        
        
        [shrinkAni setCompletionBlock:^(POPAnimation *ani, BOOL maybe) {
            
            //[recSliderLabel.layer pop_addAnimation:growAni forKey:@"growAni"];
            
        }];
        
        
        [recSliderLabel.layer pop_addAnimation:shrinkAni forKey:@"shrinkMe"];
        [recSlider pop_addAnimation:colorChange forKey:@"changeCOLOR"];
        recSliderLabel.text = @"Slide to Record";
        
        
        
        releaseToRecord = NO;
        
    }
}
-(NSValue*)shrinkPoint
{
    return [NSValue valueWithCGPoint:CGPointMake(0.1, 0.1)];
}
-(NSValue*)fullPoint
{
    return [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
}
-(NSValue*)fastVelocity
{
   return [NSValue valueWithCGPoint:CGPointMake(2.0, 2.0)];
}
-(void)setAnimationSpeedFast:(POPSpringAnimation*) ani
{
    ani.springSpeed = 20.0;
    ani.springBounciness = 6.0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(CGFloat)calculateAlphaValueForPoint:(CGFloat) thePoint
{
    CGFloat leftBound = firstPoint.x;
    CGFloat rightBound = firstPoint.x + recSliderLine.bounds.size.width - recSlider.bounds.size.width;
    
    CGFloat totalSpace = rightBound - leftBound;
    
    
    
    thePoint = thePoint - leftBound;
   // NSLog(@"TotalSpace is: %f\nThe Point is: %f", totalSpace, thePoint);
    
    return 1 - (thePoint / totalSpace);
}

@end
