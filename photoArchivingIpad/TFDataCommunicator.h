//  This is just something that I need to comment later
//
//
//
//
#import <Foundation/Foundation.h>
#import "TFPerson.h"
#import <UIKit/UIKit.h>
#import "imageHandling.h"
#import "NSDate+timelineStuff.h"
#import "photoUploadingConstants.h"
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
#import "ImagePackage.h"

typedef NS_ENUM(NSUInteger, photoType) {
    
    tPNG,
    tJPG
    
};

typedef NS_ENUM(NSInteger, simpleResponseType) {
    simpleResponseTypeImageClean,
    simpleResponseTypeServerStatus
};

typedef NS_ENUM(NSInteger, serverResponseType) {
    serverResponseTypeOK,
    serverResponseTypeServerError
};
@class TFDataCommunicator;

@protocol TFCommunicatorDelegate <NSObject>

@optional

-(void)finishedParsingPeople:(NSArray*) people;
-(void)finishedPullingImageFromUrl:(UIImage*) image;
-(void)finishedPullingPhotoList:(NSArray*) list;
-(void)finishedServerCleanup:(NSDictionary*) results;
-(void)finishedUploadingRequestWithData:(NSDictionary*) data;
-(void)finishedUploadingPhotoInfoToServer;
-(void)finishedAddingStory;
-(void)finishedDeletingStoryWithStatusCode:(NSInteger) statusCode;

@end


@interface TFDataCommunicator : NSObject <AmazonServiceRequestDelegate>


@property (nonatomic, weak) id <TFCommunicatorDelegate> delegate;

-(void)setupTransferManager;

-(void)getUserWithUsername:(NSString*) username;
-(void)retrieveImageWithURL:(NSString*) url;
-(void)getPhotoListWithOptions:(NSDictionary*) options;
-(void)sendImageToServer:(UIImage *)image ofType:(photoType) type withInformation:(NSDictionary*) information;
-(void)getPhotosForUser:(NSString*) username;
-(void)getPhotosForTestUser;
-(void)cleanImages;
-(void)uploadSmallFile;
-(void)saveImageToCameraRoll;
-(void)uploadPhoto:(UIImage*) photo withInformation:(NSDictionary*) information;
-(void)uploadPhoto:(ImagePackage*) photo;
-(void)mainServerUploadPhoto:(ImagePackage *)photo;
-(void)deletePhoto:(imageObject*) photo;
-(void)updatePhoto:(ImagePackage*) photo;
-(void)uploadAudioFileWithUrl:(NSURL*) url andKey:(NSString*) uniqueKey;
-(void)getDummyData;
-(void)dummyUpdateImageWithStory:(imageObject*) image andStory:(Story*) newStory;
-(void)addStoryToImage:(Story*) aStory imageObject:(imageObject*) theImage;
-(void)removeStoryFromImage:(imageObject*) theImage withStoryID:(NSString*) storyID;


@end
