//
//  ZPLectureWebController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLectureWebController.h"
#import <WebKit/WebKit.h>
//#import "NoInputAccessoryView.h"
#import "ZPLoginController.h"
#import "ZPBaseNavigationController.h"
@interface ZPLectureWebController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)  WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation ZPLectureWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllWk];
}


- (void)initAllWk {
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self initWKProgressView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPage)];
//    NoInputAccessoryView *inputAccessoryView = [[NoInputAccessoryView alloc] init];
//    [inputAccessoryView removeInputAccessoryViewFromWKWebView:self.wkWebView];
}

- (void)refreshPage {
    [self.wkWebView reload];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.scheme isEqualToString:@"lecturelogin"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPLectureWebController class]) object:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
}

@end
