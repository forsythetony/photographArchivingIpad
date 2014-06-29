//
//  ImageTakerViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/20/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "ImageTakerViewController.h"

@interface ImageTakerViewController () {
    UIImagePickerController* imagePicker;
    UIPopoverController*    popController;
}

@end

@implementation ImageTakerViewController

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
    [self configureImagePicker];
    
    _pickerContainer.backgroundColor = [UIColor grayColor];
    

}
-(void)viewDidAppear:(BOOL)animated
{
        [popController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(void)configureImagePicker
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    popController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    
    
    
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Finished picking photograph.");
    
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
