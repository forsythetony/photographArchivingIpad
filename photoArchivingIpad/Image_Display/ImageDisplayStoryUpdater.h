//
//  ImageDisplayStoryUpdater.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

typedef NS_ENUM(NSInteger, ButtonState) {
    ButtonStateUploading,
    ButtonStateDisabled,
    ButtonStateEnabled
};
#import <Foundation/Foundation.h>

#import "Story.h"

@protocol ImageDisplayStoryUpdater <NSObject>

-(BOOL)didUpdateTitle:(NSString*) newTitle;
-(BOOL)didUpdateDate:(NSDate*) newDate;
-(BOOL)didUpdateStoryteller:(NSString*) newStoryteller;
-(void)shouldChangeButtonToState:(ButtonState) newState;

@end