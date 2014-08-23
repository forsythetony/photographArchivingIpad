//
//  StoriesDisplayTable.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryCellTableViewCell.h"
#import "imageObject.h"

#import "ImageInformationDisplayer.h"

@interface StoriesDisplayTable : UIViewController

@property (strong, nonatomic) imageObject *info;

@property (weak, nonatomic) IBOutlet UITableView *storiesDisplayTableview;

@end
