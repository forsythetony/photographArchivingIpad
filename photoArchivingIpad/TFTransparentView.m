//
//  TFTransparentView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFTransparentView.h"


@interface TFTransparentView ()

@property (nonatomic, strong) UIVisualEffectView *ev;

@end
@implementation TFTransparentView

-(instancetype)initWithFrame:(CGRect)frame imageType:(TFTransparentViewImageType)t_imageType
{
    if (self = [super initWithFrame:frame]) {
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.contentMode = UIViewContentModeTopLeft;
        
        imgView.image = [self imageForImageType:t_imageType];
        
        [self addSubview:imgView];
        
        
        self.ev = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        
        self.ev.frame = imgView.bounds;
        
        [imgView addSubview:self.ev];
    }
    
    return self;
}
-(UIView *)contentView
{
    return self.ev.contentView;
}
-(UIImage*)imageForImageType:(TFTransparentViewImageType) t_type
{
    NSString    *path = nil;
    
    switch (t_type) {
        case TFTransparentViewImageTypeScrapbook:
            path = @"CollageThing_light.jpg";
            break;
            
        default:
            path = @"CollageThing_light.jpg";
            break;
    }
    
    return [UIImage imageNamed:path];
}
@end
