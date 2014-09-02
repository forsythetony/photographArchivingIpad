//
//  TATriggerFrame.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 9/2/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TriggerOrientation) {
    TriggerOrientationLeft,
    TriggerOrientationRight
};
@interface TATriggerFrame : UIView {
    
    float current_value;
    float new_to_value;
    
    UILabel *ProgressLbl;
    
    id delegate;
    
    BOOL IsAnimationInProgress;

}


@property id delegate;
@property float current_value;
@property float totalTime;
@property TriggerOrientation orientation;

@property (nonatomic, strong) UIColor *triggerColor;

- (void)setProgress:(NSNumber*)value;

-(void)start;
-(void)stop;


@end

@protocol TATriggerFrameDelegate
- (void)didFinishAnimation:(TATriggerFrame*)progressView;
@end