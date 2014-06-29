//
//  basicInfoCell.m
//  photoArchivingIpad
//
//  Created by Forsythe, Anthony R. (MU-Student) on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "basicInfoCell.h"
#define TESTING NO

@interface basicInfoCell () {
    NSMutableDictionary    *titleStyle,
                    *infoStyle,
                    *mainStyle;
    
    NSString *oldValue;
    
    
}

@end
@implementation basicInfoCell
+(id)createCellOfType:(cellType)cellType
{
    basicInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"basicInfoCell" owner:nil options:nil] lastObject];
    
    if ([cell isKindOfClass:[basicInfoCell class]]) {
        [cell setupVariablesWithType:cellType];
        [cell setupViews];
        
        return cell;
    }
    else
    {
        return nil;
    }
}
- (void)awakeFromNib
{
    // Initialization code
}
-(void)setupVariablesWithType:(cellType) cellType
{
    float titleFontSize = 15.0;
    float infoFontSize = 18.0;
    
    NSString *fontName = global_font_family;
    
    UIFont *titleFont = [UIFont fontWithName:fontName size:titleFontSize];
    UIColor *titleFontColor = [UIColor icebergColor];
    UIColor *titleBackgroundColor = [UIColor clearColor];
    NSTextAlignment titleTextAlign = NSTextAlignmentRight;
    
    
    UIFont *infoFont = [UIFont fontWithName:fontName size:infoFontSize];
    UIColor *infoFontColor;
    
    switch (cellType) {
        case cellTypeDefault:
            infoFontColor = [UIColor whiteColor];
            
            break;
           case cellTypeLink:
            infoFontColor = [UIColor babyBlueColor];
            break;

        default:
            infoFontColor = [UIColor whiteColor];
            break;
    }
    
    UIColor *infoBackgroundColor = [UIColor clearColor];
    
    NSTextAlignment infoAlign = NSTextAlignmentLeft;
    
    UIColor *backgroundColor = [UIColor clearColor];

    
    titleStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeTitle];
    infoStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeLabel1];
    mainStyle = [NSMutableDictionary attributesDictionaryForType:attrDictTypeView1];
    
    [titleStyle updateValues:@[titleFont,
                               titleBackgroundColor,
                               titleFontColor,
                               [NSNumber numberWithInteger:titleTextAlign]]
                     forKeys:@[keyFont,
                               keyBackgroundColor,
                               keyTextColor,
                               keytextAlignment]];
    
    [infoStyle updateValues:@[infoFont,
                             infoBackgroundColor,
                             infoFontColor,
                              [NSNumber numberWithInteger:infoAlign]]
                    forKeys:@[keyFont,
                              keyBackgroundColor,
                              keyTextColor,
                              keytextAlignment
                              ]];
    
    [mainStyle updateValues:@[backgroundColor]
                    forKeys:@[keyBackgroundColor]];
    
}
-(void)setPlaceholderText:(NSString *)placeholderText withMainText:(NSString *)mainText
{
    _titleTextField.placeholder = placeholderText;
    _titleTextField.text = mainText;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_titleTextField resignFirstResponder];
    
    return NO;
}
-(void)setupViews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.backgroundColor = [mainStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    
    _titleTextField.text = @"";
    _titleTextField.placeholder = @"";
    _titleTextField.borderStyle = UITextBorderStyleNone;
    _titleTextField.font = [infoStyle objectForConstKey:keyFont];
    _titleTextField.textColor = [infoStyle objectForConstKey:(TESTING ? keyTestingTextColor : keyTextColor)];
    _titleTextField.textAlignment = [[infoStyle objectForConstKey:keytextAlignment] integerValue];
    _titleTextField.delegate = self;
    
    
    _titleConstLabel.text = @"Title";
    _titleConstLabel.font = [titleStyle objectForConstKey:keyFont];
    _titleConstLabel.textColor = [titleStyle objectForConstKey:(TESTING ? keyTestingTextColor : keyTextColor)];
    _titleConstLabel.textAlignment = [[titleStyle objectForConstKey:keytextAlignment] integerValue];
    _titleConstLabel.backgroundColor = [titleStyle objectForConstKey:(TESTING ? keyTestingBackground : keyBackgroundColor)];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"The new text is %@", textField.text);
    [self.delegate updatedOldTextValue:oldValue toNewValue:textField.text ofType:fieldTypeTitle];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    oldValue = textField.text;
}

@end
