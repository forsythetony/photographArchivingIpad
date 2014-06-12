//
//  TFPerson.h
//  PhotoArchiving
//
//  Created by Anthony Forsythe on 3/25/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFPerson : NSObject

@property (nonatomic, weak) NSString    *username;
@property (nonatomic, weak) NSString    *firstName;
@property (nonatomic, weak) NSString    *lastName;
@property (nonatomic, weak) NSString    *photoUrl;
@property (nonatomic, weak) UIImage     *profileImage;

@end
