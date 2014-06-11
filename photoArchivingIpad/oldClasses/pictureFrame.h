//
//  pictureFrame.h
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>
#import <Colours.h>
#import "imageObject.h"
#import "NSDate+timelineStuff.h"

typedef NS_ENUM(NSInteger, pLabelType) {
    pLabelTypeTitle,
    pLabelTypeBasic,
    pLabelTypeCategory
};

@interface pictureFrame : UIView <POPAnimationDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *theImage;

@property (nonatomic, strong) imageObject* imageObject;
@property (nonatomic, strong) NSDictionary* imageInformation;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, assign) BOOL expanded;

//- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

+ (id) createFrame;

-(void)resize;
-(void)bounceInFromPoint:(CGFloat) startPoint toPoint:(CGFloat) endPoint;
-(void)subtleBounce;
-(void)setImageObject:(imageObject *)imageObject;
-(void)largeResize;

@end
