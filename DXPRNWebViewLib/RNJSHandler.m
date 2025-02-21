//
//  RNJSHandler.m
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import "RNJSHandler.h"
#import "RNHandelJson.h"
#import <DXPToolsLib/HJTool.h>
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <MJRefresh/MJRefresh.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>
#import <AVFoundation/AVFoundation.h>
#import <DXPAnalyticsLib/GoogleAnalyticsManagement.h>
#import <DXPAnalyticsLib/SensorsManagement.h>

#define NSUSER_DEF(a)  [[NSUserDefaults standardUserDefaults] valueForKey:a]

#define isNull(x)                (!x || [x isKindOfClass:[NSNull class]])
#define isEmptyString(x)         (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"] || [x isEqual:@"<null>"])

typedef enum {
    SchemeType_APP = 1,
    SchemeType_WebView_Nav,
    SchemeType_WebView_NoneNav,
    SchemeType_Safari,
    SchemeType_MiniApps, // 小程序
} SchemeType;

typedef enum {
    OpenMode_NewPage = 1,      // 直接打开新页面(不传默认)
    OpenMode_CloseCurrentPage, // 关闭当前页打开新页面
    OpenMode_BackHomeClosePage, // 回APP首页后打开新页面
    OpenMode_OpenNativePage     // 打开新的原生页面
} OpenMode;

@interface RNJSHandler () <UIImagePickerControllerDelegate,UIActionSheetDelegate,UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,QLPreviewControllerDataSource, QLPreviewControllerDelegate>

//@property (nonatomic, weak) BasecurrentVC *currentVC;
@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy) NSString * getPicType;
//@property (nonatomic, strong) HJPhoneNumberView *contact;
// openAppUrl
@property (nonatomic, assign) SchemeType schemeType;
@property (nonatomic, assign) OpenMode openMode;
// 定位
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLLocation *myLocation;
// 小票数据流
@property (nonatomic, strong) NSData *fileData;
// 小票存储路径
@property (nonatomic, strong) NSString *filePath;

// 定位
@property (nonatomic, assign) BOOL isFlag;
@property (nonatomic, copy) NSString *locationType; // 定位类型。
@property (nonatomic, copy) NSString *mapAddressParamsStr; // 地图定位H5参数
@end

@implementation RNJSHandler

- (instancetype)initWithView:(RNBaseWebView *)baseWebView {
    if (self = [super init]) {
        _baseWebView = baseWebView;
        _currentVC = [HJTool currentVC];
    }
    return self;
}

#pragma mark -- 返回到指定堆栈根目录
- (void)goBackHomeByTabIndex:(NSString *)paramsStr {
//    [self.webViewController.navigationController popToRootViewControllerAnimated:YES];
//    if (!isEmptyString(paramsStr)) {
//        NSDictionary *dic = [HJHandelJson dictionaryWithJsonString:paramsStr];
//        NSInteger tabIndex = [[dic objectForKey:@"tabIndex"] integerValue];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//#if IS_CUSTOM_TABBAR
//            DCCustomTabBarController *tabBar = (DCCustomTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//#else
//            DCTabBarController *tabBar = (DCTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//#endif
//            [tabBar setSelectedIndex:tabIndex];
//        });
//    }
}

