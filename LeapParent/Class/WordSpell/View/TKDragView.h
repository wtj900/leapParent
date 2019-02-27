//
//  TKDragView.h
//  Retail Incentive
//
//  Created by Mapedd on 11-05-14.
//  Copyright 2011 Tomasz Kuzma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKDragView;

typedef BOOL TKVelocity;

#define kTKDragConstantTime YES

#define kTKDragConstantSpeed NO

/**
 Creates NSValue object holding given CGRect
 */
NSValue * TKCGRectValue(CGRect rect);

CGRect TKCGRectFromValue(NSValue *value);

/**
 Returns the distance between centers of the two frames
 */
CGFloat TKDistanceBetweenFrames(CGRect rect1, CGRect rect2);

/**
 Compute center of the given CGRect
 */
inline CGPoint TKCGRectCenter(CGRect rect);


@protocol TKDragViewDelegate <NSObject>

@optional

- (void)dragViewDidStartDragging:(TKDragView *)dragView;

- (void)dragViewDidEndDragging:(TKDragView *)dragView;

- (void)dragViewDidEnterStartFrame:(TKDragView *)dragView;

- (void)dragViewDidLeaveStartFrame:(TKDragView *)dragView;

- (void)dragViewDidEnterGoodFrame:(TKDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewDidLeaveGoodFrame:(TKDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewDidEnterBadFrame:(TKDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewDidLeaveBadFrame:(TKDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewWillSwapToEndFrame:(TKDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewDidSwapToEndFrame:(TKDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewWillSwapToStartFrame:(TKDragView *)dragView;

- (void)dragViewDidSwapToStartFrame:(TKDragView *)dragView;

- (BOOL)dragView:(TKDragView *)dragView canAnimateToEndFrameWithIndex:(NSInteger)index;

@end

@interface TKDragView : UIView <UIGestureRecognizerDelegate>

/**
 is YES when user is dragging the view
 */
@property (nonatomic, assign, readonly) BOOL isDragging;

/**
 is YES when view is animating for example to one of the end frames or to start frame
 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

/**
 is YES when view is hovering over one of the good end frames
 */
@property (nonatomic, assign, readonly) BOOL isOverEndFrame;

/**
 is YES when view is hovering over one of the bad frames
 */
@property (nonatomic, assign, readonly) BOOL isOverBadFrame;

/**
 is YES when view placed on end frame (view have animated to end frame)
 */
@property (nonatomic, assign, readonly) BOOL isAtEndFrame;

/**
 is YES when view sits on start frame 
 */
@property (nonatomic, assign, readonly) BOOL isAtStartFrame;

/**
 When you set this property to NO, when drag view was once placed on end frame it can't swap back to start frame.
 Default: YES
 */
@property (nonatomic, setter = setCanSwapToStartPosition:) BOOL canSwapToStartPosition;

/**
 By setting this property to NO, drag view is added to TKDragManager, it's purpose it to prevent placing two views 
 on the same end frame
 Default: YES
 */
@property (nonatomic, setter = setCanUseSameEndFrameManyTimes:) BOOL canUseSameEndFrameManyTimes;

/**
 By setting this property to NO only one drag view can be dragged in the givien moment
 Default: YES
 */
@property (nonatomic, setter = setCanDragMultipleDragViewsAtOnce:) BOOL canDragMultipleDragViewsAtOnce;

/**
 By settings this property to YES, if drag view is placed on end frame and user will drag it but not leave the current end frame, 
 after releasing it will animate to current end frame, otherwise it will animate to start frame
 Default: NO
 */
@property (nonatomic, setter = setShouldStickToEndFrame:) BOOL shouldStickToEndFrame;

/**
 You can select duration of the swaping animations:
 kTKDragConstantTime - animation duration is constant and given be macros SWAP_TO_START_DURATION and SWAP_TO_END_DURATION 
 kTKDragConstantSpeed - animation is a function of a distance from a target frame from current position
 Default: kTKDragConstantTime
 */
@property (nonatomic, assign) TKVelocity usedVelocity;

/**
 When set to NO, after placing view on the good end frame, drag view cannot be moved at all
 Default: YES
 */
@property (nonatomic, assign) BOOL canDragFromEndPosition;

/**
 @discusion all methods in TKDragViewDelegate protocol are optional
 
 Default: nil
 */
@property (nonatomic, weak) id<TKDragViewDelegate> delegate;

/**
 @discusion Initializer for drag views with only one end frame
 */
- (instancetype)initWithImage:(UIImage *)image
                   startFrame:(CGRect)startFrame
                     endFrame:(CGRect)endFrame;

/**
 @discusion Initializer for drag views with only one end frame and delegate
 */
- (instancetype)initWithImage:(UIImage *)image
                   startFrame:(CGRect)startFrame
                     endFrame:(CGRect)endFrame
                     delegate:(id<TKDragViewDelegate>)delegate;

/**
 @discusion Default initilizer, it's called by all others init methods
 */
- (instancetype)initWithImage:(UIImage *)image
                   startFrame:(CGRect)startFrame
                   goodFrames:(NSArray *)goodFrames
                    badFrames:(NSArray *)badFrames
                     delegate:(id<TKDragViewDelegate>)delegate;

/**
 Animates drag view to current startFrame
 @seealso startFrame
 */
- (void)swapToStartPosition;

/**
 Animates drag view to good frame with given index from the goodFramesArray
 @seealso goodFrameArray
 */
- (void)swapToEndPositionAtIndex:(NSInteger)index;

@end

#pragma mark - TKDragManager

/*
 * 
 * Drag View manager to manage dragging and occupancy of the good end frames 
 * 
 */
@interface TKDragManager : NSObject

+ (TKDragManager *)manager;

- (void)addDragView:(TKDragView *)dragView;

- (void)removeDragView:(TKDragView *)dragView;

- (BOOL)dragView:(TKDragView*)dragView wantSwapToEndFrame:(CGRect)endFrame;

- (BOOL)dragViewCanStartDragging:(TKDragView*)dragView;

- (void)dragViewDidEndDragging:(TKDragView *)dragView;

- (void)dragView:(TKDragView *)dragView didLeaveEndFrame:(CGRect)endFrame;

@end

#pragma mark - TKOccupancyIndicator

@interface TKOccupancyIndicator : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isFree;

+ (TKOccupancyIndicator *)indicatorWithFrame:(CGRect)frame;

@end
