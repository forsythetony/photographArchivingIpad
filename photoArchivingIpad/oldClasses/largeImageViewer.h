//
//  largeImageViewer.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>
#import "imageObject.h"

#import "imageHandling.h"
#import <LiveFrost.h>

#import "largeImageViewerDelegate.h"
#import "UIImage+imageAdditions.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface largeImageViewer : UIViewController <largeImageViewerDelegate>

@property (strong, nonatomic) imageObject *imageObj;
@property (strong, nonatomic) IBOutlet UIImageView *displayImage;

@property (weak, nonatomic) id <largeImageViewerDelegate> delegate;

+(id)createLargeViewerWithFrame:(CGRect) frame;

-(void)setDisplayedImage:(imageObject*) image;

@end
