//
//  TFPopOverBasicView.m
//  photoArchivingIpad
//
//  Created by Tony Forsythe on 7/7/15.
//  Copyright (c) 2015 Tonyf. All rights reserved.
//

#import "TFPopOverBasicView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "Story.h"
#import "TFPopOverStoriesCell.h"
#import "TFAudioManager.h"
#import "TFChromecastManager.h"
#import "Image Display/ImageDisplayRecordingSliderView.h"
#import "TFDataCommunicator.h"
#import "NSString+Helpers.h"
#import "TFVisualConstants.h"
#import "Story+Converters.h"
#import <pop/POP.h>

NSString* const TFPOPOVERBASICVIEW_CELL_REUSE_ID = @"cell";
@interface TFPopOverBasicView () <TFPopOverStoriesCellDelegate, UITableViewDataSource, UITableViewDelegate, imageObjectDelegate, TFAudioManagerDelegate, ImageDisplayRecordingSliderViewDelegate, TFCommunicatorDelegate>
{
    CGRect  frame_mainImageView,
            frame_title,
            frame_stories,
            frame_recordingButton;
    
    
    UIImageView *imgView_main, *imgView_background;
    
    UITableView *stories_tableview;
    
    NSIndexPath *playPath;
    
    ImageDisplayRecordingSliderView *sliderView;
    
    RecordingDuration *duration;
    
    
    
}

@property (nonatomic, strong) NSArray   *stories;
@property (nonatomic, strong) TFAudioManager *audioMan;
@property (nonatomic, strong) TFChromecastManager *chromeMan;
@property (nonatomic, strong) TFDataCommunicator *dataCom;

@end