#pragma mark -- 返回到当前控制器根目录
- (void)goBackHome {
//    [self.webViewController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 返回到当前控制器根目录
- (void)closePage {
//    [self.webViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 隐藏原生导航栏
- (void)hiddenNavigationBar {
//    self.webViewController.isShowNavBar = NO;
//    [self.webViewController refreshWebViewLayout];
//    [self.webViewController.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- 显示原生导航栏
- (void)showNavigationBar {
//    self.webViewController.isShowNavBar = YES;
//    [self.webViewController refreshWebViewLayout];
//    [self.webViewController.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark -- 获取登录信息
- (NSString *)getLoginInfo {
//    NSString *subsId = isEmptyString([HJGlobalDataManager shareInstance].selectedSubsModel.subsId) ? @"" : [HJGlobalDataManager shareInstance].selectedSubsModel.subsId;
//    if (isEmptyString(subsId)) {
//        subsId = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.subsId) ? @"" : [HJGlobalDataManager shareInstance].signInResponseModel.userInfo.subsId;
//    }
//    NSString *phoneNumber = [HJGlobalDataManager shareInstance].currentInfoModel.currentAccNbr;
//    if (isEmptyString(phoneNumber)) {
//        phoneNumber = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.mobile)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.userInfo.mobile;
//    }
////    NSString *custId = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.custId)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.userInfo.custId;
//    NSString *userName = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userName)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userName;
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *userId = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userId)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userId;
//    NSString *email = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.email)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.userInfo.email;
//    NSString *token = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.token)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.token;
//    NSString *partyId = isEmptyString([HJGlobalDataManager shareInstance].identifyUserModel.userId)?@"":[HJGlobalDataManager shareInstance].identifyUserModel.userId;
//    NSString *partyType = isEmptyString([HJGlobalDataManager shareInstance].identifyUserModel.partyType)?@"":[HJGlobalDataManager shareInstance].identifyUserModel.partyType;
//    NSString *prefix = [HJGlobalDataManager shareInstance].isCorporationFlag ? nil : [HJGlobalDataManager shareInstance].selectedSubsModel.prefix;
//    NSString *prefixVal = prefix;
//    if (isEmptyString(prefix)) {
//        prefixVal = _webViewController.prefix;
//    }
//    
//    NSString *custId = isEmptyString([HJGlobalDataManager shareInstance].currentInfoModel.currentCustId)?@"":[HJGlobalDataManager shareInstance].currentInfoModel.currentCustId;
//    
//    NSString *custNbr = isEmptyString([HJGlobalDataManager shareInstance].currentInfoModel.currentCustNbr)?@"":[HJGlobalDataManager shareInstance].currentInfoModel.currentCustNbr;
//    NSString *userCode = isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userCode)?@"":[HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userCode;
//    NSString *paidFlag = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPaidFlag"];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:phoneNumber forKey:@"phone"];
//    [params setValue:prefixVal forKey:@"prefix"];
//    [params setValue:NSUSER_DEF(@"cx_language") forKey:@"language"];
//    [params setValue:custId forKey:@"custId"];
//    [params setValue:userName forKey:@"userName"];
//    [params setValue:userId forKey:@"userId"];
//    [params setValue:@"ios" forKey:@"platform"];
//    [params setValue:subsId forKey:@"subsId"];
//    [params setValue:email forKey:@"email"];
//    [params setValue:version forKey:@"version"];
//    [params setValue:token forKey:@"token"];
//    [params setValue:@"cx" forKey:@"terminalType"];
//    [params setValue:partyType forKey:@"partyType"];
//    [params setValue:partyId forKey:@"partyId"];
//    
//    [params setValue:custNbr forKey:@"custNbr"];
//    [params setValue:userCode forKey:@"userCode"];
//    [params setValue:isEmptyString(paidFlag)?@"":paidFlag forKey:@"paidFlag"];
//    
//    [params setValue:[HJGlobalDataManager shareInstance].currentInfoModel.currentAccNbr forKey:@"currentAccNbr"];
//    [params setValue:NSUSER_DEF(@"deviceId") forKey:@"deviceId"];
//
//    NSString *jsStr = [NSString stringWithFormat:@"%@",[HJHandelJson convert2JSONWithDictionary:params]];
//    if (!isEmptyString(jsStr)) return jsStr;
    return @"";
}

#pragma mark -- 有H5登录场景 H5登录成功后把用户信息传递给APP  APP缓存登录信息
- (void)setLoginInfo:(id)objStr {
//    NSDictionary *dic = [HJHandelJson dictionaryWithJsonString:objStr];
//    
//    HJSignInResponseModel *userModel = [HJSignInResponseModel yy_modelWithDictionary:dic];
//    [HJGlobalDataManager shareInstance].signInResponseModel = userModel;
//    // 设置PB
//#if DXPPageBuildSDKModule
//    DCSignInResponseModel *pb_userModel = [DCSignInResponseModel yy_modelWithDictionary:dic];
//    [DXPPBDataManager shareInstance].signInResponseModel = pb_userModel;
//#endif
//
//    NSString *userInfoModelStr = [HJHandelJson convert2JSONWithDictionary:dic];
//    [[NSUserDefaults standardUserDefaults] setValue:userInfoModelStr forKey:@"userModelInfo"];
//    [[NSUserDefaults standardUserDefaults] setValue:[HJGlobalDataManager shareInstance].signInResponseModel.token forKey:@"DCLoginToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    [DCNetAPIClient userAddRequestHeader:[HJGlobalDataManager shareInstance].signInResponseModel.token forHeadFieldName:@"Token"];
//    [DCNetAPIClient userAddRequestHeader:[HJGlobalDataManager shareInstance].signInResponseModel.token forHeadFieldName:@"authtoken"];
//    
//    NSString *account = @"";
//    if (!isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.email)) {
//        account = [HJGlobalDataManager shareInstance].signInResponseModel.userInfo.email;
//    } else if (!isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userName)) {
//        account = [HJGlobalDataManager shareInstance].signInResponseModel.userInfo.userName;
//    }
//    NSString *deviceToken = [HJGlobalDataManager shareInstance].deviceToken;
//    [[HJGlobalDataManager shareInstance] uploadDeviceInfoWithAppVersion:kVersion_Coding deviceToken:deviceToken os:@"I" osVersion:OS_VERSION appCode:@"cx" userKey:account];
}

#pragma mark -- 调用手机通讯录用户信息
- (NSString *)callContactAddress {
//    WS(weakSelf);
//    [self.contact showContactFinish:^(NSString *number, NSString * name) {
//        NSString *prefix = [HJGlobalDataManager shareInstance].isCorporationFlag ? nil : [HJGlobalDataManager shareInstance].selectedSubsModel.prefix;
//        NSString *prefixVal = prefix;
//        if (isEmptyString(prefix)) {
//            prefixVal = weakSelf.webViewController.prefix;
//        }
//        NSLog(@"js交互选择号码%@",number);
//        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:name];//替换英文", 防止json转换失败
//        [self.webViewController.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"getContactInfo" params:@{@"contactName":[mutableString stringByReplacingOccurrencesOfString:@"\"" withString:@""],@"phoneNumber":number,@"prefix":prefixVal}] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//            NSLog(@"finish");
//        }];
//    }];
    return @"";
}

#pragma mark -- 打开新的路由地址页面
- (void)openAppUrl:(NSString *)objStr {
//    NSDictionary *dic = [HJHandelJson dictionaryWithJsonString:objStr];
//    // 跳转路由
//    NSString *pageUrl = [dic objectForKey:@"url"];
//    // 跳转类型
//    self.schemeType = isEmptyString([dic objectForKey:@"schemaType"])?[[dic objectForKey:@"schemeType"] intValue]:[[dic objectForKey:@"schemaType"] intValue];
//    // 跳转参数
//    NSString *params = [dic objectForKey:@"params"];
//    NSDictionary *paramsDic;
//    if ([params isKindOfClass:[NSDictionary class]]) {
//        paramsDic = (NSDictionary *)params;
//    } else {
//        paramsDic = [HJHandelJson dictionaryWithJsonString:params];
//    }
//    
//    // 跳转后的操作
//    self.openMode = [[dic objectForKey:@"openMode"] intValue];
//    
//    if (!isEmptyString(pageUrl)) {
//        switch (self.schemeType) {
//            case SchemeType_APP: {
//                // 跳转原生页面
//                if ([pageUrl isEqualToString:@"/tm_app/home"]) {
//                    //这个要跳转首页
//                    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//                    [param setValue:[HJGlobalDataManager shareInstance].currentInfoModel.userInfo.email forKey:@"loginAccount"];
//                    [param setValue:@"" forKey:@"currentAccNbr"];
//                    [[DCNetAPIClient sharedClient] POST:KCurrentInfoUrl paramaters:param CompleteBlock:^(id res, NSError *error) {
//                        if (!error && !isNull([res objectForKey:@"data"]) && [HTTP_Code isEqualToString:HTTP_Success]) {
//                            NSUSER_DEF_SET([HJGlobalDataManager shareInstance].currentInfoModel.userInfo.email, @"User_Login_Account");
//                            [HJGlobalDataManager shareInstance].currentInfoModel = [DCCurrentInfoModel yy_modelWithDictionary:HTTP_Data];
//                            NSDictionary * userInfo = [HTTP_Data objectForKey:@"userInfo"];
//                            [HJGlobalDataManager shareInstance].currentInfoModel.userInfo = [DCCurrentUserInfoModel yy_modelWithDictionary:userInfo];
////                            [[HJGlobalDataManager shareInstance] queryDataAfterLoginSuccess];
//                            [[HJGlobalDataManager shareInstance] queryDataWhenInHomePage];
//                            
//                            [self reporteBehaviorAnalysisWithAccount:[HJGlobalDataManager shareInstance].currentInfoModel.userInfo.email
//                                                           isSuccess:YES
//                                                          failReason:@""];
//                        }
//                    }];
//                } else if ([pageUrl containsString:@"/clp_purchase/index"]) {
//                    BaseViewController *vc = (BaseViewController *)[[HJRouterManager sharedInstance] getViewController:@"/clp_purchase/index"];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    NSDictionary *dic = [HJTool getParamsWithUrlString:pageUrl];
//                    NSString *tab = dic && !isEmptyString([dic objectForKey:@"tab"])?[dic objectForKey:@"tab"]:@"";
//                    NSString *fromofferid = dic && !isEmptyString([dic objectForKey:@"fromofferid"])?[dic objectForKey:@"fromofferid"]:@"";
//                    [vc.paramsDic setValue:tab forKey:@"tab"];
//                    [vc.paramsDic setValue:fromofferid forKey:@"fromofferid"];
//                    [self.webViewController.navigationController pushViewController:vc animated:YES];
//                } else {
//                    BaseViewController *baseVC = [[HJRouterManager sharedInstance] getViewController:pageUrl];
//                    if (baseVC) {
//                        if ([paramsDic allKeys].count > 0) {
//                            if (baseVC && [baseVC isKindOfClass:[BaseViewController class]]) {
//                                baseVC.paramsDic = paramsDic;
//                            }
//                        }
//                        baseVC.returnValue = ^(NSString * _Nonnull string) {
//                            if ([pageUrl containsString:@"/sim/activate"]) {
//                                if (isEmptyString(string)) {
//                                    [self.webViewController simCodeScanning:@{@"result":@"cancel", @"iccid":@""}];
//                                } else {
//                                    [self.webViewController simCodeScanning:@{@"result":@"success", @"iccid":string}];
//                                }
//                            }
//                        };
//                        if (OpenMode_CloseCurrentPage == self.openMode) {
//                            [_webViewController.navigationController pushViewController:baseVC animated:YES];
//                            _webViewController.isFinishPreviousWebview = YES;
//                        } else if (OpenMode_BackHomeClosePage == self.openMode) {
//                            [self.webViewController.navigationController pushViewController:baseVC animated:YES];
//                            NSArray *vcArray = self.webViewController.navigationController.viewControllers;
//                            [self.webViewController.navigationController setViewControllers:@[vcArray.firstObject, vcArray.lastObject]];
//                        } else {
//                            [self.webViewController.navigationController pushViewController:baseVC animated:YES];
//                        }
//                    }
//                }
//            }
//                break;
//            case SchemeType_WebView_Nav: {
//                // 默认带导航栏WebView
//                BaseWebViewController *baseViewVC = [[BaseWebViewController alloc] init];
//                baseViewVC.loadUrl = pageUrl;
//                baseViewVC.hidesBottomBarWhenPushed = YES;
//                baseViewVC.isShowNavBar = YES;
//                if ([paramsDic allKeys].count > 0) {
//                    baseViewVC.paramsDic = paramsDic;
//                }
//                if (OpenMode_CloseCurrentPage == self.openMode) {
//                    self.webViewController.isFinishPreviousWebview = YES;
//                    [self.webViewController.navigationController pushViewController:baseViewVC animated:YES];
//                } else if (OpenMode_BackHomeClosePage == self.openMode) {
//                    [self.webViewController.navigationController pushViewController:baseViewVC animated:YES];
//                    NSArray *vcArray = self.webViewController.navigationController.viewControllers;
//                    [self.webViewController.navigationController setViewControllers:@[vcArray.firstObject, vcArray.lastObject]];
//                } else {
//                    [self.webViewController.navigationController pushViewController:baseViewVC animated:YES];
//                }
//            }
//                break;
//            case SchemeType_WebView_NoneNav: {
//                // 不带导航栏WebView
//                BaseWebViewController *baseViewVC = [[BaseWebViewController alloc] init];
//                baseViewVC.loadUrl = pageUrl;
//                baseViewVC.hidesBottomBarWhenPushed = YES;
//                if ([paramsDic allKeys].count > 0) {
//                    baseViewVC.paramsDic = paramsDic;
//                }
//                if (OpenMode_CloseCurrentPage == self.openMode) {
//                    self.webViewController.isFinishPreviousWebview = YES;
//                    [self.webViewController.navigationController pushViewController:baseViewVC animated:YES];
//                } else if (OpenMode_BackHomeClosePage == self.openMode) {
//                    [self.webViewController.navigationController pushViewController:baseViewVC animated:YES];
//                    NSArray *vcArray = self.webViewController.navigationController.viewControllers;
//                    [self.webViewController.navigationController setViewControllers:@[vcArray.firstObject, vcArray.lastObject]];
//                } else {
//                    [self.webViewController.navigationController pushViewController:baseViewVC animated:YES];
//                }
//            }
//                break;
//            case SchemeType_Safari: {
//                if (OpenMode_CloseCurrentPage == self.openMode) {
//                    self.webViewController.isFinishPreviousWebview = YES;
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pageUrl] options:@{} completionHandler:^(BOOL success) {
//                    }];
//                } else if (OpenMode_BackHomeClosePage == self.openMode) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pageUrl] options:@{} completionHandler:^(BOOL success) {
//                    }];
//                    NSArray *vcArray = self.webViewController.navigationController.viewControllers;
//                    [self.webViewController.navigationController setViewControllers:@[vcArray.firstObject]];
//                } else {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pageUrl] options:@{} completionHandler:^(BOOL success) {
//                    }];
//                }
//                
//            }
//                break;
//            case SchemeType_MiniApps: {
//            }
//                break;
//            default:
//                break;
//        }
//    }
}

#pragma mark -- 获取定位以及地理位置信息
- (void)getLocation {
    self.locationType = @"getLocation";
    [self startLocation];
}

// 开始定位
- (void)startLocation {
    self.isFlag = NO;
    
    // 初始化定位管理者
    self.locationManager = [[CLLocationManager alloc] init];
    // 判断设备是否能够进行定位
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        // 精确度获取到米
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        // 取得定位权限
        [self.locationManager requestWhenInUseAuthorization];
        // 开始获取定位
        [self.locationManager startUpdatingLocation];
        // 地理信息
        self.geoCoder = [[CLGeocoder alloc] init];
    } else {
        NSLog(@"error");
    }
}

// CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%lu", (unsigned long)locations.count);
    
    if (self.isFlag) { // 防止多次调用
        return;
    }
    self.isFlag = YES;
    
    self.myLocation = locations.lastObject;
    NSLog(@"经度:%f 维度:%f", _myLocation.coordinate.longitude, _myLocation.coordinate.latitude);
    if ([self.locationType isEqualToString:@"openMapByAddress"]) {
        // 导航
        [self.locationManager stopUpdatingLocation];
        [self navigatorGoogleMapPlaceWithCoordinate2D:_myLocation.coordinate];
        return;
    }
    
    [self.geoCoder reverseGeocodeLocation:self.myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placeMark.name);
            NSString *city = placeMark.locality;
            if (!city) {
                city = placeMark.administrativeArea;
            }
            NSString *name = isEmptyString(placeMark.name)? @"" : placeMark.name;
            NSString *thoroughfare = isEmptyString(placeMark.thoroughfare) ? @"" : placeMark.thoroughfare;
            NSString *subThoroughfare = isEmptyString(placeMark.subThoroughfare) ? @"": placeMark.subThoroughfare;
            NSString *locality = isEmptyString(placeMark.locality) ? @"": placeMark.locality;
            NSString *subLocality = isEmptyString(placeMark.subLocality) ? @"" : placeMark.subLocality;
            NSString *country = isEmptyString(placeMark.country) ? @"" : placeMark.country ;
            NSLog(@"位置名称:%@,街道:%@,子街道:%@,市:%@,区:%@,国家:%@",name,thoroughfare,subThoroughfare,locality,subLocality,country);
        
            [self.baseWebView.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"setLocation" params:@{@"lat":[NSNumber numberWithDouble:self.myLocation.coordinate.latitude],@"lng":[NSNumber numberWithDouble:self.myLocation.coordinate.longitude],@"name":name,@"thoroughfare":thoroughfare,@"subThoroughfare":subThoroughfare,@"locality":locality,@"subLocality":subLocality,@"country":country}] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                NSLog(@"地址反馈完成");
            }];
            
        } else if (error == nil && [placemarks count] == 0) {
            // 未查找到结果
            NSLog(@"未查找到结果");
        } else if (error != nil) {
            // error
            NSLog(@"出错:%@",error);
        }
        [self.locationManager stopUpdatingLocation];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"出错:%@",error);
}

