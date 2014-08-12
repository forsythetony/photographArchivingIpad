//
//  StoryRecordingMeter.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoryRecordingMeter.h"

#import <Colours/Colours.h>

@interface StoryRecordingMeter ()

@property (nonatomic, strong) UIView *levelView;


@end
@implementation StoryRecordingMeter
@synthesize levelView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
           }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)addMeterToView
{
    UIColor *backgroundColor = [UIColor whiteColor];

    
    self.backgroundColor = backgroundColor;
    
    levelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 0.0)];
    
    levelView.backgroundColor = backgroundColor;
    
    [self addSubview:levelView];

}
-(void)updateLevelToPercentage:(CGFloat)percentage
{
    
    UIColor *meterColor = [UIColor indigoColor];
    self.backgroundColor = meterColor;
    
    CGFloat newPercentage = 1.0 - percentage;
    
    CGFloat newHeight = self.frame.size.height * newPercentage;
    
    CGRect newFrame;
    
    newFrame.origin = levelView.frame.origin;
    
    newFrame.size.width = levelView.frame.size.width;
    
    newFrame.size.height = newHeight;
    
    [levelView setFrame:newFrame];
}


@end