@implementation TFPopOverBasicView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        
        [self setupViews];
    }
    
    return self;
}
-(void)setupFrames
{
    CGRect mainFrame = self.frame;
    
    frame_mainImageView = CGRectZero;
    frame_mainImageView.size = CGSizeMake(mainFrame.size.width, mainFrame.size.width);
    
    
    frame_stories = CGRectZero;
    
    frame_stories.size.width = frame_mainImageView.size.width;
    frame_stories.size.height = mainFrame.size.height - frame_mainImageView.size.height;
    
    
    frame_recordingButton = CGRectZero;
    frame_recordingButton.size.width = frame_stories.size.width;
    frame_recordingButton.size.height = 75.0;
    
}
-(void)setImg:(imageObject *)img
{
    [imgView_main sd_setImageWithURL:img.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        
        ani.fromValue = [NSValue valueWithCGSize:CGSizeZero];
        
        ani.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        
        
        POPSpringAnimation *alphaAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        
        alphaAni.toValue = @(1.0);
        
        [imgView_main pop_addAnimation:alphaAni forKey:@"alphaAni"];
        [imgView_main.layer pop_addAnimation:ani forKey:@"scaleAni"];
    }];
        
    [imgView_background sd_setImageWithURL:img.thumbNailURL placeholderImage:[UIImage imageNamed:@"garden.JPG"]];
    
    img.delegate = self;
    [img populateStories];
    
    [self.chromeMan sendImage:img];
    
    _img = img;
    
    NSLog(@"\nImage id: %@\n", img.id);
}
-(void)hideThings
{
    stories_tableview.alpha = 0.0;
    sliderView.alpha = 0.0;
    
    POPSpringAnimation *fromRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    
    fromRight.fromValue = @(0.0);
    fromRight.toValue = @(100.0);
    
    [fromRight setCompletionBlock:^(POPAnimation *ani, BOOL y) {
        [self animateThings];
    }];
    [stories_tableview.layer pop_addAnimation:fromRight forKey:@"fromRightTable"];
    [sliderView.layer pop_addAnimation:fromRight forKey:@"fromRightSlider"];
}
-(void)animateThings
{
    
    POPSpringAnimation *alphaAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    alphaAni.toValue = @(1.0);
    
    
    
    POPSpringAnimation *fromRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    
    fromRight.fromValue = @(200.0);
    fromRight.toValue = @(0.0);
    
    [stories_tableview pop_addAnimation:alphaAni forKey:@"alphaUpAniTable"];
    [sliderView pop_addAnimation:alphaAni forKey:@"alphaUpAniSlider"];
    [stories_tableview.layer pop_addAnimation:fromRight forKey:@"fromRightTable"];
    [sliderView.layer pop_addAnimation:fromRight forKey:@"fromRightSlider"];
    
    
    
}
-(void)setupViews
{
    [self setupFrames];
    
    
    //self.backgroundColor = [UIColor TFPaperTextureOne];
    
    imgView_background = [[UIImageView alloc] initWithFrame:self.frame];
    imgView_background.contentMode = UIViewContentModeScaleToFill;
    
    
    [self addSubview:imgView_background];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *ev = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    ev.frame = self.bounds;
    
    [self addSubview:ev];
    
    
    
    imgView_main = [[UIImageView alloc] initWithFrame:frame_mainImageView];
    imgView_main.contentMode = UIViewContentModeScaleAspectFit;
    imgView_main.alpha = 0.0;
    [imgView_main setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageDoubleTap:)];
    
    tapper.numberOfTapsRequired = 2;
    
    [imgView_main addGestureRecognizer:tapper];
    
    [ev.contentView addSubview:imgView_main];
    
    UISwipeGestureRecognizer *gest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    
    [imgView_main setUserInteractionEnabled:YES];
    [imgView_main addGestureRecognizer:gest];
    
    
    //  Setup Stories Table View
    
    stories_tableview = [[UITableView alloc] initWithFrame:frame_stories style:UITableViewStylePlain];
    stories_tableview.dataSource = self;
    stories_tableview.delegate = self;
    stories_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    stories_tableview.allowsMultipleSelectionDuringEditing = NO;

    [stories_tableview registerNib:[UINib nibWithNibName:@"TFPopOverStoriesCell" bundle:nil] forCellReuseIdentifier:TFPOPOVERBASICVIEW_CELL_REUSE_ID];
    
    stories_tableview.backgroundColor = [UIColor clearColor];
    
    
    
    [ev.contentView addSubview:stories_tableview];
    
    
    //  Setup Recording Button
    
    sliderView = [[ImageDisplayRecordingSliderView alloc] initWithFrame:frame_recordingButton];
    sliderView.delegate = self;
    [ev.contentView addSubview:sliderView];
    
    
    //  Add Constraints
    
    [imgView_background mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topPad = 0.0;
        CGFloat bottomPad = 0.0;
        CGFloat leftPad = 0.0;
        CGFloat rightPad = 0.0;
        
        make.top.equalTo(self).with.offset(topPad);
        make.bottom.equalTo(self).with.offset(-bottomPad);
        make.left.equalTo(self).with.offset(leftPad);
        make.right.equalTo(self).with.offset(-rightPad);
    }];
    
    [imgView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(frame_mainImageView.size.height);
    }];
    
    [stories_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat padding_horiz = 10.0;
        CGFloat padding_top = 10.0;
        
        make.top.equalTo(imgView_main.mas_bottom).with.offset(padding_top);
        make.left.equalTo(self).with.offset(padding_horiz);
        make.right.equalTo(self).with.offset(-padding_horiz);
        make.height.mas_equalTo(300.0);
    }];
    
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView_main);
        make.right.equalTo(imgView_main);
        make.top.equalTo(stories_tableview.mas_bottom).with.offset(5.0);
        make.height.mas_equalTo(frame_recordingButton.size.height);
    }];
    
}

#pragma mark - Action Handlers
-(void)handleImageDoubleTap:(UITapGestureRecognizer*) t_gest
{
    if ([self.delegate respondsToSelector:@selector(didDoubleTapImage:)]) {
        [self.delegate didDoubleTapImage:self];
    }
}
-(void)handleRightSwipe:(UISwipeGestureRecognizer*) t_gest
{
    if ([self.delegate respondsToSelector:@selector(shouldHidePanel:)]) {
        [self.delegate shouldHidePanel:self];
    }
}
#pragma mark - Stories Table View

#pragma mark Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFPopOverStoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:TFPOPOVERBASICVIEW_CELL_REUSE_ID forIndexPath:indexPath];
    
    Story *story = [self.stories objectAtIndex:indexPath.row];
    
    
    if (cell) {
        
        cell.value_storyteller.text = story.storyTeller;
        
        cell.title_text_field.text = story.title;
        cell.duration = story.recordingLength;
        cell.value_date_uploaded.text = story.dateUploadedString;
        cell.delegate = self;
    }
    
    
    return cell;
}
#pragma mark - Delegate Methods

#pragma mark Stories Table View
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TFPopOverStoriesCell defaultSize].height;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.img deleteStoryAtIndex:indexPath.row];
    }
}
#pragma mark DataCommunicator
-(void)didFinishPopulatingStories:(id)imgObject
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [stories_tableview reloadData];
    });
    
}

