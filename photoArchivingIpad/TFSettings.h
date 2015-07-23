//
//  TFSettings.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/17/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TFAudioPlayType) {
    TFAudioPlayTypeDevice,
    TFAudioPlayTypeDefault
};

@interface TFSettings : NSObject

+(TFAudioPlayType)TFAudioPlayerOutputOverride;
+(BOOL)TFShouldUseChromecast;

@end
