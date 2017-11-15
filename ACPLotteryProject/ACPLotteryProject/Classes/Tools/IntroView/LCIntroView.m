//
//  LCIntroView.m
//  LotteryClient
//
//  Created by Dick on 2017/7/24.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCIntroView.h"
#import "UIDevice+Resolution.h"
#import "MDFPageControl.h"
#import "NSArray+MDF.h"

@interface LCIntroView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) MDFPageControl *pageControl;
@property (nonatomic, assign) BOOL willPushNextView;

@end

@implementation LCIntroView

+ (instancetype)showInView:(UIView *)superView {
    if (superView) {
        LCIntroView *introView = [[LCIntroView alloc] initWithFrame:superView.bounds];
        [superView addSubview:introView];
        return introView;
    }
    return nil;
}

- (void)dismissIntroView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"splash_2"]];
//        _images = @[@"开启"];//, @"引导页2", @"引导页3",@"引导页4",@"开启"
        [self setupSubview];
    }
    return self;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    for (int i = 0; i < _images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.width, 0, _scrollView.width, _scrollView.height)];
        //        imageView.image = [UIImage imageNamed:[_images mdf_safeObjectAtIndex:i]];
        [imageView sd_setImageWithURL:[_images mdf_safeObjectAtIndex:i][@"advertisement_img_url"]];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * _images.count, _scrollView.height);
    
    _pageControl = [[MDFPageControl alloc] initWithFrame:CGRectMake(0, self.height - 42, self.width, 7)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.enabled = NO;
    _pageControl.numberOfPages = _images.count;
    _pageControl.pageIndicatorSpacing = 6;
    _pageControl.imagePageStateNormal = [UIImage imageNamed:@"icon_dot_n"];
    _pageControl.imagePageStateHighlighted = [UIImage imageNamed:@"icon_dot_s"];
    [self addSubview:_pageControl];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(0, (self.scrollView.height - 210), 222, 120);
    [_startButton addTarget:self action:@selector(dismissIntroView) forControlEvents:UIControlEventTouchUpInside];
    _startButton.alpha = 1;
    [_scrollView addSubview:_startButton];
    _startButton.left = self.scrollView.contentSize.width - self.scrollView.width + (self.scrollView.width - 222) / 2;
    //    [self layoutStartButton];
    
    _willPushNextView = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"跳过" forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREENWIDTH - 50, 20, 44, 44);
    [btn addTarget:self action:@selector(dismissIntroView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)setupSubview
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator= NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    [self addSubview:_scrollView];
}

#pragma UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage:(scrollView.contentOffset.x + scrollView.width/2)/scrollView.width];
    
    if (scrollView.contentOffset.x > (scrollView.contentSize.width - scrollView.width)) {
        [scrollView addSubview:self.pageControl];
        self.pageControl.left = (scrollView.contentSize.width - scrollView.width);
    } else if (scrollView.contentOffset.x < 0) {
        [scrollView addSubview:self.pageControl];
        self.pageControl.left = 0;
    } else {
        [self addSubview:self.pageControl];
        self.pageControl.left = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.startButton.alpha && scrollView.contentOffset.x == (scrollView.width * (self.pageControl.numberOfPages - 1))) {
        [UIView animateWithDuration:0.75f animations:^{
            self.startButton.alpha = 1;
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.startButton.alpha && scrollView.contentOffset.x == (scrollView.width * (self.pageControl.numberOfPages - 1))) {
        [UIView animateWithDuration:0.75f animations:^{
            self.startButton.alpha = 1;
        }];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.startButton.alpha && scrollView.contentOffset.x == (scrollView.width * (self.pageControl.numberOfPages - 1))) {
        [UIView animateWithDuration:0.75f animations:^{
            self.startButton.alpha = 1;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
