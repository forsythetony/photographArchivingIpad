//
//  largeImageViewerDelegate.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol largeImageViewerDelegate <NSObject>

@optional
-(void)shouldDismissImageViewer:(id) imageViewer;

@end