#pragma mark -- 拍照、从相册 获取图片
- (void)openCamera:(NSString *)objStr {
    if (isEmptyString(objStr)) {
        self.getPicType = @"";
    } else {
        self.getPicType = objStr;
    }
    [self showPhotosActionSheet];
}

// 展示对应的弹框
- (void)showPhotosActionSheet {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    // 弹出图片获取方式弹框
    UIAlertController *action = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*self)weakSelf = self;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Albums" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showAlbums];
    }];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf getPicFromCamera];
    }];
    
    UIAlertAction *filesAction = [UIAlertAction actionWithTitle:@"Files" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf getPicFromFiles];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [action addAction:photoAction];
    [action addAction:takePhotoAction];
    [action addAction:cancelAction];
    [weakSelf.currentVC presentViewController:action animated:YES completion:nil];
}

- (void)getPicFromCamera {
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
    }
    self.getPicType = isEmptyString(self.getPicType)?@"":self.getPicType;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    [[HJTool currentVC] presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)getPicFromFiles{
    
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];

    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self.currentVC presentViewController:documentPickerViewController animated:YES completion:nil];
}


// 弹出相册选择
- (void)showAlbums {
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
    }
    self.getPicType = isEmptyString(self.getPicType)?@"":self.getPicType;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // [self.webViewController presentViewController:self.imagePicker animated:YES completion:nil];
    [[HJTool currentVC] presentViewController:self.imagePicker animated:YES completion:nil];
}

