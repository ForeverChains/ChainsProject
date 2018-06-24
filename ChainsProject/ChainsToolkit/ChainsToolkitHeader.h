//
//  ChainsToolkitHeader.h
//  ChainsProject
//
//  Created by lianzun on 2018/5/11.
//  Copyright © 2018年 Chains. All rights reserved.
//

#ifndef ChainsToolkitHeader_h
#define ChainsToolkitHeader_h


#import "UIView+Chains.h"
#import "NSString+Chains.h"
#import "UILabel+Chains.h"
#import "NSFileManager+Chains.h"
#import "UIImage+Chains.h"
#import "NSDate+Chains.h"
#import "UIColor+Chains.h"
#import "UIViewController+Chains.h"
#import "NSData+Chains.h"
#import "Base64.h"
#import "MBProgressHUD+Chains.h"
#import "NSDictionary+Chains.h"
#import "NSNumber+Round.h"
#import "NSString+RegexCategory.h"
#import "NSString+Size.h"
#import "NSString+Trims.h"
#import "UINavigationController+Chains.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


#import "BaseNavigationController.h"
#import "BaseTabBarController.h"

#import "User.h"
#import "Owner.h"
#import "SharedModel.h"

#import "ApplicationContext.h"

#import "NetworkManager.h"
#import "APIConfig.h"

#import "AxcUIKit.h"
#import "ReactiveObjC.h"


#define COLOR_THEME                                         @"FF6A7E"

#define kHistoryVersion                                     @"HistoryVersion"
#define kUserDefaults_NotFirstLaunch                        @"kUserDefaults_NotFirstLaunch"//非首次启动

#define kNotificationNameCheckVersion                       @"kNotificationNameCheckVersion"

/**
 *  随机颜色
 */
#define COLOR_RANDOM                      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

/**
 *  设置RGB与透明度
 */
#define COLOR_RGBA(r,g,b,a)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define COLOR_RGB(r,g,b)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


#define weakReference(var)   __weak typeof(var) weakVar = var
#define strongrReference(var) __strong typeof(var) sRtrongVar = var


#define kMainScreenBounds                                  [UIScreen mainScreen].bounds
#define kMainScreenHeight                                  kMainScreenBounds.size.height
#define kMainScreenWidth                                   kMainScreenBounds.size.width

//是否为齐刘海
#define kIsBluntBang                                      ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kViewSafeArea(view)                                ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define kTabBarHeight                                      49
#define kNavigationBarHeight                               44
#define kStatusBarHeight                                   (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define kSafeAreaTopDistance                               (kStatusBarHeight+kNavigationBarHeight)
#define kSafeAreaBottomDistance                            (kIsBluntBang?34:0)


#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])



//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)


//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//应用版本号
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_VERSION_BUILD [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//获取系统版本
#define IOS_VERSION [[UIDevice currentDevice] systemVersion]

/**
 *  NSLog二代目
 */
#define NSLog(format, ...)   {fprintf(stderr, "<%s : %d> %s\n",                                         \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
}

#define NSLogRect(rect)     NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size)     NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point)   NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

#endif /* ChainsToolkitHeader_h */
