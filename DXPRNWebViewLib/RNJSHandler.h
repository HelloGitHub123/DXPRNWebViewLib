//
//  RNJSHandler.h
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import <Foundation/Foundation.h>
#import "RNWKWebViewHandler.h"
#import "RNBaseWebView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RNZXXE_JavaScriptExport <RNJavaScriptExport>

// 返回到Home首页，如果指定index，则跳转都指定tabbar index
- (void)goBackHomeByTabIndex:(NSString *)paramsStr;
// 返回到当前控制器根目录
- (void)goBackHome;
// 关闭当前H5堆栈
- (void)closePage;
// 隐藏原生导航栏
- (void)hiddenNavigationBar;
// 显示原生导航栏
- (void)showNavigationBar;
// 获取登录信息
- (NSString *)getLoginInfo;
// 有H5登录场景 H5登录成功后把用户信息传递给APP
- (void)setLoginInfo:(id)objStr;
// 调用手机通讯录用户信息
- (NSString *)callContactAddress;
// 打开新的webview控制器
- (void)openAppUrl:(NSString *)objStr;
// 获取定位以及地理位置信息
- (void)getLocation;
// 拍照、从相册 获取图片
- (void)openCamera:(NSString *)objStr;
// 保存和获取、删除H5数据
- (void)setObject:(id)objStr;
- (NSString *)getObject:(id)objStr;
// 调用原生分享功能进行第三方社媒分享
- (void)shareBySystem:(NSString *)url;
// 保存图片到相册
- (void)saveImageToGallery:(NSString *)params;
// 为H5提供是否开启下拉刷新功能
- (void)setPullRefreshEnable:(NSString *)params;
// H5需要APP登录调用。APP原生会跳转或者弹出原生登录页面
- (void)needLogin;
// 打开二维码扫描
- (void)startQrScan;
// 上传文件
- (void)uploadFileType:(NSString *)paramsStr;
// 下载图片base64
- (NSString *)downloadFile:(id)paramsStr;
// 打开系统相机
- (void)openSystemCamera:(NSString *)paramsStr;
// 系统文件选择器
- (void)openFileChooser:(NSString *)paramsStr;
// 打开系统相册
- (void)openAlbum:(NSString *)paramsStr;
// 发邮件
- (void)sendMail:(NSString *)paramsStr;
// 设置手机 状态栏颜色
- (void)changeStatusBarColor:(NSString *)paramsStr;
// 下载小票
- (void)viewReceipt:(NSString *)paramsStr;
// MNP业务流程---app刷新
- (void)refreshCurrentInfoView;
// 二次支付
- (void)paycPaymentForm:(NSString *)paramsStr;
// 监听事件
- (void)postEvents:(NSString *)paramsStr;
// 拍照
- (void)getPicFromCamera;
// 选择文件
- (void)getPicFromFiles;
// 弹出相册选择
- (void)showAlbums;
// 打开地图
- (void)openMapByAddress:(NSString *)paramsStr;
@end

@interface RNJSHandler : NSObject<RNZXXE_JavaScriptExport>

@property (nonatomic, weak) RNBaseWebView *baseWebView;

- (instancetype)initWithView:(RNBaseWebView *)baseWebView;

@end

NS_ASSUME_NONNULL_END
