//
//  OWXDragView.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXDragView.h"

#include <mach/mach_time.h>
#include <stdint.h>

#define SWAP_TO_START_DURATION .24f

#define SWAP_TO_END_DURATION   .24f

#define VELOCITY_PARAMETER 1000.0f

NSValue * OWXCGSizeValue(CGSize size) {
    return [NSValue valueWithCGSize:size];
}

CGSize OWXCGSizeFromValue(NSValue *value) {
    return [value CGSizeValue];
}

NSValue * OWXCGRectValue(CGRect rect) {
    return [NSValue valueWithCGRect:rect];
}

CGRect OWXCGRectFromValue(NSValue *value) {
    return [value CGRectValue];
}

CGPoint OWXCGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGFloat OWXDistanceBetweenFrames(CGRect rect1, CGRect rect2) {
    CGPoint p1 = OWXCGRectCenter(rect1);
    CGPoint p2 = OWXCGRectCenter(rect2);
    return sqrtf(powf(p1.x - p2.x, 2) + powf(p1.y - p2.y, 2));
}

typedef struct {
    
    unsigned int dragViewDidStartDragging;
    unsigned int dragViewDidEndDragging;
    
    unsigned int dragViewDidEnterStartFrame;
    unsigned int dragViewDidLeaveStartFrame;
    
    unsigned int dragViewDidEnterEndFrame;
    unsigned int dragViewDidLeaveEndFrame;
    
    unsigned int dragViewWillSwapToEndFrame;
    unsigned int dragViewDidSwapToEndFrame;
    
    unsigned int dragViewWillSwapToStartFrame;
    unsigned int dragViewDidSwapToStartFrame;
    
    unsigned int dragViewCanAnimateToEndFrame;
    
} OWXDelegateFlags;

@interface OWXDragView ()

/**
 UIImageView instance already added to this view as a subview with autoresizing mask set to flexible width and height
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 Array to hold NSValues from CGRects with frames where drag view can be placed
 */
@property (nonatomic, strong) NSArray *endFrames;

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
 is YES when view placed on end frame (view have animated to end frame)
 */
@property (nonatomic, assign) BOOL isAtEndFrame;

/**
 is YES when view sits on start frame
 */
@property (nonatomic, assign) BOOL isAtStartFrame;

@property (nonatomic, assign) BOOL isAddedToManager;

@property (nonatomic, assign) NSInteger currentEndFrameIndex;

@property (nonatomic, assign) CGPoint startLocation;;

@property (nonatomic, assign) OWXDelegateFlags delegateFlags;

@end

@implementation OWXDragView

#pragma mark - Initializers
- (instancetype)initWithImage:(UIImage *)image startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame {
    
    return [self initWithImage:image
                    startFrame:startFrame
                     endFrames:@[OWXCGRectValue(endFrame)]
                      delegate:nil];
}

- (instancetype)initWithImage:(UIImage *)image startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame delegate:(id<OWXDragViewDelegate>)delegate {
    return [self initWithImage:image
                    startFrame:startFrame
                     endFrames:@[OWXCGRectValue(endFrame)]
                      delegate:delegate];
}



- (instancetype)initWithImage:(UIImage *)image startFrame:(CGRect)startFrame endFrames:(NSArray *)endFrames delegate:(id<OWXDragViewDelegate>)delegate {
    return [self initWithImage:image
               animationImages:nil
                    startFrame:startFrame
                     endFrames:endFrames
                      delegate:delegate];
}

- (instancetype)initWithImage:(UIImage *)image animationImages:(NSArray *)animationImages startFrame:(CGRect)startFrame endFrames:(NSArray *)endFrames delegate:(id<OWXDragViewDelegate>)delegate {
    self = [super initWithFrame:startFrame];
    if(!self) {
        return nil;
    }
    
    _startFrame = startFrame;
    _endFrames = endFrames;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.image = image;
    self.imageView.animationImages = animationImages;
    self.imageView.animationDuration = 1;
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
    
    [self initPropertyValue];
    
    self.shouldStickToEndFrame = YES;
    self.canDragFromEndPosition = NO;
    self.canSwapToStartPosition = YES;
    
    self.usedVelocity = kOWXDragConstantTime;
    self.delegate = delegate;
    
    return self;
}

