//
//  TFCommunicator.m
//  PhotoArchiving
//
//  Created by Anthony Forsythe on 3/25/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TFDataCommunicator.h"

#import "constants.h"

@implementation TFDataCommunicator

-(void)getUserWithUsername:(NSString *)username
{
    
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@%@", APIADDRESS, @"/users/", username];
    
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
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@%@", APIADDRESS, @"/photos"];
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
    request.URL         = [NSURL URLWithString:@"http://localhost:3000/photos"];
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
    
    NSString        *urlString  = [NSString stringWithFormat:@"%@/photos?forUser=%@", APIADDRESS, username];
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
@end