//
//  BaseModel.h
//  Summary
//
//  Created by 马腾飞 on 16/4/27.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

/**
 初始化

 @param dic 数据字典
 @param specialKeyDic 特殊键转换字典（key：属性名称  value：特殊键）
 */
- (instancetype)initWithDic:(NSDictionary *)dic replacedSpecialKeyDic:(NSDictionary *)specialKeyDic;

+ (instancetype)modelWithDic:(NSDictionary *)dic;


/**
 模型转字典
 */
- (NSMutableDictionary *)keyValues;


- (NSDictionary *)propertyClassesByName;

@end