- (void)initPropertyValue {
    
    self.isDragging =       NO;
    self.isAnimating =      NO;
    self.isOverStartFrame = YES;
    self.isOverEndFrame =   NO;
    self.isAtEndFrame =     NO;
    self.isAtStartFrame =   YES;
    self.isAddedToManager = NO;
    
    self.canUseSameEndFrameManyTimes = NO;
    self.canDragMultipleDragViewsAtOnce = YES;
    self.currentEndFrameIndex = NSNotFound;
    self.startLocation = CGPointZero;

}

- (void)setImage:(UIImage *)image animationImages:(NSArray *)animationImages startFrame:(CGRect)startFrame endFrames:(NSArray *)endFrames {
    
    self.imageView.image = image;
    self.imageView.animationImages = animationImages;
    self.startFrame = startFrame;
    self.frame = startFrame;
    self.endFrames = endFrames;
    
    [self initPropertyValue];
}

- (void)setStartFrame:(CGRect)startFrame {
    
    _startFrame = startFrame;
    self.frame = startFrame;
}

- (void)startAnimating {
    [self.imageView startAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
}

- (void)stopAnimating {
    [self.imageView stopAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

#pragma mark - Setters

- (void)setDelegate:(id<OWXDragViewDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateFlags.dragViewDidStartDragging     = [delegate respondsToSelector:@selector(dragViewDidStartDragging:)];
        _delegateFlags.dragViewDidEndDragging       = [delegate respondsToSelector:@selector(dragViewDidEndDragging:)];
        
        _delegateFlags.dragViewDidEnterStartFrame   = [delegate respondsToSelector:@selector(dragViewDidEnterStartFrame:)];
        _delegateFlags.dragViewDidLeaveStartFrame   = [delegate respondsToSelector:@selector(dragViewDidLeaveStartFrame:)];
        
        _delegateFlags.dragViewDidEnterEndFrame    = [delegate respondsToSelector:@selector(dragViewDidEnterEndFrame:atIndex:)];
        _delegateFlags.dragViewDidLeaveEndFrame    = [delegate respondsToSelector:@selector(dragViewDidLeaveEndFrame:atIndex:)];
        
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
        [[OWXDragManager manager] addDragView:self];
        self.isAddedToManager = YES;
    }
    else if(canUseSameEndFrameManyTimes){
        [[OWXDragManager manager] removeDragView:self];
        self.isAddedToManager = NO;
    }
}

- (void)setCanDragMultipleDragViewsAtOnce:(BOOL)canDragMultipleDragViewsAtOnce {
    
    _canDragMultipleDragViewsAtOnce = canDragMultipleDragViewsAtOnce;
    
    if (canDragMultipleDragViewsAtOnce) {
        [[OWXDragManager manager] dragViewDidEndDragging:self];
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
        if (![[OWXDragManager manager] dragViewCanStartDragging:self]) {
            return;
        }
    }
    
    if (self.isAtEndFrame && !self.canDragFromEndPosition) {
        return;
    }
    
    if (!self.isDragging && !self.isAnimating) {
        
        self.isDragging = YES;
        
        CGPoint point = [gestureRecognizer locationInView:self];
        
        self.startLocation = point;
        
        [[self superview] bringSubviewToFront:self];
        
        if (self.delegateFlags.dragViewDidStartDragging) {
            [self.delegate dragViewDidStartDragging:self];
        }
        
    }
}

- (void)panMoved:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if(!self.isDragging) {
        return;
    }
    
    CGPoint point = [gestureRecognizer locationInView:self];
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    [self setCenter:CGPointMake([self center].x + translation.x, [self center].y + translation.y)];
    [gestureRecognizer setTranslation:CGPointZero inView:[self superview]];
    
    // Is over start frame
    BOOL isOverStartFrame = [self didEnterStartFrameWithPoint:point];
    
    if (!self.isOverStartFrame && isOverStartFrame) {
        
        self.isOverStartFrame = YES;
        if (self.delegateFlags.dragViewDidEnterStartFrame) {
            [self.delegate dragViewDidEnterStartFrame:self];
        }
    }
    else if (self.isOverStartFrame && !isOverStartFrame){
        
        self.isOverStartFrame = NO;
        if (self.delegateFlags.dragViewDidLeaveStartFrame) {
            [self.delegate dragViewDidLeaveStartFrame:self];
        }
    }
    
    // Is over end frame?
    NSInteger endFrameIndex = [self endFrameIndexWithPoint:point];
    
    // Entered new good frame
    if (endFrameIndex != NSNotFound && !self.isOverEndFrame) {
        
        self.isOverEndFrame = YES;
        self.currentEndFrameIndex = endFrameIndex;
        
        if (self.delegateFlags.dragViewDidEnterEndFrame) {
            [self.delegate dragViewDidEnterEndFrame:self atIndex:endFrameIndex];
        }
    }
    
    // Did leave end frame
    if (self.isOverEndFrame && endFrameIndex == NSNotFound) {
        
        if (self.delegateFlags.dragViewDidLeaveEndFrame) {
            [self.delegate dragViewDidLeaveEndFrame:self atIndex:self.currentEndFrameIndex];
        }
        
        if(!self.canUseSameEndFrameManyTimes){
            CGRect endFrame = OWXCGRectFromValue([self.endFrames objectAtIndex:self.currentEndFrameIndex]);
            [[OWXDragManager manager] dragView:self didLeaveEndFrame:endFrame];
        }
        
        self.currentEndFrameIndex = NSNotFound;
        self.isOverEndFrame = NO;
        self.isAtEndFrame = NO;
        
    }
    
    // Did switch from one good from to another
    
    if (self.isOverEndFrame && endFrameIndex != self.currentEndFrameIndex) {
        
        if (self.delegateFlags.dragViewDidLeaveEndFrame) {
            [self.delegate dragViewDidLeaveEndFrame:self atIndex:self.currentEndFrameIndex];
        }
        
        if (!self.canUseSameEndFrameManyTimes && self.isAtEndFrame) {
            CGRect rect = OWXCGRectFromValue([self.endFrames objectAtIndex:self.currentEndFrameIndex]);
            [[OWXDragManager manager] dragView:self didLeaveEndFrame:rect];
        }
        
        if (self.delegateFlags.dragViewDidEnterEndFrame) {
            [self.delegate dragViewDidEnterEndFrame:self atIndex:endFrameIndex];
        }
        
        self.currentEndFrameIndex = endFrameIndex;
        self.isAtEndFrame = NO;
    }
    
}

- (void)panEnded:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (!self.isDragging) {
        return;
    }
    
    self.isDragging = NO;
    
    if(!self.canDragMultipleDragViewsAtOnce) {
        [[OWXDragManager manager] dragViewDidEndDragging:self];
    }
    
    if (self.delegateFlags.dragViewDidEndDragging) {
        [self.delegate dragViewDidEndDragging:self];
    }
    
    if (self.delegateFlags.dragViewCanAnimateToEndFrame){
        if (![self.delegate dragView:self canAnimateToEndFrameWithIndex:self.currentEndFrameIndex]) {
            [self swapToStartPosition];
            return;
        }
    }
    
    if (self.isAtEndFrame && !self.shouldStickToEndFrame) {
        
        if(!self.canUseSameEndFrameManyTimes) {
            CGRect endFrame = OWXCGRectFromValue([self.endFrames objectAtIndex:self.currentEndFrameIndex]);
            [[OWXDragManager manager] dragView:self didLeaveEndFrame:endFrame];
        }
        
        if(self.delegateFlags.dragViewDidLeaveEndFrame) {
            [self.delegate dragViewDidLeaveEndFrame:self atIndex:self.currentEndFrameIndex];
        }
        
        [self swapToStartPosition];
    }
    else if (self.isOverStartFrame && self.canSwapToStartPosition) {
        [self swapToStartPosition];
    }
    else if (self.currentEndFrameIndex != NSNotFound) {
        [self swapToEndPositionAtIndex:self.currentEndFrameIndex];
    }
    else {
        if (self.isOverEndFrame && !self.canUseSameEndFrameManyTimes) {
            CGRect endFrame = OWXCGRectFromValue([self.endFrames objectAtIndex:self.currentEndFrameIndex]);
            [[OWXDragManager manager] dragView:self didLeaveEndFrame:endFrame];
        }
        
        [self swapToStartPosition];
    }
    
    self.startLocation = CGPointZero;
    
}

