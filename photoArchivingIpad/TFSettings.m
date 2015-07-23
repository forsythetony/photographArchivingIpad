//
//  TFSettings.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/17/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFSettings.h"

@implementation TFSettings

#pragma mark - Audio
+(TFAudioPlayType)TFAudioPlayerOutputOverride
{
    return TFAudioPlayTypeDefault;
}

#pragma mark - Chromecast
+(BOOL)TFShouldUseChromecast
{
    BOOL    shouldUseChromecast = YES;
    
    return shouldUseChromecast;
}
@end
