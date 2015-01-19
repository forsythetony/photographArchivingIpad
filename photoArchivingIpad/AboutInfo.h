//
//  AboutInfo.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 1/19/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, InfoType) {
    InfoTypeProject,
    InfoTypePersonal
};

@interface AboutInfo : NSObject

+(instancetype)initWithDictionary;


@property (nonatomic, assign) InfoType type;

@end
