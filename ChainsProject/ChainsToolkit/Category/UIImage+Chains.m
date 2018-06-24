//
//  UIImage+Chains.m
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/1.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import "UIImage+Chains.h"

@implementation UIImage (Chains)

+ (UIImage *)chains_compressImageForSize:(UIImage *)sourceImage targetSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)chains_compressImageForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)chains_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSData *)chains_transformToData
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    if ((float)data.length/1024 > 1000) {
        data = UIImageJPEGRepresentation(self, 1024*1000.0/(float)data.length);
    }
    
    return data;
}
    
- (UIImage*)chains_changeAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0.0f);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGRect area=CGRectMake(0,0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx,0, -area.size.height);
    CGContextSetBlendMode(ctx,kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIImage (QRCode)

- (NSString *)chains_extractQRCode
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:self.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    
    NSString *result = feature.messageString;
    
    if ([result isEqualToString:@""] || result.length == 0) {
        NSLog(@"未能识别二维码");
        return nil;
    } else {
        NSLog(@"QRCode is %@",result);
        return result;
    }
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (CIImage *)createQRForString:(NSString *)qrString
{
    // 1.将字符串转换为UTF8编码的NSData对象
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 4.返回CIImage
    return qrFilter.outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                                size:(CGFloat)size
{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),
                        size/CGRectGetHeight(extent));
    // 1.创建一个位图图像，绘制到其大小的位图上下文
    size_t width        = CGRectGetWidth(extent) * scale;
    size_t height       = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs  = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context     = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.创建具有内容的位图图像
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // 3.清理
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return (UIImage*)[UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)chains_codeImageWithString:(NSString *)string size:(CGFloat)width
{
    CIImage *ciImage = [UIImage createQRForString:string];
    if (ciImage)
    {
        return [UIImage createNonInterpolatedUIImageFormCIImage:ciImage
                                                           size:width];
    }
    else
    {
        return nil;
    }
}

+ (UIImage *)chains_codeImageWithString:(NSString *)string size:(CGFloat)width color:(UIColor *)color
{
    UIImage *image = [UIImage chains_codeImageWithString:string size:width];
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat red     = components[0]*255;
    CGFloat green   = components[1]*255;
    CGFloat blue    = components[2]*255;
    
    const int imageWidth    = image.size.width;
    const int imageHeight   = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf   = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 1.创建上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 2.像素转换
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // 3.生成UIImage
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL,
                                                                  rgbImageBuf,
                                                                  bytesPerRow * imageHeight,
                                                                  ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth,
                                        imageHeight,
                                        8,
                                        32,
                                        bytesPerRow,
                                        colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little,
                                        dataProvider,
                                        NULL,
                                        true,
                                        kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = (UIImage*)[UIImage imageWithCGImage:imageRef];
    
    // 4.释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

+ (UIImage *)chains_codeImageWithString:(NSString *)string size:(CGFloat)width color:(UIColor *)color icon:(UIImage *)icon iconWidth:(CGFloat)iconWidth
{
    UIImage *bgImage = [UIImage chains_codeImageWithString:string size:width color:color];
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    CGFloat x = (bgImage.size.width - iconWidth) * 0.5;
    CGFloat y = (bgImage.size.height - iconWidth) * 0.5;
    [icon drawInRect:CGRectMake( x,  y, iconWidth,  iconWidth)];
    
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (UIImage *)newImage;
}

@end