//获取选择的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //调整最大1m
    UIImage *resultImage = [UIImage imageWithData: [self reSizeImageData:image maxImageSize:10000 maxSizeWithKB:1024.0]];
    if (resultImage) {
        // 处理选中的图片
        NSData *imgData = UIImageJPEGRepresentation(image, 0.2);
        NSString *base64Str = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *base64StrWithHeader = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",base64Str];
        // 去除特殊字符
        base64StrWithHeader = [base64StrWithHeader stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        base64StrWithHeader = [base64StrWithHeader stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        [self.baseWebView.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"getSelectFile" params:@{@"type":self.getPicType,@"fileBase64":base64StrWithHeader,@"fileName":@"",@"code":@"200",@"fileSuffix":@"jpeg",@"businessType":@""}] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"发送H5完成");
        }];
    } else {
        [self.baseWebView.wkWebview evaluateJavaScript:[self setJsMethodStrWithMethName:@"getSelectFile" params:@{@"type":self.getPicType,@"fileBase64":@"",@"fileName":@"",@"code":@"502",@"fileSuffix":@"jpeg",@"businessType":@""}] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"发送H5完成");
        }];
        NSLog(@"获取图片出错");
    }
}

#pragma mark -- UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
    //获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            //读取文件
//            _fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            if (!error) {
//                [self uploadFileWithData:fileData];
            }
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
    }
}

