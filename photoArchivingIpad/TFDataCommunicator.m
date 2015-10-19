//
//  TFCommunicator.m
//  PhotoArchiving
//
//  Created by Anthony Forsythe on 3/25/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TFDataCommunicator.h"

#import "updatedConstants.h"
#import "TFDataCommunicator+Helpers.h"
#import "Story+StoryHelpers.h"
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
#import "Story+Converters.h"
#import "TFImageCollection.h"
#import "TFImageCollection+Converters.h"
#import "TFCollectionImageListItem.h"

@interface TFDataCommunicator () <AmazonServiceRequestDelegate>
{
    NSURL   *currentUploadLocalPath;
}

@property (strong, nonatomic) S3TransferOperation *fileUpload;

@property (strong, nonatomic) S3TransferManager *tm;

@property (strong, nonatomic) NSString *pathForFile;

@property (strong, nonatomic) NSDictionary *tempSaveDict;

@property (nonatomic, strong) NSFileManager *fileMan;

@property (nonatomic, strong) NSOperationQueue *dataOpQueue;
@end

static BOOL isValidResponseCode(NSUInteger responseCode)
{
    return (responseCode == 200 || responseCode == 201);
}

static NSString* const EC2_BASE_URL = @"http://52.11.175.22";

@implementation NSString (URLS)

