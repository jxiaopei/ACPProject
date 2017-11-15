//
//  DTextField.m
//  Template
//
//  Created by l on 2017/5/10.
//  Copyright © 2017年 WestLand. All rights reserved.
//

#import "DTextField.h"
#import "UIView+MDF.h"

@interface DTextField ()

@property (nonatomic, strong) UIView * promptView;
@property (nonatomic, strong) UILabel * promptLabel;
@property (nonatomic, strong) UIImageView * promptImageView;

@end

@implementation DTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont systemFontOfSize:13];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEditing:) name:UITextFieldTextDidChangeNotification object:self];
        
    }
    return self;
}

- (void)textBeginEditing:(NSNotification*)notification
{
    self.rightView.hidden = YES;
    self.rightView = nil;
}

- (void)textEndEditing:(NSNotification*)notification
{
    self.rightView = self.promptView;
    self.rightView.backgroundColor = [UIColor blackColor];
    self.rightView.hidden = NO;
}


- (void)setPromptText:(NSString *)promptText
{
    _promptText = promptText;
    
    self.promptLabel.text = _promptText;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize size = [promptText boundingRectWithSize:CGSizeMake(200, 20)
                                     options: NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    self.promptImageView.frame = CGRectMake(0, 0, 20, 20);
    self.promptLabel.frame = CGRectMake(self.promptImageView.right, 0, size.width, 20);
    self.promptView.width = self.promptImageView.width + size.width;
    
    self.rightView = self.promptView;
    self.rightView.hidden = NO;
    
}

- (UIView *)promptView
{
    if (!_promptView)
    {
        _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
    }
    return _promptView;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel)
    {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 1;
        _promptLabel.font = [UIFont systemFontOfSize:13];
        [self.promptView addSubview:_promptLabel];
    }
    return _promptLabel;
}

- (UIImageView *)promptImageView
{
    if (!_promptImageView)
    {
        _promptImageView = [[UIImageView alloc] init];
        _promptImageView.image = [UIImage imageNamed:@"Login_note"];
        _promptImageView.contentMode = UIViewContentModeCenter;
        [self.promptView addSubview:_promptImageView];
    }
    return _promptImageView;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
     return CGRectMake(bounds.size.width - self.promptView.width - 5, (bounds.size.height - self.promptView.height)/2, self.promptView.width, self.promptView.height);
}


@end
