//
//  StoryCellTableViewCell.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>



@interface StoryCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *StopButton;
@property (weak, nonatomic) IBOutlet UIButton *PlayButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)tappedPlay:(id)sender;
- (IBAction)tappedStop:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *timeView;

@property (nonatomic, strong) Story *myStory;
@property (nonatomic, strong) AVAudioPlayer *player;

-(void)setupStreamer;
+(id)createCell;

@end
