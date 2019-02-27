//
//  TKDragView.m
//  Retail Incentive
//
//  Created by Mapedd on 11-05-14.
//  Copyright 2011 Tomasz Kuzma. All rights reserved.
//

#import "TKDragView.h"

#include <mach/mach_time.h>
#include <stdint.h>

#define SWAP_TO_START_DURATION .24f

#define SWAP_TO_END_DURATION   .24f

#define VELOCITY_PARAMETER 1000.0f

NSValue * TKCGRectValue(CGRect rect) {
    return [NSValue valueWithCGRect:rect];
}

CGRect TKCGRectFromValue(NSValue *value) {
    return [value CGRectValue];
}

CGPoint TKCGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGFloat TKDistanceBetweenFrames(CGRect rect1, CGRect rect2) {
    CGPoint p1 = TKCGRectCenter(rect1);
    CGPoint p2 = TKCGRectCenter(rect2);
    return sqrtf(powf(p1.x - p2.x, 2) + powf(p1.y - p2.y, 2));
}

typedef struct {
    
    unsigned int dragViewDidStartDragging;
    unsigned int dragViewDidEndDragging;
    
    unsigned int dragViewDidEnterStartFrame;
    unsigned int dragViewDidLeaveStartFrame;
    
    unsigned int dragViewDidEnterGoodFrame;
    unsigned int dragViewDidLeaveGoodFrame;
    
    unsigned int dragViewDidEnterBadFrame;
    unsigned int dragViewDidLeaveBadFrame;
    
    unsigned int dragViewWillSwapToEndFrame;
    unsigned int dragViewDidSwapToEndFrame;
    
    unsigned int dragViewWillSwapToStartFrame;
    unsigned int dragViewDidSwapToStartFrame;
    
    unsigned int dragViewCanAnimateToEndFrame;

} TKDelegateFlags;

@interface TKDragView ()

/**
 UIImageView instance already added to this view as a subview with autoresizing mask set to flexible width and height
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 Array to hold NSValues from CGRects with frames where drag view can be placed
 
 @seealso badFramesArray
 */
@property (nonatomic, strong) NSArray *goodFramesArray;

/**
 Array to hold NSValues from CGRects with frames where drag view cannot be placed
 
 @seealso goodFramesArray
 */
@property (nonatomic, strong) NSArray *badFramesArray;

/**
 initial frame, set on initialization
 */
@property (nonatomic, assign) CGRect startFrame;

/**
 is YES when user is dragging the view
 */
@property (nonatomic, assign) BOOL isDragging;

/**
 is YES when view is animating for example to one of the end frames or to start frame
 */
@property (nonatomic, assign) BOOL isAnimating;

/**
 is YES when view is hovering over one of the good start frames
 */
@property (nonatomic, assign) BOOL isOverStartFrame;

/**
 is YES when view is hovering over one of the good end frames
 */
@property (nonatomic, assign) BOOL isOverEndFrame;

/**
 is YES when view is hovering over one of the bad frames
 */
@property (nonatomic, assign) BOOL isOverBadFrame;

/**
 is YES when view placed on end frame (view have animated to end frame)
 */
@property (nonatomic, assign) BOOL isAtEndFrame;

/**
 is YES when view sits on start frame
 */
@property (nonatomic, assign) BOOL isAtStartFrame;

@property (nonatomic, assign) BOOL isAddedToManager;

@property (nonatomic, assign) NSInteger currentGoodFrameIndex;

@property (nonatomic, assign) NSInteger currentBadFrameIndex;

@property (nonatomic, assign) CGPoint startLocation;;

@property (nonatomic, assign) TKDelegateFlags delegateFlags;

@end

@implementation TKDragView

#pragma mark - Initializers

- (instancetype)initWithImage:(UIImage *)image startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame {

    return [self initWithImage:image
                    startFrame:startFrame
                    goodFrames:[NSArray arrayWithObject:[NSValue valueWithCGRect:endFrame]]
                     badFrames:nil
                      delegate:nil];
}

- (instancetype)initWithImage:(UIImage *)image startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame delegate:(id<TKDragViewDelegate>)delegate {
    return [self initWithImage:image
                    startFrame:startFrame
                    goodFrames:[NSArray arrayWithObject:[NSValue valueWithCGRect:endFrame]]
                     badFrames:nil
                      delegate:delegate];
}

