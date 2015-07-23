//
//  TFPopOverStoriesCell.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPopOverStoriesCellDelegate;

@interface TFPopOverStoriesCell : UITableViewCell
@property (nonatomic, strong) NSNumber *duration;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_view;
@property (weak, nonatomic) IBOutlet UITextField *title_text_field;
@property (weak, nonatomic) IBOutlet UIButton *action_button;
@property (weak, nonatomic) IBOutlet UILabel *title_date_uploaded;
@property (weak, nonatomic) IBOutlet UILabel *value_date_uploaded;
@property (weak, nonatomic) IBOutlet UITextField *value_storyteller;
@property (weak, nonatomic) IBOutlet UILabel *title_storyteller;

@property (nonatomic, weak) id<TFPopOverStoriesCellDelegate> delegate;

+(CGSize)defaultSize;

-(void)beginPlaying;
-(void)pausePlaying;
-(void)stopPlaying;

@end

@protocol TFPopOverStoriesCellDelegate <NSObject>

@optional
-(void)didClickPlayButton:(TFPopOverStoriesCell*) t_cell;
-(void)didClickPauseButton:(TFPopOverStoriesCell*) t_cell;
-(void)didUpdateText:(TFPopOverStoriesCell*) t_cell;
-(void)didUpdateStoryteller:(TFPopOverStoriesCell*) t_cell;
@end