#pragma mark -- 保存和获取、删除H5数据
- (void)setObject:(id)objStr {
    NSDictionary *parmas = [RNHandelJson dictionaryWithJsonString:objStr];
    if ([parmas allKeys] == 0) {
        return;
    }
    NSArray *keys = [parmas allKeys];
    NSArray *values = [parmas allValues];
    for (int i = 0; i< keys.count; i++) {
        NSString *strKey = [keys objectAtIndex:i];
        if (isEmptyString(strKey)) {
            continue;
        }
        NSString *strVal = [values objectAtIndex:i];
        // 持久化保存数据
        [[NSUserDefaults standardUserDefaults] setObject:isEmptyString(strVal)?@"":strVal forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)getObject:(id)objStr {
    if (isEmptyString(objStr)) {
        return @"";
    }
    NSString *listValue = [[NSUserDefaults standardUserDefaults] objectForKey:objStr];
    return isEmptyString(listValue)?@"":listValue;
}

#pragma mark -- 调用原生分享功能进行第三方社媒分享
- (void)shareBySystem:(NSString *)url {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:url];
    if ([parmasDic allKeys] == 0) {
        return;
    }
    // 图片链接
    NSString *shareImageUrl = isEmptyString([parmasDic objectForKey:@"shareImageUrl"])?@"":[parmasDic objectForKey:@"shareImageUrl"];
    // 链接
    NSString *shareLink = isEmptyString([parmasDic objectForKey:@"shareLink"])?@"":[parmasDic objectForKey:@"shareLink"];
    // 内容
    NSString *shareContent = isEmptyString([parmasDic objectForKey:@"shareContent"])?@"":[parmasDic objectForKey:@"shareContent"];
    
    // 判断分享的图片
    NSArray *activityItems = @[];
    if (!isEmptyString(shareImageUrl)) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[parmasDic objectForKey:@"shareImageUrl"]]];
        if (data) {
            UIImage *result = [UIImage imageWithData:data];
            UIImage *imageToShare = result;
            activityItems = @[shareContent, imageToShare, shareLink];
        } else {
            activityItems = @[shareContent, shareLink];
        }
    } else {
        if(!isEmptyString(shareContent)) {
            activityItems = @[shareContent, shareLink];
        } else {
            activityItems = @[shareLink];
        }
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self.currentVC presentViewController:activityVC animated:YES completion:nil];
    //分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
        } else  {
            NSLog(@"cancled");
        }
    };
}

#pragma mark -- 保存图片到相册
- (void)saveImageToGallery:(NSString *)params {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:params];
    if ([parmasDic allKeys] == 0) {
        return;
    }
    NSString *imagebase64 = [parmasDic objectForKey:@"imagebase64"];
    if (isEmptyString(imagebase64)) {
        return;
    }
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imagebase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *photo = [UIImage imageWithData:imageData];
    [self saveImageToPhotos:photo];
}

- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 保存图片到相册 -- 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = nil ;
    if (error != NULL) {
        msg = @"保存图片失败";
    } else {
        msg = @"保存图片成功";
    }
}

#pragma mark -- 为H5提供是否开启下拉刷新功能
- (void)setPullRefreshEnable:(NSString *)params {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:params];
    if ([parmasDic allKeys] == 0) {
        return;
    }
    NSString *flag = [parmasDic objectForKey:@"isEnable"];
    if ([[flag lowercaseString] isEqualToString:@"true"]) {
        // 添加下拉刷新
        self.baseWebView.wkWebview.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 刷新当前路由
            [self.baseWebView refreshCurrentURL];
        }];
    } else {
        // 去掉头部下拉刷新
        self.baseWebView.wkWebview.scrollView.mj_header = nil;
    }
}

#pragma mark -- H5需要APP登录调用。APP原生会跳转或者弹出原生登录页面
- (void)needLogin {
//    if (isEmptyString([HJGlobalDataManager shareInstance].signInResponseModel.token)) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoLoginVCNotification" object:nil];
//    }
}

#pragma mark -- 打开二维码扫描
- (void)startQrScan {
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    if (device) {
//        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        switch (status) {
//            case AVAuthorizationStatusNotDetermined: {
//                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                    if (granted) {
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            [self tapQRcodeAction];
//                        });
//                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
//                    } else {
//                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
//                    }
//                }];
//                break;
//            }
//            case AVAuthorizationStatusAuthorized: {
//                [self tapQRcodeAction];
//                break;
//            }
//            case AVAuthorizationStatusDenied: {
//                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"To control access to Camera:" message:@"1. Tap on iOS Settings. \n2. Scroll down and tap on Privacy. \n3. Tap on Camera.\n4. Tap on DITO app." preferredStyle:(UIAlertControllerStyleAlert)];
//                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }];
//                
//                [alertC addAction:alertA];
//                [self.webViewController presentViewController:alertC animated:YES completion:nil];
//                break;
//            }
//            case AVAuthorizationStatusRestricted: {
//                NSLog(@"Unable to access the album due to system reasons");
//                break;
//            }
//                
//            default:
//                break;
//        }
//        return;
//    }
//    
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"tips" message:@"This feature requires camera access.In iPhone settings, tap DITO and turn on Camera." preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    [alertC addAction:alertA];
//    [self.webViewController presentViewController:alertC animated:YES completion:nil];
}

//- (void)tapQRcodeAction {
//    ZFScanViewController * vc = [[ZFScanViewController alloc] init];
//    vc.returnScanBarCodeValue = ^(NSString * barCodeString){
//        //扫描完成后，在此进行后续操作
//        NSLog(@"扫描结果======%@",barCodeString);
//        [self.webViewController qRCodeScanning:@{@"result":barCodeString}];
//    };
//    
//    [self.webViewController presentViewController:vc animated:YES completion:nil];
//}

#pragma mark -- 上传文件
- (void)uploadFileType:(NSString *)paramsStr {
    
}

#pragma mark -- 下载图片base64
- (NSString *)downloadFile:(id)paramsStr {
    NSDictionary *fileData = [NSDictionary dictionary];
    if ([paramsStr isKindOfClass:[NSDictionary class]]) {
        fileData = paramsStr;
    } else {
        fileData = [RNHandelJson dictionaryWithJsonString:paramsStr];
    }
    if ([fileData allKeys] == 0) {
        return @"";
    }
    // 参数解析
    NSString *url = [fileData objectForKey:@"url"];
    NSString *contentDisposition = [fileData objectForKey:@"contentDisposition"];
    NSString *mimeType = [fileData objectForKey:@"mimeType"];
    NSString *base64 = [fileData objectForKey:@"base64"];
    if ([[mimeType lowercaseString] containsString:@"png"]
        || [[mimeType lowercaseString] containsString:@"jpg"]
        || [[mimeType lowercaseString] containsString:@"jpeg"]) {
        // 图片
        if (!isEmptyString(base64)) {
            NSString *imgBase64 = base64;
            if ([base64 containsString:@"data:image/png;base64,"]) {
                imgBase64 = [base64 stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
            }
            [self saveTextureToLocal:imgBase64];
        }
    } else {
        // 文件
        
    }
    return [RNHandelJson convert2JSONWithDictionary:@{@"code":[NSNumber numberWithInteger:200]}];
}

// 保存base64文件到相册
- (void)saveTextureToLocal:(NSString*)imgBase64 {
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imgBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
};

#pragma mark -- 打开系统相机
- (void)openSystemCamera:(NSString *)paramsStr {
    [self getPicFromCamera];
}

#pragma mark -- 系统文件选择器
- (void)openFileChooser:(NSString *)paramsStr {
    [self getPicFromFiles];
}

#pragma mark -- 打开系统相册
- (void)openAlbum:(NSString *)paramsStr {
    [self showAlbums];
}

#pragma mark -- 打开地图
// openMapByAddress('{"longitude":"" "latitude":"", " displayAddr":"address"}')
- (void)openMapByAddress:(NSString *)paramsStr {
    if (isEmptyString(paramsStr)) {
        return;
    }
    self.mapAddressParamsStr = paramsStr;
    // 定位当前位置地址
    self.locationType = @"openMapByAddress";
    [self startLocation];
}

#pragma mark -- 谷歌地图导航
- (void)navigatorGoogleMapPlaceWithCoordinate2D:(CLLocationCoordinate2D)myLocation {
    if (isEmptyString(self.mapAddressParamsStr)) {
        return;
    }
    NSDictionary *dic = [RNHandelJson dictionaryWithJsonString:self.mapAddressParamsStr];
    NSString *longitude = [dic valueForKey:@"longitude"];
    NSString *latitude = [dic valueForKey:@"latitude"];
    NSString *displayAddr = [dic valueForKey:@"displayAddr"];
    
    // 检查本地是否安装了谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        // 优先判断打开经纬度。如果没有则打开地址信息
        if (!isEmptyString(longitude) && !isEmptyString(latitude)) {
            // 打开经纬度
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航",@"nav123456",latitude, longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            // 打开谷歌地图
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                
            }];

        } else if (!isEmptyString(displayAddr)) {
            // 根据地址信息打开
            NSString *urlString = [[NSString stringWithFormat:@"https://www.google.com/maps/dir/?api=1&origin=%f,%f&destination=%@", myLocation.latitude,myLocation.longitude,displayAddr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            // 打开谷歌地图
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
            }];
        }
    } else {
        // 未安装谷歌地图
        NSLog(@"未安装谷歌地图");
        // 优先判断打开经纬度。如果没有则打开地址信息
        if (!isEmptyString(longitude) && !isEmptyString(latitude)) {
            
            NSString *urlString = [[NSString stringWithFormat:@"https://www.google.com/maps/dir/?api=1&origin=%f,%f&destination=%@,%@", myLocation.latitude,myLocation.longitude,latitude,longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            // 打开谷歌地图
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else if (!isEmptyString(displayAddr)) {
            // 根据地址信息打开
            NSString *urlString = [[NSString stringWithFormat:@"https://www.google.com/maps/dir/?api=1&origin=%f,%f&destination=%@", myLocation.latitude,myLocation.longitude,displayAddr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            // 打开谷歌地图
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
            }];
        }
    }
}

#pragma mark -- 发邮件
- (void)sendMail:(NSString *)paramsStr {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:paramsStr];
    if ([parmasDic allKeys] == 0) {
        return;
    }
    NSString *emailAddress = isEmptyString([parmasDic objectForKey:@"emailAddress"])?@"":[parmasDic objectForKey:@"emailAddress"]; // 指定发送邮箱地址
    NSString *emailSubject = isEmptyString([parmasDic objectForKey:@"emailSubject"])?@"":[parmasDic objectForKey:@"emailSubject"]; // 邮件主题
    NSString *emailContent = isEmptyString([parmasDic objectForKey:@"emailContent"])?@"":[parmasDic objectForKey:@"emailContent"]; // 邮件正文
    
    //先验证邮箱能否发邮件，不然会崩溃
    if (![MFMailComposeViewController canSendMail]) {
        NSURL *url = [NSURL URLWithString:@"mailto://"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        }
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    // 设置picker的委托方法，完成之后会自动调用成功或失败的方法
    picker.mailComposeDelegate = self;
    // 添加主题
    [picker setSubject:emailSubject];
    // 内容
    [picker setMessageBody:emailContent isHTML:NO];
    //收件人邮箱，使用NSArray指定多个收件人
    NSArray *toRecipients = [NSArray arrayWithObject:emailAddress];
    [picker setToRecipients:toRecipients];
    [self.currentVC.navigationController presentViewController:picker animated:YES completion:nil];
}

// 代理
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    NSLog(@"send mail error:%@", error);
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件发送取消");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件保存成功");
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件发送成功");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        default:
            NSLog(@"邮件未发送");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 设置手机 状态栏颜色
- (void)changeStatusBarColor:(NSString *)paramsStr {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:paramsStr];
    if ([parmasDic allKeys] == 0) {
        return;
    }
    // 状态栏颜色 #FFFFFF
    NSString *color = [parmasDic objectForKey:@"color"];
    // status  1 深色模式  0 浅色模式
    NSString *status = [parmasDic objectForKey:@"status"];
    
    if (!isEmptyString(color)) {
        [self setStatusBarBackgroundColor:[self hjp_colorWithHex:@"#2A2F38" alpha:1]];
    }
    // status  1 深色模式  状态栏背景色是深色时设置 状态栏 字体颜色会是白的
    if ([status isEqualToString:@"1"]) {
        
    }
    // status  0 浅色模式  状态栏背景色是深色时设置 状态栏 字体颜色会是黑的
    if ([status isEqualToString:@"1"]) {
        
    }
}

