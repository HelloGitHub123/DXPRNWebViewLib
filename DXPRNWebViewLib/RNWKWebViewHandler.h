//
//  RNWKWebViewHandler.h
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

///创建model 时 必须注意 有返回值的 才能设置返回值，无返回值的 必须 设置为void
@protocol RNJavaScriptExport
@end

@interface RNWKWebViewHandler : NSObject

@property (nonatomic, readonly) id jsExport;

@property (nonatomic, strong) id parentJsExport;

@property (nonatomic, readonly) WKUserContentController *userContent;

- (instancetype)initWithUserContent:(WKUserContentController *)userContent;
///移除所有注册方法
- (void)removeAllMessageHandler;

/// 绑定model，name
/// @param jsExport 绑定model
/// @param name 绑定 名字 用于 js 调用   例 ：name.function
- (void)configureWithJSExport:(id)jsExport bindName:(NSString *)name;

/// js 获取oc返回值    此方法 在    WKUIDelegate 的  runJavaScriptTextInputPanelWithPrompt 方法中调用(必需， 否则js无法获取返回值)
/// @param sel 方法名
/// @param object 参数
- (id)performWithSel:(NSString *)sel withObject:(id)object;

@end

NS_ASSUME_NONNULL_END
