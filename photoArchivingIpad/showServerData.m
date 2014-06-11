//
//  showServerData.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "showServerData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface showServerData () {
    TFDataCommunicator *mainDataCom;
    NSArray *photosList;
    BOOL textFieldHasColor;
}

@end

@implementation showServerData

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)initialSetup
{
    //  Configure the label for the photos table
    
    UIColor* lblPhotosBackground = [UIColor icebergColor];
    UIColor* lblText = [UIColor indigoColor];

    NSString* lblTitle = @"User's Photographs";
    
    float photosLblFontSize = 18.0;
    
    UIFont *lblFont = [UIFont fontWithName:@"DINAlternate-Bold" size:photosLblFontSize];
    
    [self.lblPhotosForUsers setBackgroundColor:lblPhotosBackground];
    [self.lblPhotosForUsers setTextColor:lblText];
    
    [self.lblPhotosForUsers setText:lblTitle];
    [self.lblPhotosForUsers setTextAlignment:NSTextAlignmentCenter];
    [self.lblPhotosForUsers setFont:lblFont];
    
    //  Configure the image view
    
    [self.mainImageView.layer setCornerRadius:8.0];
    
    //  Configure the text view
    
    [self.mainTextView setFont:[UIFont fontWithName:@"CourierNewPSMT" size:13.0]];
    [self.mainTextView setBackgroundColor:[UIColor clearColor]];
    [self.mainTextView setTextColor:[UIColor ghostWhiteColor]];
    [self.mainTextView.layer setCornerRadius:4.0];
    [self.mainTextView setText:@""];
    [self.mainTextView setEditable:NO];
    
    textFieldHasColor = NO;
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialSetup];
    mainDataCom = [TFDataCommunicator new];
    [mainDataCom setDelegate:self];
    [mainDataCom getPhotosForUser:@"forsythetony"];
    
    photosList = [NSArray new];
    
    
    // Do any additional setup after loading the view.
}
-(void)finishedPullingPhotoList:(NSArray *)list
{
    photosList = list;

    [self.photosForUser reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [photosList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        NSInteger rowNumber = indexPath.row;
        
        NSDictionary *photograph = [photosList objectAtIndex:rowNumber];

        NSLog(@"The photos list array is %i big.", [photosList count]);
        
        
        NSLog(@"%@", photograph);
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.textLabel.text = [[photograph objectForKey:@"imageInformation"] objectForKey:@"title"];
        
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        NSDictionary *photoDict = [photosList objectAtIndex:indexPath.row];
        
        NSString *imageDetailText = [NSString stringWithFormat:@"%@", photoDict];
        
        [self.mainTextView setText:imageDetailText];
        
        [self.mainImageView setImageWithURL:[NSURL URLWithString:[photoDict objectForKey:@"imageURL"]]];
        
        [self.mainImageView setImageWithURL:[NSURL URLWithString:[photoDict objectForKey:@"imageURL"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            POPSpringAnimation* photoSpring = [POPSpringAnimation animation];
            
            photoSpring.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
            
            photoSpring.toValue = [NSValue valueWithCGSize:CGSizeMake(350.0, 350.0)];
            photoSpring.fromValue = [NSValue valueWithCGSize:CGSizeMake(325.0, 325.0)];
            
            photoSpring.springSpeed = 10.0;
            
            [self.mainImageView.layer pop_addAnimation:photoSpring forKey:@"photoSpringDownload"];
        }];
        
        POPSpringAnimation* photoSpring = [POPSpringAnimation animation];
        
        photoSpring.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
        
        photoSpring.toValue = [NSValue valueWithCGSize:CGSizeMake(350.0, 350.0)];
        photoSpring.fromValue = [NSValue valueWithCGSize:CGSizeMake(325.0, 325.0)];
        
        photoSpring.springSpeed = 10.0;
        
        //  Create corner radius animation
        
        POPSpringAnimation* cornerRadiusSpring = [POPSpringAnimation animation];
        
        cornerRadiusSpring.property = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
        
        cornerRadiusSpring.fromValue = @(0.0);
        cornerRadiusSpring.toValue = @(30.0);
        
        
        [self.mainImageView.layer pop_addAnimation:cornerRadiusSpring forKey:@"cornerRadSpring"];
        [self.mainImageView.layer pop_addAnimation:photoSpring forKey:@"photoSpring"];
        
        if (textFieldHasColor == NO) {
            POPSpringAnimation* colorChange = [POPSpringAnimation animation];
            
            colorChange.property = [POPAnimatableProperty propertyWithName:kPOPLayerBackgroundColor];
            
            colorChange.fromValue = [UIColor clearColor];
            colorChange.toValue = [UIColor midnightBlueColor];
            
            
            [self.mainTextView.layer pop_addAnimation:colorChange forKey:@"changingColors"];
            
            textFieldHasColor = YES;

        }
        
        
        
    }
}




@end
