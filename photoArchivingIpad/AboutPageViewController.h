//
//  AboutPageViewController.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 1/19/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutPageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@end
