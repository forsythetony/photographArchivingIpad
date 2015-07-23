//
//  TFPopOverStoriesCell.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFPopOverStoriesCell.h"
#import "TFVisualConstants.h"

typedef NS_ENUM(NSInteger, TFPopOverButtonActionState) {
    TFPopOverButtonActionStatePlay,
    TFPopOverButtonActionStatePause,
    TFPopOverButtonActionStateStop,
    TFPopOverButtonActionStateNone
};
@interface TFPopOverStoriesCell () <UITextFieldDelegate>
{
    NSTimer *progressTimer;
    CGFloat runningTime;
    NSString    *oldText;
}
@property (nonatomic, assign) CGFloat timerInterval;
@property (nonatomic, assign) CGFloat totalTime;

@end
@implementation TFPopOverStoriesCell

- (void)awakeFromNib {
    
    UIColor *background = [UIColor colorWithWhite:0.3 alpha:0.5];
    self.backgroundColor = background;
    
    [self.progress_view setProgress:0.0];
    [self setupAesthetics];
    self.progress_view.progressTintColor = [UIColor orangeColor];
    runningTime = 0.0;
    [self setButtonState:TFPopOverButtonActionStatePlay];
}
-(void)setupAesthetics
{
    CGFloat fontsize_title_labels = 17.0;
    CGFloat fontsize_value_labels = fontsize_title_labels * 0.85;
    
    UIFont  *font_title_labels = [UIFont fontWithName:[TFVisualConstants TFFontFamilyOne] size:fontsize_title_labels];
    UIFont  *font_value_labels = [UIFont fontWithName:[TFVisualConstants TFFontFamilyOne] size:fontsize_value_labels];
    
    UIColor *title_label_text_color = [UIColor whiteColor];
    UIColor *value_label_text_color = [UIColor whiteColor];
    
    
    self.title_text_field.font = font_title_labels;
    self.title_date_uploaded.font =     font_title_labels;
    self.title_storyteller.font = font_title_labels;
    
    self.title_text_field.delegate = self;
    self.title_text_field.tag = 1;
    
    self.title_text_field.textColor = title_label_text_color;
    self.title_date_uploaded.textColor = title_label_text_color;
    self.title_storyteller.textColor = title_label_text_color;
    
    self.value_date_uploaded.font = font_value_labels;
    self.value_date_uploaded.textColor = value_label_text_color;

    self.value_storyteller.delegate = self;
    self.value_storyteller.font = font_value_labels;
    self.value_storyteller.textColor = value_label_text_color;
    self.value_storyteller.tag = 2;
    
    //[self setBackgroundView:ev.contentView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)playToggle:(id)sender {
    
    if ([self.action_button.titleLabel.text isEqualToString:@"Play"]) {
        if ([self.delegate respondsToSelector:@selector(didClickPlayButton:)]) {
            [self.delegate didClickPlayButton:self];
        }
    }
    else if ([self.action_button.titleLabel.text isEqualToString:@"Pause"])
    {
        if ([self.delegate respondsToSelector:@selector(didClickPauseButton:)]) {
            [self.delegate didClickPauseButton:self];
        }
    }
    
}
-(void)beginPlaying
{
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(incrementTime:) userInfo:nil repeats:YES];
    
    [self setButtonState:TFPopOverButtonActionStatePause];
    
}
-(void)pausePlaying
{
    [progressTimer invalidate];
    [self setButtonState:TFPopOverButtonActionStatePlay];
}
-(void)stopPlaying
{
    [self resetTimes];
    [self updateProgressView];
}
-(void)resetTimes
{
    [progressTimer invalidate];
    runningTime = 0.0;
}
-(void)incrementTime:(NSTimer*) t_sender
{
    
    
    if (runningTime + self.timerInterval <= self.totalTime) {
        runningTime += self.timerInterval;
        [self updateProgressView];
    }
    else
    {
        self.progress_view.progress = 0.0;
        [self setButtonState:TFPopOverButtonActionStatePlay];
        [progressTimer invalidate];
    }
}
-(void)updateProgressView
{
    self.progress_view.progress = [self currentProgress];
}
-(CGFloat)currentProgress
{
    CGFloat total = self.totalTime;
    CGFloat current = runningTime;
    
    return current / total;
}
-(CGFloat)timerInterval
{
    return 0.1;
}
-(CGFloat)totalTime
{
    if (_duration) {
        _totalTime = [self.duration floatValue];
    }
    else
    {
        _totalTime = 0.1;
    }
    
    return _totalTime;
}
+(CGSize)defaultSize
{
    CGFloat width = 309.0;
    CGFloat height = 117.0;
    
    return CGSizeMake(width, height);
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    oldText = self.title_text_field.text;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        if ([self.delegate respondsToSelector:@selector(didUpdateText:)]) {
            [self.delegate didUpdateText:self];
        }
    }
    else if (textField.tag == 2)
    {
        if ([self.delegate respondsToSelector:@selector(didUpdateStoryteller:)]) {
            [self.delegate didUpdateStoryteller:self];
        }
    }
    
}
-(void)setButtonState:(TFPopOverButtonActionState) t_state
{
    CGFloat fontSize = 18.0;
    
    UIFont *buttonFont = [UIFont fontWithName:[TFVisualConstants TFFontFamilyOne] size:fontSize];
    
    UIColor *textColor;
    NSString    *text;
    
    switch (t_state) {
        case TFPopOverButtonActionStatePlay:
            textColor = [UIColor greenColor];
            text = @"Play";
            break;
            
            case TFPopOverButtonActionStateStop:
            textColor = [UIColor redColor];
            text = @"Stop";
            break;
            
            case TFPopOverButtonActionStatePause:
            textColor = [UIColor blueColor];
            text = @"Pause";
            break;
            
        TFPopOverButtonActionStateNone:
        default:
            text = @"n/a";
            textColor = [UIColor blackColor];
            break;
    }
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : buttonFont, NSForegroundColorAttributeName : textColor}];
    
    [self.action_button setAttributedTitle:string forState:UIControlStateNormal];
    
    
}
@end
