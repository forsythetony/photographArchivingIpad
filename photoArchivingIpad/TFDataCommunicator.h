//  This is just something that I need to comment later
//
//
//
//
#import <Foundation/Foundation.h>
#import "TFPerson.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, photoType) {
    tPNG,
    tJPG
};

@class TFDataCommunicator;

@protocol TFCommunicatorDelegate <NSObject>

@optional

-(void)finishedParsingPeople:(NSArray*) people;
-(void)finishedPullingImageFromUrl:(UIImage*) image;
-(void)finishedPullingPhotoList:(NSArray*) list;


@end

@interface TFDataCommunicator : NSObject

@property (nonatomic, weak) id <TFCommunicatorDelegate> delegate;

-(void)getUserWithUsername:(NSString*) username;
-(void)retrieveImageWithURL:(NSString*) url;
-(void)getPhotoListWithOptions:(NSDictionary*) options;
-(void)sendImageToServer:(UIImage *)image ofType:(photoType) type withInformation:(NSDictionary*) information;
-(void)getPhotosForUser:(NSString*) username;

@end
