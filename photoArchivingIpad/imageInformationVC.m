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
    
    _imageTitle.text = _information.title;
    
}

@end
