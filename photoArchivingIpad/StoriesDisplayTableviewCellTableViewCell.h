//
//  StoriesDisplayTableviewCellTableViewCell.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"


@interface StoriesDisplayTableviewCellTableViewCell : UITableViewCell

@property (strong, nonatomic) Story *myStory;

@property (weak, nonatomic) IBOutlet UILabel *storyTitleValue;
@property (weak, nonatomic) IBOutlet UILabel *storyDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *storytellerTitle;
@property (weak, nonatomic) IBOutlet UILabel *storyLengthTitle;


@property (weak, nonatomic) IBOutlet UILabel *storyDateValue;
@property (weak, nonatomic) IBOutlet UILabel *storytellerValue;
@property (weak, nonatomic) IBOutlet UILabel *storylengthValue;

@property (weak, nonatomic) IBOutlet UIView *mediaControlsContainer;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end
