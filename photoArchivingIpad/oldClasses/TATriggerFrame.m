//
//  TATriggerFrame.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 9/2/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TATriggerFrame.h"
#import <QuartzCore/QuartzCore.h>

@interface TATriggerFrame () {
    
    CALayer *boxLayer;
    
    NSTimer *triggerTimer;
    
    float animationDuration;
    CGFloat currentAlpha;
    
}

@end

@implementation TATriggerFrame

@synthesize delegate,
            current_value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        current_value = 0.0;
        new_to_value = 0.0;
        IsAnimationInProgress = NO;
        animationDuration = 0.01;
        boxLayer = nil;
        
        self.alpha = 1.0;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(void)SetAnimationDone
{
    IsAnimationInProgress = NO;
    if (new_to_value>self.current_value)
        [self setProgress:[NSNumber numberWithFloat:new_to_value]];
}
-(void)setProgress:(NSNumber *)value
{
    CGFloat newProgress = [value floatValue];
    
    CGFloat newWidth = self.bounds.size.width * newProgress;
    
    CGSize newSize = boxLayer.bounds.size;
    
    newSize.width = newWidth;
    
    [self resizeBoxToSize:newSize];
    
    
}
/*
- (void)setProgress:(NSNumber*)value{
    
    float to_value = [value floatValue];
    
    if (to_value<=self.current_value)
        return;
    else if (to_value>1.0)
        to_value = 1.0;
    
    if (IsAnimationInProgress)
    {
        new_to_value = to_value;
        return;
    }
    
    IsAnimationInProgress = YES;
    
    float animation_time = to_value-self.current_value;
    
    [self performSelector:@selector(SetAnimationDone) withObject:Nil afterDelay:animation_time];
    
    if (to_value == 1.0 && delegate && [delegate respondsToSelector:@selector(didFinishAnimation:)])
        [delegate performSelector:@selector(didFinishAnimation:) withObject:self afterDelay:animation_time];
    
   // [self setProgressValue:to_value withAnimationTime:animation_time];
    
    float start_angle = 2*M_PI*self.current_value-M_PI_2;
    float end_angle = 2*M_PI*to_value-M_PI_2;
    
    float radius = self.frame.size.width * .70;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    // Make a circular shape
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                 radius:radius startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = 3;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = animation_time;
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    self.current_value = to_value;
}
*/
-(void)setupBoxLayer
{
    boxLayer = [CALayer layer];
    
    CGColorRef triggerColor;
    
    if (_triggerColor) {
        triggerColor = [_triggerColor CGColor];
    }
    else
    {
        triggerColor = [[UIColor redColor] CGColor];
    }
    
    
    boxLayer.backgroundColor = triggerColor;
    
    
    CGRect boxFrame;
    
    boxFrame.origin = CGPointMake(0.0, 0.0);
    boxFrame.size.width = 3.0;
    boxFrame.size.height = self.frame.size.height;
    
    [boxLayer setOpacity:0.0];
    boxLayer.frame = boxFrame;
    
    [self.layer addSublayer:boxLayer];
}
-(void)resizeBoxToSize:(CGSize) size
{
    CGRect oldBounds = boxLayer.bounds;
    CGRect newBounds = oldBounds;
    
    newBounds.size = size;
    
    CABasicAnimation *positionChange = [CABasicAnimation animationWithKeyPath:@"position"];
    
    CGPoint oldPos = boxLayer.position;
    CGPoint newPos = boxLayer.position;
    
    newPos.x = size.width / 2;
    
    positionChange.fromValue = [NSValue valueWithCGPoint:oldPos];
    positionChange.toValue = [NSValue valueWithCGPoint:newPos];
    positionChange.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    boxLayer.position = newPos;
    
    [boxLayer setOpacity:currentAlpha];
    
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    
    boxLayer.bounds = newBounds;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[positionChange, animation];
    group.duration = animationDuration;
    
    
    
    [boxLayer addAnimation:group forKey:@"frame"];
    
    
}
-(void)stop
{
    IsAnimationInProgress = NO;
    [self tearDownTimer];
    [boxLayer removeFromSuperlayer];
    boxLayer = nil;
    [self setupBoxLayer];

}
-(void)start
{
    if (!IsAnimationInProgress) {
        if (!boxLayer) {
            [self setupBoxLayer];
        }
        IsAnimationInProgress = YES;
        [self startTimer];
        
    }
    

    
}
-(void)startTimer
{
    current_value = 0.0;
    triggerTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(updateTrigger) userInfo:nil repeats:YES];
}
-(void)tearDownTimer
{
    [triggerTimer invalidate];
    triggerTimer = nil;
    
}
-(void)updateTrigger
{
    current_value++;
    
    CGSize newSize = [self calculateNewSizeWithTime:current_value];
    
        [self resizeBoxToSize:newSize];
    
    NSLog(@"Current: %f / Total: %f", current_value, _totalTime);
    
    if (current_value * animationDuration == _totalTime) {
        
        [self didFinish];
    }
    
}
-(void)didFinish
{
    IsAnimationInProgress = NO;
    [self tearDownTimer];
    
    [self.delegate didFinishAnimation:self];
}

-(CGSize)calculateNewSizeWithTime:(float) time
{
    CGFloat timePieces = _totalTime / animationDuration;
    CGFloat things = self.bounds.size.width / timePieces;
    
    CGFloat newSize = time * things;
    
    CGSize size = self.bounds.size;
    
    currentAlpha = (0.5 / self.bounds.size.width) * newSize;
    
    size.width = newSize;
    
    return size;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
