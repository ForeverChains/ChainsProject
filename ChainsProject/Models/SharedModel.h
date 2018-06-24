//
//  SharedModel.h
//  LeChuangProject
//
//  Created by lianzun on 2017/9/9.
//  Copyright © 2017年 Chains. All rights reserved.
//

#import "BaseModel.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

typedef enum : NSUInteger {
    Sina = 0,
    QQ,
    Wechat,
    Alipay
} ServiceType;

@interface SharedModel : BaseModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *describeStr;
@property (strong, nonatomic) NSArray <UIImage *> *imgArr;
@property (strong, nonatomic) NSURL *url;

+ (instancetype)modelWithTitle:(NSString *)title describe:(NSString *)describeStr images:(NSArray <UIImage *> *)imgArr url:(NSURL *)url;

/**
 微信分享
 
 @param scene 0分享给朋友,1是朋友圈,2是收藏
 @param onlyText 分享内容类型  NO：多媒体   YES：文本
 **/
//- (void)shareByWeixinWithScene:(int)scene onlyText:(BOOL)onlyText;

- (void)shareBySLComposeViewControllerWithServiceType:(ServiceType)type complete:(void(^)(BOOL cancelled))complete;

- (void)shareByIFMShare;

- (void)shareByUIActivityViewControllerWithSourceView:(UIView *)sourceView complete:(void (^)(BOOL complete ,UIActivityType  _Nullable activityType))complete;

//- (void)shareByMob:(UIView *)view complete:(void(^)(SSDKPlatformType platformType))complete;

//- (void)shareByMobWithType:(SSDKPlatformType)type complete:(void(^)(void))complete;

@end

