//
//  basicInfoCell.m
//  photoArchivingIpad
//
//  Created by Forsythe, Anthony R. (MU-Student) on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "basicInfoCell.h"

@interface basicInfoCell () {
    NSDictionary    *titleStyle,
                    *infoStyle,
                    *mainStyle;
    
    
}

@end
@implementation basicInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupVariables];
        [self setupViews];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setupVariables
{
    float titleFontSize = 20.0;
    float infoFontSize = 14.0;
    
    NSString *fontName = @"DINAlternate-Bold";
    
    UIFont *titleFont = [UIFont fontWithName:fontName size:titleFontSize];
    UIFont *infoFont = [UIFont fontWithName:fontName size:infoFontSize];
    
    UIColor *titleFontColor = [UIColor blackColor];
    UIColor *infoFontColor = [UIColor blackColor];
    UIColor *backgroundColor = [UIColor whiteColor];
    NSTextAlignment infoAlign = NSTextAlignmentRight;
    
    
    
    titleStyle = @{@"font": titleFont,
                   @"textColor" : titleFontColor};
    
    infoStyle = @{@"font": infoFont,
                  @"textColor": infoFontColor,
                  @"textAlignment" : [NSNumber numberWithInt:infoAlign]};
    
    mainStyle = @{@"background": backgroundColor};
    
    
}
-(void)setupViews
{
    CGRect valueRect = CGRectMake(10.0, 10.0, self.frame.size.width - 10.0, self.frame.size.height - 10.0);
    
    _valueLabel = [[UILabel alloc] initWithFrame:valueRect];
    
    _valueLabel.text = @"";
    _valueLabel.font = infoStyle[@"font"];
    _valueLabel.textAlignment = [infoStyle[@"textAlignment"] intValue];
    
    
    [self.contentView addSubview:_valueLabel];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
