//
//  OWXWordSpellView.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXWordSpellView.h"

#import "OWXDragView.h"
#import "OWXEndView.h"
#import "OWXWordModel.h"
#import "OWXAudioManager.h"

const CGFloat kLetterMiddleMargin = 10;
const CGFloat kLetterMaxHeight = 80;

@interface OWXWordSpellView () <OWXDragViewDelegate>

@property (nonatomic, strong) NSMutableSet<OWXDragView *> *dragViewPool;
@property (nonatomic, strong) NSMutableArray<OWXDragView *> *dragViews;

@property (nonatomic, strong) NSMutableSet<OWXEndView *> *endViewPool;
@property (nonatomic, strong) NSMutableArray<OWXEndView *> *endViews;

@property (nonatomic, strong) NSMutableSet *jointLetters;

@property (nonatomic, strong) OWXWordModel *currentWordModel;

@end

@implementation OWXWordSpellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initWordSpellView];
    }
    return self;
}

- (void)initWordSpellView {
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor redColor].CGColor;

    self.dragViewPool = [[NSMutableSet alloc] init];
    self.dragViews = [[NSMutableArray alloc] init];
    
    self.endViewPool = [[NSMutableSet alloc] init];
    self.endViews = [[NSMutableArray alloc] init];
    
    self.jointLetters = [[NSMutableSet alloc] init];
    
}

- (void)setWordList:(NSArray<OWXWordModel *> *)wordList {
    
    _wordList = wordList;
    
    [self buildWordSpellSubViews:0];
}

- (void)buildWordSpellSubViews:(NSInteger)index {
    
    OWXWordModel *model = [self.wordList objectOrNilAtIndex:index];
    
    if (!model) {
        return;
    }
    
    if (self.spellIndex) {
        self.spellIndex(index);
    }
    
    self.currentWordModel = model;
    
    [self resetWordSpellView];
    
    NSArray *endFrames = [self addEndViewsWithWordModel:model];
    [self addDragViewsWithWordModel:model endFrames:endFrames];
    
}

- (void)resetWordSpellView {
    
    [self.dragViewPool addObjectsFromArray:self.dragViews];
    [self.dragViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.dragViews removeAllObjects];
    
    [self.endViewPool addObjectsFromArray:self.endViews];
    [self.endViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.endViews removeAllObjects];
    
    [self.jointLetters removeAllObjects];
    
    [[OWXDragManager manager] reset];
    
}

- (NSArray *)addEndViewsWithWordModel:(OWXWordModel *)model {
    
    NSArray *letterImages = [model.structs componentsSeparatedByString:@"|"];
    NSInteger letterCount = letterImages.count;
    NSMutableArray *endSizes = [NSMutableArray arrayWithCapacity:letterCount];
    
    CGFloat wordMaxWidth = self.width - kLetterMiddleMargin * letterCount;
    CGFloat lettersTotalWidth = 0;
    CGFloat letterScale = 1.0;
    CGFloat startOriginX = 0;
    
    for (int i = 0; i < letterCount; i++) {
        
        UIImage *letterImage = [UIImage imageNamed:[NSString stringWithFormat:@"s%@",letterImages[i]]];
        CGSize letterSize = letterImage.size;
        
        CGFloat scale = kLetterMaxHeight / letterSize.height;
        letterSize = CGSizeMake(letterSize.width * scale, kLetterMaxHeight);

        [endSizes addObject:OWXCGSizeValue(letterSize)];
        lettersTotalWidth += letterSize.width;
        
    }
    
    if (lettersTotalWidth > wordMaxWidth) {
        letterScale = wordMaxWidth / lettersTotalWidth;
    }
    else {
        startOriginX = (wordMaxWidth - lettersTotalWidth) * 0.5;
    }
    
    NSMutableArray *endFrames = [NSMutableArray arrayWithCapacity:letterCount];
    
    for (int i = 0; i < letterCount; i++) {
        
        CGSize letterSize = OWXCGSizeFromValue(endSizes[i]);
        
        CGRect endFrame = CGRectMake(startOriginX, 10, letterSize.width * letterScale, letterSize.height * letterScale);
        [endFrames addObject:OWXCGRectValue(endFrame)];
        
        OWXEndView *endView = [self dequeueReusableEndViewFrame:endFrame tagId:[letterImages[i] integerValue]];
        [self addSubview:endView];
        [self.endViews addObject:endView];
        
        startOriginX += endFrame.size.width + kLetterMiddleMargin;
        
    }
    
    return endFrames;
    
}

- (OWXEndView *)dequeueReusableEndViewFrame:(CGRect)frame tagId:(NSInteger)tagId {
    
    OWXEndView *endView = nil;
    if (self.endViewPool.count > 0) {
        endView = self.endViewPool.anyObject;
        endView.frame = frame;
        
        [self.endViewPool removeObject:endView];
    }
    else {
        endView = [[OWXEndView alloc] initWithFrame:frame];
    }
    
    endView.tagId = tagId;
    
    return endView;
    
}

