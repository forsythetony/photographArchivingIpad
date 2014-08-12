//
//  UploadingButton.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/11/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "UploadingButton.h"

@interface UploadingButton () {
    
    NSInteger secondsPassed;
    NSTimer *uploadingTimer;
}

@end

@implementation UploadingButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)setup
{
    secondsPassed = 0;
    
}
-(void)startUploading
{
    secondsPassed = 0;

    //uploadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    [self setTitle:@"Uploading..." forState:UIControlStateDisabled];
    
    [self setEnabled:NO];
    
}
-(void)updateLabel
{
    NSString *suffixString;
    NSString *titleString;
    
    secondsPassed++;
    switch (secondsPassed) {
        case 1:
            suffixString = @".";
            break;
            
        case 2:
            suffixString = @"..";
            break;
            
        case 3:
            suffixString = @"...";
            secondsPassed = 0;
            break;
            
        default:
            break;
    }
    
    titleString = [NSString stringWithFormat:@"Uploading%@", suffixString];
    
    [self performSelectorOnMainThread:@selector(updateLabelMainThread:) withObject:titleString waitUntilDone:NO];
    

    
    
}
-(void)updateLabelMainThread:(NSString*) titleString
{
    self.titleLabel.text = titleString;
}
-(void)stopUploading
{

    [self setEnabled:YES];
}


@end
