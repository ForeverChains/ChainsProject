//
//  UIImage+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/1.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Chains)

/**
 *  指定大小等比缩放
 *
 *  @param sourceImage 源文件
 *  @param size        目标大小
 */
+ (UIImage *)chains_compressImageForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 *  指定宽度等比缩放
 *
 *  @param sourceImage 源文件
 *  @param defineWidth 目标宽度
 */
+ (UIImage *)chains_compressImageForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 *  生成纯色背景图
 *
 *  @param color 颜色
 */
+ (UIImage *)chains_imageWithColor:(UIColor *)color;

/**
 *  图片转数据
 */
- (NSData *)chains_transformToData;
    
- (UIImage*)chains_changeAlpha:(CGFloat)alpha;

@end

@interface UIImage (QRCode)

/**
 识别二维码

 @return 二维码内容
 */
- (NSString *)chains_extractQRCode;

+ (UIImage *_Nonnull)chains_codeImageWithString:(NSString *_Nullable)string
                                           size:(CGFloat)width;

+ (UIImage *_Nonnull)chains_codeImageWithString:(NSString *_Nullable)string
                                           size:(CGFloat)width
                                          color:(UIColor *_Nullable)color;

/**
 二维码生成

 @param string 内容
 @param width 二维码宽度
 @param color 二维码颜色
 @param icon 中间图片
 @param iconWidth 中间图片宽度，建议小于二维码宽度的1/4
 @return UIImage
 */
+ (UIImage *_Nonnull)chains_codeImageWithString:(NSString *_Nullable)string
                                           size:(CGFloat)width
                                          color:(UIColor *_Nullable)color
                                           icon:(UIImage *_Nullable)icon
                                      iconWidth:(CGFloat)iconWidth;

@end
