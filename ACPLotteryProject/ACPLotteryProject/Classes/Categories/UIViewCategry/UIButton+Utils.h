//
//  UIButton+Utils.h
//  Meet
//
//  Created by BruceZCQ on 12/19/14.
//  Copyright (c) 2014 BruceZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utils)

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Normal Title
 *
 *  @param title titleString
 */
- (void)setNormalTitle:(NSString *)title;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Select Title
 *
 *  @param title titleString
 */
- (void)setSelectTitle:(NSString *)title;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set disable title
 *
 *  @param title title string
 */
- (void)setDisableTitle:(NSString *)title;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Normal Title Color
 *
 *  @param color title Color
 */
- (void)setNormalTitleColor:(UIColor *)color;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set select Title Color
 *
 *  @param color title Color
 */
- (void)setSelectTitleColor:(UIColor *)color;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set disable color
 *
 *  @param color title color
 */
- (void)setDisableTitleColor:(UIColor *)color;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Normal Image
 *
 *  @param image imageSrc
 */
- (void)setNomalImage:(UIImage *)image;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  set disable image
 *
 *  @param image imagesrc
 */
- (void)setDisableImage:(UIImage *)image;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Select Image
 *
 *  @param image imageSrc
 */
- (void)setSelectImage:(UIImage *)image;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Background Image
 *
 *  @param image imageSrc
 */
- (void)setBackgroundImage:(UIImage *)image;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set Background Image
 *
 *  @param image imageSrc
 */
- (void)setSelectBackgroundImage:(UIImage *)image;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Set label Font
 *
 *  @param font fontSrc
 */
- (void)setLabelFont:(UIFont *)font;

/**
 *  @author BruceZCQ (brucezcq@gmail.com)
 *
 *  @brief  Add Action
 *
 *  @param target reflect target
 *  @param action action to do
 */
- (void)addTarget:(id)target action:(SEL)action;

@end
