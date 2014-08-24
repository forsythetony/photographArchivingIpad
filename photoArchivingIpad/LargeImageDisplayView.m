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
    [imageScrollView addSubview:[[UIImageView alloc] initWithImage:displayedImage]];
    
    [self addSubview:imageScrollView];
    imageScrollView.zoomScale = self.frame.size.width / displayedImage.size.width;
    imageScrollView.maximumZoomScale = 10.0;
    imageScrollView.minimumZoomScale = 0.1;
    _displayedImage = displayedImage;
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [[UIImageView alloc] initWithImage:_displayedImage];
}

@end
