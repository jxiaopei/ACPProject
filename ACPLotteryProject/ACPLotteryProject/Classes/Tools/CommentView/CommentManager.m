//
//  CommentManager.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/11/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "CommentManager.h"

#define kAnimationDuration 0.2

@interface CommentManager ()<UITextViewDelegate>

@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,strong)UITextView *contentText;
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,strong)UIView *view;
@property(nonatomic,copy)commentComplateBlock complateBlock;
@property(nonatomic,copy)void (^noThingBlock)();

@end

@implementation CommentManager

+(instancetype)shareManager{
    
    static CommentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
//        //注册通知,监听键盘弹出事件
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//        //注册通知,监听键盘消失事件
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    });
    
    return manager;
}

-(void)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder commentComplateBlock:(commentComplateBlock)complateBlock doNothingBlock:(void(^)())noThingBlock{
    
   
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    self.view = [self getCurrentVC].view;
    self.complateBlock = complateBlock;
    self.noThingBlock = noThingBlock;
    [self initCommentViewWithTitle:title placeHolder:placeHolder];
    
}

-(void)initCommentViewWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder{

    UIView *markView = [UIView new];
    [self.view addSubview:markView];
    _markView = markView;
    markView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT -64);
    markView.backgroundColor = [UIColor blackColor];
    markView.tag = 2000;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMarkView)];
    [markView addGestureRecognizer:tap];
    
    UIView *commentsView = [UIView new];
    [self.view addSubview:commentsView];
    commentsView.backgroundColor = [UIColor whiteColor];
    commentsView.tag = 1000;
    commentsView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 150);
    
    UIButton *cancelBtn = [UIButton new];
    [commentsView addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(10, 5, 60, 25);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(dismissMarkView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [UIButton new];
    [commentsView addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(SCREENWIDTH - 70, 5, 60, 25);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn addTarget:self action:@selector(publishComment) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *replyTitle = [UILabel new];
    [commentsView addSubview:replyTitle];
    [replyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right).mas_offset(5);
        make.right.mas_equalTo(confirmBtn.mas_left).mas_offset(5);
        make.centerY.mas_equalTo(cancelBtn.mas_centerY);
    }];
    replyTitle.textColor = [UIColor blackColor];
    replyTitle.text = title;
    replyTitle.font = [UIFont systemFontOfSize:18];
    replyTitle.textAlignment = NSTextAlignmentCenter;
//    replyTitle.hidden = YES;
    
    UITextView *textView = [UITextView new];
    [commentsView addSubview:textView];
    _contentText = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
    }];
    
    textView.delegate =self;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:18];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    
    _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, 200, 20)];
    _placeholder.enabled = NO;
    _placeholder.text = @"请输入评论内容";
    _placeholder.font =  [UIFont systemFontOfSize:18];
    _placeholder.textColor = [UIColor lightGrayColor];
    [textView addSubview:_placeholder];
    
    [textView becomeFirstResponder];
    
}

-(void)publishComment{
    self.complateBlock(_contentText, _markView);
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view viewWithTag:1000].frame = CGRectMake(0, SCREENHEIGHT-keyboardRect.size.height-150, SCREENWIDTH, 150);
        [self.view viewWithTag:2000].frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [self.view viewWithTag:2000].alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
}

//键盘消失时
-(void)keyboardDidHidden{
    //定义动画
    [UIView animateWithDuration:kAnimationDuration*2 animations:^{
        [self.view viewWithTag:1000].frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 150);
        [self.view viewWithTag:2000].frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        [self.view viewWithTag:2000].alpha = 0;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:2000]  removeFromSuperview];
        [[self.view viewWithTag:1000]  removeFromSuperview];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }];
}

- (void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        [_placeholder setHidden:NO];
    }else{
        [_placeholder setHidden:YES];
    }
}

-(void)dismissMarkView{
    [_contentText endEditing:YES];
    self.noThingBlock();
}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

@end
