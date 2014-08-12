//
//  StoryCellTableViewCell.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/9/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoryCellTableViewCell.h"
#import "NSMutableDictionary+attributesDictionary.h"
#import <Colours.h>
#import <FAKFoundationIcons.h>
#import "NSDate+timelineStuff.h"

@class StoryCellTableViewCell;

@interface StoryCellTableViewCell () <AVAudioPlayerDelegate> {
    NSMutableDictionary    *titleStyle,
    *infoStyle,
    *mainStyle,
    *buttonStyle,
    *dateStyle;
    
    NSTimer *progressTimer;
    
}
@end
@implementation StoryCellTableViewCell

@synthesize titleLabel, PlayButton, StopButton, timeView, dateLabel, deleteButton;

- (IBAction)deleteMe:(id)sender {
    
    [self.delegate deleteMePlease:self];
}
+(id)createCell
{
    StoryCellTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"StoryCellTableViewCell"
                                                        owner:nil
                                                      options:nil] lastObject];
    
    if ([cell isKindOfClass:[StoryCellTableViewCell class]]) {
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell setupVariables];
        [cell setupViews];
        [cell hideItAll];
        return cell;
    }
    else
    {
        return nil;
    }

}
- (void)awakeFromNib
{
    // Initialization code
    
    
    self.backgroundColor = [UIColor clearColor];
    [self.contentView setBackgroundColor:[UIColor charcoalColor]];
    [self setupVariables];
    [self setupViews];
    [self hideItAll];
    
}
-(void)hideItAll
{
    [titleLabel setAlpha:0.0];
    [PlayButton setAlpha:0.0];
    [StopButton setAlpha:0.0];
    
}
-(void)setupViews
{
    UIFont *theFont = [titleStyle objectForConstKey:keyFont];
    
    titleLabel.font = theFont;
    titleLabel.textColor = [titleStyle objectForConstKey:keyTextColor];
    titleLabel.textAlignment = [[titleStyle objectForConstKey:keytextAlignment] integerValue];
    
    timeView.progressTintColor = [UIColor RedditOrange];
    timeView.progress = 0.0;
    
    [PlayButton setImage:buttonStyle[@"playButton"] forState:UIControlStateNormal];
    [PlayButton setTintColor:[UIColor icebergColor]];
    [StopButton setTintColor:[UIColor icebergColor]];
    
    [StopButton setImage:buttonStyle[@"stopButton"] forState:UIControlStateNormal];
    
    [deleteButton setImage:buttonStyle[@"trashButton"] forState:UIControlStateNormal];
    [deleteButton setTintColor:[UIColor dangerColor]];
    
    dateLabel.font = [dateStyle objectForConstKey:keyFont];
    dateLabel.textColor = [dateStyle objectForKeyedSubscript:keyTextColor];
    dateLabel.textAlignment = [[dateStyle objectForConstKey:keytextAlignment] integerValue];
    dateLabel.alpha = [[dateStyle objectForConstKey:keyAlpha] floatValue];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    titleLabel.font = titleStyle[keyFont];
//    
//    [titleLabel setTextColor:titleStyle[keyFont]];
//    [titleLabel setTextAlignment:[titleStyle[keytextAlignment] integerValue]];
//
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tappedPlay:(id)sender {
    
    [_player play];
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
    
}

- (IBAction)tappedStop:(id)sender {
    
    [_player stop];
    [progressTimer invalidate];
    progressTimer = nil;
    
}
-(void)setMyStory:(Story *)myStory
{

    if (myStory) {
        [self unhideItAll];
    }
    _myStory = myStory;
    
    [dateLabel setText:[[_myStory storyDate] displayDateOfType:sDateTypeWithTime]];
    
    [self setupTitleLabel];
    
}
-(void)setupTitleLabel
{
    if (_myStory) {
        if (_myStory.title) {
            
            if ([_myStory.title isEqualToString:@""]) {
                
                titleLabel.font = [titleStyle objectForConstKey:keyPlaceholderFont];
                titleLabel.textColor = [titleStyle objectForConstKey:keyPlaceholderTextColor];
                
                titleLabel.text = [titleStyle objectForConstKey:keyPlaceholderText];

            }
            else{
                titleLabel.text = _myStory.title;
            }
            
        }
        else
        {
            
            titleLabel.font = [titleStyle objectForConstKey:keyPlaceholderFont];
            titleLabel.textColor = [titleStyle objectForConstKey:keyPlaceholderTextColor];
            
            titleLabel.text = [titleStyle objectForConstKey:keyPlaceholderText];
        
        }
    }
}
-(void)unhideItAll
{
    [titleLabel setAlpha:1.0];
    [StopButton setAlpha:1.0];
    [PlayButton setAlpha:1.0];
}
-(void)updateProgressView
{
    CGFloat progress = _player.currentTime / _player.duration;
    
    [timeView setProgress:progress animated:YES];
    
}
-(void)setupStreamer
{
    

    
    NSData *_objectData = [NSData dataWithContentsOfURL:_myStory.recordingS3Url];
    
    NSError *error;
    

        _player = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
    _player.delegate = self;
    

        _player.numberOfLoops = 0.0;
        _player.volume = 1.0;
        [_player prepareToPlay];
        

}

-(void)setupVariables
{
    float titleFontSize = 20.0;
    float infoFontSize = 18.0;
    
    NSString *fontName = global_font_family;
    
    UIFont *titleFont = [UIFont fontWithName:fontName size:titleFontSize];
    UIColor *titleFontColor = [UIColor whiteColor];
    
    UIFont *titlePlaceholderFont = [UIFont fontWithName:fontName size:(titleFontSize - 2.0)];
    UIColor *titlePlaceholderColor = [UIColor icebergColor];
    NSString *placeholderText = @"No Title";
    
    UIColor *titleBackgroundColor = [UIColor clearColor];
    NSTextAlignment titleTextAlign = NSTextAlignmentLeft;
    
    
    UIFont *infoFont = [UIFont fontWithName:fontName size:infoFontSize];
    UIColor *infoFontColor;
    

    infoFontColor = [UIColor whiteColor];

    
    UIColor *infoBackgroundColor = [UIColor clearColor];
    
    NSTextAlignment infoAlign = NSTextAlignmentLeft;
    
    UIColor *backgroundColor = [UIColor clearColor];
    
    //  Buttons
    
    CGFloat buttonSize = 30.0;
    
    //  Date Label
    
    UIFont *dateLabelFont = [UIFont fontWithName:global_font_family size:titleFontSize - 4.0];
    UIColor *dateTextColor = [UIColor icebergColor];
    NSTextAlignment dateTextAlignment = NSTextAlignmentCenter;
    CGFloat dateAlpha = 0.5;
    
    
    titleStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeTitle];
    infoStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeLabel1];
    mainStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeView1];
    
    buttonStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeButtonDefault];
    dateStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeLabel1];
    
    
    [titleStyle updateValues:@[titleFont,
                               titleBackgroundColor,
                               titleFontColor,
                               [NSNumber numberWithInteger:titleTextAlign],
                               titlePlaceholderFont,
                               titlePlaceholderColor,
                               placeholderText]
                     forKeys:@[keyFont,
                               keyBackgroundColor,
                               keyTextColor,
                               keytextAlignment,
                               keyPlaceholderFont,
                               keyPlaceholderTextColor,
                               keyPlaceholderText]];
    
    [infoStyle updateValues:@[infoFont,
                              infoBackgroundColor,
                              infoFontColor,
                              [NSNumber numberWithInteger:infoAlign]]
                    forKeys:@[keyFont,
                              keyBackgroundColor,
                              keyTextColor,
                              keytextAlignment
                              ]];
    
    [mainStyle updateValues:@[backgroundColor]
                    forKeys:@[keyBackgroundColor]];
    
    
    [buttonStyle updateValues:@[[self playButtonImageForSize:buttonSize],
                                [self pauseButtonForSize:buttonSize],
                                [self trashIconForSize:buttonSize]]
                      forKeys:@[@"playButton",
                                @"stopButton",
                                @"trashButton"]];
    
    [dateStyle updateValues:@[dateLabelFont,
                             dateTextColor,
                             [NSNumber numberWithInteger:dateTextAlignment],
                             [NSNumber numberWithFloat:dateAlpha]]
                    forKeys:@[keyFont,
                              keyTextColor,
                              keytextAlignment,
                              keyAlpha
          ]];
}
-(UIImage*)playButtonImageForSize:(CGFloat) size
{
    CGSize sizeSize = CGSizeMake(size, size);
    
    FAKFoundationIcons *playIcon = [FAKFoundationIcons playIconWithSize:size];
    
    [playIcon setAttributes:@{NSForegroundColorAttributeName: [UIColor successColor]}];
    
    return [playIcon imageWithSize:sizeSize];
}
-(UIImage*)pauseButtonForSize:(CGFloat) size
{
    CGSize sizeSize = CGSizeMake(size, size);
    
    FAKFoundationIcons *stopIcon = [FAKFoundationIcons stopIconWithSize:size];
    [stopIcon setAttributes:@{NSForegroundColorAttributeName: [UIColor dangerColor]}];
    
    return [stopIcon imageWithSize:sizeSize];
}
-(UIImage*)trashIconForSize:(CGFloat) size
{
    CGSize sizeSize = CGSizeMake(size, size);
    
    FAKFoundationIcons *trashIcon = [FAKFoundationIcons trashIconWithSize:size];
    [trashIcon setAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    return [trashIcon imageWithSize:sizeSize];

}

@end
