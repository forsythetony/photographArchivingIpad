//
//  TFChromecastManager.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFChromecastManager.h"


@interface TFChromecastManager () <GCKDeviceManagerDelegate, GCKDeviceScannerListener, GCKMediaControlChannelDelegate>
{
    NSTimer *mediaPositionTimer;
    
}

@property GCKMediaControlChannel *mediaControlChannel;
@property GCKApplicationMetadata *applicationMetadata;

@property(nonatomic, strong) GCKDeviceScanner *deviceScanner;
@property(nonatomic, strong) GCKDeviceManager *deviceManager;
@property(nonatomic, readonly) GCKMediaInformation *mediaInformation;
@property (nonatomic, assign) NSTimeInterval currentMediaDuration;

@end

static NSString* TFCHROMECASTMANAGER_kReceiverAppID         = @"94B7DFA1";

@implementation TFChromecastManager

+(id)sharedManager
{
    static TFChromecastManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[TFChromecastManager alloc] init];
    });
    
    return manager;
    
}
-(instancetype)init
{
    if (self = [super init]) {
        [self setupThings];
    }
    
    return self;
}
-(void)pauseAudio
{
    if (self.isPlayingAudio) {
        [_mediaControlChannel pause];
        [self.delegate didPauseAudio];
    }
}
-(void)playAudioFromStory:(Story *)t_story image:(imageObject *)t_img
{
    if (self.isConnected) {
        
        NSLog(@"\nCast audio stream");
        GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
        
        [metadata setString:( t_story.title ? t_story.title : @"Untitled") forKey:kGCKMetadataKeyTitle];
        
        [metadata setString:( t_story.storyDate ? [t_story.storyDate displayDateOfType:sDateTypPretty] : @"")
                     forKey:kGCKMetadataKeySubtitle];
        
        CGSize displayImageSize;
        
        NSURL *imageURL;
        
        if (t_img.thumbnailImage) {
            displayImageSize = CGSizeMake(700.0, 700.0);
            imageURL = t_img.thumbNailURL;
            
        } else
        {
            displayImageSize = t_img.largeImage.size;
            imageURL = t_img.photoURL;
        }
        
        imageURL = t_img.photoURL;
        displayImageSize = t_img.largeImage.size;
        
        [metadata addImage:[[GCKImage alloc]
                            initWithURL:imageURL
                            width:displayImageSize.width
                            height:displayImageSize.height
                            ]];
        
        NSString *urlString;
        
        if (t_story.recordingS3Url.absoluteString != nil) {
            urlString = t_story.recordingS3Url.absoluteString;
        }
        else if(t_story.recordingS3Url.absoluteString != nil)
        {
            urlString = t_story.recordingS3Url.absoluteString;
        }
        else
        {
            return;
        }
        
        
        GCKMediaInformation *mediaInformation =
        [[GCKMediaInformation alloc] initWithContentID:urlString
                                            streamType:GCKMediaStreamTypeUnknown
                                           contentType:@"audio/mp4"
                                              metadata:metadata
                                        streamDuration:0
                                            customData:nil];
        
        [_mediaControlChannel loadMedia:mediaInformation autoplay:TRUE playPosition:0];
        
        
    }
}
-(void)setupThings
{
    self.deviceScanner = [[GCKDeviceScanner alloc] init];
    
    [self.deviceScanner addListener:self];
}
-(void)beginScanning
{
    [self.deviceScanner startScan];
}
-(void)sendImage:(imageObject*) t_img
{
    
    if (self.isConnected) {
        NSString *urlString = [t_img.photoURL absoluteString];
        
        if (!self.deviceManager || !self.deviceManager.isConnected) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not Connected", nil)
                                       message:NSLocalizedString(@"Please connect to Cast device", nil)
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                             otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
        
        [metadata setString:([t_img title] ? [t_img title] : @"untitled") forKey:kGCKMetadataKeyTitle];
        
        
        GCKMediaInformation *mediaInformation =
        [[GCKMediaInformation alloc] initWithContentID:
         urlString
                                            streamType:GCKMediaStreamTypeUnknown
                                           contentType:@"image/jpg"
                                              metadata:metadata
                                        streamDuration:0
                                            customData:nil];
        
        
        
        [_mediaControlChannel loadMedia:mediaInformation autoplay:TRUE playPosition:0];
    }
    
}

