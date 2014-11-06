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
#import <POP.h>

typedef struct sBounds {
    
    CGFloat leftBound;
    CGFloat rightBound;
    
} TFBounds;

@interface StoriesDisplayTableviewCellTableViewCell () <AVAudioPlayerDelegate> {
    
    AVAudioPlayer *player;
    
    UIView *progressViewSlider;
    
    CGPoint firstPoint;
    
    TFBounds progressSliderBounds;
    
    CGFloat sliderPercentage;
    
    BOOL isShowingScrubbingTime;
    
    UILabel *sliderScrubbingLabel;
    
    NSTimer *progressTimer;
    
    NSInteger   totalTime,
                timeElapsed;

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
-(void)variableSetup
{
    isShowingScrubbingTime = NO;
    totalTime = 0.0;
    timeElapsed = 0.0;
}
-(void)addSliderToProgressView
{
    CGRect sliderFrame;
    
    sliderFrame.size.width = 10.0;
    sliderFrame.size.height = progressView.frame.size.height;
    
    sliderFrame.origin = CGPointMake(0.0, 0.0);
    
    progressViewSlider = [[UIView alloc] initWithFrame:sliderFrame];
    
    progressViewSlider.backgroundColor = [UIColor fadedBlueColor];
    
    UIPanGestureRecognizer *gest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSlideSlider:)];
    
    [progressViewSlider addGestureRecognizer:gest];
    
    progressSliderBounds.leftBound = sliderFrame.size.width / 2.0;
    
    CGRect sliderScrubbingFrame;
    CGPoint sliderScrubbingCenter;
    
    sliderScrubbingFrame.origin = CGPointMake(0.0, sliderFrame.size.height + 10.0);
    sliderScrubbingFrame.size = CGSizeMake(40.0, 20.0);
    
    sliderScrubbingLabel = [[UILabel alloc] initWithFrame:sliderScrubbingFrame];
    [progressView addSubview:sliderScrubbingLabel];
    
    //  Set slider scrubbing time label's properties
    
    CGFloat fontSize = 10.0;
    NSString *fontFamily = @"DINAlternate-Bold";
    
    UIColor *fontColor = [UIColor whiteColor];
    
    UIFont *scrubbingTimeFont = [UIFont fontWithName:fontFamily size:fontSize];
    
    sliderScrubbingLabel.font = scrubbingTimeFont;
    sliderScrubbingLabel.textColor = fontColor;
    sliderScrubbingLabel.alpha = 0.0;
    
    sliderScrubbingLabel.text = @"00:00";
    [sliderScrubbingLabel sizeToFit];
    sliderScrubbingCenter.x = [progressViewSlider center].x;
    sliderScrubbingCenter.y = [sliderScrubbingLabel center].y;
    
    [sliderScrubbingLabel setCenter:sliderScrubbingCenter];

    
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
   progressSliderBounds.rightBound = progressView.frame.size.width - ( progressViewSlider.frame.size.width / 2.0);
    
    if( sender.state == UIGestureRecognizerStateBegan )
    {
        
        firstPoint.x = [[sender view] center].x;
        firstPoint.y = [[sender view] center].y;
        
    }
    else if( sender.state == UIGestureRecognizerStateChanged )
    {
        CGPoint transPoint = [sender translationInView:progressView];
        
        CGPoint newCenter;
        
        newCenter.x = transPoint.x;
        newCenter.y = firstPoint.y;
        /*
        NSLog(@"( left, right ) : ( %f , %f )", progressSliderBounds.leftBound , progressSliderBounds.rightBound);
        NSLog(@"New Center: %@", NSStringFromCGPoint(newCenter));
        */
        if (transPoint.x >= progressSliderBounds.leftBound && transPoint.x <= progressSliderBounds.rightBound) {
            
            [[sender view] setCenter:newCenter];
            
            CGFloat xCenter = [[sender view] center].x;
            
            [self updatePercentageWithXValue:xCenter];
            [self updateScrubbingTimeWithNewCenter:newCenter];
            
        }
        
    }
    else if( sender.state == UIGestureRecognizerStateEnded )
    {

        CGPoint trans = [sender translationInView:self.progressView];
        NSLog(@"Ended: %@", NSStringFromCGPoint(trans));
        
        [self removeScrubbingLabel];
    }
    
    
}
-(void)setMyStory:(Story *)myStory
{
    _myStory = myStory;
    
    storyTitleValue.text = myStory.title;
    storyDateValue.text = [myStory.storyDate displayDateOfType:sDateTypPretty];
    storytellerValue.text = myStory.storyTeller;
    
    if (myStory.audioRecording) {

        NSString *lengthString = [myStory.audioRecording.recordingLength getDisplayStringOfType:DurationDisplayTypeMinSec];

        storylengthValue.text = lengthString;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

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
    
   /*
    if (!player) {
        [self setupStreamer];
    }
        
        
        [player play];
    */
     
    [self.delegate playAudioStreamWithStory:_myStory];
}
- (IBAction)tappedPause:(id)sender {
    
    [player pause];
    
    //[self.delegate shouldStopAudio];
}
-(void)updatePercentageWithXValue:(CGFloat) xVal
{
    CGFloat totalLength = progressSliderBounds.rightBound - progressSliderBounds.leftBound;
    
    CGFloat adjustedX = xVal - progressSliderBounds.leftBound;
    
    sliderPercentage = adjustedX / totalLength;
    
    NSLog(@"Slider Percentage: %f", sliderPercentage);
}
-(void)updateScrubbingTimeWithNewCenter:(CGPoint) newCenter
{
    NSString *timeString = [_myStory.audioRecording.recordingLength getTimeWithPercentage:sliderPercentage];
    
    NSLog(@"Scrubbing: %@" ,timeString);
    
    CGPoint newScrubbingLabelCenter;
    
    newScrubbingLabelCenter.x = newCenter.x;
    newScrubbingLabelCenter.y = sliderScrubbingLabel.center.y;
    
    if (!isShowingScrubbingTime) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            sliderScrubbingLabel.alpha = 1.0;
            sliderScrubbingLabel.text = timeString;
            
            POPSpringAnimation *sizePop = [POPSpringAnimation animation];
            
            sizePop.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
            
            sizePop.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
            sizePop.toValue = [NSValue valueWithCGSize:sliderScrubbingLabel.frame.size];
            
            [sliderScrubbingLabel.layer pop_addAnimation:sizePop forKey:@"sizePopAnimation"];
            
            isShowingScrubbingTime = YES;
        });
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sliderScrubbingLabel setCenter:newScrubbingLabelCenter];
            sliderScrubbingLabel.text = timeString;
            
        });
    }
    
    
}
-(void)removeScrubbingLabel
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        POPSpringAnimation *goAway = [POPSpringAnimation animation];
        
        goAway.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
        
        goAway.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        
        [goAway setCompletionBlock:^(POPAnimation *ani , BOOL maybe ) {
            
            sliderScrubbingLabel.alpha = 0.0;
        }];
        
        [sliderScrubbingLabel.layer pop_addAnimation:goAway forKey:@"goAwayAni"];
        
    });
    
    isShowingScrubbingTime = NO;
}
-(void)updateProgressView {
    
    timeElapsed += 1;
    
    
}

-(void)startProgressTimer {
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
}
@end
