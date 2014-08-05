//
//  PreviewView.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/5/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface PreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
