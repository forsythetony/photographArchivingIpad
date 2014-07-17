//
//  PhotoUploadManager.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 7/17/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <InformationForm.h>
#import <ImageTakerViewController.h>

@interface PhotoUploadManager : NSObject

@property (strong, nonatomic) InformationForm *infoForm;
@property (strong, nonatomic) ImageTakerViewController *imageTaker;

-(id)initWithInfoContainer:(UIView*) infoContainer andImageTakerContainer:(UIView*) takerContainer;

@end
