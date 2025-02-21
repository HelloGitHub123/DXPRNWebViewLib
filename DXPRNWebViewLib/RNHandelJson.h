//
//  RNHandelJson.h
//  AccountManagement
//
//  Created by 胡灿 on 2025/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNHandelJson : NSObject

//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//字典转json
+ (NSString *)convert2JSONWithDictionary:(NSDictionary *)dic;
//数组转json
+ (NSString *)arrayToJSONString:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
