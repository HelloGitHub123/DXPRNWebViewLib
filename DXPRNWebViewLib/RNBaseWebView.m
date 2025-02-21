//
//  RNBaseWebView.m
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import "RNBaseWebView.h"
#import "WKWebView+RNJSHandler.h"
#import "RNJSHandler.h"
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <DXPToolsLib/HJTool.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define Is_iPhoneX_Or_More ([UIScreen mainScreen].bounds.size.height >= 812)
#define HOME_INDICATOR_HEIGHT       (Is_iPhoneX_Or_More ? 34.f : 0.f)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define isNull(x)                (!x || [x isKindOfClass:[NSNull class]])
#define isEmptyString(x)         (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"] || [x isEqual:@"<null>"])
#define stringFormat(s, ...)     [NSString stringWithFormat:(s),##__VA_ARGS__]

@interface RNBaseWebView () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    WKWebView *_wkWebview;
}

@property (nonatomic, strong) NSString *url_temp; //中间存储url,下拉刷新用到
@property (nonatomic, strong) NSTimer *adTimer;
@property (nonatomic, strong) NSString *paycDefultReturnUrl;

@end

@implementation RNBaseWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = self.bgColor ? self.bgColor : UIColorFromRGB(0xFFFFFF);
                
        [self initUI];
               
//        [self loadWebPage];// 加载页面
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.wkWebview];
    [self.wkWebview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
}

- (void)loadWebPage {
    if (isEmptyString(self.htmlStr)) {
        if (!isEmptyString(self.loadUrl)) {
            self.url_temp = self.loadUrl;
            NSString *url = [self.loadUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            //原生打开H5页面需要带上时间戳参数，避免有缓存，需要判断一下打开的url，如果url上没参数则拼接 ?timestamp=当前时间戳； 如果url上本来有参数，则拼接 &timestamp=当前时间戳
            NSString *timeSp = [NSString stringWithFormat:@"%.0lf", (double)[[NSDate  date] timeIntervalSince1970]*1000];
            NSURLComponents *components = [NSURLComponents componentsWithString:url];
            NSArray<NSURLQueryItem *> *queryItems = [components queryItems];
            if (queryItems.count > 0) {
                url = stringFormat(@"%@&timestamp=%@", url, timeSp);
            } else {
                url = stringFormat(@"%@?timestamp=%@", url, timeSp);
            }
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//            _loadUrl = @"https://react-vant.3lang.dev/~demo";
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_loadUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]];
            [self.wkWebview loadRequest:request];
            
            [self.wkWebview addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
        }
    } else {
//        [self.wkWebview loadHTMLString:[self divWithHtml:self.htmlStr] baseURL:[NSURL URLWithString:[DCNetAPIClient sharedClient].baseUrl]];
        [self.wkWebview loadHTMLString:[self divWithHtml:self.htmlStr] baseURL:nil];
    }
}

// 观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"URL"]) { // 监听URL的变化
        NSLog(@"当前URL-----%@",self.wkWebview.URL.absoluteString);
        self.url_temp = self.wkWebview.URL.absoluteString;
    }
}

#pragma mark - 扫描后调用桥接给H5返回结果
- (void)qRCodeScanning:(NSDictionary *)dic {
    [self.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"getQrInfo" params:dic] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"evaluateJavaScript --- qRCodeScanning");
    }];
}

#pragma mark - sim卡扫描后调用桥接给H5返回结果
- (void)simCodeScanning:(NSDictionary *)dic {
    [self.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"getSimCardNumber" params:dic] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"evaluateJavaScript --- simCodeScanning");
    }];
}

// 刷新当前路由页面下的指定H5页面动作 -- 由App主动调用
- (void)refreshCurrentPageEvent {
    [self.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"reloadPage" params:@{}] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"evaluateJavaScript --- reloadPage");
    }];
}

// 刷新当前页面路由
- (void)refreshCurrentURL {
    if (isEmptyString(self.url_temp)) {
        [self.wkWebview.scrollView.mj_header endRefreshing];
        return;
    }
    NSString *url = [self.url_temp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wkWebview loadRequest:request];
    [self.wkWebview.scrollView.mj_header endRefreshing];
}

#pragma mark -- WKNavigationDelegate 主要处理一些跳转、加载处理操作
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s ---页面开始加载",__func__);
    [HJMBProgressHUD showLoading];
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(closeHud) userInfo:nil repeats:NO];
}

- (void)closeHud {
    [HJMBProgressHUD hideLoading];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s ---页面加载完成",__func__);
    [HJMBProgressHUD hideLoading];
}

// 提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s ---页面加载失败 \n didFailNavigation error:%@",__func__, [error description]);
    [HJMBProgressHUD hideLoading];
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
// 是否允许页面加载 在这个方法里可以对页面跳转进行拦截处理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"正在加载请求--------:%@",urlStr);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if(navigationAction.targetFrame ==nil|| !navigationAction.targetFrame.isMainFrame) {
            [webView loadRequest:navigationAction.request];
            decisionHandler (WKNavigationActionPolicyCancel);
        }else {
            decisionHandler (WKNavigationActionPolicyAllow);
        }
    }
