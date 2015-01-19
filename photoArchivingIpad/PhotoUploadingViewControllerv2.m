//
//  PhotoUploadingViewControllerv2.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 1/19/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "PhotoUploadingViewControllerv2.h"
#import <Masonry/Masonry.h>
#import <FAKFoundationIcons.h>

@interface PhotoUploadingViewControllerv2 ()

@end

@implementation PhotoUploadingViewControllerv2

@synthesize controlPanelContainer,
            photosToUpload,
            takePhotoButton;

- (void)viewDidLoad {
    [super viewDidLoad];

 [self aestheticsConfiguration];
}
- (void)viewDidAppear:(BOOL)animated
{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
-(void)aestheticsConfiguration
{
    [self applyMasonryConstraints];
    
    UIColor *cameraButtonColor = [UIColor whiteColor];
    
    CGSize takePhotoButtonSize = takePhotoButton.frame.size;
    
    FAKFoundationIcons *cameraIcon = [FAKFoundationIcons cameraIconWithSize:takePhotoButtonSize.width];
    [cameraIcon setAttributes:@{NSForegroundColorAttributeName : cameraButtonColor}];
    [takePhotoButton setImage:[cameraIcon imageWithSize:takePhotoButtonSize] forState:UIControlStateNormal];
    [takePhotoButton setBackgroundColor:[UIColor clearColor]];
    [takePhotoButton setTintColor:cameraButtonColor];
    
    
}
-(void)applyMasonryConstraints
{
    
    [photosToUpload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.left.equalTo(self.view).with.offset(5.0);
        make.height.equalTo(self.view).with.offset(100.0);
    }];
    
    [controlPanelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.view).with.offset(5.0);
        make.height.greaterThanOrEqualTo(@100.0).with.priority(200.0);
    }];
    
    [takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.and.bottom.equalTo(controlPanelContainer).with.offset(5.0);
        //make.width.equalTo(takePhotoButton.mas_height);
    }];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
