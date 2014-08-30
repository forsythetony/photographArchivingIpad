//
//  StoriesDisplayTableviewCellTableViewCell.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoriesDisplayTableviewCellTableViewCell.h"
#import <Colours.h>
#import "NSDate+timelineStuff.h"
#import <AVFoundation/AVFoundation.h>

@interface StoriesDisplayTableviewCellTableViewCell () <AVAudioPlayerDelegate> {
    
    AVAudioPlayer *player;
    
    UIView *progressViewSlider;
    
    CGPoint firstPoint;

}

@end
@implementation StoriesDisplayTableviewCellTableViewCell

@synthesize storyDateTitle, storyDateValue, storyLengthTitle, storylengthValue, storytellerTitle, storytellerValue, storyTitleValue;
@synthesize mediaControlsContainer;
@synthesize progressView;

- (void)awakeFromNib
{
    [self aestheticsConfiguration];
    
    [self addSliderToProgressView];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}
-(void)addSliderToProgressView
{
    CGRect sliderFrame;
    
    sliderFrame.size.width = 10.0;
    sliderFrame.size.height = progressView.frame.size.height;
    
    sliderFrame.origin = CGPointMake(0.0, 0.0);
    
    progressViewSlider = [[UIView alloc] initWithFrame:sliderFrame];
    
    progressViewSlider.backgroundColor = [UIColor RedHat];
    
    UIPanGestureRecognizer *gest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSlideSlider:)];
    
    [progressViewSlider addGestureRecognizer:gest];
    
    
    
    
    [progressView addSubview:progressViewSlider];
    
}
-(void)aestheticsConfiguration
{
    UIColor *mainBackgroundColor = [UIColor charcoalColor];
    
    NSString *fontFamily = @"DINAlternate-Bold";
    
    CGFloat titleFontSize = 17.0;
    CGFloat valueFontSize = 15.0;
    CGFloat mainTitleFontSize = 20.0;
    
    UIColor *titleColor = [UIColor whiteColor];
    UIColor *valueColor = [UIColor black75PercentColor];
    UIColor *mainTitleColor = [UIColor chartreuseColor];
    
    UIFont *titleFont = [UIFont fontWithName:fontFamily size:titleFontSize];
    UIFont *valueFont = [UIFont fontWithName:fontFamily size:valueFontSize];
    UIFont *mainTitleFont = [UIFont fontWithName:fontFamily size:mainTitleFontSize];
    
    //  Main configuration
    
    self.contentView.backgroundColor = mainBackgroundColor;
    self.backgroundColor = mainBackgroundColor;
    
    //  Main Title Configuration
    
    storyTitleValue.font = mainTitleFont;
    storyTitleValue.textColor = mainTitleColor;
    storyTitleValue.textAlignment = NSTextAlignmentLeft;
    
    
    //  Titles configuration
    
    storyDateTitle.font = titleFont;
    storyDateTitle.textColor = titleColor;
    storyDateTitle.textAlignment = NSTextAlignmentRight;
    
    storyLengthTitle.font = titleFont;
    storyLengthTitle.textColor = titleColor;
    storyLengthTitle.textAlignment = NSTextAlignmentRight;
    
    storytellerTitle.font = titleFont;
    storytellerTitle.textColor = titleColor;
    storytellerTitle.textAlignment = NSTextAlignmentRight;
    
    //  Values Configuration
    
    storyDateValue.font = valueFont;
    storyDateValue.textColor = valueColor;
    storyDateValue.textAlignment = NSTextAlignmentLeft;

    
    storytellerValue.font = valueFont;
    storytellerValue.textColor = valueColor;
    storytellerValue.textAlignment = NSTextAlignmentLeft;
    
    storylengthValue.font = valueFont;
    storylengthValue.textColor = valueColor;
    storylengthValue.textAlignment = NSTextAlignmentLeft;
    
    //  Media Controls Configuration
    /*
    mediaControlsContainer.backgroundColor = [UIColor black25PercentColor];
    
    [pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    */
    /*
    controlsView = [[AudioControlsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    
    [mediaControlsContainer addSubview:controlsView];
    */
    
}
-(void)didSlideSlider:(UIPanGestureRecognizer*) sender
{
        
        
        CGPoint trans = [sender translationInView:self];
        
        
        
        if ([sender state] == UIGestureRecognizerStateBegan) {
            
            firstPoint.x = [[sender view] center].x;
            firstPoint.y = [[sender view] center].y;
            
        }
        
        CGFloat newXTrans = firstPoint.x + trans.x;
    
        [[sender view] setCenter:trans];
    
    
}
-(void)setMyStory:(Story *)myStory
{
    _myStory = myStory;
    
    storyTitleValue.text = myStory.title;
    storyDateValue.text = [myStory.storyDate displayDateOfType:sDateTypPretty];
    storytellerValue.text = myStory.storyTeller;
    
    if (myStory.audioRecording) {

        storylengthValue.text = [NSString stringWithFormat:@"%d sec.", myStory.audioRecording.recordingLength];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupStreamer
{
    
    
    
    NSData *_objectData = [NSData dataWithContentsOfURL:_myStory.audioRecording.s3URL];
    
    NSError *error;
    
    
    player = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
    player.delegate = self;
    
    
    player.numberOfLoops = 0.0;
    player.volume = 1.0;
    [player prepareToPlay];
    
    
}
- (IBAction)tappedPlay:(id)sender {
    
    if (!player) {
        [self setupStreamer];
    }
        
        
        [player play];
        
}
- (IBAction)tappedPause:(id)sender {
    
    if (player) {
        if (player.isPlaying) {
            [player pause];
        }
    }
}

@end