+(NSString *)EC2CollectionsEndpoint
{
    return [NSString stringWithFormat:@"%@/photoarchiving/collections.php", EC2_BASE_URL];
}
+(NSString *)EC2PhotosEndpoint
{
    return [NSString stringWithFormat:@"%@/photoarchiving/photos.php", EC2_BASE_URL];
}
+(NSString *)EC2StoriesEndpoint
{
    return [NSString stringWithFormat:@"%@/photoarchiving/stories.php", EC2_BASE_URL];
}
@end
@implementation TFDataCommunicator
-(NSOperationQueue *)dataOpQueue
{
    if (!_dataOpQueue) {
        _dataOpQueue = [[NSOperationQueue alloc] init];
    }
    
    return _dataOpQueue;
}
+(id)sharedCommunicator
{
    static TFDataCommunicator *dataCom = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dataCom = [[TFDataCommunicator alloc] init];
        [dataCom setupTransferManager];
    });
    
    return dataCom;
}
-(NSFileManager *)fileMan
{
    if (!_fileMan) {
        _fileMan = [[NSFileManager alloc] init];
    }
    
    return _fileMan;
}
-(id)init
{
    self = [super init];
    
    if (self) {
        
        return self;
    
    }
    
    else
    {
        return nil;
    }
}
-(void)getDummyData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dummyData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [self.delegate finishedPullingPhotoList:json];
}
-(void)uploadSmallFile
{
    if(self.fileUpload == nil || (self.fileUpload.isFinished && !self.fileUpload.isPaused)){
        self.fileUpload = [self.tm uploadFile:self.pathForFile bucket: [updatedConstants transferManagerBucket] key: kKeyForSmallFile];
        
    }
}
-(void)deletePhoto:(imageObject *)photo
{
    if (photo.id) {
       NSString *reqString = [NSString stringWithFormat:@"%@?photo_id=%@", [NSString EC2PhotosEndpoint], photo.id];
        
        NSURL           *urlObject  = [NSURL URLWithString:reqString];
        
        
        NSMutableURLRequest *mutableReq = [[NSMutableURLRequest alloc] initWithURL:urlObject];
        mutableReq.HTTPMethod = @"DELETE";
        
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:mutableReq queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (isValidResponseCode(httpResponse.statusCode)) {
                
                NSLog(@"Deleted");
                
                if ([self.delegate respondsToSelector:@selector(finishedDeletingImage:)]) {
                    [self.delegate finishedDeletingImage:photo];
                }
                
            }
        }];

    }
   
}
-(void)uploadPhoto:(ImagePackage *)photo
{
    if (self.fileUpload == nil || (self.fileUpload.isFinished && !self.fileUpload.isPaused)) {
        
        NSString *thumbnailMod = @"";
        UIImage *uploadPhoto = photo.image_large;
        
        if (photo.image_thumbnail) {
            uploadPhoto = photo.image_thumbnail;
            thumbnailMod = @"_tn";
        }
        
        NSData* imageData = UIImageJPEGRepresentation(uploadPhoto, 1.0);
        
        NSString *photoKey = [NSString stringWithFormat:@"%@%@_%@", photo.title, thumbnailMod, [photo.dateTaken displayDateOfType:sdatetypeURL]];
        
        S3PutObjectRequest* req = [[S3PutObjectRequest alloc] initWithKey:photoKey inBucket:[updatedConstants transferManagerBucket]];
        req.data = imageData;
        
        if (photo.contentType) {
            req.contentType = photo.contentType;
        }
        
        req.cannedACL = [S3CannedACL publicRead];

        _fileUpload = [_tm upload:req];
    }
    else
    {
        NSLog(@"Could not upload %@", photo);
    }
}
-(void)updatePhoto:(ImagePackage *)photo
{
    
    
    if (photo.imageID) {
        NSString        *urlString  = [NSString stringWithFormat:@"%@%@/%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint, photo.imageID];
        
        NSURL           *urlObject  = [NSURL URLWithString:urlString];
        
        NSLog(@"%@", photo.imageID);
        
        NSMutableURLRequest *mutableReq = [[NSMutableURLRequest alloc] initWithURL:urlObject];
        mutableReq.HTTPMethod = @"PUT";
        mutableReq.HTTPBody = [photo createJSONReadyDict];
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [mutableReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
//        NSData *putData = [photo createJSONReadyDict];

//        NSLog(@"%@", putData);
        
        
        
        
        [NSURLConnection sendAsynchronousRequest:mutableReq queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            [self.delegate finishedUpdatingPhotoDateWithStatusCode:httpResponse.statusCode];
            if (httpResponse.statusCode == 200) {

            }
        }];
        
    }

}
-(void)mainServerUploadPhoto:(ImagePackage *)photo
{
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint];
    NSURL           *urlObject  = [NSURL URLWithString:urlString];

    
    NSMutableURLRequest *mutableReq = [[NSMutableURLRequest alloc] initWithURL:urlObject];
    mutableReq.HTTPMethod = @"POST";
    [mutableReq setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];

    NSData *postData = [photo createJSONReadyDict];
    
    NSLog(@"Data: %@", postData);
    
    mutableReq.HTTPBody = postData;
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:mutableReq queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            
            [self.delegate finishedUploadingPhotoInfoToServer];
            
        }
    }];
    
}
-(void)uploadSinglePhoto:(UIImage*) photo withInformation:(NSDictionary*) information
{
    if (self.fileUpload == nil || (self.fileUpload.isFinished && !self.fileUpload.isPaused)) {
        
        NSData* imageData = UIImageJPEGRepresentation(photo, 1.0);
        
        NSString *photoKey = [NSString stringWithFormat:@"%@_%@", information[keyTitle], [information[keyDateUploaded] displayDateOfType:sdatetypeURL]];
        
        S3PutObjectRequest* req = [[S3PutObjectRequest alloc] initWithKey:photoKey inBucket:[updatedConstants transferManagerBucket]];
        req.data = imageData;
        req.contentType = contentTypeJPEG;
        req.cannedACL = [S3CannedACL publicRead];
        
        _fileUpload = [_tm upload:req];
    }
}
-(void)getUserWithUsername:(NSString *)username
{
    
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@/%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_usersEndpoint, username];
    
    NSString        *urlString  = [NSString stringWithString:apiEndpoint];
    NSURL           *url        = [NSURL URLWithString:urlString];
    NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200 && data) {
            
            [self parsePersonDataFromData:data];
            
        }
    }];
}
-(void)setupTransferManager
{
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    
    NSString *secret_key = @"w14s0oUFSLG2Ft5Y4h0aVPrd8p/b62Rm/xUTCPRG";
    
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:@"AKIAJ7TRHRICO7YAEJNA" withSecretKey:secret_key];
    
    s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    
    self.tm = [S3TransferManager new];
    self.tm.s3 = s3;
    self.tm.delegate = self;
    
    S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:[updatedConstants transferManagerBucket] andRegion:[S3Region USWest2]];
    
    
    @try {
        S3CreateBucketResponse *createBucketResponse = [s3 createBucket:createBucketRequest];
        if (createBucketResponse.error != nil) {
            NSLog(@"Error: %@", createBucketResponse.error);
        }
    }
    @catch (AmazonServiceException *exception) {
        
        if ([s3_error_already_owned isEqualToString: exception.errorCode]) {
            NSLog(@"Unable to create bucket: %@", exception.error);
        }
    }
    
    self.pathForFile = [self generateTempFile: @"small_test_data.txt": kSmallFileSize];
}
-(void)getPhotosForTestUser
{
    NSString        *urlString  = [NSString stringWithFormat:@"%@/%@?forUser=%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint, api_testUser];
    NSURL           *url        = [NSURL URLWithString:urlString];
    NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200 && data) {
            
            [self parsePhotosFromData:data];
            
        }
    }];
}
-(void)parsePersonDataFromData:(NSData*) data
{
    
    NSError *error;
    
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSMutableArray *parsedPeople = [NSMutableArray array];
    
    
    TFPerson *person = [[TFPerson alloc] init];
    
    person.username     = rootDictionary[@"username"];
    person.photoUrl     = [rootDictionary[@"profilePhoto"] objectForKey:@"url"];
    person.firstName    = rootDictionary[@"firstName"];
    person.lastName     = rootDictionary[@"lastName"];
    
    [parsedPeople addObject:person];
    
    [self.delegate finishedParsingPeople:[NSArray arrayWithArray:parsedPeople]];
    
}
-(void)retrieveImageWithURL:(NSString *)url
{
    
    NSString        *urlString  = url;
    NSURL           *urlObject  = [NSURL URLWithString:urlString];
    NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:urlObject];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200 && data) {
            
            [self parseImageFromData:data];
            
        }
    }];
}

