//
//  dateInfoCell.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableDictionary+attributesDictionary.h"
#import <Colours.h>

@interface dateInfoCell : UITableViewCell <UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *confidenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *confLabelConst;

@property (strong, nonatomic) UIPopoverController *popoverController;

+ (id) createCell;
-(void)setConfidenceValue:(NSString*) value;

@end
