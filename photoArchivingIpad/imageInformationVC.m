//
//  imageInformationVC.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "imageInformationVC.h"

@interface imageInformationVC ()

@property (nonatomic, strong) UILabel* imageTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageSections;

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
    [self dataSetup];
    
    [self viewSetup];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewSetup
{
    
    self.view.backgroundColor = [UIColor icebergColor];
    self.view.layer.cornerRadius = 8.0;
    
    UIFont *fontForLabelKeys = [UIFont fontWithName:@"DINAlternate-Bold" size:15.0];
    UIFont *fontForLabelValues = [UIFont fontWithName:@"DINAlternate-Bold" size:13.0];
    
    UIColor *colorForLabelKeys = [UIColor black25PercentColor];
    UIColor *colorForLabelValues = [UIColor blackColor];
    
    CGRect titleContainerFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0);
    
    
    _tableView = [[UITableView alloc] initWithFrame:titleContainerFrame];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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
    
    
    NSMutableDictionary *titleSection = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": @"Title",
                                                                                        @"value" : [NSArray arrayWithObject:@""]}];
    NSMutableDictionary *datesSection = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": @"Dates",
                                                                                        @"value" : [NSArray new]}];
    NSMutableDictionary *uploaderSection = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": @"Uploader",
                                                                                           @"value" : [NSArray new]}];
    
    

    [secs addObject:datesSection];
    [secs addObject:titleSection];
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
    
    [[_imageSections objectAtIndex:0] setValue:[NSArray arrayWithObject:_information.title] forKey:@"value"];
    
    NSMutableArray *datesArray = [NSMutableArray new];
    
    [datesArray addObject:[_information.date displayDateOfType:sDateTypeSimple]];
    
    [[_imageSections objectAtIndex:1] setValue:[NSArray arrayWithArray:datesArray] forKeyPath:@"value"];
    
    [[_imageSections objectAtIndex:2] setValue:[NSArray arrayWithObject:_information.uploader] forKey:@"value"];
    
    
    
    
    [_tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_imageSections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger rowCount = [[[_imageSections objectAtIndex:section] objectForKey:@"value"] count];
    
    return rowCount;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_imageSections objectAtIndex:section] objectForKey:@"sectionName"];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger sectionNum = indexPath.section;
    
    NSDictionary *sectionDict = [_imageSections objectAtIndex:sectionNum];
    
    NSString *sectionTitle = sectionDict[@"sectionName"];
    
    
    
    if ([sectionTitle isEqualToString:@"Title"]) {
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.textLabel.text = [sectionDict[@"value"] objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        return cell;
    }
    else if ([sectionTitle isEqualToString:@"Dates"])
    {
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.textLabel.text = [sectionDict[@"value"] objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else if ([sectionTitle isEqualToString:@"Uploader"]) {
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.textLabel.text = [sectionDict[@"value"] objectAtIndex:indexPath.row];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.textLabel.text = @"Nothing";
        
        
        return cell;
    }
}
@end
