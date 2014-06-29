//
//  photoUploadingViewController.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 6/19/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "photoUploadingViewController.h"
#import "photoUploadingCell.h"

@interface photoUploadingViewController () {
    NSArray *photos;
    XLFormViewController *formView;
    UIImagePickerController *imagePicker;
    UIPopoverController *popOverController;
    TFDataCommunicator *dataCom;
    ImagePackage *currentUpload;
    
}

@end

@implementation photoUploadingViewController


- (IBAction)takePhooto:(id)sender {
    
    [popOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    CGRect frame = self.view.frame;
    
    float popOverWidth = 800;
    float popOverHeight = 500;
    
    
    CGRect popoverContainer;
    popoverContainer.origin.x = self.view.center.x - (popOverWidth / 2.0);
    popoverContainer.origin.y = self.view.center.y - (popOverHeight / 2.0);
    popoverContainer.size = CGSizeMake(popOverWidth, popOverHeight);
    
   // [popOverController presentPopoverFromRect:popoverContainer inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _photoUploadsCollectionView.delegate = self;
        _photoUploadsCollectionView.dataSource = self;

        
        
        
    }
    return self;
}
- (IBAction)takeNewPhoto:(id)sender {

    
    
}
- (IBAction)testButtonPressed:(id)sender {
    
    NSDictionary *dict = [formView.form httpParameters:formView];
    
    NSLog(@"%@", dict);
    
    
}
- (IBAction)addPhoto:(id)sender {
    
    NSDictionary *formValues = [formView httpParameters];
    
    
    ImagePackage *newImage = [ImagePackage new];
    
    newImage.image_large    = _mainImageView.image;
    newImage.title          = formValues[keyTitle];
    newImage.dateTaken      = formValues[keyDateTaken];
    newImage.dateUploaded   = [NSDate date];
    newImage.contentType    = contentTypeJPEG;
    
    currentUpload = newImage;
    
    [dataCom uploadPhoto:newImage];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [_mainImageView setImage:photoTaken];
    
    [popOverController dismissPopoverAnimated:YES];
    
}
-(void)finishedUploadingRequestWithData:(NSDictionary *)data
{
    if (currentUpload) {
        
        if (!currentUpload.imageURL_large && !currentUpload.imageURL_thumbnail ) {
            currentUpload.imageURL_large = data[keyImageURL];
            
            currentUpload.image_thumbnail = [UIImage createThumbnailImageWithImage:currentUpload.image_large];
            
            [dataCom uploadPhoto:currentUpload];
            
        }
        else if (currentUpload.imageURL_large && !currentUpload.imageURL_thumbnail)
        {
            currentUpload.imageURL_thumbnail = data[keyImageURL];
            [dataCom mainServerUploadPhoto:currentUpload];
            
        }
    }else
    {
        NSLog(@"There was no current image to work with.");
    }
}
- (void) addUploadedPhotoToCollectionView
{
    NSMutableArray *photoArr = [NSMutableArray arrayWithArray:photos];
    
    [photoArr insertObject:currentUpload atIndex:0];
    
    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    
    photos = [NSArray arrayWithArray:photoArr];
    [_photoUploadsCollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndex]];
    
    currentUpload = nil;
    
}
-(void)finishedUploadingPhotoInfoToServer
{
    [self addUploadedPhotoToCollectionView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self dataSetup];
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    imagePicker.allowsEditing = YES;
    
    
    popOverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    
    dataCom = [TFDataCommunicator new];
    dataCom.delegate = self;
    
    /*
    
    [self aestheticsConfiguration];
    

    
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Main Title"];
    XLFormSectionDescriptor *sectionOne = [XLFormSectionDescriptor formSectionWithTitle:@"Section 1"];
    [form addFormSection:sectionOne];
    
    XLFormRowDescriptor *rowOne = [XLFormRowDescriptor formRowDescriptorWithTag:keyTitle rowType:XLFormRowDescriptorTypeText];
    [rowOne.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    [rowOne setTitle:@"Title"];
    
    
    XLFormRowDescriptor *dateTaken = [XLFormRowDescriptor formRowDescriptorWithTag:keyDateTaken rowType:XLFormRowDescriptorTypeDate title:@"Date Taken"];
    
    XLFormRowDescriptor *dateConfidence = [XLFormRowDescriptor formRowDescriptorWithTag:keyDateConfidence rowType:XLFormRowDescriptorTypeStepCounter title:@"Date Confidence"];
    
    
    [sectionOne addFormRow:rowOne];
    
    XLFormSectionDescriptor *dateSection = [XLFormSectionDescriptor formSectionWithTitle:@"Date Taken"];
    
    
    
    [dateSection addFormRow:dateTaken];
    [dateSection addFormRow:dateConfidence];
    

    [form addFormSection:dateSection];

    
    formView = [[XLFormViewController alloc] init];
    
    
    
    
    
    
    formView.delegate = self;
    
    
    formView.view.frame = CGRectMake(0.0, 0.0, _containerView.frame.size.width, _containerView.frame.size.height);

    
    
    
    [self addChildViewController:formView];
    
    
    imageInformationVC *imageInformationForm = [[imageInformationVC alloc] init];
    
    
    
    
    
    
    //[formView didMoveToParentViewController:self];
    //formView.form = form;
    
    [_containerView addSubview:imageInformationForm.view];
    // Do any additional setup after loading the view.
     
     */
}
-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    NSString *string = [formRow displayText];
    
    NSLog(@"Did select form with value %@", string);
}
-(void)dataSetup
{
    NSMutableArray *photosArray = [NSMutableArray new];
    
    UIImage *test1Image = [UIImage imageNamed:@"christmas.JPG"];
    UIImage *test1thumg = [UIImage imageNamed:@"christmas_tn.png"];
    
    
    ImagePackage *photoOne = [ImagePackage new];
    [photoOne setImage_large:test1Image];
    [photoOne setImage_thumbnail:test1thumg];
    
    [photosArray addObject:photoOne];
    
    photos = [NSArray arrayWithArray:photosArray];
    
}
- (void)aestheticsConfiguration
{
    _photoUploadsCollectionView.backgroundColor = [UIColor steelBlueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    photoUploadingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ImagePackage *image = [photos objectAtIndex:indexPath.row];
    
    
    [cell.thumbImage setImage:image.image_thumbnail];
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [photos count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
