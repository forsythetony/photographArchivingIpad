//
//  ImageInformationDisplayer.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imageObject.h"

@protocol ImageInformationDisplayer <NSObject>

-(void)updateInformationForImage:(imageObject*) information;

@end
