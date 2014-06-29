//
//  ImageTakerViewController.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/20/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTakerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@end
