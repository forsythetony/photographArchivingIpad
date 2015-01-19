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

@interface PhotoUploadingViewControllerv2 () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation PhotoUploadingViewControllerv2



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePicker = [[UIImagePickerController alloc] init];
        [_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    }
}
- (void)viewDidAppear:(BOOL)animated
{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

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