#pragma mark - Private
- (BOOL)didEnterStartFrameWithPoint:(CGPoint)point {
    
    CGPoint touchInSuperview = [self convertPoint:point toView:[self superview]];
    
    return CGRectContainsPoint(self.startFrame, touchInSuperview);
}

- (NSInteger)endFrameIndexWithPoint:(CGPoint)point {
    
    __block NSInteger index = NSNotFound;
    
    CGPoint touchInSuperview = [self convertPoint:point toView:[self superview]];
    
    [self.endFrames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect endFrame = [obj CGRectValue];
        if (CGRectContainsPoint(endFrame, touchInSuperview)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
    
}

- (NSTimeInterval)swapToStartAnimationDuration {
    
    if (self.usedVelocity == kOWXDragConstantTime) {
        return SWAP_TO_START_DURATION;
    }
    else{
        // kOWXDragConstantVelocity
        return OWXDistanceBetweenFrames(self.frame, self.startFrame) / VELOCITY_PARAMETER;
    }
    
}

- (NSTimeInterval)swapToEndAnimationDurationWithFrame:(CGRect)endFrame {
    
    if (self.usedVelocity == kOWXDragConstantTime) {
        return SWAP_TO_END_DURATION;
    }
    else{
        // kOWXDragConstantVelocity
        return OWXDistanceBetweenFrames(self.frame, endFrame) / VELOCITY_PARAMETER;
    }
}

#pragma mark - Public
- (void)swapToStartPosition {
    
    self.isAnimating = YES;
    
    if (self.delegateFlags.dragViewWillSwapToStartFrame) {
        [self.delegate dragViewWillSwapToStartFrame:self];
    }
    
    [UIView animateWithDuration:[self swapToStartAnimationDuration]
                          delay:0.
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = self.startFrame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             self.isAnimating = NO;
                             self.isAtStartFrame = YES;
                             self.isAtEndFrame = NO;
                             
                             if (self.delegateFlags.dragViewDidSwapToStartFrame) {
                                 [self.delegate dragViewDidSwapToStartFrame:self];
                             }
                             
                         }
                     }];
    
}