-(void)parseImageFromData:(NSData*) data
{
    
    UIImage *img = [UIImage imageWithData:data];
    
    [self.delegate finishedPullingImageFromUrl:img];
    
}
-(void)getPhotoListWithOptions:(NSDictionary *)options
{
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint];
    NSURL           *urlObject  = [NSURL URLWithString:urlString];
    NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:urlObject];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200 && data) {
            
            [self parsePhotoListFromData:data];
            
        }
    }];
}
-(void)cleanImages
{
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@?%@=%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint, api_cleanFlagKey, api_cleanFlagValue];
    
    NSURL           *urlObject  = [NSURL URLWithString:urlString];
    NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:urlObject];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200 && data) {
            
            [self parseSimpleResponseFromData:data withType:simpleResponseTypeImageClean andStatus:serverResponseTypeOK];
            
        }
    }];
}
-(void)parseSimpleResponseFromData:(NSData*) data withType:(simpleResponseType) responseType andStatus:(serverResponseType) status
{
    NSError *error;
    NSDictionary *respDict;
    
    switch (responseType) {
            
        case simpleResponseTypeImageClean: {
            
            respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSArray *resultsKeys = @[respKeys_responseStatus, respKeys_responseMessage];
            NSArray *resultsValues = @[respDict[@"responseMessage"], [NSNumber numberWithInteger:status]];
            
            NSDictionary *resultsDict = [NSDictionary dictionaryWithObjects:resultsValues forKeys:resultsKeys];
            
            [self.delegate finishedServerCleanup:resultsDict];
    }
            break;
            
        case simpleResponseTypeServerStatus: {
            
        }
            
            break;
        default:
            break;
    }
}
-(void)parsePhotoListFromData:(NSData*) data
{
    NSError *error;
    
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    for (NSDictionary *dict in rootDict) {
        
        NSString *titleString = [dict objectForKey:@"title"];
        
        NSLog(@"\n%@\n", titleString);
        
    }
}

-(void)sendImageToServer:(UIImage *)image ofType:(photoType) type withInformation:(NSDictionary*) information
{
    
    NSString *imageDataString = [self createBase64EncodedStringFromImage:image
                                                                  ofType:type];
    
    NSLog(@"%@", imageDataString);
    
    NSDictionary *uploadInfo    = information[@"uploadInformation"];
    
    NSDictionary *postData = @{
                               @"title"     : [information objectForKey:@"title"],
                               @"imageData" : imageDataString,
                               @"uploadInformation" : @{@"user"         : uploadInfo[@"user"],
                                                        @"uploadTime"   : uploadInfo[@"uploadTime"]}
                               };
    
    
    NSError *error;
    
    NSData *postDataData = [NSJSONSerialization dataWithJSONObject:postData
                                                           options:0
                                                             error:&error];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    request.HTTPMethod  = @"POST";
    request.URL         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint]];
    request.HTTPBody    = postDataData;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSLog(@"\nThe response from the server was: %ld", (long)httpResponse.statusCode);
        
    }];
}

