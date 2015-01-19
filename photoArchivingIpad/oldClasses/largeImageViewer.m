//
//  largeImageViewer.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/16/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "largeImageViewer.h"

@interface largeImageViewer ()

@end

@implementation largeImageViewer

+(id)createLargeViewerWithFrame:(CGRect)frame
{
    largeImageViewer *viewer = [[[NSBundle mainBundle] loadNibNamed:@"largeImageViewer" owner:nil options:nil] firstObject];
    
    if ([viewer isKindOfClass:[largeImageViewer class]]) {
        
        viewer.view.frame = frame;
        viewer.view.alpha = 1.0;
        viewer.modalPresentationStyle = UIModalTransitionStylePartialCurl;
        
        LFGlassView *frosty = [[LFGlassView alloc] initWithFrame:frame];
        
        UISwipeGestureRecognizer *swippy = [UISwipeGestureRecognizer new];
        swippy.direction = UISwipeGestureRecognizerDirectionDown;
        
        [swippy addTarget:viewer    action:@selector(handleTap:)];

        
        UIView *frostContainer = [[UIView alloc] initWithFrame:frame];
        frostContainer.backgroundColor = [UIColor clearColor];
        
        [frostContainer addSubview:frosty];
        [frostContainer addGestureRecognizer:swippy];
        [viewer.view addSubview:frostContainer];
        

        return viewer;
    }
    else
    {
        return nil;
    }
}
-(void)setDisplayedImage:(imageObject *)image
{
    _imageObj = image;
    _displayImage.alpha = 0.0;

    UITapGestureRecognizer *noTappy = [UITapGestureRecognizer new];
    
    [noTappy setEnabled:NO];
    
    [_displayImage addGestureRecognizer:noTappy];
    
    [_displayImage sd_setImageWithURL:_imageObj.photoURL];

    [self.view bringSubviewToFront:_displayImage];
    
    UIColor *newColor = [_displayImage.image getDominantColor];
    
    self.view.backgroundColor = newColor;
    
}
-(void)handleTap:(id) sender
{

    
    [self.delegate shouldDismissImageViewer:self];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view bringSubviewToFront:_displayImage];
    
    _displayImage.center = self.view.center;
}
-(void)viewDidAppear:(BOOL)animated
{
    POPSpringAnimation *alphaSpring = [POPSpringAnimation animation];
    
    alphaSpring.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    
    alphaSpring.fromValue = @(0.0);
    alphaSpring.toValue = @(1.0);
    
    alphaSpring.springBounciness = 10.0;
    alphaSpring.springSpeed = 10.0;
    
    POPSpringAnimation *sizeSpring = [POPSpringAnimation animation];
    
    sizeSpring.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
    
    sizeSpring.fromValue = [NSValue valueWithCGSize:CGSizeMake(4.0, 4.0)];
    sizeSpring.toValue = [NSValue valueWithCGSize:_displayImage.frame.size];
    
    sizeSpring.springBounciness = 10.0;
    sizeSpring.springSpeed = 10.0;
    
    
    POPSpringAnimation *colorChange = [POPSpringAnimation animation];
    
    colorChange.property = [POPAnimatableProperty propertyWithName:kPOPLayerBackgroundColor];
    
    colorChange.fromValue = [UIColor blackColor];
    colorChange.toValue = [_displayImage.image getDominantColor];
    
    
    
    colorChange.springSpeed = 10.0;
    colorChange.springBounciness = 10.0;
    
    //[self.view.layer pop_addAnimation:colorChange forKey:@"colorz"];
    
    
    
    
    //[self.view.layer pop_addAnimation:colorChange forKey:@"colorz"];
    [_displayImage pop_addAnimation:alphaSpring forKey:@"alphaSpringImage"];
    [_displayImage.layer pop_addAnimation:sizeSpring forKey:@"siz"];
    
    [self.view pop_addAnimation:alphaSpring forKey:@"alphaSpring"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
