//
//  CommonWebViewController.m
//  NanShaProject
//
//  Created by 马腾飞 on 16/4/11.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "BaseWebViewController.h"
#import <objc/runtime.h>

//#import "XLPhotoBrowser.h"

@interface BaseWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) WKNavigation *backNavigation;
@end

@implementation BaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (@available(iOS 11.0, *))
    {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
   
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    // 进度条监视
    NSLog(@"%f", self.webView.estimatedProgress); // 防止苹果改变属性名时，项目不报错。故这里先打印。
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //处理WKContentView的crash
    [self progressWKContentViewCrash];
    
    if (self.link) [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    if (self.canReachable && self.link) [self requestData];
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self deleteCash];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_link];
    NSLog(@"%@",_link);
    [self.webView loadRequest:request];
}

- (WKWebView *)webView
{
    if (_webView == nil)
    {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        configuration.allowsAirPlayForMediaPlayback = YES;//允许视频播放
        configuration.allowsInlineMediaPlayback = YES;// 允许在线播放
        configuration.selectionGranularity = YES;
//        configuration.suppressesIncrementalRendering = YES;// 是否支持记忆读取
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.bounces = NO;
        [self.view addSubview:_webView];
        
        //隐藏滑动条
        [_webView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)obj setShowsVerticalScrollIndicator:NO];
                [(UIScrollView *)obj setShowsHorizontalScrollIndicator:NO];
            }
        }];
    }
    
    return _webView;
}

- (UIProgressView *)progressView
{
//    if (_progressView == nil)
//    {
//        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 2)];
//        [_progressView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
//        _progressView.progressTintColor = [UIColor chains_colorWithHexString:COLOR_THEME alpha:1];
//        [self.view addSubview:_progressView];
//    }
    return _progressView;
}

//- (void)setModel:(Product *)model
//{
//    _model = model;
//    self.sharedModel = [SharedModel modelWithTitle:model.productName describe:nil images:@[model.img] url:[NSURL URLWithString:URL_Html_ProductDetail_Share(model.alipayItemId)]];
//}

- (void)leftBarButtonClick:(id)sender
{
    if ([_webView canGoBack])
    {
        self.backNavigation = [_webView goBack];
    }
    else
    {
        [super leftBarButtonClick:sender];
    }
}

- (void)deleteCash
{
    NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                    WKWebsiteDataTypeDiskCache,
                                                    //                                                    //WKWebsiteDataTypeOfflineWebApplicationCache,
                                                    WKWebsiteDataTypeMemoryCache,
                                                    //                                                    //WKWebsiteDataTypeLocalStorage,
                                                    //                                                    //WKWebsiteDataTypeCookies,
                                                    //                                                    //WKWebsiteDataTypeSessionStorage,
                                                    //                                                    //WKWebsiteDataTypeIndexedDBDatabases,
                                                    //                                                    //WKWebsiteDataTypeWebSQLDatabases
                                                    ]];
    
//    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 进度条
    if ([@"estimatedProgress" isEqualToString:keyPath]) {
        NSLog(@"%f", self.webView.estimatedProgress);
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        // 初始和终止状态
        if (self.progressView.progress == 1)
        {
//             1秒后隐藏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 再次判断，防止正在加载时隐藏
                if (self.progressView.progress == 1) {
                    self.progressView.progress = 0;
                    self.progressView.hidden = YES;
                }
            });
//            self.progressView.hidden = YES;
        }
        else
        {
            self.progressView.hidden = NO;
        }
    }
}

#pragma mark - WKNavigationDelegate 页面跳转
#pragma mark 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = webView.URL;
    NSLog(@"在发送请求之前，决定是否跳转:%@",url);
    NSLog(@"resourceSpecifier:%@\nscheme:%@\nhost:%@\npath:%@\nquery:%@",[url resourceSpecifier],[url scheme],[url host],[url path],[url query]);
    /**
     *typedef NS_ENUM(NSInteger, WKNavigationActionPolicy) {
     WKNavigationActionPolicyCancel, // 取消
     WKNavigationActionPolicyAllow,  // 继续
     }
     */
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 身份验证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    NSLog(@"身份验证");
    // 不要证书验证
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"在收到响应后，决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}

#pragma mark WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"WKNavigation导航错误");
}

#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"WKWebView终止");
}

#pragma mark - WKNavigationDelegate 页面加载
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
    NSURL *url = webView.URL;
    NSLog(@"%@  开始加载",url);
    NSLog(@"resourceSpecifier:%@\nscheme:%@\nhost:%@\npath:%@\nquery:%@",[url resourceSpecifier],[url scheme],[url host],[url path],[url query]);
    
    
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"当内容开始返回时调用");
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"%@  加载完成",webView.URL);
    
    //回退刷新
//    if ([_backNavigation isEqual:navigation]) {
//        [webView reload];
//        _backNavigation = nil;
//        
//    }
    
    if (!self.webView.loading)
    {
        if([NSString chains_isEmpty:self.title]){
            self.navigationItem.title = webView.title; // 页面标题
        }
        // 上一页按钮和下一页按钮是否可点
//        self.goBackBarButtonItem.enabled = [self.webView canGoBack];
//        self.goForwardBarButtonItem.enabled = [self.webView canGoForward];
    }
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@  加载失败:%@",webView.URL ,error.localizedDescription);
}

#pragma mark - WKUIDelegate
#pragma mark 新建webView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    //解决点击加载新地址崩溃的bug
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark 关闭webView
- (void)webViewDidClose:(WKWebView *)webView
{
    NSLog(@"关闭webView");
}

#pragma mark alert弹出框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"Alert弹出框");
    // 确定按钮
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark Confirm选择框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    NSLog(@"Confirm选择框");
    // 按钮
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 返回用户选择的信息
        completionHandler(NO);
    }];
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOK];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark TextInput输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
    NSLog(@"TextInput输入框");
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    // 确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 返回用户输入的信息
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }]];
    // 显示
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
//WKScriptMessageHandler其实就是一个遵循的协议，它能让网页通过JS把消息发送给OC
//WKUserContentController可以理解为调度器，WKScriptMessage则是携带的数据。
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    // 方法名
    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if ([self respondsToSelector:selector])
    {
        [self performSelector:selector withObject:message.body];
    }
    else
    {
        NSLog(@"未执行方法：%@", methods);
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    
}


/**
 处理WKContentView的crash
 [WKContentView isSecureTextEntry]: unrecognized selector sent to instance 0x101bd5000
 */
- (void)progressWKContentViewCrash
{
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
        BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
            NSLog(@"WKContentView-Crash->修复失败");
        }
    }
}

/**
 实现WKContentView对象isSecureTextEntry方法
 @return NO
 */
BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

/**
 实现WKContentView对象secureTextEntry方法
 @return NO
 */
BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

@end
