//
//  IDPPageControl.m
//  IDP
//
//  Created by Tu You on 13-11-18.
//
//

#import "MDFPageControl.h"

#define DefaultPageIndicatorSize (7)
#define DefaultPageIndicatorSpacing (9)

@implementation MDFPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setPageIndicatorSpacing:DefaultPageIndicatorSpacing];
    [self updatePageControl];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage < 0 || currentPage >= self.numberOfPages) {
        return;
    }
    [super setCurrentPage:currentPage];
    [self updatePageControl];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (numberOfPages != self.numberOfPages) {
        [super setNumberOfPages:MAX(0, numberOfPages)];
        [self updatePageControl];
    }
}

- (void)setTotalAndCurrentPageNumber:(NSInteger)totalPageNumber currentPageNumber:(NSInteger)currentPageNumber
{
    [self setNumberOfPages:totalPageNumber];
    [self setCurrentPage:currentPageNumber];
}

- (void)setImagePageStateNormal:(UIImage *)imageNormal
{
    _imagePageStateNormal = imageNormal;
    [self updatePageControl];
}

- (void)setImagePageStateHighlighted:(UIImage *)imageHighlighted
{
    _imagePageStateHighlighted = imageHighlighted;
    [self updatePageControl];
}

- (void)setImageOfPageNormalAndHighlighted:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    [self setImagePageStateNormal:normalImage];
    [self setImagePageStateHighlighted:highlightedImage];
}

- (void)setColorOfBackgroundAndCurrentPageIndicator:(UIColor *)colorOfBackground colorOfCurrentPageIndicator:(UIColor *)colorOfCurrentPageIndicator
{
    [self setBackgroundColor:colorOfBackground];
    [self setCurrentPageIndicatorTintColor:colorOfCurrentPageIndicator];
}

- (void)setPageIndicatorSpacing:(NSInteger)indicatorSpacing
{
    if (indicatorSpacing != _pageIndicatorSpacing) {
        _pageIndicatorSpacing = indicatorSpacing;
        [self updatePageControl];
    }
}

- (void)updatePageControl
{
    //如果设置了图片，将默认圆点改为透明
    if (_imagePageStateNormal && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        self.pageIndicatorTintColor = [UIColor clearColor];
    }
    if (_imagePageStateHighlighted && [self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
        self.currentPageIndicatorTintColor = [UIColor clearColor];
    }
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)iRect
{
    CGRect rect;
    UIImage *image;
    iRect = self.bounds;
        
    if ( self.opaque ) {
        [self.backgroundColor set];
        UIRectFill( iRect );
    }

    //取两个图片中较大的size用于位置计算
    float bigWidth = MAX(_imagePageStateHighlighted.size.width, _imagePageStateNormal.size.width);
    float bigHeight = MAX(_imagePageStateHighlighted.size.height,_imagePageStateNormal.size.height);
    if (self.pageIndicatorSize > 0)
    {
        bigWidth = self.pageIndicatorSize;
        bigHeight = self.pageIndicatorSize;
    }
    else
    {
        bigWidth = MAX(bigWidth, DefaultPageIndicatorSize);
        bigHeight = MAX(bigHeight, DefaultPageIndicatorSize);
    }

    //计算Rect
    rect.size.height = bigHeight;
    rect.size.width = self.numberOfPages * bigWidth + ( self.numberOfPages - 1 ) * _pageIndicatorSpacing;
    rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0 );
    rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0 );
    rect.size.width = bigWidth;
        
    BOOL flag = NO;
    for (int i = 0; i < self.numberOfPages; ++i ) {
        if (i == self.currentPage) {
            if (_imagePageStateHighlighted) {
                image = _imagePageStateHighlighted;
            }
            else {
                flag = YES;
            }
        }
        else {
            if (_imagePageStateNormal) {
                image = _imagePageStateNormal;
            }
            else {
                flag = YES;
            }
        }
        //如果未设置点的图片，则根据点大小重设frame
        if (flag) {
            float deltaX = (rect.size.width - [[self.subviews objectAtIndex:i] frame].size.width) / 2;
            float deltaY = (rect.size.height - [[self.subviews objectAtIndex:i] frame].size.height) / 2;
            rect.origin.x += deltaX;
            rect.origin.y += deltaY;
            rect.size.width = [[self.subviews objectAtIndex:i] frame].size.width;
            rect.size.height = [[self.subviews objectAtIndex:i] frame].size.height;
            [[self.subviews objectAtIndex:i] setFrame:rect];
            rect.origin.x += rect.size.width + deltaX + _pageIndicatorSpacing;
            rect.origin.y -= deltaY;
            rect.size.width = bigWidth;
            rect.size.height = bigHeight;
            flag = NO;
        }
        //如果设置了点的图片，则绘制该图
        else {
            rect.size.width = image.size.width;
            rect.size.height = image.size.height;
            rect.origin.y = (iRect.size.height - image.size.height) / 2.0f;
            [image drawInRect: rect];
            //ios5以下没有tintColor属性，因此绘制图片时将原本的点设置为透明
            if ([[UIDevice currentDevice] systemVersion].floatValue < 6.0) {
                [[self.subviews objectAtIndex:i] setAlpha:0];
            }
            rect.origin.x += bigWidth + _pageIndicatorSpacing;
        }
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self updatePageControl];
}
@end