//
//  StoriesDisplayTable.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoriesDisplayTable.h"
#import "TFDataCommunicator.h"

#define FOOTERHEIGHT 40.0
#define HEADERHEIGHT 40.0

@interface StoriesDisplayTable () <UITableViewDataSource, UITableViewDelegate, ImageInformationDisplayer, TFCommunicatorDelegate, StoryCellDelegate> {
    
    TFDataCommunicator *mainCom;
    NSIndexPath *indexPathToDelete;
    
}

@end

@implementation StoriesDisplayTable

@synthesize storiesDisplayTableview, info;
-(void)finishedDeletingStoryWithStatusCode:(NSInteger)statusCode
{
    
    if (statusCode == 200) {
        [self performSelectorOnMainThread:@selector(removeCellSlatedForDeletion) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self showErrorAlertWithStatusCode:statusCode];
    }
    
}
-(void)showErrorAlertWithStatusCode:(NSInteger) statusCode
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:[NSString stringWithFormat:@"There was an error deleting the story. Status code %ld", (long)statusCode] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    [alert show];
}
-(void)removeCellSlatedForDeletion
{
    
    NSMutableArray *storiesArr = [NSMutableArray arrayWithArray:info.stories];
    
    [storiesArr removeObjectAtIndex:indexPathToDelete.row];
    
    
    info.stories = [NSArray arrayWithArray:storiesArr];

    [storiesDisplayTableview beginUpdates];
    
    [storiesDisplayTableview deleteRowsAtIndexPaths:@[indexPathToDelete] withRowAnimation:UITableViewRowAnimationRight];
    
    
    [storiesDisplayTableview endUpdates];
    
    indexPathToDelete = nil;
    
    
}
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
    
    mainCom = [TFDataCommunicator new];
    mainCom.delegate = self;
    
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
    storiesDisplayTableview.allowsMultipleSelectionDuringEditing = NO;
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
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteCellAtIndexPath:indexPath];
    }
}
-(void)deleteCellAtIndexPath:(NSIndexPath*) index
{
    Story *deletedStory = [[info stories] objectAtIndex:index.row];
    
    
    indexPathToDelete = index;
    
    
    [mainCom removeStoryFromImage:info withStoryID:deletedStory.stringId];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StoryCellTableViewCell *cell = [storiesDisplayTableview dequeueReusableCellWithIdentifier:@"StoryCell"];
    
    Story *story = [info.stories objectAtIndex:indexPath.row];
    
    if (cell) {
        
        [cell setMyStory:story];
        [cell setupStreamer];
        cell.delegate = self;
        
    }
    
    return cell;
    
}
-(void)updateInformationForImage:(imageObject *)information
{
    
    info = information;
    
    [storiesDisplayTableview reloadData];
    
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            
            return [self createHeaderView];
        
        }
            
            break;
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERHEIGHT;
}
-(UIView*)createHeaderView
{
    CGRect headerRect;
    
    headerRect.origin = CGPointMake(0.0, 0.0);
    
    headerRect.size.width = storiesDisplayTableview.frame.size.width;
    headerRect.size.height = HEADERHEIGHT;
    
    UIView *headerView = [[UIView alloc] initWithFrame:headerRect];
    
    CGRect labelRect;
    
    CGFloat margin = 10.0;
    CGFloat height = HEADERHEIGHT / 2.0;
    CGFloat width = headerRect.size.width - margin;
    
    labelRect.origin.x = margin;
    labelRect.origin.y = (HEADERHEIGHT / 2.0) - (height / 2.0);
    
    labelRect.size.width = width;
    labelRect.size.height = height;
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelRect];
    
    [headerLabel setAttributedText:[[NSAttributedString alloc ] initWithString:@"Stories" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                       NSFontAttributeName: [UIFont fontWithName:global_font_family size:20.0]}]];
    
    CGRect headerLineFrame;
    
    headerLineFrame.origin.x = margin;
    headerLineFrame.origin.y = labelRect.origin.y + labelRect.size.height + 5.0;
    
    headerLineFrame.size.width = headerRect.size.width / 3.0;
    headerLineFrame.size.height = 1.0;
    
    UIView *headerLine = [[UIView alloc] initWithFrame:headerLineFrame];
    [headerLine setBackgroundColor:[UIColor whiteColor]];
    
    [headerView addSubview:headerLine];
    [headerView addSubview:headerLabel];
    
    return headerView;
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
-(void)deleteMePlease:(StoryCellTableViewCell *)me
{
    NSIndexPath *path = [storiesDisplayTableview indexPathForCell:me];
    
    [self deleteCellAtIndexPath:path];
    
}

@end
