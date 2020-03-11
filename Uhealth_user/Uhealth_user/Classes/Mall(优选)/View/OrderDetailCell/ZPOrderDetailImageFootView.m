//
//  ZPOrderDetailImageFootView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/7/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPOrderDetailImageFootView.h"
#import "WebKitSupport.h"
@interface ZPOrderDetailImageFootView()<UIWebViewDelegate>
@property (nonatomic , strong ) UIWebView *webView; //内容webview
@end
@implementation ZPOrderDetailImageFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化子视图
        
        [self initSubview];
        
        // 设置自动布局
        
        [self configAutoLayout];
    }
    return self;
}
#pragma mark - 初始化子视图

- (void)initSubview{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.delegate = self;
    
    _webView.scrollView.bounces = NO;
    
    _webView.scrollView.bouncesZoom = NO;
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.scrollView.directionalLockEnabled = YES;
    
    _webView.scrollView.scrollEnabled = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.8.8:8083/#/productDetailIos?id=1"]]];
    
    [self addSubview:_webView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    //webview
    
    _webView.sd_layout
    .topSpaceToView(self , 0.0f)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f);
    
    //自适应高度
    
    [self setupAutoHeightWithBottomView:self.webView bottomMargin:0.0f];
    
//    __weak typeof(self) weakSelf = self;
//
//    [self setDidFinishAutoLayoutBlock:^(CGRect rect) {
//
//        if (weakSelf) {
//
//            if (weakSelf.updateHeightBlock) weakSelf.updateHeightBlock(weakSelf);
//        }
//
//    }];
    
}

#pragma mark ————— 给每个Img标签添加JS事件 —————
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *js = @"var imgs = document.getElementsByTagName(\"img\");"
//    "for(var i=0;i<imgs.length;i++){"
//    "  var img = imgs[i];"
//    "  img.onload=function(){window.location.href=('yyjapp://ImgLoaded');}"
//    "}";
//    //yourAppUrlSchemes 是在 info.plist - URL Types里设置的当前URL Schemes
//    [webView stringByEvaluatingJavaScriptFromString:js];
    
    //HTML5的高度
    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    //HTML5的宽度
    NSString *htmlWidth = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"];
    //宽高比
    float i = [htmlWidth floatValue]/[htmlHeight floatValue];
    //webview控件的最终高度
    float height = kSCREEN_WIDTH/i;
    _webView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, height);
    if (self.updateHeightBlock) {
        self.updateHeightBlock(self);
    }
}

#pragma mark =============== 拦截webview的请求，获取网页中最后一个可视元素的位置 ===============
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString *urlString = [[request URL] absoluteString];
//    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
//    NSLog(@"urlString=%@---urlComps=%@",urlString,urlComps);
//    if (urlComps.count==2&&[urlComps[1] isEqualToString:@"ImgLoaded"]) {
//        //imgload 图片加载完成，重新获取高度
//        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
//        //此处我获取的是网页中倒数第三个标签的位置，可以根据要加载的网页结构设定取倒数第几个标签的位置可以代表整个网页高度
//        CGFloat lastHeight =[[_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"body\")[0].children[document.getElementsByTagName(\"body\")[0].children.length-3].offsetTop"] floatValue];
//
//        NSLog(@"webView:%@",NSStringFromCGSize(fittingSize));
//        _webView.frame = CGRectMake(0, 0, fittingSize.width, lastHeight);
//
////        [self.tableView beginUpdates];
////        [self.tableView setTableHeaderView:_webView];
////        [self.tableView endUpdates];
//
//        if (self.updateHeightBlock) {
//            self.updateHeightBlock(self);
//        }
//
//    }
    return YES;
}
@end
