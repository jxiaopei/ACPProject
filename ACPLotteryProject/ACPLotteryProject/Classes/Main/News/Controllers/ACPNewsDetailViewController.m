//
//  ACPNewsDetailViewController.m
//  ACPLotteryProject
//
//  Created by iMac on 2017/10/6.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "ACPNewsDetailViewController.h"
#import <WebKit/WebKit.h>

@interface ACPNewsDetailViewController ()//<WKNavigationDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *dateLab;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)WKWebView *webView;

@end

@implementation ACPNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTitleWith:@"新闻详情"];
    [self customBackBtn];
    [self setupUI];
}

-(void)setupUI{
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    _titleLab = [UILabel new];
    [_scrollView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREENWIDTH-30);
        make.top.mas_equalTo(10);
    }];
    _titleLab.font = [UIFont systemFontOfSize:22];
    _titleLab.numberOfLines = 0;
    _titleLab.textAlignment = NSTextAlignmentCenter;

    _dateLab = [UILabel new];
    [_scrollView addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCREENWIDTH-15);
        make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(5);
    }];
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.font = [UIFont systemFontOfSize:13];
    _dateLab.textColor = [UIColor grayColor];

    UIView *line = [UIView new];
    [_scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.top.mas_equalTo(_dateLab.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = .3;
    
    WKWebView *webView = [WKWebView new];
    _webView = webView;
    webView.frame = CGRectMake(5, 65,SCREENWIDTH-10, SCREENHEIGHT - 60 - 64);
//    webView.navigationDelegate = self;
    [_scrollView addSubview:webView];
    
    NSLog(@"%@",BaseUrl(NewsDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":NewsDetail,
                           @"paramData":@{@"id" : _newsId}
                           };
    [[ACPNetworkTool getInstance] postDataWithUrl:BaseUrl(NewsDetail) parameters:dict success:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            
            _titleLab.text = responseObject[@"data"][@"news_title"];
            NSString *date = responseObject[@"data"][@"create_time"];
            _dateLab.text = [date insertStandardTimeFormatWithCN];
            NSString *htmlStr = responseObject[@"data"][@"data_content"];
            
            htmlStr = [self htmlEntityDecode:htmlStr];
            
            [webView loadHTMLString:htmlStr baseURL:nil];

        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    NSString *script = [NSString stringWithFormat:
//                        @"var script = document.createElement('script');"
//                        "script.type = 'text/javascript';"
//                        "script.text = \"function ResizeImages() { "
//                        "var img;"
//                        "var maxwidth=%f;"
//                        "for(i=0;i <document.images.length;i++){"
//                        "img = document.images[i];"
//                        "if(img.width > maxwidth){"
//                        "img.width = maxwidth;"
//                        "}"
//                        "}"
//                        "}\";"
//                        "document.getElementsByTagName('head')[0].appendChild(script);", SCREENWIDTH - 20];
//    [webView stringByEvaluatingJavaScriptFromString: script];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//}


//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    string = [string stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:30px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",string];
    
    return htmls;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

//去掉 HTML 字符串中的标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


@end