- (instancetype)initWithImage:(UIImage *)image startFrame:(CGRect)startFrame goodFrames:(NSArray *)goodFrames badFrames:(NSArray *)badFrames delegate:(id<TKDragViewDelegate>)delegate {
    
    self = [super initWithFrame:startFrame];
    if(!self) {
        return nil;
    }
    
    self.goodFramesArray = goodFrames;
    self.badFramesArray = badFrames;
    self.startFrame = startFrame;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.image = image;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.imageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 2;
    panGesture.delaysTouchesEnded = NO;
    [self addGestureRecognizer:panGesture];
    
    self.opaque = NO;
    self.exclusiveTouch = NO;
    self.multipleTouchEnabled = NO;
    
    self.usedVelocity = kTKDragConstantTime;
    self.isDragging =       NO;
    self.isAnimating =      NO;
    self.isOverStartFrame = YES;
    self.isOverBadFrame =   NO;
    self.isOverEndFrame =   NO;
    self.isAtEndFrame =     NO;
    self.shouldStickToEndFrame = NO;
    self.isAtStartFrame =   YES;
    self.canDragFromEndPosition = YES;
    
    self.canUseSameEndFrameManyTimes = YES;
    self.canDragMultipleDragViewsAtOnce = YES;
    self.canSwapToStartPosition = YES;
    self.isAddedToManager = NO;
    
    self.currentBadFrameIndex = -1;
    self.currentGoodFrameIndex = -1;
    self.startLocation = CGPointZero;
    self.delegate = delegate;
    
    return self;
}

#pragma mark - Setters

- (void)setDelegate:(id<TKDragViewDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateFlags.dragViewDidStartDragging     = [delegate respondsToSelector:@selector(dragViewDidStartDragging:)];
        _delegateFlags.dragViewDidEndDragging       = [delegate respondsToSelector:@selector(dragViewDidEndDragging:)];
        
        _delegateFlags.dragViewDidEnterStartFrame   = [delegate respondsToSelector:@selector(dragViewDidEnterStartFrame:)];
        _delegateFlags.dragViewDidLeaveStartFrame   = [delegate respondsToSelector:@selector(dragViewDidLeaveStartFrame:)];
        
        _delegateFlags.dragViewDidEnterGoodFrame    = [delegate respondsToSelector:@selector(dragViewDidEnterGoodFrame:atIndex:)];
        _delegateFlags.dragViewDidLeaveGoodFrame    = [delegate respondsToSelector:@selector(dragViewDidLeaveGoodFrame:atIndex:)];
        
        _delegateFlags.dragViewDidEnterBadFrame     = [delegate respondsToSelector:@selector(dragViewDidEnterBadFrame:atIndex:)];
        _delegateFlags.dragViewDidLeaveBadFrame     = [delegate respondsToSelector:@selector(dragViewDidLeaveBadFrame:atIndex:)];
        
        _delegateFlags.dragViewWillSwapToEndFrame = [delegate respondsToSelector:@selector(dragViewWillSwapToEndFrame:atIndex:)];
        _delegateFlags.dragViewDidSwapToEndFrame    = [delegate respondsToSelector:@selector(dragViewDidSwapToEndFrame:atIndex:)];
        
        _delegateFlags.dragViewWillSwapToStartFrame = [delegate respondsToSelector:@selector(dragViewWillSwapToStartFrame:)];
        _delegateFlags.dragViewDidSwapToStartFrame  = [delegate respondsToSelector:@selector(dragViewDidSwapToStartFrame:)];
        
        _delegateFlags.dragViewCanAnimateToEndFrame = [delegate respondsToSelector:@selector(dragView:canAnimateToEndFrameWithIndex:)];
        
    }
    
}

- (void)setCanUseSameEndFrameManyTimes:(BOOL)canUseSameEndFrameManyTimes {
    
    _canUseSameEndFrameManyTimes = canUseSameEndFrameManyTimes;
    
    if (!canUseSameEndFrameManyTimes && !self.isAddedToManager) {
        [[TKDragManager manager] addDragView:self];
        self.isAddedToManager = YES;
    }
    else if(canUseSameEndFrameManyTimes){
        [[TKDragManager manager] removeDragView:self];
        self.isAddedToManager = NO;
    }
}

