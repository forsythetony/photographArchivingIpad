//
//  TFPopOverPageViewController.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 8/3/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFPopOverPageViewController.h"

@interface TFPopOverPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation TFPopOverPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    TFImageInformationViewController *image_info_vc = [[TFImageInformationViewController alloc] init];
    
    [self setViewControllers:[NSArray arrayWithObject:image_info_vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