// 设置状态栏背景色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        static UIView *statusBar =nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                statusBar.backgroundColor= color;
            });
        } else {
            statusBar.backgroundColor= color;
        }
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}

#pragma mark -- 下载小票
- (void)viewReceipt:(NSString *)paramsStr {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:paramsStr];
    NSString *transSN = [parmasDic objectForKey:@"transSN"];
    NSString *transType = [parmasDic objectForKey:@"transType"];
    NSString *accNbr = [parmasDic objectForKey:@"accNbr"];
    // 判空
//    if (isEmptyString(transSN) || isEmptyString(transType)) {
//        return;
//    }
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:transSN forKey:@"transSN"];
    [parmas setValue:transType forKey:@"transType"];
    [parmas setValue:accNbr forKey:@"accNbr"];

    [DCNetAPIClient sharedClient].httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];//特殊处理：返回的是二进制字节流，不能以json接受
    [[DCNetAPIClient sharedClient] POST:@"/ecare/common/down-receipt" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        [DCNetAPIClient sharedClient].httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        if (!error) {
            self.fileData = res;
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *timeSp = [NSString stringWithFormat:@"%.0lf", (double)[[NSDate  date] timeIntervalSince1970]*1000];
            self.filePath = [NSString stringWithFormat:@"%@/%@.pdf",path,timeSp];
            [res writeToFile:self.filePath atomically:YES];
            // 预览
            QLPreviewController *qlvc = [[QLPreviewController alloc] init];
            qlvc.dataSource = self;
            qlvc.delegate = self;
            [self.currentVC.navigationController presentViewController:qlvc animated:YES completion:nil];
        } else {
        }
    }];
}