- (void)setCanDragMultipleDragViewsAtOnce:(BOOL)canDragMultipleDragViewsAtOnce {
    
    _canDragMultipleDragViewsAtOnce = canDragMultipleDragViewsAtOnce;
    
    if (canDragMultipleDragViewsAtOnce) {
        [[TKDragManager manager] dragViewDidEndDragging:self];
    }
}

#pragma mark - Gesture handling

- (void)panDetected:(UIPanGestureRecognizer*)gestureRecognizer{
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self panBegan:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self panMoved:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self panEnded:gestureRecognizer];
            break;
        default:
            break;
    }
}

- (void)panBegan:(UIPanGestureRecognizer*)gestureRecognizer{
    
    if (!self.canDragMultipleDragViewsAtOnce) {
        if (![[TKDragManager manager] dragViewCanStartDragging:self]) {
            return;
        }
    }
    
    
    
    if (self.isAtEndFrame && !self.canDragFromEndPosition) {
        return;
    }
    
	if (!self.isDragging && !self.isAnimating) {
        
        self.isDragging = YES;

        CGPoint pt = [gestureRecognizer locationInView:self];
    
        self.startLocation = pt;
    
        [[self superview] bringSubviewToFront:self];


        if (self.delegateFlags.dragViewDidStartDragging) {
            [self.delegate dragViewDidStartDragging:self];
        }

    }
}

- (void)panMoved:(UIPanGestureRecognizer*)gestureRecognizer{
    
    if(!self.isDragging)
        return;
    
        
    CGPoint pt = [gestureRecognizer locationInView:self];
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    [self setCenter:CGPointMake([self center].x + translation.x, [self center].y + translation.y)];
    [gestureRecognizer setTranslation:CGPointZero inView:[self superview]];
    
    // Is over start frame
    
    BOOL isOverStartFrame = [self didEnterStartFrameWithPoint:pt];
    
    if (!self.isOverStartFrame && isOverStartFrame) {
        
        if (self.delegateFlags.dragViewDidEnterStartFrame)
            [self.delegate dragViewDidEnterStartFrame:self];
        self.isOverStartFrame = YES;
    }
    else if(self.isOverStartFrame && !isOverStartFrame){
        
        if (self.delegateFlags.dragViewDidLeaveStartFrame)
            [self.delegate dragViewDidLeaveStartFrame:self];
        self.isOverStartFrame = NO;
    }
    
    
    
    // Is over good or bad frame?
    
    NSInteger goodFrameIndex = [self goodFrameIndexWithPoint:pt];
    NSInteger badFrameIndex = [self badFrameIndexWithPoint:pt];
    
    
    // Entered new good frame
    if (goodFrameIndex >= 0 && !self.isOverEndFrame) {
        
        if (self.delegateFlags.dragViewDidEnterGoodFrame) {
            [self.delegate dragViewDidEnterGoodFrame:self atIndex:goodFrameIndex];
        }
        
        self.currentGoodFrameIndex = goodFrameIndex;
        self.isOverEndFrame = YES;
    }
    
    
    // Did leave good frame
    if (self.isOverEndFrame && goodFrameIndex < 0) {
        
        if (self.delegateFlags.dragViewDidLeaveGoodFrame) {
            [self.delegate dragViewDidLeaveGoodFrame:self atIndex:self.currentGoodFrameIndex];
            
        }
        
        if(!self.canUseSameEndFrameManyTimes){
            CGRect goodFrame = TKCGRectFromValue([self.goodFramesArray objectAtIndex:self.currentGoodFrameIndex]);
            [[TKDragManager manager] dragView:self didLeaveEndFrame:goodFrame];
        }
        
        self.currentGoodFrameIndex = -1;
        self.isOverEndFrame = NO;
        self.isAtEndFrame = NO;
        
    }
    
    // Did switch from one good from to another
    
    if (self.isOverEndFrame && goodFrameIndex != self.currentGoodFrameIndex) {
        
        if (self.delegateFlags.dragViewDidLeaveGoodFrame) {
            [self.delegate dragViewDidLeaveGoodFrame:self atIndex:self.currentGoodFrameIndex];
            
        }
        
        if (!self.canUseSameEndFrameManyTimes && self.isAtEndFrame) {
            CGRect rect = TKCGRectFromValue([self.goodFramesArray objectAtIndex:self.currentGoodFrameIndex]);
            [[TKDragManager manager] dragView:self didLeaveEndFrame:rect];
        }
        
        if (self.delegateFlags.dragViewDidEnterGoodFrame) {
            [self.delegate dragViewDidEnterGoodFrame:self atIndex:goodFrameIndex];
        }
        
        self.currentGoodFrameIndex = goodFrameIndex;
        self.isAtEndFrame = NO;
    }
    
    
    // Is over bad frame
    
    if(badFrameIndex >= 0 && !self.isOverBadFrame) {
        
        if (self.delegateFlags.dragViewDidEnterBadFrame)
            [self.delegate dragViewDidEnterBadFrame:self atIndex:badFrameIndex];
        
        self.isOverBadFrame = YES;
        self.currentBadFrameIndex = badFrameIndex;
    }
    
    if (self.isOverBadFrame && badFrameIndex < 0) {
        if (self.delegateFlags.dragViewDidLeaveBadFrame)
            [self.delegate dragViewDidLeaveBadFrame:self atIndex:self.currentBadFrameIndex];
        
        self.isOverBadFrame = NO;
        self.currentBadFrameIndex = -1;
    }
    
    
    // Did switch bad frames
    if (self.isOverBadFrame && badFrameIndex != self.currentBadFrameIndex){
        if (self.delegateFlags.dragViewDidLeaveBadFrame)
            [self.delegate dragViewDidLeaveBadFrame:self atIndex:self.currentBadFrameIndex];
        
        if (self.delegateFlags.dragViewDidEnterBadFrame)
            [self.delegate dragViewDidEnterBadFrame:self atIndex:badFrameIndex];
        
        self.currentBadFrameIndex = badFrameIndex;

    }
    
}

