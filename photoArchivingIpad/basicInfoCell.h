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
#import "imageInformationUpdater.h"
#import "imageInformationConstants.h"
typedef NS_ENUM(NSInteger, cellType) {
    cellTypeDefault,
    cellTypeLink
};
@interface basicInfoCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) IBOutlet UILabel *titleConstLabel;
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) id <imageInformationUpdater> delegate;

+(id)createCellOfType:(cellType) cellType;

-(void)setPlaceholderText:(NSString*) placeholderText withMainText:(NSString*) mainText;

@end
