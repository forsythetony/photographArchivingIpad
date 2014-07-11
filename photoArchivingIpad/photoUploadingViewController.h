//
//  photoUploadingViewController.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Colours.h>
#import "TFDataCommunicator.h"
#import "photoUploadingConstants.h"
#import "imageHandling.h"
#import "ImagePackage.h"
#import "imageInformationVC.h"
#import <InformationForm.h>

@interface photoUploadingViewController : UIViewController <TFCommunicatorDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, InformationFormDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoUploadsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *formContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;


@end