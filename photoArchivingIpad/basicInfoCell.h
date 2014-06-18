//
//  basicInfoCell.h
//  photoArchivingIpad
//
//  Created by Forsythe, Anthony R. (MU-Student) on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableDictionary+attributesDictionary.h"
#import "pageViewControllers.h"
#import <Colours.h>

typedef NS_ENUM(NSInteger, cellType) {
    cellTypeDefault,
    cellTypeLink
};
@interface basicInfoCell : UITableViewCell

@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) IBOutlet UILabel *titleConstLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

+(id)createCellOfType:(cellType) cellType;

@end
