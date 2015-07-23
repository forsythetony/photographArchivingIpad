//
//  TFPopOverBasicView.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageObject.h"

@protocol TFPopOverViewDelegate;

@interface TFPopOverBasicView : UIView

@property (nonatomic, strong)  imageObject  *img;
@property (nonatomic, weak) id<TFPopOverViewDelegate> delegate;
-(void)animateThings;
-(void)hideThings;
@end

@protocol TFPopOverViewDelegate <NSObject>

-(void)shouldHidePanel:(TFPopOverBasicView*) t_panel;
-(void)didDoubleTapImage:(TFPopOverBasicView*) t_panel;

@end
