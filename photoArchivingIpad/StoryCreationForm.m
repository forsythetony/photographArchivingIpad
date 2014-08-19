//
//  StoryCreationForm.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoryCreationForm.h"

typedef NS_ENUM(NSInteger, ViewType) {
    ViewTypeTitleLabel
    
};
@interface StoryCreationForm () {
    
    UILabel *titleLabel;
    UIView *storyTellerCont, *storyTitleCont, *dateCont;
    
    UILabel *storyTellerLabel;
    UITextField *storyTellerField;
    
}

@end
@implementation StoryCreationForm

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews
{
    self.backgroundColor = [UIColor grayColor];
    
    titleLabel = [self viewTitleviewCreate];
    
    
    
    //[self addConstraintsToView:title ofType:ViewTypeTitleLabel];
    
}
-(UILabel*)viewTitleviewCreate
{
    UILabel *label;
    
    //  Frame
    
    CGFloat labelHeight = 30.0;
    CGFloat labelY = 0.0;
    
    CGRect labelRect = [self genericFrameAtY:labelY andHeight:labelHeight];
    
    
    //  Properties
    
    UIFont *titleLabelFont = [UIFont fontWithName:@"DINAlternate-Bold" size:20.0];
    
    UIColor *titleLabelColor = [UIColor blackColor];
    
    NSString *titleLabelString = @"Create Story";
    
    NSTextAlignment align = NSTextAlignmentCenter;
    
    //  Set properties
    
    label = [[UILabel alloc] initWithFrame:labelRect];
    
    label.font = titleLabelFont;
    label.textColor = titleLabelColor;
    label.text = titleLabelString;
    label.textAlignment = align;
    
    [self addSubview:label];
    
    return label;
    
}

-(CGRect)genericFrameAtY:(CGFloat) Y andHeight:(CGFloat) height
{
    CGRect genericRect;
    
    genericRect.size.width = self.frame.size.width;
    genericRect.size.height = height;
    genericRect.origin.x = 0.0;
    genericRect.origin.y = Y;
    
    return genericRect;
}
/*
-(void)addConstraintsToView:(UIView*) theView ofType:(ViewType) type
{
    switch (type) {
        case ViewTypeTitleLabel: {
            
            
            [theView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:theView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            
            [theView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:theView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]];
            
            [theView addConstraint:[NSLayoutConstraint constraintWithItem:theView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:theView.bounds.size.height]];
            
            [theView addConstraint:[NSLayoutConstraint constraintWithItem:theView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:theView.bounds.size.width]];
            

        }
            break;
            
        default:
            break;
    }
}
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
