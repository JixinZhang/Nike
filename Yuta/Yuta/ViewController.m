//
//  ViewController.m
//  Yuta
//
//  Created by ZhangBob on 07/04/2017.
//  Copyright © 2017 wallstreetcn.com. All rights reserved.
//

#import "ViewController.h"
#import "GoldHybridFramework.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) HybridJsBridge *bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    NSBundle *manager = [NSBundle mainBundle];
    NSString *filePath = [manager pathForResource:@"Yuta" ofType:@"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSURL *baseURL = [NSURL fileURLWithPath:manager.bundlePath];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
    NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:baseURL];
    [self setupToolView];
    // Do any additional setup after loading the view, typically from a nib.
    
    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *) webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20 - 40)];
    }
    return _webView;
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
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)goForwardAction {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)refreshAction {
    [self.webView reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.bridge = [[HybridJsBridge alloc] init];
    self.bridge.webView = webView;
    context[@"__YutaJsBridge"] = self.bridge;
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"error = %@", exception);
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
}

@end