- (void)panEnded:(UIPanGestureRecognizer*)gestureRecognizer{
    
    if (!self.isDragging)
        return;
    
    self.isDragging = NO;
    
    if(!self.canDragMultipleDragViewsAtOnce)
        [[TKDragManager manager] dragViewDidEndDragging:self];
    
    if (self.delegateFlags.dragViewDidEndDragging) {
        [self.delegate dragViewDidEndDragging:self];
    }

    if (self.delegateFlags.dragViewCanAnimateToEndFrame){
        if (![self.delegate dragView:self canAnimateToEndFrameWithIndex:self.currentGoodFrameIndex]){
            [self swapToStartPosition];
            return;
        }
    }
    
    if (self.isOverBadFrame) {
        if (self.delegateFlags.dragViewDidLeaveBadFrame)
            [self.delegate dragViewDidLeaveBadFrame:self atIndex:self.currentBadFrameIndex];
    }
    
    
    if (self.isAtEndFrame && !self.shouldStickToEndFrame) {
        if(!self.canUseSameEndFrameManyTimes) {
            CGRect goodFrame = TKCGRectFromValue([self.goodFramesArray objectAtIndex:self.currentGoodFrameIndex]);
            [[TKDragManager manager] dragView:self didLeaveEndFrame:goodFrame];
        }
        
        if(self.delegateFlags.dragViewDidLeaveGoodFrame)
            [self.delegate dragViewDidLeaveGoodFrame:self atIndex:self.currentGoodFrameIndex];
        
        [self swapToStartPosition];
    }
    else{
        if (self.isOverStartFrame && self.canSwapToStartPosition) {
            [self swapToStartPosition];
        }
        else{
            
            
            if (self.currentGoodFrameIndex >= 0) {
                [self swapToEndPositionAtIndex:self.currentGoodFrameIndex];
            }
            else{
                if (self.isOverEndFrame && !self.canUseSameEndFrameManyTimes) {
                    CGRect goodFrame = TKCGRectFromValue([self.goodFramesArray objectAtIndex:self.currentGoodFrameIndex]);
                    [[TKDragManager manager] dragView:self didLeaveEndFrame:goodFrame];
                }
                
                [self swapToStartPosition];
            }
        }
    }

    self.startLocation = CGPointZero;
    
   
}

#pragma mark - Private

- (BOOL)didEnterGoodFrameWithPoint:(CGPoint)point {
    
    if ([self goodFrameIndexWithPoint:point] >= 0) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)didEnterBadFrameWithPoint:(CGPoint)point {
    
    if ([self badFrameIndexWithPoint:point] >= 0) {
        return YES;
    }
    else{
        return NO;
    }

}
    
