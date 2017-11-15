//
//  IDPPageControl.h
//  IDP
//
//  Created by Tu You on 13-11-18.
//
//

#import <UIKit/UIKit.h>

@interface MDFPageControl : UIPageControl

@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;

@property (nonatomic, assign) CGFloat pageIndicatorSize;

/**
 *  设置PageControl的indicator间距
 */
@property (nonatomic, assign) NSInteger pageIndicatorSpacing;

/**
 *  设置PageControl的总页数与当前页
 *
 *  @param totalPageNumber    总页数
 *  @param currentPageNumber  当前页
 */
- (void)setTotalAndCurrentPageNumber:(NSInteger)totalPageNumber
                   currentPageNumber:(NSInteger)currentPageNumber;

/**
 *  设置PageControl的活动与非活动指示器图片
 *
 *  @param normalImage          活动页指示器图片
 *  @param highlightedImage     非活动页指示器图片
 */
- (void)setImageOfPageNormalAndHighlighted:(UIImage *)normalImage
                          highlightedImage:(UIImage *)highlightedImage;

/**
 *  设置PageControl的背景及活动指示器颜色
 *
 *   normalImage          活动页指示器颜色
 *   highlightedImage     非活动页指示器颜色
 */
- (void)setColorOfBackgroundAndCurrentPageIndicator:(UIColor *)colorOfBackground
                        colorOfCurrentPageIndicator:(UIColor *)colorOfCurrentPageIndicator;

@end
