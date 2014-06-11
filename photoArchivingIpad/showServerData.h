//
//  showServerData.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFDataCommunicator.h"
#import <Colours.h>
#import <pop/POP.h>

@interface showServerData : UIViewController <UITableViewDataSource, UITableViewDelegate, TFCommunicatorDelegate>

@property (weak, nonatomic) IBOutlet UITableView *photosForUser;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotosForUsers;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end