- (BOOL)didEnterStartFrameWithPoint:(CGPoint)point {
    
    CGPoint touchInSuperview = [self convertPoint:point toView:[self superview]];
    
    return CGRectContainsPoint(self.startFrame, touchInSuperview);
}

- (NSInteger)badFrameIndexWithPoint:(CGPoint)point{
    
    CGPoint touchInSuperview = [self convertPoint:point toView:[self superview]];
    
    NSInteger index = -1;
    
    
    
    for (int i=0;i<[self.badFramesArray count];i++) {
        CGRect badFrame = [[self.badFramesArray objectAtIndex:i] CGRectValue];
            if (CGRectContainsPoint(badFrame, touchInSuperview))
               index = i;
    }
    
    
    return index;
}

- (NSInteger)goodFrameIndexWithPoint:(CGPoint)point{
    
    CGPoint touchInSuperview = [self convertPoint:point toView:[self superview]];
    
    NSInteger index = -1;
    
    for (int i=0;i<[self.goodFramesArray count];i++) {
        CGRect goodFrame = [[self.goodFramesArray objectAtIndex:i] CGRectValue];
        if (CGRectContainsPoint(goodFrame, touchInSuperview))
            index = i;
    }

    return index;
}

- (NSTimeInterval)swapToStartAnimationDuration{
    if (self.usedVelocity == kTKDragConstantTime) {
        return SWAP_TO_START_DURATION;
    }
    else{
        // kTKDragConstantVelocity
        return TKDistanceBetweenFrames(self.frame, self.startFrame)/VELOCITY_PARAMETER;
    }
        
}

- (NSTimeInterval)swapToEndAnimationDurationWithFrame:(CGRect)endFrame{
    if (self.usedVelocity == kTKDragConstantTime) {
        return SWAP_TO_END_DURATION;
    }
    else{
        // kTKDragConstantVelocity
        return TKDistanceBetweenFrames(self.frame, endFrame)/VELOCITY_PARAMETER;
    }
}

#pragma mark - Public

- (void)swapToStartPosition{
    
    self.isAnimating = YES;
    
    if (self.delegateFlags.dragViewWillSwapToStartFrame)
        [self.delegate dragViewWillSwapToStartFrame:self];
    
    
    
    [UIView animateWithDuration:[self swapToStartAnimationDuration]
                          delay:0. 
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        self.frame = self.startFrame; 
                     } 
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (self.delegateFlags.dragViewDidSwapToStartFrame)
                                 [self.delegate dragViewDidSwapToStartFrame:self];
                             
                             self.isAnimating = NO;
                             self.isAtStartFrame = YES;
                             self.isAtEndFrame = NO;
                         }
                     }];
    
    
}

- (void)swapToEndPositionAtIndex:(NSInteger)index{
    
    if (![self.goodFramesArray count]) return;
    
    CGRect endFrame = [[self.goodFramesArray objectAtIndex:index] CGRectValue];
    
    
    if (!self.isAtEndFrame) {
        if (!self.canUseSameEndFrameManyTimes) {
            
            if(![[TKDragManager manager] dragView:self wantSwapToEndFrame:endFrame]){
                if(self.delegateFlags.dragViewDidLeaveGoodFrame){
                    [self.delegate dragViewDidLeaveGoodFrame:self atIndex:index];
                }
                return;
            }
        }
    }
    
    self.isAnimating = YES;
    
    if (self.delegateFlags.dragViewWillSwapToEndFrame)
        [self.delegate dragViewWillSwapToEndFrame:self atIndex:index];
    
    [UIView animateWithDuration:[self swapToEndAnimationDurationWithFrame:endFrame]
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = endFrame;
                     } 
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (self.delegateFlags.dragViewDidSwapToEndFrame)
                                 [self.delegate dragViewDidSwapToEndFrame:self atIndex:index];
                             
                             self.isAnimating = NO;
                             self.isAtEndFrame = YES;
                             self.isAtStartFrame = NO;
                             
                         }
                     }];
}


@end

#pragma mark - TKDragManager

@interface TKDragManager ()

@property (nonatomic, strong) NSMutableArray *managerArray;

@property (nonatomic, unsafe_unretained) TKDragView *currentDragView;

@end


@implementation TKDragManager