//    else if (navigationAction.navigationType == WKNavigationTypeFormSubmitted) {
//        decisionHandler (WKNavigationActionPolicyCancel);
//
//        NSURLComponents *orginComponents = [NSURLComponents componentsWithURL:navigationAction.request.URL resolvingAgainstBaseURL:NO];
//        NSArray<NSURLQueryItem *> *orginQueryItems = orginComponents.queryItems;
//
//        [self formDataByWebView:webView completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//            NSString *formData = (NSString *)result;
//            NSData *data = [formData dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            if (json.count > 0) {
//                NSURLComponents *components = [NSURLComponents componentsWithURL:navigationAction.request.URL resolvingAgainstBaseURL:NO];
//                NSMutableArray *queryItems = [NSMutableArray array];
//                if (orginQueryItems.count > 0) {
//                    for (NSURLQueryItem *queryItem in orginQueryItems) {
//                        NSString *key = queryItem.name;
//                        NSString *value = queryItem.value;
//                        NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:value];
//                        [queryItems addObject:queryItem];
//                    }
//                }
//                [json enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
//                    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:value];
//                    [queryItems addObject:queryItem];
//                }];
//                [components setQueryItems:queryItems];
//                NSURL *url = [components URL];
//                NSMutableURLRequest *request = [navigationAction.request mutableCopy];
//                [request setURL:url];
//                [webView loadRequest:request];
//            } else {
//                [webView loadRequest:navigationAction.request];
//            }
//        }];
//    }
    else {
//        NSString *relativePath = navigationAction.request.URL.relativePath;
//        if ([relativePath containsString:self.paycDefultReturnUrl] && !isEmptyString(self.paycDefultReturnUrl) && [urlStr containsString:@"MERCHANTID="]) {
//            [self.navigationController popViewControllerAnimated:YES];
//            decisionHandler (WKNavigationActionPolicyCancel);
//        } else {
            decisionHandler (WKNavigationActionPolicyAllow);
//        }
    }
    return;
}

#pragma mark -
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
    }
}

#pragma mark - 执行当前请求中，获取form表单数据
- (void)formDataByWebView:(WKWebView *)webView completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler {
    
    NSString *javascript = @"\
               var form = document.forms[0];\
               var formData = new FormData(form);\
               var data = {};\
               for (var pair of formData.entries()) {\
                   data[pair[0]] = pair[1];\
               }\
               JSON.stringify(data);\
           ";
    [webView evaluateJavaScript:javascript completionHandler:^(id result, NSError *error) {
        completionHandler(result, error);
    }];
}

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [[HJTool currentVC] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
// js 调用 OC 会代理回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
}

// JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if (prompt) {
        id res = [webView.jsHandler performWithSel:prompt withObject:defaultText];
        completionHandler(res);
    }
}

#pragma mark - tools

- (void)setjsHandler:(WKUserContentController *)userContent {
    RNWKWebViewHandler *handler = [[RNWKWebViewHandler alloc] initWithUserContent:userContent];
    [handler configureWithJSExport:[[RNJSHandler alloc] initWithView:self] bindName: @"clp"];
    _wkWebview.jsHandler = handler;
}

- (NSString *)divWithHtml:(NSString *)html {
    html = stringFormat(@"<div>%@</div>", html);
    NSString *strCssHead = [NSString stringWithFormat:@"<head>"
                            "<link rel=\"stylesheet\" type=\"text/css\" href=\"FAQHtmlCss.css\">"
                            "<meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, user-scalable=no\">"
                            "<style>img{max-width:320px !important;}</style>"
                            "</head>"];
    NSString *end = [NSString stringWithFormat:@"%@<body>%@</body>", strCssHead, html];
    return end;
}

- (NSString*)setJsMethodStrWithMethName:(NSString *)jsMethod params:(NSDictionary*)params {
    NSString *method = @"";
    if (params==nil) {
        method = [NSString stringWithFormat:@"%@()",jsMethod];
    }
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        method = [NSString stringWithFormat:@"%@(\'%@\')",jsMethod,string];
        return method;
    }
    return method;
}

// 判断是否ipad
- (BOOL)getIsPad {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

#pragma mark - setter

- (void)setHtmlStr:(NSString *)htmlStr {
    _htmlStr = htmlStr;
    [self loadWebPage];
}

- (void)setLoadUrl:(NSString *)loadUrl {
    _loadUrl = loadUrl;
    [self loadWebPage];
}

- (void)setBgColor:(UIColor *)bgColor {
    if (bgColor) {
        _bgColor = bgColor;
        self.backgroundColor = bgColor;
    }
}

#pragma mark - lazy

- (WKWebView *)wkWebview {
    if (!_wkWebview) {
        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContent;
        WKPreferences *preferences = [WKPreferences new];
        config.preferences = preferences;
        if ([self getIsPad]) {
            config.applicationNameForUserAgent = @"clp,iPad"; // 浏览器设置UA
        } else {
            config.applicationNameForUserAgent = @"clp"; // 浏览器设置UA
        }
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
//        设置请求的User-Agent信息中应用程序名称 iOS9后可用
//        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        _wkWebview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _wkWebview.backgroundColor = [UIColor whiteColor];
        _wkWebview.scrollView.backgroundColor = [UIColor whiteColor];
        _wkWebview.UIDelegate = self;// UI代理
        _wkWebview.navigationDelegate = self;// 导航代理
        _wkWebview.allowsBackForwardNavigationGestures = YES;// 是否支持手势返回上一级
        _wkWebview.opaque = NO;
        _wkWebview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _wkWebview.scrollView.showsHorizontalScrollIndicator = NO;
        _wkWebview.scrollView.showsVerticalScrollIndicator = NO;

//        _wkWebview.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCurrentURL)];
        
//        HJWKWebViewHandler *handler = [[HJWKWebViewHandler alloc] initWithUserContent:userContent];
//        [handler configureWithJSExport:[[HJ_JSHandler alloc] initWithViewController:self] bindName: @"clp"];
//        _wkWebview.hj_jsHandler = handler;
        
        [self setjsHandler:userContent];
        
        if (@available(iOS 11.0, *)) {
            _wkWebview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _wkWebview;
}

@end