-(void)getPhotosForUser:(NSString *)username
{
    username = @"forsythetony";
    
    NSString *babbage_urlString = [NSString stringWithFormat:@"%@?username=%@", [NSString EC2PhotosEndpoint], username];
    
    
    NSURL           *url        = [NSURL URLWithString:babbage_urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.HTTPMethod = @"GET";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (isValidResponseCode(httpResponse.statusCode) && data ) {
            
            [self parsePhotosFromData:data];
        }
        
    }];
}
-(void)pullStoriesListForPhoto:(NSString *)photo_id
{
    NSString *babbage_urlString = [NSString stringWithFormat:@"%@?photo_id=%@", [NSString EC2StoriesEndpoint], photo_id];
    
    NSURL           *url        = [NSURL URLWithString:babbage_urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.HTTPMethod = @"GET";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 201 && data ) {
            [self parseStoriesFromData:data];
        }
        
    }];

}
-(void)parseStoriesFromData:(NSData*) data
{
    NSError *error;
    
    NSArray *rootArray = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:&error];
    
    NSMutableArray *stories = [NSMutableArray new];
    
    for (NSDictionary *dict in rootArray) {
        
        Story *newStory = [Story StoryFromDictionary:dict];
        
        [stories addObject:newStory];
    }
    
    [self.delegate finishedPullingStoriesList:[NSArray arrayWithArray:stories]];
}
-(void)parsePhotosFromData:(NSData*) data
{
    NSError *error;
    
    NSArray *rootDict = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:&error];
    
    NSLog(@"Something : %@", rootDict[0]);
    
    [self.delegate finishedPullingPhotoList:rootDict];
    
}
#pragma mark - Utility Functions
-(NSString*)createBase64EncodedStringFromImage:(UIImage*) image ofType:(photoType) type
{
    if (!image) return nil;
    
    CGFloat jpegCompressionQuality = 0.9;
    
    NSData *imageData = nil;
    
    switch (type) {
            
        case tPNG:
            imageData = UIImagePNGRepresentation(image);
            break;

        case tJPG:
            imageData = UIImageJPEGRepresentation(image, jpegCompressionQuality);
            break;
            
        default:
            return nil;
            break;
    }
    
    return [imageData base64EncodedStringWithOptions:0];
    
}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse called: %@", request.url);
}

