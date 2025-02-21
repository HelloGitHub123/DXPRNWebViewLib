//
//  RNBaseWebView.h
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNBaseWebView : UIView

@property (nonatomic, readonly, strong) WKWebView *wkWebview;
@property (nonatomic, strong) NSString *loadUrl; //h5加载
@property (nonatomic, strong) NSString *htmlStr; //html加载
@property (nonatomic, strong) UIColor *bgColor;

// 扫描后调用桥接给H5返回结果
- (void)qRCodeScanning:(NSDictionary *)dic;
// 刷新当前页面路由
- (void)refreshCurrentURL;
// 刷新当前路由页面下的指定H5页面动作 -- 由App主动调用
- (void)refreshCurrentPageEvent;

- (void)simCodeScanning:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
