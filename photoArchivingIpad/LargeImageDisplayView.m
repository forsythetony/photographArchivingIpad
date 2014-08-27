//
//  LargeImageDisplayView.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/14/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "LargeImageDisplayView.h"

@interface LargeImageDisplayView () <UIScrollViewDelegate> {
    
    UIScrollView *imageScrollView;
    UIImageView *displayImageView;
    
}

@end
@implementation LargeImageDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDisplayedImage:(UIImage *)displayedImage
{
    imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [imageScrollView setContentSize:displayedImage.size];
    
    displayImageView = [[UIImageView alloc] initWithImage:displayedImage];
    [imageScrollView addSubview:displayImageView];
    
    [self addSubview:imageScrollView];
    imageScrollView.zoomScale = self.frame.size.width / displayedImage.size.width;
    imageScrollView.maximumZoomScale = 2.0;
    imageScrollView.minimumZoomScale = 0.5;
    
    //[displayImageView setCenter:[imageScrollView center]];
    imageScrollView.zoomScale = 0.9;
    
    
    
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.delegate = self;
    
    _displayedImage = displayedImage;
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return displayImageView;
}

@end
