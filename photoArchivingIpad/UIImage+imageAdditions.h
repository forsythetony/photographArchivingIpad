//
//  UIImage+imageAdditions.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageAdditions)

-(UIColor*)getDominantColor;
+(UIImage*)createThumbnailImageWithImage:(UIImage*) image;
@end
