//
//  TFTimelineDataView.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/30/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTimelineDate.h"

@interface TFTimelineDataView : UIView

@property (nonatomic, strong) TFTimelineDate *date;
@property (nonatomic, assign) BOOL shouldShow;

-(instancetype)initWithFrame:(CGRect)           t_frame
                        date:(TFTimelineDate*)  t_date;


-(void)animate;

@end
