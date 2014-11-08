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
#import "updatedConstants.h"

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
-(void)finishedAddingStoryWithHTTPResponseCode:(NSInteger) responseCode;
-(void)finishedDeletingStoryWithStatusCode:(NSInteger) statusCode;

@end


@interface TFDataCommunicator : NSObject


//
//  PROPERTIES
//


@property (nonatomic, weak) id <TFCommunicatorDelegate> delegate;



//
//  METHODS
//


//
//  S3
//
-(void)setupTransferManager;

//
//  Photos
//
-(void)retrieveImageWithURL:(NSString*) url;
-(void)getPhotoListWithOptions:(NSDictionary*) options;
-(void)sendImageToServer:(UIImage *)image ofType:(photoType) type withInformation:(NSDictionary*) information;
-(void)getPhotosForUser:(NSString*) username;
-(void)getPhotosForTestUser;
-(void)cleanImages;
-(void)saveImageToCameraRoll;
-(void)uploadPhoto:(ImagePackage*) photo;
-(void)mainServerUploadPhoto:(ImagePackage *)photo;
-(void)deletePhoto:(imageObject*) photo;
-(void)updatePhoto:(ImagePackage*) photo;


//
//  Audio
//
-(void)uploadAudioFileWithUrl:(NSURL*) url andKey:(NSString*) uniqueKey;

//
//  Stories
//
-(void)dummyUpdateImageWithStory:(imageObject*) image andStory:(Story*) newStory;
-(void)addStoryToImage:(Story*) aStory imageObject:(imageObject*) theImage;
-(void)removeStoryFromImage:(imageObject*) theImage withStoryID:(NSString*) storyID;


//
//  Users
//
-(void)getUserWithUsername:(NSString*) username;


//
//  Misc.
//
-(void)uploadSmallFile;
-(void)getDummyData;


@end
