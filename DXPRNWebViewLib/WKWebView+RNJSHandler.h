//
//  WKWebView+RNJSHandler.h
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import <WebKit/WebKit.h>
#import "RNWKWebViewHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (RNJSHandler)

@property (nonatomic, strong) RNWKWebViewHandler *jsHandler;

@end

NS_ASSUME_NONNULL_END
