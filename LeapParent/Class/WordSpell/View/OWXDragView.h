//
//  OWXDragView.h
//  LeapParent
//
//  Created by 王史超 on 2018/6/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWXDragView;

typedef BOOL OWXVelocity;

#define kOWXDragConstantTime YES

#define kOWXDragConstantSpeed NO

/**
 Creates NSValue object holding given CGSize
 */
NSValue * OWXCGSizeValue(CGSize size);

CGSize OWXCGSizeFromValue(NSValue *value);

/**
 Creates NSValue object holding given CGRect
 */
NSValue * OWXCGRectValue(CGRect rect);

CGRect OWXCGRectFromValue(NSValue *value);

/**
 Returns the distance between centers of the two frames
 */
CGFloat OWXDistanceBetweenFrames(CGRect rect1, CGRect rect2);

/**
 Compute center of the given CGRect
 */
inline CGPoint OWXCGRectCenter(CGRect rect);


@protocol OWXDragViewDelegate <NSObject>

@optional

/**
 开始拖动

 @param dragView dragView
 */
- (void)dragViewDidStartDragging:(OWXDragView *)dragView;

- (void)dragViewDidEndDragging:(OWXDragView *)dragView;

- (void)dragViewDidEnterStartFrame:(OWXDragView *)dragView;

- (void)dragViewDidLeaveStartFrame:(OWXDragView *)dragView;

- (void)dragViewDidEnterEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewDidLeaveEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewWillSwapToEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewDidSwapToEndFrame:(OWXDragView *)dragView atIndex:(NSInteger)index;

- (void)dragViewWillSwapToStartFrame:(OWXDragView *)dragView;

- (void)dragViewDidSwapToStartFrame:(OWXDragView *)dragView;

- (BOOL)dragView:(OWXDragView *)dragView canAnimateToEndFrameWithIndex:(NSInteger)index;

@end

@interface OWXDragView : UIView <UIGestureRecognizerDelegate>

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
 By setting this property to NO, drag view is added to OWXDragManager, it's purpose it to prevent placing two views
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
 When set to NO, after placing view on the good end frame, drag view cannot be moved at all
 Default: NO
 */
@property (nonatomic, setter = setCanDragFromEndPosition:) BOOL canDragFromEndPosition;

/**
 You can select duration of the swaping animations:
 kOWXDragConstantTime - animation duration is constant and given be macros SWAP_TO_START_DURATION and SWAP_TO_END_DURATION
 kOWXDragConstantSpeed - animation is a function of a distance from a target frame from current position
 Default: kOWXDragConstantTime
 */
@property (nonatomic, assign) OWXVelocity usedVelocity;

/**
 @discusion all methods in OWXDragViewDelegate protocol are optional
 
 Default: nil
 */
@property (nonatomic, weak) id<OWXDragViewDelegate> delegate;

/**
 Identify ID
 */
@property (nonatomic, assign) NSInteger tagId;

/**
 initial frame, set on initialization
 */
@property (nonatomic, assign) CGRect startFrame;

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
                     delegate:(id<OWXDragViewDelegate>)delegate;

/**
 @discusion Default initilizer, it's called by all others init methods
 */
- (instancetype)initWithImage:(UIImage *)image
                   startFrame:(CGRect)startFrame
                    endFrames:(NSArray *)endFrames
                     delegate:(id<OWXDragViewDelegate>)delegate;

/**
 @discusion Default initilizer, it's called by all others init methods
 */
- (instancetype)initWithImage:(UIImage *)image
              animationImages:(NSArray *)animationImages
                   startFrame:(CGRect)startFrame
                    endFrames:(NSArray *)endFrames
                     delegate:(id<OWXDragViewDelegate>)delegate;

/**
 @discusion Reset
 */
- (void)setImage:(UIImage *)image animationImages:(NSArray *)animationImages startFrame:(CGRect)startFrame endFrames:(NSArray *)endFrames;

/**
 start animation
 */
- (void)startAnimating;

/**
 stop animation
 */
- (void)stopAnimating;

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

#pragma mark - OWXDragManager

/*
 *
 * Drag View manager to manage dragging and occupancy of the good end frames
 *
 */
@interface OWXDragManager : NSObject

+ (OWXDragManager *)manager;

- (void)reset;

- (void)addDragView:(OWXDragView *)dragView;

- (void)removeDragView:(OWXDragView *)dragView;

- (BOOL)dragView:(OWXDragView*)dragView wantSwapToEndFrame:(CGRect)endFrame;

- (BOOL)dragViewCanStartDragging:(OWXDragView*)dragView;

- (void)dragViewDidEndDragging:(OWXDragView *)dragView;

- (void)dragView:(OWXDragView *)dragView didLeaveEndFrame:(CGRect)endFrame;

@end

#pragma mark - OWXOccupancyIndicator

@interface OWXOccupancyIndicator : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isFree;

+ (OWXOccupancyIndicator *)indicatorWithFrame:(CGRect)frame;

@end