- (void)swapToEndPositionAtIndex:(NSInteger)index {
    
    if (self.endFrames.count <= 0) {
        return;
    }
    
    CGRect endFrame = [[self.endFrames objectAtIndex:index] CGRectValue];
    
    if (!self.isAtEndFrame &&
        !self.canUseSameEndFrameManyTimes &&
        ![[OWXDragManager manager] dragView:self wantSwapToEndFrame:endFrame]) {
        if(self.delegateFlags.dragViewDidLeaveEndFrame) {
            [self.delegate dragViewDidLeaveEndFrame:self atIndex:index];
        }
        return;
    }
    
    self.isAnimating = YES;
    
    if (self.delegateFlags.dragViewWillSwapToEndFrame) {
        [self.delegate dragViewWillSwapToEndFrame:self atIndex:index];
    }
    
    [UIView animateWithDuration:[self swapToEndAnimationDurationWithFrame:endFrame]
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = endFrame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             self.isAnimating = NO;
                             self.isAtEndFrame = YES;
                             self.isAtStartFrame = NO;
                             
                             if (self.delegateFlags.dragViewDidSwapToEndFrame) {
                                 [self.delegate dragViewDidSwapToEndFrame:self atIndex:index];
                             }
                             
                         }
                     }];
}

@end

#pragma mark - OWXDragManager

@interface OWXDragManager ()

@property (nonatomic, strong) NSMutableArray *managerArray;

@property (nonatomic, weak) OWXDragView *currentDragView;

@end

@implementation OWXDragManager

