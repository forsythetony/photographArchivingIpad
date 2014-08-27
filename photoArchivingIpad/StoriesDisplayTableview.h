//
//  StoriesDisplayTableview.h
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoriesDisplayTableviewCellTableViewCell.h"

@interface StoriesDisplayTableview : UITableView

-(id)initWithFrame:(CGRect)frame andDelegate:(id) delegate andDatasource:(id) datasource;

@end
