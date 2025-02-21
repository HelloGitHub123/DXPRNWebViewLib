//
//  WKWebView+RNJSHandler.m
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import "WKWebView+RNJSHandler.h"
#import <objc/runtime.h>

@implementation WKWebView (RNJSHandler)

- (RNWKWebViewHandler *)jsHandler{
    return objc_getAssociatedObject(self, @selector(jsHandler));
}
- (void)setJsHandler:(RNWKWebViewHandler *)jsHandler{
    objc_setAssociatedObject(self, @selector(jsHandler), jsHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