#pragma mark Cells
-(void)didClickPlayButton:(TFPopOverStoriesCell *)t_cell
{
    NSIndexPath *path = [stories_tableview indexPathForCell:t_cell];
    
    if (path) {
        playPath = path;
        
        Story *story = [self.stories objectAtIndex:path.row];
        
        [self.audioMan playAudioFromStory:story image:self.img];
    }
}
-(void)didClickPauseButton:(TFPopOverStoriesCell *)t_cell
{
    [self.audioMan pauseAudio];
}

#pragma mark Audio Manager
-(void)didBeginPlayingAudio
{
    if (playPath) {
        
        TFPopOverStoriesCell *cell = (TFPopOverStoriesCell*)[stories_tableview cellForRowAtIndexPath:playPath];
        
        
        if (cell) {
            
            [cell beginPlaying];
        }
    }
}
-(void)didPauseAudio
{
    if (playPath) {
        TFPopOverStoriesCell *cell = (TFPopOverStoriesCell*)[stories_tableview cellForRowAtIndexPath:playPath];
        
        
        if (cell) {
            
            [cell pausePlaying];
        }
    }
}
-(void)didFinishRecordingWithUrl:(NSURL *)t_url
{
    self.dataCom.delegate = self;
    [self.dataCom uploadAudioFileWithUrl:t_url andKey:[NSString randomString]];
}

#pragma mark - Data Com
-(void)finishedUploadingRequestWithData:(NSDictionary *)data
{
    NSURL *url = data[keyImageURL];
    
    Story *newStory = [self createStoryWithURL:url];
    
    [self.img addStory:newStory];
}
#pragma mark Recording Slider
-(void)didSlideToRecordLock
{
    [self.audioMan beginRecording];
}
-(void)didUnlockSliderWithRecordingTime:(RecordingDuration *)recDuration
{
    duration = recDuration;
    [self.audioMan stopRecording];
}

#pragma mar - Image Object
-(void)didFinishAddingStoryWithSuccess:(BOOL)t_success
{
    if (t_success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [stories_tableview reloadData];
            self.dataCom.delegate = self;
        });
    }
    else
    {
        
    }
}
-(void)didFinishDeletingStoryAtIndex:(NSInteger)t_index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [stories_tableview beginUpdates];
        
        [self.img localDeleteStoryAtIndex:t_index];
        
        NSIndexPath *deletePath = [NSIndexPath indexPathForRow:t_index inSection:0];
        
        [stories_tableview deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationFade];
        
        [stories_tableview endUpdates];
    });
    
}
-(void)shouldUpdateStories
{
    [stories_tableview reloadData];
}
-(Story*)createStoryWithURL:(NSURL*) t_url
{
    Story *newStory = [[Story alloc] init];
    
    newStory.title = @"";
    newStory.recordingS3Url = t_url;
    newStory.recordingLength = @(duration->seconds);
    newStory.uploader = @"forsythetony";
    newStory.dateUploaded = [NSDate new];
    return newStory;
}
#pragma mark - Getters/ Setters
-(TFAudioManager *)audioMan
{
    if (!_audioMan) {
        _audioMan = [TFAudioManager sharedManager];
        _audioMan.delegate = self;
    }
    
    return _audioMan;
}
-(NSArray *)stories
{
    if (!_img) {
        _stories = [NSArray new];
    }
    else
    {
        _stories = _img.stories;
    }
    
    return _stories;
}
-(TFChromecastManager *)chromeMan
{
    if (!_chromeMan) {
        _chromeMan = [TFChromecastManager sharedManager];
    }
    
    return _chromeMan;
}
-(TFDataCommunicator *)dataCom{
    if (!_dataCom) {
        _dataCom = [TFDataCommunicator sharedCommunicator];
        _dataCom.delegate = self;
    }
    
    return _dataCom;
}
-(void)didUpdateText:(TFPopOverStoriesCell *)t_cell
{
    NSIndexPath *path = [stories_tableview indexPathForCell:t_cell];
    
    if (path) {
        Story *story = self.img.stories[path.row];
        
        if (story) {
            [story updateToNewTitle:t_cell.title_text_field.text];
            [story persistUpdates];
        }
    }
}
-(void)didUpdateStoryteller:(TFPopOverStoriesCell *)t_cell
{
    NSIndexPath *path = [stories_tableview indexPathForCell:t_cell];
    
    if (path) {
        Story *story = self.img.stories[path.row];
        
        if (story) {
            [story updateToNewStoryTeller:t_cell.value_storyteller.text];
            [story persistUpdates];
        }
    }
}
@end
