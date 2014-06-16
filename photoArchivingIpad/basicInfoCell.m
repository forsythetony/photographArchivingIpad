//
//  basicInfoCell.m
//  photoArchivingIpad
//
//  Created by Forsythe, Anthony R. (MU-Student) on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "basicInfoCell.h"

@implementation basicInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupViews];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setupViews
{
    CGRect valueRect = CGRectMake(10.0, 10.0, self.frame.size.width - 10.0, self.frame.size.height - 10.0);
    
    _valueLabel = [[UILabel alloc] initWithFrame:valueRect];
    
    _valueLabel.text = @"";
    
    [self.contentView addSubview:_valueLabel];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