- (void)addDragViewsWithWordModel:(OWXWordModel *)model endFrames:(NSArray *)endFrames {
    
    NSArray *letterImages = [model.structs componentsSeparatedByString:@"|"];
    NSInteger letterCount = letterImages.count;
    
    for (int i = 0; i < letterCount; i++) {
        
        NSString *letterId = letterImages[i];
        UIImage *letterImage = [UIImage imageNamed:[NSString stringWithFormat:@"s%@",letterId]];
        
        NSMutableArray *animationImages = [[NSMutableArray alloc] init];
        for (NSInteger index = 1; index <= 6; index++) {
            [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"p%@_%ld",letterId, index]]];
        }
        
        CGRect startFrame = OWXCGRectFromValue([endFrames objectAtIndex:i]);
        startFrame = CGRectMake(startFrame.origin.x, 150, startFrame.size.width, startFrame.size.height);
        OWXDragView *dragView = [self dequeueReusableDragViewWithImage:letterImage animationImages:animationImages startFrame:startFrame endFrames:endFrames tagId:[letterImages[i] integerValue]];
        [self addSubview:dragView];
        [self.dragViews addObject:dragView];
        
    }
    
    [self.dragViews shuffle];
    
    CGFloat startOriginX = OWXCGRectFromValue([endFrames objectAtIndex:0]).origin.x;
    for (NSInteger index = 0; index < self.dragViews.count; index++) {
        OWXDragView *dragView = [self.dragViews objectAtIndex:index];
        dragView.startFrame = CGRectMake(startOriginX, dragView.origin.y, dragView.width, dragView.height);
        
        startOriginX += dragView.width + kLetterMiddleMargin;
        
    }
    
}

- (OWXDragView *)dequeueReusableDragViewWithImage:(UIImage *)image animationImages:(NSArray *)animationImages startFrame:(CGRect)startFrame endFrames:(NSArray *)endFrames tagId:(NSInteger)tagId {
    
    OWXDragView *dragView = nil;
    if (self.dragViewPool.count > 0) {
        dragView = self.dragViewPool.anyObject;
        [dragView setImage:image animationImages:animationImages startFrame:startFrame endFrames:endFrames];
        [self.dragViewPool removeObject:dragView];
    }
    else {
        dragView = [[OWXDragView alloc] initWithImage:image animationImages:animationImages startFrame:startFrame endFrames:endFrames delegate:self];
    }
    
    dragView.tagId = tagId;
    
    return dragView;
    
}

- (BOOL)jointLettersCompleteWithDragView:(OWXDragView *)dragView {
    
    [self.jointLetters addObject:StringFromInteger(dragView.tagId)];
    
    NSMutableSet *letterTagIds = [[NSMutableSet alloc] initWithArray:[self.currentWordModel.structs componentsSeparatedByString:@"|"]];
    
    return [self.jointLetters isEqualToSet:letterTagIds];
    
}

#pragma mark - OWXDragViewDelegate

- (void)dragViewDidStartDragging:(OWXDragView *)dragView {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidStartDragging");
    
    [dragView startAnimating];
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"p%ld.mp3",dragView.tagId] ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:audioFile];
    [[OWXAudioManager share] cyclePlayStreamerWithAudioFile:url];
    
}

- (void)dragViewDidEndDragging:(OWXDragView *)dragView {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidEndDragging");
    
    [dragView stopAnimating];
    [[OWXAudioManager share] stopStreamer];
    
}

- (void)dragViewDidEnterStartFrame:(OWXDragView *)dragView {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidEnterStartFrame");
    
}

- (void)dragViewDidLeaveStartFrame:(OWXDragView *)dragView {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidLeaveStartFrame");
    
}

- (void)dragViewDidEnterEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidEnterEndFrame");
    
}

- (void)dragViewDidLeaveEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidLeaveEndFrame");
    
}

- (void)dragViewWillSwapToEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index {
    
    NSLog(@"OWXDragViewDelegate--dragViewWillSwapToEndFrame");
    
}

- (void)dragViewDidSwapToEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidSwapToEndFrame");
    
    if (index == NSNotFound) {
        return;
    }
    
    if ([self jointLettersCompleteWithDragView:dragView]) {
        
        NSString *audioFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"word_%ld.mp3",self.currentWordModel.wordid] ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:audioFile];
        
        __weak __typeof(self) weakSelf = self;
        [[OWXAudioManager share] playStreamerWithAudioFile:url complete:^{
            [weakSelf rebuildWordSpellView];
        }];
        
    }

}

- (void)rebuildWordSpellView {
    
    NSInteger currentWordIndex = [self.wordList indexOfObject:self.currentWordModel];
    if (self.wordList.count == currentWordIndex + 1) {
        [self buildWordSpellSubViews:0];
    }
    else {
        [self buildWordSpellSubViews:currentWordIndex + 1];
    }
}

- (void)dragViewWillSwapToStartFrame:(OWXDragView *)dragView {
    
    NSLog(@"OWXDragViewDelegate--dragViewWillSwapToStartFrame");
    
}

- (void)dragViewDidSwapToStartFrame:(OWXDragView *)dragView {
    
    NSLog(@"OWXDragViewDelegate--dragViewDidSwapToStartFrame");
    
}

- (BOOL)dragView:(OWXDragView *)dragView canAnimateToEndFrameWithIndex:(NSInteger)index {

    NSLog(@"OWXDragViewDelegate--canAnimateToEndFrameWithIndex");
    
    if (index == NSNotFound) {
        return NO;
    }
    
    OWXEndView *endView = self.endViews[index];
    
    BOOL canAnimateToEndFrame = endView.tagId == dragView.tagId;
    
    return canAnimateToEndFrame;
    
}

@end
