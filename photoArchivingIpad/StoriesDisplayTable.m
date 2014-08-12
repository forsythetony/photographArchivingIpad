//
//  StoriesDisplayTable.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoriesDisplayTable.h"
#define FOOTERHEIGHT 40.0
@interface StoriesDisplayTable () <UITableViewDataSource, UITableViewDelegate, ImageInformationDisplayer> {
    
}

@end

@implementation StoriesDisplayTable

@synthesize storiesDisplayTableview, info;
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
    // Do any additional setup after loading the view from its nib.
    [self setupTableview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableview
{
    UINib *nib = [UINib nibWithNibName:@"StoryCellTableViewCell" bundle:[NSBundle mainBundle]];
    [storiesDisplayTableview registerNib:nib forCellReuseIdentifier:@"StoryCell"];
    
    [storiesDisplayTableview setDelegate:self];
    [storiesDisplayTableview setDataSource:self];
    
    [storiesDisplayTableview setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor clearColor];
    [storiesDisplayTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

#pragma mark Tableview Data Source -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *stories = [info stories];
    
    if (stories == nil) {
        return 0;
    }
    else
    {
        return [stories count];
    }
}

#pragma mark Tableview delegate -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StoryCellTableViewCell *cell = [storiesDisplayTableview dequeueReusableCellWithIdentifier:@"StoryCell"];
    
    Story *story = [info.stories objectAtIndex:indexPath.row];
    
    if (cell) {
        
        [cell setMyStory:story];
        [cell setupStreamer];
        
    }
    
    return cell;
    
}
-(void)updateInformationForImage:(imageObject *)information
{
    info = information;
    
    [storiesDisplayTableview reloadData];
    
   
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return FOOTERHEIGHT;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, storiesDisplayTableview.bounds.size.width, FOOTERHEIGHT)];
//        
//        UIButton *footerButton = [[UIButton alloc ]initWithFrame:CGRectMake(0.0, 0.0, storiesDisplayTableview.bounds.size.width, FOOTERHEIGHT)];
//        
//        [footerButton addTarget:self action:@selector(saveInformation:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [footerButton setBackgroundColor:[UIColor greenColor]];
//        
//        [footerButton setTitle:@"Save" forState:UIControlStateNormal];
//        
//        [footerView addSubview:footerButton];
//        
//        return footerView;
//        
//    }
//    else
//    {
//        return nil;
//        
//    }
//}
-(void)saveInformation:(id) sender
{
    
}
@end
