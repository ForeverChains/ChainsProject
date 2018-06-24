//
//  SharedModel.m
//  LeChuangProject
//
//  Created by lianzun on 2017/9/9.
//  Copyright © 2017年 Chains. All rights reserved.
//

#import "SharedModel.h"
//#import "WXApi.h"
//#import "IFMShareView.h"
#import <Social/Social.h>


@implementation SharedModel

+ (instancetype)modelWithTitle:(NSString *)title describe:(NSString *)describeStr images:(NSArray *)imgArr url:(NSURL *)url
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (title) [dic setValue:title forKey:@"title"];
    if (describeStr) [dic setValue:describeStr forKey:@"describeStr"];
    if (imgArr) [dic setValue:imgArr forKey:@"imgArr"];
    if (url) [dic setValue:url forKey:@"url"];
    return [self modelWithDic:dic];
}

- (void)setImgArr:(NSArray<UIImage *> *)imgArr
{
    NSMutableArray *tempArr = [NSMutableArray array];
    [imgArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]])
        {
            [tempArr addObject:obj];
        }
    }];
    _imgArr = tempArr;
}

//- (void)shareByWeixinWithScene:(int)scene onlyText:(BOOL)onlyText
//{
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
//    {
//        //message是多媒体分享(链接/网页/图片/音乐各种)
//        //text是分享文本,两者只能选其一
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//        if (onlyText)
//        {
//            req.text = self.title;
//            req.bText = YES;
//        }
//        else
//        {
//            WXMediaMessage *message = [WXMediaMessage message];
//            message.title = self.title;
//            message.description = self.describeStr;
//            [message setThumbImage:self.imgArr[0]];
//            
//            WXWebpageObject *webpage = [WXWebpageObject object];
//            webpage.webpageUrl = [NSString stringWithFormat:@"%@",self.url];
//            message.mediaObject = webpage;
//            
//            req.message = message;
//        }
//        
//        //默认是WXSceneSession分享给朋友,WXSceneTimeline是朋友圈,WXSceneFavorite是收藏
//        req.scene = WXSceneSession;
//        
//        [WXApi sendReq:req];
//    }
//    else
//    {
//        [MBProgressHUD chains_showTip:@"请先安装微信!" toView:nil hideAfterDelay:Disappear_Delay_Time];
//    }
//}

- (void)shareBySLComposeViewControllerWithServiceType:(ServiceType)type complete:(void (^)(BOOL))complete
{
    NSString *tipPlatform;
    NSString *platformID;
    switch (type)
    {
        case Sina:
        {
            platformID = @"com.apple.share.SinaWeibo.post";
            tipPlatform = @"新浪微博";
        }
            break;
        case QQ:
        {
            platformID = @"com.tencent.mqq.ShareExtension";
            tipPlatform = @"QQ";
        }
            break;
        case Wechat:
        {
            platformID = @"com.tencent.xin.sharetimeline";
            tipPlatform = @"微信";
        }
            break;
        case Alipay:
        {
            platformID = @"com.alipay.iphoneclient.ExtensionSchemeShare";
            tipPlatform = @"支付宝";
        }
            break;
            
        default:
            break;
    }
    
    NSString *UNLoginTip = [NSString stringWithFormat:@"没有配置%@相关的帐号",tipPlatform];
    NSString *UNInstallTip = [NSString stringWithFormat:@"没有安装%@",tipPlatform];
    
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:platformID];
    if (composeVc == nil){
//        ALERT_MSG(@"提示",UNInstallTip,[UIViewController chains_visibleViewController]);
        return;
    }
    if (![SLComposeViewController isAvailableForServiceType:platformID]) {
//        ALERT_MSG(@"提示",UNLoginTip,[UIViewController chains_visibleViewController]);
        return;
    }
    
    if (self.title) [composeVc setInitialText:_title];
    if (self.url) [composeVc addURL:_url];
    if (self.imgArr)
    {
        [_imgArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [composeVc addImage:obj];
        }];
    }
    
    NSLog(@"分享内容:%@",self);
    
    composeVc.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"点击了取消");
        } else {
            NSLog(@"点击了发送");
        }
        complete(result == SLComposeViewControllerResultCancelled);
    };
    
    [[UIViewController chains_visibleViewController] presentViewController:composeVc animated:YES completion:nil];
}

