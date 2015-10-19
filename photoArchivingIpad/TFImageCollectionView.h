//
//  TFImageCollectionView.h
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/23/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFImageCollection.h"

@interface TFImageCollectionView : UIView <TFImageCollectionDelegate>

@property (nonatomic, strong) TFImageCollection *collection;

-(id)initWithImageCollection:(TFImageCollection*) t_collection;
-(void)addImageObject:(imageObject*) t_image;
-(void)TFAddImageViewForImageObject:(imageObject*) t_image;

-(void)changeColor;

@end
