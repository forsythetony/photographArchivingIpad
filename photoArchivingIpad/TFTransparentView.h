//
//  TFTransparentView.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFTransparentViewImageType) {
    TFTransparentViewImageTypeScrapbook,
    TFTransparentViewImageTypeNone
};

@interface TFTransparentView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;

-(instancetype)initWithFrame:(CGRect)frame
                   imageType:(TFTransparentViewImageType) t_imageType;
@end
