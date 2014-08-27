//
//  StoriesDisplayTableview.m
//  photoArchivingIpad
//
//  Created by Anthony Forsythe on 8/27/14.
//  Copyright (c) 2014 Tonyf. All rights reserved.
//

#import "StoriesDisplayTableview.h"
#import <Colours.h>


@implementation StoriesDisplayTableview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor charcoalColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.allowsMultipleSelectionDuringEditing = NO;
    }
    
    return self;
}
-(id)initWithFrame:(CGRect)frame andDelegate:(id)delegate andDatasource:(id)datasource
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.dataSource = datasource;
        self.delegate = delegate;
        
        
    }
    
    return self;
}


@end
