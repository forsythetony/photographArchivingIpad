//
//  PhotoUploadingViewControllerv2.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 1/19/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoUploadingViewControllerv2 : UIViewController
@property (weak, nonatomic) IBOutlet UIView *controlPanelContainer;
@property (weak, nonatomic) IBOutlet UITableView *photosToUpload;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@end
