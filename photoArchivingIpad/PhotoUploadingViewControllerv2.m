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
#import "IQMediaPickerController.h"

@interface PhotoUploadingViewControllerv2 () <IQMediaPickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) IQMediaPickerController *assetsPicker;
@property (nonatomic, strong) UIImageView* imageDisplay;

@end

@implementation PhotoUploadingViewControllerv2



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageDisplay = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_imageDisplay];
    
    [_imageDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.equalTo(self.view).with.insets(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)).priorityHigh();
    }];
    
    _assetsPicker = [[IQMediaPickerController alloc] init];
    [_assetsPicker setAllowsPickingMultipleItems:YES];
    [_assetsPicker setDelegate:self];
    [_assetsPicker setMediaType:IQMediaPickerControllerMediaTypePhotoLibrary];
    [self presentViewController:_assetsPicker animated:YES completion:nil];
}
-(void)mediaPickerController:(IQMediaPickerController *)controller didFinishMediaWithInfo:(NSDictionary *)info
{
   
    NSLog(@"%@", [info description]);
    
    NSArray *images = info[IQMediaTypeImage];
    
    [_imageDisplay setImage:images[0][IQMediaImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)mediaPickerControllerDidCancel:(IQMediaPickerController *)controller
{

    [self dismissViewControllerAnimated:YES completion:nil];
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
