//
//  UILabel+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/8/21.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Chains)

/**
 *  设置行间距
 *
 *  @param space 行间距
 */
- (void)chains_setParagraphStyleWithLineSpace:(CGFloat)space;

/**
 设置关键字颜色
 
 @param color 颜色
 @param text 关键字
 */
- (void)chains_changeTextColor:(UIColor *)color text:(NSString *)text;

/**
 *  Label添加中间线
 *
 *  @param style 中间线风格
 *  @param color 中间线颜色
 */
- (void)chains_drawLineOnTheCenterWithLineStyle:(NSUnderlineStyle)style lineColor:(UIColor *)color;

/**
 *  Label添加下划线
 *
 *  @param style 下划线风格
 *  @param color 下划线颜色
 */
- (void)chains_drawLineOnTheBottomWithLineStyle:(NSUnderlineStyle)style lineColor:(UIColor *)color;


@end
