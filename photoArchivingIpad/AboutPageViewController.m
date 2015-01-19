//
//  AboutPageViewController.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 1/19/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "AboutPageViewController.h"
#import "AboutMeCell.h"

@interface AboutPageViewController ()

@property (nonatomic, strong) NSDictionary* aboutMeData;

@end

@implementation AboutPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *aboutMeInfoFilePath = [[NSBundle mainBundle] pathForResource:@"aboutInformation" ofType:@"json"];
    
    NSData *aboutMeData = [[NSData alloc] initWithContentsOfFile:aboutMeInfoFilePath];
    
    NSDictionary *aboutMeDictionary;
    
    if (aboutMeData) {
        aboutMeDictionary = [NSJSONSerialization JSONObjectWithData:aboutMeData options:0 error:nil];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dictionaryKeys = [_aboutMeData allKeys];

    if (section > [dictionaryKeys count]) {
        return 0;
    }
    
    NSString *currentKey = dictionaryKeys[section - 1];
    
    if ([currentKey isEqualToString:@"name"]) {
        return 1;
    }
    else if ([currentKey isEqualToString:@"aboutMe"])
    {
        return 1;
    }
    else if ([currentKey isEqualToString:@"dependencies"])
    {
        NSArray *dependencies = [_aboutMeData objectForKey:currentKey];
        return [dependencies count];
    }
    else if ([currentKey isEqualToString:@"thanks"])
    {
        return 1;
    }

    return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_aboutMeData allKeys] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = @"Cell";
    
    AboutMeCell *cell = (AboutMeCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    id data = _aboutMeData
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
