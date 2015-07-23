//
//  TFChromecastManager.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imageObject.h"
#import "Story.h"
#import <GoogleCast/GoogleCast.h>

@protocol TFChromecastManagerDelegate;


@interface TFChromecastManager : NSObject

@property GCKDevice *selectedDevice;


+(id)sharedManager;
-(void)playAudioFromStory:(Story*) t_story image:(imageObject*) t_img;
-(void)sendImage:(imageObject*) t_img;
-(void)beginScanning;
-(void)selectDeviceAtIndex:(NSUInteger) t_index;
-(void)disconnect;
-(void)stopAudio;
-(void)pauseAudio;

@property (nonatomic, assign) NSUInteger deviceCount;

@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL isPlayingAudio;

@property (nonatomic, strong) NSArray *devicelist;

@property (nonatomic, weak) id<TFChromecastManagerDelegate> delegate;

@end

@protocol TFChromecastManagerDelegate <NSObject>

@optional
-(void)didUpdateDeviceList:(TFChromecastManager*) t_manager;
-(void)didConnectToDevice;
-(void)didDisconnect;
-(void)didBeginPlayingAudio;
-(void)didPauseAudio;
-(void)didStopPlayingAudio;

@end
