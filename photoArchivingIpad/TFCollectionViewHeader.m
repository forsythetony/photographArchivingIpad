//
//  TFCollectionViewHeader.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFCollectionViewHeader.h"
#import "TFCounterView.h"
#import "TFProperties.h"
#import "TFDateView.h"
#import "TFVisualConstants.h"
#import <FAKIonIcons.h>
#import <Masonry/Masonry.h>




@interface TFCollectionViewHeader () {
    
    TFCounterView   *img_counter;
    TFViewProperties *img_counter_props;
    
    UILabel *title_label;
    TFLabelProperties *title_label_props;
    
    TFDateView  *dateView_left, *dateView_right;
    TFViewProperties    *dateView_left_props, *dateView_right_props;
    
    UIButton    *exitButton;
    
}

@property (nonatomic, strong) UIVisualEffectView *ev;
@property (nonatomic, assign) TFTransparentViewImageType imageType;

@end

static CGSize modSizeByFactor(CGSize t_size, CGFloat t_factor)
{
    return CGSizeMake(t_size.width * t_factor, t_size.height);
}
static CGSize squareSizeWithDimensionAndFactor(CGFloat t_dim, CGFloat t_factor)
{
    return CGSizeMake(t_dim * t_factor, t_dim * t_factor);
}

@implementation TFCollectionViewHeader

-(instancetype)initWithFrame:(CGRect)t_frame datasource:(id<TFCollectionViewHeaderDataSource>)t_datasource delegate:(id<TFCollectionViewHeaderDelegate>)t_delegate transparentViewType:(TFTransparentViewImageType)t_imageType
{
    if (self = [super initWithFrame:t_frame]) {
        self.frame = t_frame;
        self.imageType = t_imageType;
        
        _datasource = t_datasource;
        _delegate = t_delegate;
        
        [self setupViews];
    }
    
    return self;
}
-(void)setupLooks
{
    title_label_props = [TFLabelProperties new];
    
    CGFloat mod_title_width = 0.3;
    CGFloat mod_title_height = 1.0;
    CGFloat title_width = self.frame.size.width * mod_title_width;
    CGFloat title_height = self.frame.size.height * mod_title_height;
    
    title_label_props.frame = CGRectMake(0.0, 0.0, title_width, title_height);
    title_label_props.fontSize = 40.0;
    title_label_props.fontFamily = [TFVisualConstants TFFontFamilyOneMedium];
    title_label_props.textColor = [UIColor whiteColor];
    
    dateView_left_props = [TFViewProperties new];
    
    CGFloat mod_date_width = 0.15;
    CGFloat width_date = self.frame.size.width * mod_date_width;
    
    dateView_left_props.frame = CGRectMake(0.0, 0.0, width_date, title_height);
    
    
    dateView_right_props = [TFViewProperties new];
    
    dateView_right_props.frame = dateView_left_props.frame;
    
}
-(void)setupViews
{
    [self setupLooks];
    
    //  Main Visual Effect View
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imgView.contentMode = UIViewContentModeTopLeft;
    
    imgView.image = [self imageForImageType:self.imageType];
    
    [self addSubview:imgView];
    
    self.ev = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.ev.frame = imgView.bounds;
    
    [imgView addSubview:self.ev];
    
    
    
    
    
    
    
    title_label = [[UILabel alloc] initWithFrame:title_label_props.frame];
    
    [title_label TFConfigureLabelWithProperties:title_label_props];
    
    title_label.text = [self.datasource TFCollectionViewHeaderTitle];
    [title_label sizeToFit];
    
    [self.contentView addSubview:title_label];
    
    

    
    dateView_left = [[TFDateView alloc] initWithFrame:dateView_left_props.frame];
    
    [dateView_left TFConfigureViewWithProperties:dateView_left_props];
    
    [self.contentView addSubview:dateView_left];
    
    [dateView_left setDate:[self.datasource TFCollectionViewHeaderStartDate]];
    
    
    dateView_right = [[TFDateView alloc] initWithFrame:dateView_right_props.frame];
    [dateView_right TFConfigureViewWithProperties:dateView_right_props];
    
    [dateView_right setDate:[self.datasource TFCollectionViewHeaderEndDate]];
    
    [self.contentView addSubview:dateView_right];
    
    
    CGSize iconSize = squareSizeWithDimensionAndFactor(self.bounds.size.height, 0.6);
    
    
    FAKIonIcons *cancelIcon = [FAKIonIcons ios7CloseIconWithSize:iconSize.height];
    
    [cancelIcon setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    UIImage *cancelImage= [cancelIcon imageWithSize:iconSize];
    
    CGSize  cancelButtonSize = squareSizeWithDimensionAndFactor(self.bounds.size.height, 1.0);
    
    exitButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, cancelButtonSize.width, cancelButtonSize.height)];
    
    [exitButton setImage:cancelImage forState:UIControlStateNormal];
    
    [exitButton addTarget:self action:@selector(handleExitButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:exitButton];
    
    
    
    
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat topOffset = 5.0;
        
        make.width.mas_equalTo(cancelButtonSize.width);
        make.height.mas_equalTo(cancelButtonSize.height);
        make.top.equalTo(self).with.offset(topOffset);
        make.left.equalTo(self);
    }];
    
    [dateView_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(dateView_right_props.frame.size.width);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(title_label.mas_right);
    }];
    
    [dateView_left mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(dateView_left_props.frame.size.width);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(title_label.mas_left);
    }];
    
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(title_label_props.frame.size.width);
        make.height.mas_equalTo(title_label_props.frame.size.height);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
}
-(void)reloadData
{
    if (title_label) {
        title_label.text = [self.datasource TFCollectionViewHeaderTitle];
        [title_label sizeToFit];
    }
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
-(void)handleExitButton:(UIButton*) t_sender
{
    [self.delegate TFCollectionViewHeaderDidClickExit];
}
@end
