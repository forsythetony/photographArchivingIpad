//
//  imageInfoPagerVC.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/15/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "imageInfoPagerVC.h"

@interface imageInfoPagerVC ()

@property (strong, nonatomic) NSArray *pageVCs;

@end

@implementation imageInfoPagerVC

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
    
    self.delegate = self;
    self.dataSource = self;
    [self dataSetup];
    
    [self setViewControllers:[NSArray arrayWithObject:[_pageVCs firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
-(UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationNone;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dataSetup
{
    NSMutableArray *VCs = [NSMutableArray new];
    
    imageInformationVC* imageInfo = [imageInformationVC new];

    imageInfo.view.frame = self.view.frame;
    imageInfo.view.alpha = 0.0;
    
    socialInformationVC* socialInfo = [socialInformationVC new];
    
    socialInfo.view.frame = self.view.frame;
    socialInfo.view.alpha = 0.0;
    
    [VCs addObject:imageInfo];
    [VCs addObject:socialInfo];
    
    
    NSArray *viewControllers = [NSArray arrayWithArray:VCs];
    
    _pageVCs = viewControllers;
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
-(void)updateImageInformation:(imageObject *)theImage
{
    for (NSUInteger i = 0 ; i < [_pageVCs count]; i++) {
        [[_pageVCs objectAtIndex:i] updateInformation:theImage];
        
    }
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [_pageVCs indexOfObject:viewController];
    
    if (index >= [_pageVCs count] - 1) {
        return nil;
    }
    else
    {
        return [_pageVCs objectAtIndex:(index + 1)];
    }
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [_pageVCs indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    }
    else
    {
        return [_pageVCs objectAtIndex:(index - 1)];
    }
}
@end