/*
- (void)shareByIFMShare
{
    IFMShareView *shareView = [[IFMShareView alloc] initWithItems:@[IFMPlatformNameWechat,IFMPlatformNameQQ,IFMPlatformNameSina] itemSize:CGSizeMake(80,100) DisplayLine:YES];
    shareView.itemSpace = 10;
    if (self.title) [shareView addText:self.title];
    if (self.imgArr)
    {
        [self.imgArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [shareView addImage:obj];
        }];
    }
    if (self.url) [shareView addURL:self.url];
    shareView.showCancleButton = NO;
    [shareView showFromControlle:[UIApplication sharedApplication].keyWindow.rootViewController];
}
 */

- (void)shareByUIActivityViewControllerWithSourceView:(UIView *)sourceView complete:(void (^)(BOOL complete ,UIActivityType  _Nullable activityType))complete
{
    //这个方法接收俩个数组类型的参数，第一个数组内的对象代表的是我们想要操作的数据的一些表征，而且这个数组至少需要一个值，比如我们PDF文档的名称，URL；第二个数组指定了泛型，数组内的对象必须是UIActivity类型的对象，代表的是iOS系统支持的我们自定义的服务，可以为nil
    NSMutableArray *tempArr = [NSMutableArray array];
    NSLog(@"分享内容:%@",self);
    
    if (self.url)
    {
        //分享网址
        [tempArr addObject:self.url];
        if (self.title) [tempArr addObject:self.title];
        if (self.imgArr && self.imgArr.count == 1) [tempArr addObject:_imgArr[0]];
    }
    else
    {
        //分享图片
        if (self.imgArr && self.imgArr.count > 0)
        {
            [_imgArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempArr addObject:obj];
            }];
        }
    }
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:tempArr applicationActivities:nil];
    
    /**
     excludedActivityTypes是一个字符串数组，所包含的内容必须是系统提供的UIActivity的activityType字符串，这个属性包含了所有不想在UIActivityViewController中展示的Item服务。系统提供的字符串如下：
     
     NSString *const UIActivityTypePostToFacebook;
     NSString *const UIActivityTypePostToTwitter;
     NSString *const UIActivityTypePostToWeibo;
     NSString *const UIActivityTypeMessage;
     NSString *const UIActivityTypeMail;
     NSString *const UIActivityTypePrint;
     NSString *const UIActivityTypeCopyToPasteboard;
     NSString *const UIActivityTypeAssignToContact;
     NSString *const UIActivityTypeSaveToCameraRoll;
     NSString *const UIActivityTypeAddToReadingList;
     NSString *const UIActivityTypePostToFlickr;
     NSString *const UIActivityTypePostToVimeo;
     NSString *const UIActivityTypePostToTencentWeibo;
     NSString *const UIActivityTypeAirDrop;
     **/
    activity.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeCopyToPasteboard,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeOpenInIBooks];
    
    activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (activityError)
        {
            NSLog(@"%@ failed:%@",activityType,activityError);
            [MBProgressHUD chains_showTip:activityError.localizedDescription toView:[UIViewController chains_visibleViewController].view];
        }
        else
        {
            complete(completed, activityType);
        }
    };
    
    /**
     自定义UIActivity服务
     UIActivity主要是操作给用户展示的信息，而且还可以操作展示定制化的界面来获取更多地数据信息。必须通过继承来使用,除此之外，我们必须重写下面的几个方法:
     
     - (nullable NSString *)activityType;
     这是用来标识自定义服务的一个字符串,尽量参照系统提供的服务标识的规范来定义
     - (nullable NSString *)activityTitle;
     在UIActivityViewController中给用户展示的服务的名称
     - (nullable UIImage *)activityImage;
     在UIActivityViewController中给用户展示的服务的图标。关于这里的图标，有非常严格的限制：
     ·首先是图标的背景色，这里推荐最好的完全透明的背景色。
     ·其次是图标的尺寸，在不同的设备需要不同的尺寸，因此需要准备一套图标。
     Device                 iOS Version	   Icon Size(pt)
     iPhone、iPod Touch         iOS 6        < 43x43
     iPhone、iPod Touch         iOS 7+       60x60
     iPad                       iOS 6        < 60x60
     iPad                       iOS 7+       76x76
     Retina                     All           @2x
     
     - (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
     指定可以处理的数据类型，如果可以处理则返回`YES`
     - (void)prepareWithActivityItems:(NSArray *)activityItems;
     在用户选择展示在UIActivityViewController中的自定义服务的图标之后，调用自定义服务处理方法之前的准备工作，都需要在这个方法中指定，比如可以根据数据展示一个界面来获取用户指定的额外数据信息
     + (UIActivityCategory)activityCategory;
     UIActivityViewController中的服务分为了俩种， UIActivityCategoryAction和 UIActivityCategoryShare,`UIActivityCategoryAction表示在最下面一栏的操作型服务,比如Copy、Print;UIActivityCategoryShare`表示在中间一栏的分享型服务，比如一些社交软件。
     - (void)performActivity;
     在用户选择展示在`UIActivityViewController`中的自定义服务的图标之后，而且也调用了`prepareWithActivityItems:`,就会调用这个方法执行具体的服务操作
     **/
    
    
    /**
     补充之AirDrop
     AirDrop是在iOS 7中提供的，实现跨设备传输文档的功能。AirDrop的实现基于蓝牙创建一种类似WIFI的”点对点网络“，然后实现跨设备传输功能。
     只是AirDrop的传输是有限制的，我们可以在我们的App中通过AirDrop传送内容，却不能实现通过AirDrop接收内容，因为，苹果把设备上通过AirDrop接收到的内容都放到了自家App上，比如仅仅传送文字时，在接收设备上就会通过Notes打开；如果传送图片，在接收设备上就会保存到Photos应用中；通过URL传送文件，在接收设备上就会通过Safari打开。
     **/
    
    //展示UIActivityViewController的时候需要根据当前的设备类型选择合适的展示方式，在iPad设备上就必须在'popover'视图里面展示，在其他设备上，必须以模态视图展示。
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sourceView;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [[UIViewController chains_visibleViewController] presentViewController:activity animated:YES completion:^{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage chains_imageWithColor:[UIColor chains_colorWithHexString:@"b4b4b4" alpha:1]] forBarMetrics:UIBarMetricsDefault];
    }];
}

