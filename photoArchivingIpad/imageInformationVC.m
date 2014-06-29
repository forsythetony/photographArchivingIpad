//
//  imageInformationVC.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "imageInformationVC.h"
#import "TFDataCommunicator.h"

#define HEADERHEIGHT 30.0
#define FOOTERHEIGHT 50.0

@interface imageInformationVC () {
    
    NSDictionary *footerStyle;
    BOOL imageInformationEdited;
    NSMutableDictionary *currentInformation;
    NSMutableArray *fieldInfo;
    TFDataCommunicator *mainCom;
}

@property (nonatomic, strong) UILabel* imageTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageSections;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation imageInformationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self variableSetup];
    [self dataSetup];
    
    [self viewSetup];
    
}
-(void)variableSetup
{
    imageInformationEdited = NO;
    
    mainCom = [TFDataCommunicator new];
    mainCom.delegate = self;
    
    CGRect footerFrame = CGRectMake(
                                    0.0     , 0.0           ,
                                    320.0   , FOOTERHEIGHT
                                    );
    
    float cornerRadius = 8.0;
    
    UIColor *enabledColor = [UIColor successColor];
    UIColor *disabledColor = [UIColor black50PercentColor];
    
    
    NSMutableDictionary *footerDict = [NSMutableDictionary attributesDictionaryForType:attrDictTypeTableFooter];
    
    [footerDict updateValues:@[[NSValue valueWithCGRect:footerFrame],
                               @"Save",
                               [NSNumber numberWithFloat:cornerRadius],
                               enabledColor,
                               disabledColor]
                     forKeys:@[keyFrame,
                               keyTextValue,
                               keyCornerRadius,
                               keyEnabledColor,
                               keyDisabledColor]];
    
    footerStyle = [NSDictionary dictionaryWithDictionary:footerDict];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewSetup
{
    

    self.view.layer.cornerRadius = 8.0;

    CGRect titleContainerFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    _tableView = [[UITableView alloc] initWithFrame:titleContainerFrame];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.view addSubview:_tableView];
    
    _tableView.frame = self.view.frame;
    _tableView.backgroundColor = [UIColor clearColor];
    

    [_tableView reloadData];
    
    /*
    UIView *titleContainer = [[UIView alloc] initWithFrame:titleContainerFrame];
    
    //titleContainer.backgroundColor = [UIColor lightGrayColor];
    
    
    float titleConstOffset = 10.0;
    
    float titleAndConstSpace = 30.0;
    float titleConstWidth = 30.0 + titleAndConstSpace;
    
    CGRect titleConstFrame = CGRectMake(titleConstOffset, 0.0, titleConstWidth, 40.0);
    
    UILabel *titleConstLabel = [[UILabel alloc] initWithFrame:titleConstFrame];
    
    titleConstLabel.text = @"Title: ";
    titleConstLabel.textColor = colorForLabelKeys;
    titleConstLabel.font = fontForLabelKeys;
    titleConstLabel.backgroundColor = [UIColor clearColor];
    titleConstLabel.textAlignment = NSTextAlignmentRight;
    
    float titleWidth = titleContainerFrame.size.width - (titleConstWidth + 5.0);
    CGRect titleFrame = CGRectMake(titleConstLabel.frame.origin.x + titleConstLabel.frame.size.width + 30.0, 0.0, titleWidth, 40.0);
    
    _imageTitle = [[UILabel alloc ]initWithFrame:titleFrame];
    
    _imageTitle.text = @"";
    _imageTitle.textColor = colorForLabelValues;
    _imageTitle.font = fontForLabelValues;
    
    _imageTitle.backgroundColor = [UIColor clearColor];
    
    [titleContainer addSubview:titleConstLabel];
    [titleContainer addSubview:_imageTitle];
    
    [self.view addSubview:titleContainer];
    
    */
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dataSetup
{
    NSMutableArray *secs = [NSMutableArray new];
    
    
    NSMutableDictionary *titleSection = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": @"Title:",
                                                                                        @"value" : @""}];
    NSMutableDictionary *datesSection = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": @"Date Taken:",
                                                                                        @"value" : @"",
                                                                                        @"confidence" : @""}];
    NSMutableDictionary *uploaderSection = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": @"Uploader:",
                                                                                           @"value" : @""}];

    
    
    [secs addObject:titleSection];
    [secs addObject:datesSection];

    [secs addObject:uploaderSection];
    _imageSections = [NSArray arrayWithArray:secs];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [_tableView reloadData];
   
}
-(void)updateInformation:(imageObject *)information
{
    POPSpringAnimation *alphaAnimation = [POPSpringAnimation animation];
    
    alphaAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    
    alphaAnimation.fromValue = @(0.0);
    alphaAnimation.toValue = @(1.0);
    
    alphaAnimation.springBounciness = 10.0;
    alphaAnimation.springSpeed = 10.0;
    
    [self.view pop_addAnimation:alphaAnimation forKey:@"canNowSeeAlpha"];
    
    _information = information;
    
    [[_imageSections objectAtIndex:0] setValue:_information.title forKey:@"value"];
    
    [[_imageSections objectAtIndex:1] setValue:[_information.date displayDateOfType:sDateTypPretty] forKeyPath:@"value"];
    [[_imageSections objectAtIndex:1] setValue:_information.confidence forKey:@"confidence"];
    
    [[_imageSections objectAtIndex:2] setValue:_information.uploader forKey:@"value"];
    
    
    [_tableView reloadData];
    
    currentInformation = [_information informationAsMutableDictionary];
    
    fieldInfo = [NSMutableArray new];
    [fieldInfo insertObject:[NSMutableDictionary dictionaryWithDictionary:@{fieldTypeTitle: currentInformation[fieldTypeTitle],
                              fieldTypeHasEdited : [NSNumber numberWithBool:NO]}] atIndex:fieldInformationTitle];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger rowCount = [_imageSections count];
    
    return rowCount;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self createSectionFooter];
            
            break;
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return FOOTERHEIGHT;
            break;
            
        default:
            return 50.0;
            
            break;
    }
}
-(UIView*)createSectionFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, FOOTERHEIGHT)];
    
    UIButton* footerButton = [[UIButton alloc] initWithFrame:[footerStyle[keyFrame] CGRectValue]];
    
    footerButton.backgroundColor = footerStyle[keyDisabledColor];
    footerButton.titleLabel.font = footerStyle[keyFont];
    footerButton.titleLabel.textColor = footerStyle[keyTextColor];
    footerButton.layer.cornerRadius = [footerStyle[keyCornerRadius] floatValue];
    
    [footerButton setTitle:footerStyle[keyTextValue] forState:UIControlStateNormal];
    
    [footerButton addTarget:self action:@selector(useDidSaveInformation:) forControlEvents:UIControlEventTouchUpInside];
    
    _saveButton = footerButton;
    
    [footerView addSubview:footerButton];
    
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger sectionNum = indexPath.row;
    
    NSDictionary *sectionDict = [_imageSections objectAtIndex:sectionNum];
    
    NSString *sectionTitle = sectionDict[@"sectionName"];
    
    if ([sectionTitle isEqualToString:@"Date Taken:"]) {
        dateInfoCell *cell = [dateInfoCell createCell];
        
        cell.titleLabel.text = sectionTitle;
        cell.dateLabel.text = sectionDict[@"value"];
        [cell setConfidenceValue:sectionDict[@"confidence"]];
        
        return cell;
    }
    else
    {
        cellType theType;
        
        if (sectionNum == 0) {
            theType = cellTypeDefault;
        }
        else
        {
            theType = cellTypeLink;
        }
        basicInfoCell *cell = [basicInfoCell createCellOfType:theType];
    
        cell.titleConstLabel.text = sectionTitle;
        [cell setPlaceholderText:@"" withMainText:sectionDict[@"value"]];
        cell.delegate = self;
        
    return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return BASICROWHEIGHT / 2.0;
            
            break;
            case 1:
            return BASICROWHEIGHT;
            break;
            case 2:
            return BASICROWHEIGHT / 2.0;
        default:
            return 100.0;
            break;
    }
}
-(void)useDidSaveInformation:(id) sender
{
    ImagePackage *package = [ImagePackage new];
    [package setContentsWithImageObject:_information];
    
    [mainCom updatePhoto:package];
    
}
-(void)updatedOldTextValue:(NSString *)oldVal toNewValue:(NSString *)newVal ofType:(NSString *)type
{
    NSLog(@"\nThe old value -- %@ -- was updated to new value -- %@ -- of field type -> %@", oldVal, newVal, type);
    
    if ([self isNewValue:newVal forField:type]) {
        [fieldInfo[fieldInformationTitle] setObject:newVal forKey:fieldTypeTitle];
        [fieldInfo[fieldInformationTitle] setObject:[NSNumber numberWithBool:YES] forKey:fieldTypeHasEdited];
        _information.title = newVal;
        
        [self updateSaveButton];
        
        
        
    }
    
}
-(void)updateSaveButton
{
    BOOL hasEdited = NO;
    
    for (NSDictionary* dict in fieldInfo) {
        if ([dict[fieldTypeHasEdited] boolValue]) {
            hasEdited = YES;
        }
    }
    
    if (hasEdited) {
        //_saveButton.backgroundColor = footerStyle[keyEnabledColor];
        POPSpringAnimation *colorChange = [POPSpringAnimation animation];
        
        colorChange.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
        
        colorChange.toValue = footerStyle[keyEnabledColor];
    
        [_saveButton pop_addAnimation:colorChange forKey:@"colorChangeEnabled"];
        
        _saveButton.enabled = YES;
    }
    else
    {
        _saveButton.backgroundColor = footerStyle[keyDisabledColor];
        _saveButton.enabled = NO;
    }
}
-(BOOL)isNewValue:(NSString*) newValue forField:(NSString*) fieldType
{
    if ([fieldType isEqualToString:fieldTypeTitle]) {
        NSString *oldValue = fieldInfo[fieldInformationTitle][fieldTypeTitle];
        
        if (oldValue == nil && newValue != nil) {
            return YES;
        }
        return (!([newValue isEqualToString:oldValue]));
    }
    else
    {
        return NO;
    }
    
    
    
    
    
}

@end
