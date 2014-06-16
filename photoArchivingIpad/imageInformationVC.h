//
//  imageInformationVC.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "imageHandling.h"
#import "basicInfoCell.h"
@interface imageInformationVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) imageObject *information;

-(void)updateInformation:(imageObject*)information;

@end
