//
//  TFImageDisplayer.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageObject.h"

@protocol TFImageDisplayerDelegate;

@interface TFImageDisplayer : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) imageObject *image;
@property (nonatomic, weak) id<TFImageDisplayerDelegate> delegate;

@end

@protocol TFImageDisplayerDelegate <NSObject>

-(void)TFImageDisplayerShouldDismiss:(TFImageDisplayer*) t_displayer;

@end
