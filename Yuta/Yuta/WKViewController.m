//
//  WKViewController.m
//  Yuta
//
//  Created by ZhangBob on 07/04/2017.
//  Copyright © 2017 wallstreetcn.com. All rights reserved.
//

#import "WKViewController.h"
#import "GoldHybridFramework.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WKViewController()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;
@property (nonatomic, strong) WKUserContentController *contentController;
@property (nonatomic, strong) HybridJsBridge *bridge;


@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    
    NSBundle *manager = [NSBundle mainBundle];
    NSString *filePath = [manager pathForResource:@"Yuta" ofType:@"html"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:fileUrl]];

    [self setupToolView];
}

- (void)setupToolView {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBackAction)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForwardAction)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
    
    [toolBar setItems:@[backButton,fixedSpace,
                        forwardButton,fixedSpace,
                        refreshButton] animated:YES];
}

#pragma mark - Tool bar item action

- (void)goBackAction {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)goForwardAction {
    if ([self.wkWebView canGoForward]) {
        [self.wkWebView goForward];
    }
}

- (void)refreshAction {
    [self.wkWebView reload];
}

- (WKWebViewConfiguration *) configuration {
    if (!_configuration) {
        _configuration   = [[WKWebViewConfiguration alloc] init];
        [_configuration setUserContentController:self.contentController];
    }
    return _configuration;
}

- (WKUserContentController *) contentController {
    if (!_contentController) {
        _contentController = [[WKUserContentController alloc] init];
        [_contentController addScriptMessageHandler:self.bridge name:@"__YutaJsBridge"];
    }
    return _contentController;
}

- (WKWebView *) wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20 - 40)
                                        configuration:self.configuration];
        
    }
    return _wkWebView;
}

- (HybridJsBridge *)bridge {
    if (!_bridge) {
        _bridge = [[HybridJsBridge alloc] init];
    }
    return _bridge;
}

- (void)loadWebWithURL:(NSString *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 25.0f;
    [self.wkWebView loadRequest:request];
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.bridge.wkWebView = webView;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
