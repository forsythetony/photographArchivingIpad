//
//  TFCommunicator.m
//  PhotoArchiving
//
//  Created by Anthony Forsythe on 3/25/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TFDataCommunicator.h"

#import "updatedConstants.h"

@interface TFDataCommunicator ()

@property (strong, nonatomic) S3TransferOperation *fileUpload;

@property (strong, nonatomic) S3TransferManager *tm;

@property (strong, nonatomic) NSString *pathForFile;

@end


@implementation TFDataCommunicator

-(id)init
{
    self = [super init];
    
    if (self) {
        AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:S3_access_Key_ID withSecretKey:S3_secret_key];
        
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
        
        return self;
    
    }
    
    else
    {
        return nil;
    }
}
-(void)uploadSmallFile
{
    if(self.fileUpload == nil || (self.fileUpload.isFinished && !self.fileUpload.isPaused)){
        self.fileUpload = [self.tm uploadFile:self.pathForFile bucket: [updatedConstants transferManagerBucket] key: kKeyForSmallFile];
        
    }
}
-(void)getUserWithUsername:(NSString *)username
{
    
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@/%@", (USELOCALHOST ? api_localhostBaseURL : api_ec2BaseURL), api_usersEndpoint, username];
    
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
-(void)getPhotosForTestUser
{
    NSString        *urlString  = [NSString stringWithFormat:@"%@/%@?forUser=%@", (USELOCALHOST ? api_localhostBaseURL : api_ec2BaseURL), api_photosEndpoint, api_testUser];
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
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@", (USELOCALHOST ? api_localhostBaseURL : api_ec2BaseURL), api_photosEndpoint];
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
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@?%@=%@", (USELOCALHOST ? api_localhostBaseURL : api_ec2BaseURL), api_photosEndpoint, api_cleanFlagKey, api_cleanFlagValue];
    
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
    request.URL         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", (USELOCALHOST ? api_localhostBaseURL : api_ec2BaseURL), api_photosEndpoint]];
    request.HTTPBody    = postDataData;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSLog(@"\nThe response from the server was: %d", httpResponse.statusCode);
        
    }];
}

-(void)getPhotosForUser:(NSString *)username
{
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@?forUser=%@", (USELOCALHOST ? api_localhostBaseURL : api_ec2BaseURL), api_photosEndpoint, username];
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
    NSLog(@"didReceiveResponse called: %@", response);
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
@end