#pragma mark - Delegates

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    
    NSLog(@"\nTFManager connected!!\n");
    
    [self.deviceManager launchApplication:TFCHROMECASTMANAGER_kReceiverAppID];
}
- (void)deviceManager:(GCKDeviceManager *)deviceManager didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata sessionID:(NSString *)sessionID launchedApplication:(BOOL)launchedApplication {
    
    NSLog(@"application has launched");
    self.mediaControlChannel = [[GCKMediaControlChannel alloc] init];
    self.mediaControlChannel.delegate = self;
    [self.deviceManager addChannel:self.mediaControlChannel];
    [self.mediaControlChannel requestStatus];
    
    if ([self.delegate respondsToSelector:@selector(didConnectToDevice)]) {
        [self.delegate didConnectToDevice];
    }
    
}
- (void)deviceManager:(GCKDeviceManager *)deviceManager didFailToConnectToApplicationWithError:(NSError *)error
{
    NSLog(@"\nTFManager Failed to Connect\n\n");
}
- (void)deviceManager:(GCKDeviceManager *)deviceManager didFailToConnectWithError:(GCKError *)error
{
}
- (void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(GCKError *)error {
    NSLog(@"Received notification that device disconnected");
    
    
}
- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    
    self.applicationMetadata = applicationMetadata;
}

-(void)mediaControlChannelDidUpdateStatus:(GCKMediaControlChannel *)mediaControlChannel {
    
    GCKMediaStatus *mediaStatus = mediaControlChannel.mediaStatus;
    
    switch (mediaStatus.playerState) {
        case GCKMediaPlayerStateIdle:
        {
        }
            break;
            
            case GCKMediaPlayerStatePlaying:
        {
            if ([self.delegate respondsToSelector:@selector(didBeginPlayingAudio)]) {
                [self.delegate didBeginPlayingAudio];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"streamPosition"]) {
        
        NSTimeInterval interval = (NSTimeInterval)[(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        
        NSLog(@"\nPercent Complete:\t%f\n", interval / self.currentMediaDuration);
    }
}
-(void)selectDeviceAtIndex:(NSUInteger)t_index
{
    if (self.selectedDevice == nil) {
        
        if (t_index < self.deviceScanner.devices.count) {
            self.selectedDevice = self.deviceScanner.devices[t_index];
            NSLog(@"\nConnecting to device: %@\n", self.selectedDevice.friendlyName);
            [self connectToDevice];
        }
    }
    else
    {
        
    }
}
-(void)connectToDevice
{
    if (self.selectedDevice == nil) {
        return;
    }
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.deviceManager =
    [[GCKDeviceManager alloc] initWithDevice:self.selectedDevice
                           clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    self.deviceManager.delegate = self;
    [self.deviceManager connect];
    
}
-(void)deviceDidComeOnline:(GCKDevice *)device
{
    if ([self.delegate respondsToSelector:@selector(didUpdateDeviceList:)]) {
        [self.delegate didUpdateDeviceList:self];
    }
}
-(NSArray *)devicelist
{
    if (_deviceScanner) {
        if (_deviceScanner.devices) {
            return _deviceScanner.devices;
        }
        else
        {
            _devicelist = [NSArray new];
        }
    }
    
    return _devicelist;
}
-(NSUInteger)deviceCount
{
    if (!_deviceScanner) {
        return 0;
    }
    
    return _deviceScanner.devices.count;
}
-(BOOL)isConnected
{
    if (self.deviceManager == nil) {
        return NO;
    }
    
    return self.deviceManager.isConnected;
}
-(NSTimeInterval)currentMediaDuration
{
    if (_mediaInformation) {
        return _mediaInformation.streamDuration;
    }
    else
    {
        return 0.1;
    }
}
-(BOOL)isPlayingAudio
{
    if (self.isConnected) {
        if (_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePlaying) {
            return YES;
        }
    }
    
    return NO;
}
@end