+ (OWXDragManager *)manager {
    
    static OWXDragManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OWXDragManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.managerArray = [[NSMutableArray alloc] init];
        self.currentDragView = nil;
    }
    
    return self;
    
}

- (void)reset {
    [self.managerArray removeAllObjects];
    self.currentDragView = nil;
}

- (void)addDragView:(OWXDragView *)dragView {
    
    NSMutableArray *framesToAdd = [NSMutableArray arrayWithCapacity:0];
    
    if (self.managerArray.count > 0) {
        
        for (NSValue *dragViewValue in dragView.endFrames) {
            
            CGRect dragViewRect = OWXCGRectFromValue(dragViewValue);
            BOOL isInTheArray = NO;
            
            for (OWXOccupancyIndicator *indicator in self.managerArray) {
                
                CGRect managerRect = indicator.frame;
                if (CGRectEqualToRect(managerRect, dragViewRect)) {
                    indicator.count++;
                    isInTheArray = YES;
                    break;
                }
            }
            
            if (!isInTheArray) {
                [framesToAdd addObject:dragViewValue];
            }
        }
        
    }
    else {
        [framesToAdd addObjectsFromArray:dragView.endFrames];
    }
    
    for (int i = 0;i < framesToAdd.count; i++) {
        CGRect frame = OWXCGRectFromValue([framesToAdd objectAtIndex:i]);
        OWXOccupancyIndicator *indicator = [OWXOccupancyIndicator indicatorWithFrame:frame];
        [self.managerArray addObject:indicator];
    }
    
}

- (void)removeDragView:(OWXDragView *)dragView {
    
    NSMutableArray *arrayToRemove = [NSMutableArray arrayWithCapacity:0];
    
    for (OWXOccupancyIndicator *indicator in self.managerArray) {
        
        CGRect rect = indicator.frame;
        
        for (NSValue *value in dragView.endFrames) {
            
            CGRect endFrame = OWXCGRectFromValue(value);
            
            if (CGRectEqualToRect(rect, endFrame)) {
                indicator.count--;
                
                if (indicator.count == 0) {
                    [arrayToRemove addObject:indicator];
                }
            }
            
        }
        
    }
    
    [self.managerArray removeObjectsInArray:arrayToRemove];
    
}

- (BOOL)dragView:(OWXDragView*)dragView wantSwapToEndFrame:(CGRect)endFrame {
    
    for (OWXOccupancyIndicator *indicator in self.managerArray) {
        
        CGRect frame = indicator.frame;
        
        BOOL isTaken = !indicator.isFree;
        
        if (CGRectEqualToRect(endFrame, frame)) {
            if (isTaken) {
                [dragView swapToStartPosition];
                return NO;
            }
            else {
                indicator.isFree = NO;
                return YES;
            }
        }
    }
    
    return YES;
}

- (void)dragView:(OWXDragView *)dragView didLeaveEndFrame:(CGRect)endFrame {
    
    for (OWXOccupancyIndicator *indicator in self.managerArray) {
        
        CGRect frame = indicator.frame;
        if (CGRectEqualToRect(frame, endFrame) && dragView.isAtEndFrame) {
            indicator.isFree = YES;
        }
    }
}

- (BOOL)dragViewCanStartDragging:(OWXDragView *)dragView {
    
    if (!self.currentDragView) {
        self.currentDragView = dragView;
        return YES;
    }
    else{
        return NO;
    }
}

- (void)dragViewDidEndDragging:(OWXDragView *)dragView {
    
    if (self.currentDragView == dragView) {
        self.currentDragView = nil;
    }
}

@end

#pragma mark - OWXOccupancyIndicator

@implementation OWXOccupancyIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super init];
    if(self) {
        self.frame = frame;
        self.isFree = YES;
        self.count = 1;
    }
    return self;
    
}

+ (OWXOccupancyIndicator *)indicatorWithFrame:(CGRect)frame {
    return [[OWXOccupancyIndicator alloc] initWithFrame:frame];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"OWXOccupancyIndicator: frame: %@, count: %ld, isFree: %@",
            NSStringFromCGRect(self.frame), self.count, self.isFree ? @"YES" : @"NO"];
}

@end
