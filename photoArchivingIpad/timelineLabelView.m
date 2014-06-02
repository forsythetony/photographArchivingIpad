//
//  timelineLabelView.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "timelineLabelView.h"

@implementation timelineLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context, self.bounds.size.width / 2.0, 3.0);
    CGContextAddLineToPoint(context, self.bounds.size.width / 2.0, 15);
    
    CGContextStrokePath(context);
     */
}


@end
