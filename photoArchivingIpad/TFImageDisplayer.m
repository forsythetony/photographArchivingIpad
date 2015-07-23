//
//  TFImageDisplayer.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFImageDisplayer.h"
#import <UIImageView+WebCache.h>

@interface TFImageDisplayer () <UIScrollViewDelegate> {
    UIImageView *mainImageView;
    UIImageView *backgroundImageView;
    UITapGestureRecognizer *gest;
}
@end

@implementation TFImageDisplayer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    mainImageView.userInteractionEnabled = YES;
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:_mainScrollView.bounds];
    
    [_mainScrollView addSubview:backgroundImageView];
    
    [_mainScrollView addSubview:mainImageView];
    _mainScrollView.delegate = self;
}
-(void)handleDoubleTapGesture:(UITapGestureRecognizer*) t_gest
{
    if ([self.delegate respondsToSelector:@selector(TFImageDisplayerShouldDismiss:)]) {
        [self.delegate TFImageDisplayerShouldDismiss:self];
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return mainImageView;
}
-(void)setImage:(imageObject *)image
{
    _image = image;
    
    [mainImageView sd_setImageWithURL:image.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGSize imageSize = image.size;
        
        [mainImageView setFrame:CGRectMake(0.0, 0.0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height)];
        mainImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_mainScrollView setContentSize:imageSize];
        
        [mainImageView setImage:image];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
