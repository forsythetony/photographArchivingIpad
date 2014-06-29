//
//  photoUploadingViewController.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Colours.h>
#import <XLForm.h>
#import "uploadFormViewController.h"
#import "TFDataCommunicator.h"
#import "photoUploadingConstants.h"
#import "imageHandling.h"
#import "ImagePackage.h"
#import "imageInformationVC.h"

@interface photoUploadingViewController : UIViewController <TFCommunicatorDelegate, XLFormViewControllerPresenting, XLFormViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoUploadsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *formContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@property (strong, nonatomic) uploadFormViewController *myForm;

@end
