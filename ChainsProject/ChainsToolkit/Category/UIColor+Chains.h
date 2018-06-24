//
//  UIColor+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/24.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Chains)

/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
+ (UIColor *)chains_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)chains_colorWithHexString:(NSString *)color;

@end
