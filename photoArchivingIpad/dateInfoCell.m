//
//  dateInfoCell.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "dateInfoCell.h"
#import "datePickingThing.h"

#define TESTING NO

@interface dateInfoCell () {
    NSMutableDictionary *titleStyle,
                    *dateStyle,
                    *confidenceStyle,
    *mainStyle,
    *confConstStyle;
}

@end
@implementation dateInfoCell

+ (id)createCell
{
    dateInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"dateInfoCell"
                                                        owner:nil
                                                      options:nil] lastObject];
    
    if ([cell isKindOfClass:[dateInfoCell class]]) {
        
        [cell varSetup];
        [cell initialSetup];
        
        return cell;
    }
    else
    {
        return nil;
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)varSetup
{
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:[datePickingThing new]];
    
    NSString *fontFamily = global_font_family;
    
    float titleFontSize = 15.0;
    UIFont *titleFont = [UIFont fontWithName:fontFamily size:titleFontSize];
    UIColor *titleBackground = [UIColor clearColor];
    UIColor *titleTextColor = [UIColor icebergColor];
    NSTextAlignment titleTextAlign = NSTextAlignmentRight;
    
    
    float dateFontSize = 18.0;
    UIFont *dateFont = [UIFont fontWithName:fontFamily size:dateFontSize];
    UIColor *dateBackground = [UIColor clearColor];
    UIColor *dateTextColor = [UIColor whiteColor];
    NSTextAlignment dateTextAlignment = NSTextAlignmentLeft;
    
    float confFontSize = 18.0;
    UIFont *confFont = [UIFont fontWithName:fontFamily size:confFontSize];
    UIColor *confBackground = [UIColor clearColor];
    UIColor *confTextColor = [UIColor whiteColor];
    NSTextAlignment confTextAlign = NSTextAlignmentLeft;
    
    float confConstFontSize = titleFontSize;
    UIFont *confConstFont = [UIFont fontWithName:fontFamily size:confConstFontSize];
    UIColor *confConstTextColor = [UIColor icebergColor];
    UIColor *confConstBackground = [UIColor clearColor];
    NSTextAlignment confConstTextAlignment = NSTextAlignmentRight;
    
    UIColor *mainBackground = [UIColor clearColor];
    
    titleStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeTitle];
    dateStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeLabel1];
    
    confidenceStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeLabel2];
    confConstStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeLabel2];
    
    mainStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeView1];
    
    [titleStyle updateValues:@[titleFont,
                               titleBackground,
                               titleTextColor,
                               [NSNumber numberWithInt:titleTextAlign]]
                     forKeys:@[keyFont,
                               keyBackgroundColor,
                               keyTextColor,
                               keytextAlignment]];
    
    [dateStyle updateValues:@[dateFont,
                              dateBackground,
                              dateTextColor,
                              [NSNumber numberWithInteger:dateTextAlignment]]
                    forKeys:@[keyFont,
                              keyBackgroundColor,
                              keyTextColor,
                              keytextAlignment]];
    
    [confidenceStyle updateValues:@[confFont,
                                    confBackground,
                                    confTextColor,
                                    [NSNumber numberWithInteger:confTextAlign]]
                          forKeys:@[keyFont,
                                    keyBackgroundColor,
                                    keyTextColor,
                                    keytextAlignment]];
    
    [mainStyle updateValues:@[mainBackground] forKeys:@[keyBackgroundColor]];
    
    [confConstStyle updateValues:@[confConstFont,
                                   confConstBackground,
                                   confConstTextColor,
                                   [NSNumber numberWithInt:confConstTextAlignment]] forKeys:@[keyFont,keyBackgroundColor,keyTextColor, keytextAlignment]];
    
    
    
    
    
}
-(void)initialSetup
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [mainStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    
    
    _titleLabel.backgroundColor = [titleStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    _titleLabel.textColor = [titleStyle objectForConstKey:(TESTING ? keyTestingTextColor : keyTextColor)];
    _titleLabel.font = [titleStyle objectForConstKey:keyFont];
    _titleLabel.textAlignment = [[titleStyle objectForConstKey:keytextAlignment] integerValue];
    
    _dateLabel.backgroundColor = [dateStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    _dateLabel.textColor = [dateStyle objectForConstKey:(TESTING ? keyTestingTextColor : keyTextColor)];
    _dateLabel.font = [dateStyle objectForConstKey:keyFont];
    _dateLabel.textAlignment = [[dateStyle objectForConstKey:keytextAlignment] integerValue];
    _dateLabel.text = @"";
    
    _confidenceLabel.backgroundColor = [confidenceStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    _confidenceLabel.textColor = [confidenceStyle objectForConstKey:(TESTING ? keyTestingTextColor : keyTextColor)];
    _confidenceLabel.font = [confidenceStyle objectForConstKey:keyFont];
    _confidenceLabel.textAlignment = [[confidenceStyle objectForConstKey:keytextAlignment] integerValue];
    _confidenceLabel.text = @"";
    
    _confLabelConst.font = [confConstStyle objectForConstKey:keyFont];
    _confLabelConst.backgroundColor = [confConstStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    _confLabelConst.textColor = [confConstStyle objectForConstKey:(TESTING ? keyTestingTextColor : keyTextColor)];
    _confLabelConst.textAlignment = [[confConstStyle objectForConstKey:keytextAlignment] integerValue];
    
    
}
-(void)editDate:(id) sender
{
    [_popoverController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
-(UIColor*)getColorForValue:(NSString*) value
{
    NSInteger val = [value integerValue];
    
    if (val >= 0 && val < 30) {
        return [UIColor dangerColor];
    }
    else if (val >= 30 && val < 70)
    {
        return [UIColor warningColor];
    }
    else
    {
        return [UIColor successColor];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setConfidenceValue:(NSString *)value
{
    UIColor* confColor = [self getColorForValue:value];
    
    _confidenceLabel.textColor = confColor;
    _confidenceLabel.text = value;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
