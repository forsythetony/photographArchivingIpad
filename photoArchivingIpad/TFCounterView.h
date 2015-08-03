//
//  TFCounterView.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/31/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFCounterView : UIView

@property (nonatomic, strong) NSNumber *currentValue;


-(instancetype)initWithHeight:(CGFloat) t_height;

@end
