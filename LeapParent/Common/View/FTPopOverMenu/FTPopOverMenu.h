//
//  FTPopOverMenu.h
//  LeapParent
//
//  Created by 王史超 on 2018/6/11.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  FTPopOverMenuDoneBlock
 *
 *  @param selectedIndex SlectedIndex
 */
typedef void (^FTPopOverMenuDoneBlock)(NSInteger selectedIndex);
/**
 *  FTPopOverMenuDismissBlock
 */
typedef void (^FTPopOverMenuDismissBlock)(void);

/**
 *  FTPopOverMenuCell
 */
@interface FTPopOverMenuCell : UITableViewCell

@end
/**
 *  FTPopOverMenuView
 */
@interface FTPopOverMenuView : UIControl

@end

/**---------------------------------------------------------------------
 *  -----------------------FTPopOverMenu-----------------------
 */
@interface FTPopOverMenu : NSObject

/**
 *  setTintColor
 *
 *  @param tintColor tintColor
 */
+ (void)setTintColor:(UIColor *)tintColor;

/**
 *  show method with sender without images
 *
 *  @param sender       sender
 *  @param menuArray    menuArray
 *  @param doneBlock    FTPopOverMenuDoneBlock
 *  @param dismissBlock FTPopOverMenuDismissBlock
 */
+ (void)showForSender:(UIView *)sender
             withMenu:(NSArray<NSString*> *)menuArray
            doneBlock:(FTPopOverMenuDoneBlock)doneBlock
         dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 *  show method with sender with imageNameArray
 *
 *  @param sender         sender
 *  @param menuArray      menuArray
 *  @param imageNameArray imageNameArray
 *  @param doneBlock      FTPopOverMenuDoneBlock
 *  @param dismissBlock   FTPopOverMenuDismissBlock
 */
+ (void)showForSender:(UIView *)sender
             withMenu:(NSArray<NSString*> *)menuArray
       imageNameArray:(NSArray<NSString*> *)imageNameArray
            doneBlock:(FTPopOverMenuDoneBlock)doneBlock
         dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 *  show method for barbuttonitems with event without images
 *
 *  @param event          UIEvent
 *  @param menuArray      menuArray
 *  @param doneBlock      FTPopOverMenuDoneBlock
 *  @param dismissBlock   FTPopOverMenuDismissBlock
 */
+ (void)showFromEvent:(UIEvent *)event
             withMenu:(NSArray<NSString*> *)menuArray
            doneBlock:(FTPopOverMenuDoneBlock)doneBlock
         dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 *  show method for barbuttonitems with event with imageNameArray
 *
 *  @param event          UIEvent
 *  @param menuArray      menuArray
 *  @param imageNameArray imageNameArray
 *  @param doneBlock      FTPopOverMenuDoneBlock
 *  @param dismissBlock   FTPopOverMenuDismissBlock
 */
+ (void)showFromEvent:(UIEvent *)event
             withMenu:(NSArray<NSString*> *)menuArray
       imageNameArray:(NSArray<NSString*> *)imageNameArray
            doneBlock:(FTPopOverMenuDoneBlock)doneBlock
         dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 *  show method with SenderFrame without images
 *
 *  @param senderFrame  senderFrame
 *  @param menuArray    menuArray
 *  @param doneBlock    doneBlock
 *  @param dismissBlock dismissBlock
 */
+ (void)showFromSenderFrame:(CGRect)senderFrame
                   withMenu:(NSArray<NSString*> *)menuArray
                  doneBlock:(FTPopOverMenuDoneBlock)doneBlock
               dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 *  show method with SenderFrame with imageNameArray
 *
 *  @param senderFrame    senderFrame
 *  @param menuArray      menuArray
 *  @param imageNameArray imageNameArray
 *  @param doneBlock      doneBlock
 *  @param dismissBlock   dismissBlock
 *
 */
+ (void)showFromSenderFrame:(CGRect)senderFrame
                   withMenu:(NSArray<NSString*> *)menuArray
             imageNameArray:(NSArray<NSString*> *)imageNameArray
                  doneBlock:(FTPopOverMenuDoneBlock)doneBlock
               dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 *  dismiss method
 */
+ (void)dismiss;

@end
