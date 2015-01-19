//
//  TAProgressView.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 9/2/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TAProgressView : UIView {

    float new_to_value;
    UILabel *ProgressLbl;
    BOOL IsAnimationInProgress;
    
}


@property id delegate;
@property float current_value;


- (id)init;
- (void)setProgress:(NSNumber*)value;


@end

@protocol CustomProgressViewDelegate
- (void)didFinishAnimation:(TAProgressView*)progressView;
@end

