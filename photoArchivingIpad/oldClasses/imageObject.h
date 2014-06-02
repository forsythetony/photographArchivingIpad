//
//  imageObject.h
//  UniversalAppDemo
//
//  Created by Anthony Forsythe on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageObject : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate* date;

@property (nonatomic, strong) NSDictionary *imageInformation;
@property (nonatomic, strong) NSNumber* centerXoffset;

@end
