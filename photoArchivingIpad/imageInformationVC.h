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
#import "dateInfoCell.h"
#import "imageInformationUpdater.h"
#import "imageInformationConstants.h"
#import "TFDataCommunicator.h"
#import "StoryCellTableViewCell.h"

typedef NS_ENUM(NSInteger, fieldInformation) {
    fieldInformationTitle,
    fieldInformationDateTaken
};
@interface imageInformationVC : UIViewController <TFCommunicatorDelegate, UITableViewDataSource, UITableViewDelegate, imageInformationUpdater>

@property (strong, nonatomic) imageObject *information;


@end
