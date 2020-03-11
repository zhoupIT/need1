//
//  ZPRootWebViewController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootWebViewController.h"
#import <WebKit/WebKit.h>
#import "ZPLoginController.h"
#import "ZPIndexViewController.h"
#import "ZPNetWorkTool.h"
@interface ZPRootWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)  WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation ZPRootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLoginAction) name:NSStringFromClass([self class]) object:nil];
}

/* 弹出登录界面 */
- (void)needLoginAction {
    ZPLoginController *loginControl = [[ZPLoginController alloc] init];
    [self.navigationController pushViewController:loginControl animated:YES];
}

- (void)initAll {
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    if (self.localHtml) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"product_3"] ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *basePath = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:basePath];
        [self.wkWebView loadHTMLString:htmlString baseURL:baseURL];
    } else {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    [self initWKProgressView];
    ZPLog(@"加载url地址:%@",self.url);
    if (self.initCloseBtn) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        UIBarButtonItem *popItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_close_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
        popItem.imageInsets = UIEdgeInsetsMake(0, -45, 0, 0);
        self.navigationItem.leftBarButtonItem = backItem;
        self.navigationItem.rightBarButtonItem = popItem;
    }
}

- (void)initWKProgressView {
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH,2)];
    [self.view addSubview:self.progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if(self.wkWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

- (void)setWebViewContentInsets:(UIEdgeInsets)webViewContentInsets {
    _webViewContentInsets = webViewContentInsets;
    self.wkWebView.sd_layout.spaceToSuperView(webViewContentInsets);
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [WKWebView new];
    }
    return _wkWebView;
}


- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 返回方法和关闭方法
- (void)back {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    } else {
        [self close];
    }
}

- (void)close {
    if (self.isPsyAssessPage) {
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"assessment/get/report" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        } className:[ZPRootWebViewController class]];
        if (self.infoFilled) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ZPIndexViewController class]]) {
                    ZPIndexViewController *A =(ZPIndexViewController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