-(NSString *)generateTempFile: (NSString *)filename : (long long)approximateFileSize {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    if (![fm fileExistsAtPath:filePath]) {
        NSOutputStream * os= [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        NSString * dataString = @"S3TransferManager_V2 ";
        const uint8_t *bytes = [dataString dataUsingEncoding:NSUTF8StringEncoding].bytes;
        long fileSize = 0;
        [os open];
        while(fileSize < approximateFileSize){
            [os write:bytes maxLength:dataString.length];
            fileSize += dataString.length;
        }
        [os close];
    }
    return filePath;
}
-(void)saveImageToCameraRoll
{
    NSURL *imageURL = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/node-photo-archive/mainPhotos/Fred_and_Freddie2014-06-11T21-04%3A25-512Z"];
    

    
    NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:imageURL];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200 && data) {
            
            [self parsePhotoFromData:data];
            
        }
    }];
}
-(void)parsePhotoFromData:(NSData*) data
{
    
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [self deleteLocalFile];
    
    NSLog(@"\nImage URL: %@ \n", request.url);
    self.fileUpload = nil;
    
    [self.delegate finishedUploadingRequestWithData:@{keyImageURL: request.url}];
};
-(void)deleteLocalFile
{
    NSLog(@"\n\nFile URL:\t%@\n\n", currentUploadLocalPath.absoluteString);
    
    if (currentUploadLocalPath) {
        
        if ([self.fileMan fileExistsAtPath:currentUploadLocalPath.filePathURL.absoluteString]) {
            NSError *error;
            
            [self.fileMan removeItemAtPath:currentUploadLocalPath.filePathURL.absoluteString error:&error];
            
            if (error) {
                NSLog(@"\n\nError deleting file\n%@\n", error);
            }
            else
            {
                NSLog(@"\nSuccessfully deleted file at path %@\n", currentUploadLocalPath.absoluteString);
                currentUploadLocalPath = nil;
            }
        };
    }
}
-(void)uploadAudioFileWithUrl:(NSURL *)url andKey:(NSString *)uniqueKey
{
    
    if (self.fileUpload == nil || (self.fileUpload.isFinished && !self.fileUpload.isPaused)) {
    
        NSData* audioData = [NSData dataWithContentsOfURL:url];
        currentUploadLocalPath = url;
        
        NSString *audioFile = [NSString stringWithFormat:@"%@/%@/%@%@%@", @"forsythetony", @"audio", @"recording_", uniqueKey, @".m4a"];
        
        S3PutObjectRequest* req = [[S3PutObjectRequest alloc] initWithKey:audioFile inBucket:[updatedConstants transferManagerBucket]];
        req.data = audioData;
        req.contentType = @"audio/m4a";
        req.cannedACL = [S3CannedACL publicRead];
        
        _fileUpload = [_tm upload:req];
    }
}
-(void)dummyUpdateImageWithStory:(imageObject *)image andStory:(Story *)newStory
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dummyData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableArray *imageObjects = [NSMutableArray new];
    NSMutableArray *imagePackages = [NSMutableArray new];
    
    for (NSDictionary* dict in json) {
        
        imageObject *newImage = [self createImageObjectWithDictionary:dict];
        [imageObjects addObject:newImage];
    }
    
    for (imageObject* imageObj in imageObjects) {
        
        ImagePackage *package = [ImagePackage new];
        
        [package setContentsWithImageObject:imageObj];
        
        [imagePackages addObject:package];
        
    }
    
    NSInteger idOfPackage = 0;
    
    for (ImagePackage *pack in imagePackages) {
        
        if ([pack.imageID isEqualToString:image.id]) {
            
            idOfPackage = [imagePackages indexOfObject:pack];
            
            
        }
    }
    ImagePackage *packageTwo = [ImagePackage new];
    [packageTwo setContentsWithImageObject:image];
    NSMutableArray *thingsTwo = [NSMutableArray new];
    
    [imagePackages replaceObjectAtIndex:idOfPackage withObject:packageTwo];
    
    for (ImagePackage* package2 in imagePackages) {
        
        NSDictionary *newDict = [package2 createJSONReadyDict2];
        [thingsTwo addObject:newDict];
        
    }
    NSString *newFilePath = [[NSBundle mainBundle] pathForResource:@"dummy2" ofType:@"json"];

    NSError *error = nil;
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:newFilePath append:YES];
    [outputStream open];
    
    [NSJSONSerialization writeJSONObject:[NSArray arrayWithArray:thingsTwo]
                                toStream:outputStream
                                 options:0
                                   error:&error];
    [outputStream close];
    
}
-(void)addStoryToImage:(Story *)aStory imageObject:(imageObject *)theImage
{
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@?photo_id=%@",[updatedConstants api_babbage_baseURL], api_babbage_stories_endpoint, theImage.id];
    
    NSURL           *urlObject  = [NSURL URLWithString:urlString];
    
    
    
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:[aStory ConvertToUploadableDictionary] options:NSJSONWritingPrettyPrinted error:&err];
    
    
    NSMutableURLRequest *mutableReq = [[NSMutableURLRequest alloc] initWithURL:urlObject];

    mutableReq.HTTPBody = postData;
    mutableReq.HTTPMethod = @"POST";
    [mutableReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:mutableReq queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 201 || httpResponse.statusCode == 200) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([dict[@"status"] isEqualToString:@"success"]) {
                if ([self.delegate respondsToSelector:@selector(finishedAddingStoryWithNewId:)]) {
                    [self.delegate finishedAddingStoryWithNewId:dict[@"new_id"]];
                }
            }
        }
        
        
        
    }];
}
-(void)removeStoryFromImage:(imageObject *)theImage withStoryID:(NSString *)storyID
{
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@/%@%@%@", (USELOCALHOST ? api_localhostBaseURL : [updatedConstants api_ec2_baseURL]), api_photosEndpoint, theImage.id, APIDeleteStoryWithID, storyID];
    
    NSURL           *urlObject  = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *mutableReq = [[NSMutableURLRequest alloc] initWithURL:urlObject];
    
    mutableReq.HTTPMethod = @"GET";
    [mutableReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:mutableReq queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
        [self.delegate finishedDeletingStoryWithStatusCode:httpResponse.statusCode];
    }];
}