@synthesize currentDragView = currentDragView_;

@synthesize managerArray = managerArray_;

static TKDragManager *manager; // it's a singleton, but how to relase it under ARC?

+ (TKDragManager *)manager{
    if (!manager) {
        manager = [[TKDragManager alloc] init];
    }
    
    return manager;
}

- (id)init{
    self = [super init];
    
    if(!self) return nil;
    
    self.managerArray = [NSMutableArray arrayWithCapacity:0];
    self.currentDragView = nil;
    
    
    return self;
}

- (void)addDragView:(TKDragView *)dragView{
    
    NSMutableArray *framesToAdd = [NSMutableArray arrayWithCapacity:0];
    
    
    
    if ([self.managerArray count]) {
        
            for (NSValue *dragViewValue in dragView.goodFramesArray) {
                CGRect dragViewRect = TKCGRectFromValue(dragViewValue);
                BOOL isInTheArray = NO;

                for (TKOccupancyIndicator *ind in self.managerArray) {
                    
                    CGRect managerRect = ind.frame;
                    
                    if (CGRectEqualToRect(managerRect, dragViewRect)) {
                        ind.count++;
                        isInTheArray = YES;
                        break;
                    }
                }            
                
                if (!isInTheArray) {
                    [framesToAdd addObject:dragViewValue];
                }
                
            }  

    }
    else{
        [framesToAdd addObjectsFromArray:dragView.goodFramesArray];
    }
    
    
    for (int i = 0;i < [framesToAdd count]; i++) {
        
        CGRect frame = TKCGRectFromValue([framesToAdd objectAtIndex:i]);
        
        TKOccupancyIndicator *ind = [TKOccupancyIndicator indicatorWithFrame:frame];
        
        [self.managerArray addObject:ind];
    }
    
    
}

- (void)removeDragView:(TKDragView *)dragView{
    NSMutableArray *arrayToRemove = [NSMutableArray arrayWithCapacity:0];
    
    for (TKOccupancyIndicator *ind in self.managerArray) {
        
        CGRect rect = ind.frame;
        
        for (NSValue *value in dragView.goodFramesArray) {
            
            CGRect endFrame = TKCGRectFromValue(value);
            
            if (CGRectEqualToRect(rect, endFrame)) {
                ind.count--;
                
                if (ind.count == 0) {
                    [arrayToRemove addObject:ind];
                }
            }
            
        }
        
    }
    
    [self.managerArray removeObjectsInArray:arrayToRemove];
    
}

- (BOOL)dragView:(TKDragView*)dragView wantSwapToEndFrame:(CGRect)endFrame{
    
    
    for (TKOccupancyIndicator *ind in self.managerArray) {
        
        CGRect frame = ind.frame;
        
        BOOL isTaken = !ind.isFree;
                    
        if (CGRectEqualToRect(endFrame, frame)) {
            if (isTaken) {
                [dragView swapToStartPosition];
                return NO;
            }
            else{
                ind.isFree = NO;
                return YES;
            }
        }
    }
    
    return YES;
}

- (void)dragView:(TKDragView *)dragView didLeaveEndFrame:(CGRect)endFrame{
    for (TKOccupancyIndicator *ind in self.managerArray) {
        CGRect frame = ind.frame;
        
        if (CGRectEqualToRect(frame, endFrame) && dragView.isAtEndFrame) {
            ind.isFree = YES;
        }
    }
}

- (BOOL)dragViewCanStartDragging:(TKDragView*)dragView{
    if (!self.currentDragView) {
        self.currentDragView = dragView;
        return YES;
    }
    else{
        return NO;
    }
}

- (void)dragViewDidEndDragging:(TKDragView *)dragView{
    if (self.currentDragView == dragView)
        self.currentDragView = nil;
}

@end

#pragma mark - TKOccupancyIndicator

@implementation TKOccupancyIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super init];
    if(self) {
        self.frame = frame;
        self.isFree = YES;
        self.count = 1;
    }
    return self;
    
}

+ (TKOccupancyIndicator *)indicatorWithFrame:(CGRect)frame {
    return [[TKOccupancyIndicator alloc] initWithFrame:frame];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TKOccupancyIndicator: frame: %@, count: %ld, isFree: %@",
            NSStringFromCGRect(self.frame), self.count, self.isFree ? @"YES" : @"NO"];
}

@end