#pragma mark - QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [NSURL fileURLWithPath:self.filePath];//本地file中的url
}

-(void)previewControllerDidDismiss:(QLPreviewController *)controller {
}

#pragma mark --  MNP业务流程---app刷新
- (void)refreshCurrentInfoView {
//    [HJGlobalDataManager shareInstance].isMNP = YES;
}

#pragma mark -- 二次支付
- (void)paycPaymentForm:(NSString *)paramsStr {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:paramsStr];
    NSString *urlOrHtml = [parmasDic objectForKey:@"urlOrHtml"];
    
    RNBaseWebView *webView = [[RNBaseWebView alloc] init];
    if ([HJTool checkUrlWithString:urlOrHtml]) {
        webView.loadUrl = urlOrHtml;
    } else {
        webView.htmlStr = urlOrHtml;
    }
}

//监听事件
- (void)postEvents:(NSString *)paramsStr {
    NSDictionary *parmasDic = [RNHandelJson dictionaryWithJsonString:paramsStr];
    NSString *eventName = [parmasDic objectForKey:@"eventName"];
    if ([eventName isEqualToString:@"PAYMENT_SUCCESS"]) {
        Class packageClass = NSClassFromString(@"DCPackageOrderConfirmViewController");
        Class familyPlanClass = NSClassFromString(@"DCFamilyPlanOrderConfirmViewController");
        Class changePlanClass = NSClassFromString(@"DCChangePlanOrderConfirmViewController");
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.currentVC.navigationController.viewControllers];
        NSInteger index = 0;
        for (UIViewController *vc in vcArray) {
            if ([vc isKindOfClass:[packageClass class]] || [vc isKindOfClass:[familyPlanClass class]] || [vc isKindOfClass:[changePlanClass class]]) {
                index = [vcArray indexOfObject:vc];
                break;
            }
        }
        if (index > 0 && (index+1 <= vcArray.count)) {
            NSArray *subArray = [vcArray subarrayWithRange:NSMakeRange(0, index+1)];
            [self.currentVC.navigationController setViewControllers:subArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getNewBalance" object:nil];
        }
    }
}

#pragma mark -- other
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
    if ([params isKindOfClass:[NSString class]]) {
        method = [NSString stringWithFormat:@"%@(\'%@\')",jsMethod,params];
        return method;
    }
    return method;
}

#pragma mark -- other
// 压缩图片
- (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize {

    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}

// 可变透明度的Hex方法
- (UIColor *)hjp_colorWithHex:(NSString *)hex alpha:(float)alpha
{
    NSString *colorString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 十六进制色值必须是6-8位
    if (colorString.length >= 6  && colorString.length  <= 8)
    {
        if ([colorString hasPrefix:@"0x"] || [colorString hasPrefix:@"0X"])
            colorString = [colorString substringFromIndex:2];
        else if ([colorString hasPrefix:@"#"])
            colorString = [colorString substringFromIndex:1];
        if (colorString.length != 6)
            return [UIColor clearColor];
    }
    else
        return [UIColor clearColor];
    
    // 将6位十六进制色值分成R、G、B
    NSRange redRange    = NSMakeRange(0, 2);
    NSRange greenRange  = NSMakeRange(2, 2);
    NSRange blueRange   = NSMakeRange(4, 2);
    NSString *redString     = [colorString substringWithRange:redRange];
    NSString *greenString   = [colorString substringWithRange:greenRange];
    NSString *blueString    = [colorString substringWithRange:blueRange];
    
    // 将RGB对应的十六进制色值转化位十进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redString]    scanHexInt:&r];
    [[NSScanner scannerWithString:greenString]  scanHexInt:&g];
    [[NSScanner scannerWithString:blueString]   scanHexInt:&b];
    
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:alpha];
}

#pragma mark -- lazy load
//- (HJPhoneNumberView *)contact {
//    if (!_contact) {
//        _contact =[[HJPhoneNumberView alloc] init] ;
//    }
//    return  _contact;
//}

- (void)reporteBehaviorAnalysisWithAccount:(NSString *)account isSuccess:(BOOL)isSuccess failReason:(NSString *)failReason {
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:@"" forKey:@"phoneNum"];
    [parmas setValue:account forKey:@"email"];
    [parmas setValue:@"SMS" forKey:@"loginMethod"];
    [parmas setValue:@(isSuccess) forKey:@"isSuccess"];
    [parmas setValue:failReason forKey:@"failReason"];

    [[SensorsManagement sharedInstance] trackWithName:@"LoginApp" withProperties:parmas];
    [[GoogleAnalyticsManagement sharedInstance] logEventWithName:@"LoginApp" withProperties:parmas];
}



@end