-(void)updatePhotoDateWithImagePackage:(ImagePackage *)photo
{
    NSDate *date = [photo dateTaken];

    NSString *urlString = [NSString stringWithFormat:@"%@?photo_id=%@&date_taken=%@",[NSString EC2PhotosEndpoint] ,photo.imageID, [date displayDateOfType:sDateTypeBabbageURL]];
    
    
    NSURL *urlObject = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:urlObject];
    
    req.HTTPMethod = @"PUT";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        
        [self.delegate finishedUpdatingPhotoDateWithStatusCode:httpResponse.statusCode];
        
    }];
    
    
}
-(void)updateBabbagePhotoDateWithImagePackage:(ImagePackage*)photo
{
    NSString *reqString = [updatedConstants getURLForBabbageUpdateWithID:photo.imageID andNewDate:[[photo dateTaken] displayDateOfType:sDateTypeBabbageURL]];
    
    NSURL *urlObject = [NSURL URLWithString:reqString];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:urlObject];
    
    req.HTTPMethod = @"GET";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        
        if (httpResponse.statusCode == 200) {
            
            [self.delegate finishedUpdatingPhotoDateWithStatusCode:httpResponse.statusCode];
        }
        
    }];

}
-(void)deleteStoryWithID:(NSString *)story_id
{
    NSString *reqString = [NSString stringWithFormat:@"%@%@?story_id=%@", [updatedConstants api_babbage_baseURL], api_babbage_stories_endpoint, story_id];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:reqString]];
    
    req.HTTPMethod = @"DELETE";
    
    [NSURLConnection sendAsynchronousRequest:req queue:self.dataOpQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        
        if (resp.statusCode == 200 || resp.statusCode == 201) {
            
            NSString *deletedID = [(NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"deleted_id"];
            
            if ([self.delegate respondsToSelector:@selector(finishedDeletingStoryWithID:didDelete:)]) {
                NSLog(@"\nDeleted ID: %@\n", deletedID);
                [self.delegate finishedDeletingStoryWithID:deletedID didDelete:YES];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(finishedDeletingStoryWithID:didDelete:)]) {
                [self.delegate finishedDeletingStoryWithID:nil didDelete:NO];
            }
        }
        
        
    }];
}
-(void)updateStory:(Story *)story withUpdatedValues:(NSString *)values
{
    NSString *reqString = [NSString stringWithFormat:@"%@%@?story_id=%@%@", [updatedConstants api_babbage_baseURL], api_babbage_stories_endpoint, story.stringId, values];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:reqString]];
    
    req.HTTPMethod = @"PUT";
    
    [NSURLConnection sendAsynchronousRequest:req queue:self.dataOpQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        
        if (resp.statusCode == 200 || resp.statusCode == 201) {
            [self.delegate didUpdateValuesForStory:story];
        }
        else
        {
            NSLog(@"\nOOPS\n");
        }
        
        
    }];
}
-(void)fetchAllCollections
{
    
    NSString *babbage_urlString = [NSString EC2CollectionsEndpoint];

    NSURL           *url        = [NSURL URLWithString:babbage_urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.HTTPMethod = @"GET";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 201 && data ) {
            
            [self parseCollectionsFromData:data];
        }
        
    }];
}
-(void)parseCollectionsFromData:(NSData*) t_data
{
    if (t_data) {
        
        NSError *error;
        
        NSArray *collections = [NSJSONSerialization JSONObjectWithData:t_data options:0 error:&error];
        
        if (!error) {
            
            NSMutableArray *coll_mut = [NSMutableArray new];
            
            for (NSDictionary *dict in collections) {
                
                TFImageCollection *coll = [TFImageCollection CollectionFromJSONDictionary:dict];
                [coll populateImages];
                [coll_mut addObject:coll];
            }
            
            if ([self.delegate respondsToSelector:@selector(finishedFetchingCollections:)]) {
                [self.delegate finishedFetchingCollections:[NSArray arrayWithArray:coll_mut]];
            }
        }
        
    }
}
-(void)fetchListOfCollectionImages
{
    NSString *babbage_urlString = [NSString stringWithFormat:@"%@%@", [updatedConstants api_babbage_baseURL], @"/collectionImages"];
    
    NSURL           *url        = [NSURL URLWithString:babbage_urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.HTTPMethod = @"GET";
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 201 && data ) {
            [self parseCollectionImageListFromData:data];
        }
        
    }];
}
-(void)parseCollectionImageListFromData:(NSData*) t_data
{
    if (t_data) {
        
        NSError *err;
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:t_data options:0 error:&err];
        NSMutableArray *mut_arr = [NSMutableArray new];
        
        for (NSDictionary *dict in arr) {
            TFCollectionImageListItem *listItem = [TFCollectionImageListItem CollectionImageListingWithDict:dict];
            
            [mut_arr addObject:listItem];
        }
        
        if ([self.delegate respondsToSelector:@selector(finishedFetchingListOfCollectionImages:)]) {
            [self.delegate finishedFetchingListOfCollectionImages:[NSArray arrayWithArray:mut_arr]];
        }
    }
}
@end
