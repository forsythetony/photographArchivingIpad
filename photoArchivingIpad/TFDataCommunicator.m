//
//  TFCommunicator.m
//  PhotoArchiving
//
//  Created by Anthony Forsythe on 3/25/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "TFDataCommunicator.h"

#define APIADDRESS @"http://localhost:3000"
@implementation TFDataCommunicator

-(void)getUserWithUsername:(NSString *)username
{
    
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@%@", APIADDRESS, @"/users/", username];
    
    NSString *urlString = [NSString stringWithString:apiEndpoint];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
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
    person.username = rootDictionary[@"username"];
    person.photoUrl = [rootDictionary[@"profilePhoto"] objectForKey:@"url"];
    person.firstName = rootDictionary[@"firstName"];
    person.lastName = rootDictionary[@"lastName"];
    [parsedPeople addObject:person];
    
    NSLog(@"%@", person.firstName);
    
    
    [self.delegate finishedParsingPeople:[NSArray arrayWithArray:parsedPeople]];
}
-(void)retrieveImageWithURL:(NSString *)url
{
    NSString *urlString = url;
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURL *urlObject = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:urlObject];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@", APIADDRESS, @"/photos"];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURL *urlObject = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:urlObject];
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
    NSString *imageDataString = [self createBase64EncodedStringFromImage:image ofType:type];
    
    NSLog(@"%@", imageDataString);
    NSDictionary *postData = @{@"title": [information objectForKey:@"title"],
                               @"imageData" : imageDataString,
                               @"uploadInformation" : @{@"user": [[information objectForKey:@"uploadInformation"] objectForKey:@"user"], @"uploadTime" : [[information objectForKey:@"uploadInformation"] objectForKey:@"uploadTime"]}};
    
    NSError *error;
    
    NSData *postDataData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:@"http://localhost:3000/photos"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postDataData];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSLog(@"\nThe response from the server was: %d", httpResponse.statusCode);
        
    }];
    
}
-(void)getPhotosForUser:(NSString *)username
{
    NSString *urlString = [NSString stringWithFormat:@"%@/photos?forUser=%@", APIADDRESS, username];
    
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
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
    
    NSArray *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
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
        default:
            return nil;
            break;
    }
    
    return [imageData base64EncodedStringWithOptions:0];
}
@end
