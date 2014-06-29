//
//  imageInformationUpdater.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/25/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol imageInformationUpdater <NSObject>

@optional

-(void)didUpdatedPreviousValue:(id) prevVal toNewValue:(id) newVal;
-(void)updatedOldTextValue:(NSString*) oldVal toNewValue:(NSString*) newVal ofType:(NSString*) type;

@end