/*
- (void)shareByMob:(UIView *)view complete:(void (^)(SSDKPlatformType))complete
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    SSDKContentType type = SSDKContentTypeAuto;
    
    [shareParams SSDKSetupShareParamsByText:self.describeStr
                                     images:self.imgArr
                                        url:self.url
                                      title:self.title
                                       type:type];
    //优先使用平台客户端分享
    [shareParams SSDKEnableUseClientShare];
    //设置微博使用高级接口
    //2017年6月30日后需申请高级权限
    //    [shareParams SSDKEnableAdvancedInterfaceShare];
    //    设置显示平台 只能分享视频的YouTube MeiPai 不显示
    //    NSArray *items = @[
    //                       @(SSDKPlatformTypeFacebook),
    ////                       @(SSDKPlatformTypeFacebookMessenger),
    ////                       @(SSDKPlatformTypeInstagram),
    ////                       @(SSDKPlatformTypeTwitter),
    //                       @(SSDKPlatformTypeLine),
    //                       @(SSDKPlatformTypeQQ),
    //                       @(SSDKPlatformTypeWechat),
    //                       @(SSDKPlatformTypeSinaWeibo),
    //                       @(SSDKPlatformTypeSMS),
    //                       @(SSDKPlatformTypeMail),
    //                       @(SSDKPlatformTypeCopy)
    //                       ];
    
    //设置简介版UI 需要  #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [ShareSDK setWeiboURL:@"http://www.mob.com"];
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //设置UI等操作
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           NSLog(@"分享成功");
                           //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeInstagram)
                           {
                               break;
                           }
                           
                           complete(platformType);
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           NSLog(@"%@",error);
                           [MBProgressHUD chains_showTip:error.localizedDescription toView:nil hideAfterDelay:Disappear_Delay_Time];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           NSLog(@"分享取消");
                           break;
                       }
                       default:
                           break;
                   }
               }];
}

- (void)shareByMobWithType:(SSDKPlatformType)type complete:(void (^)(void))complete
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.describeStr
                                     images:self.imgArr //传入要分享的图片
                                        url:self.url
                                      title:self.title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
                 
             case SSDKResponseStateBegin:
             {
                 //设置UI等操作
                 break;
             }
             case SSDKResponseStateSuccess:
             {
                 NSLog(@"分享成功");
                 
                 complete();
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSLog(@"%@",error);
                 [MBProgressHUD chains_showTip:error.localizedDescription toView:nil hideAfterDelay:Disappear_Delay_Time];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 NSLog(@"分享取消");
                 break;
             }
             default:
                 break;
         }
     }];
}
 */

@end
