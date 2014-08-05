//
//  PreviewView.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/5/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "PreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation PreviewView


+ (Class)layerClass
{
	return [PreviewView class];
}

- (AVCaptureSession *)session
{
	return [(PreviewView *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
	[(PreviewView *)[self layer] setSession:session];
}

@end
