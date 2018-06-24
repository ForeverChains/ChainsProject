//
//  NetworkManager.m
//  AFNetworkingDemo
//
//  Created by 马腾飞 on 16/10/13.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworkActivityIndicatorManager.h"

#define kNetworkMethodName @[@"Get", @"Post"]
#define HUD_HIDE_DELAY           2

@implementation NetworkManager

+ (NetworkManager *)sharedManager
{
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];//请求
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.requestSerializer.timeoutInterval= 15;
    
//    self.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    self.responseSerializer = [AFHTTPResponseSerializer serializer];//设置返回NSData 数据
    self.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    [self.requestSerializer setValue:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"version"];
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

- (void)setSafeToken:(NSString *)safeToken
{
    _safeToken = safeToken;
    [self.requestSerializer setValue:safeToken forHTTPHeaderField:@"safeToken"];
}

- (NSURLSessionTask *)requestDataWithType:(HttpMethod)type baseURL:(NSString *)baseURL path:(NSString *)path params:(NSDictionary *)params andBlock:(void (^)(id, NSError *))block
{
    return [self requestDataWithType:type baseURL:baseURL path:path params:params autoShowHud:YES loadingImageArr:nil autoShowError:YES andBlock:block];
}

- (NSURLSessionTask *)requestDataWithType:(HttpMethod)type baseURL:(NSString *)baseURL path:(NSString *)path params:(NSDictionary *)params autoShowHud:(BOOL)autoShowHud loadingImageArr:(NSMutableArray *)loadingImageArr autoShowError:(BOOL)autoShowError andBlock:(void (^)(id, NSError *))block
{
    if (!baseURL || !path || baseURL.length == 0 || path.length == 0)
    {
        return nil;
    }
    
    __block MBProgressHUD *hud;
    
    if (autoShowHud)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (loadingImageArr)
            {
                hud = [MBProgressHUD chains_showGif:loadingImageArr andTip:nil toView:[UIViewController chains_visibleViewController].view];
            }
            else
            {
                hud = [MBProgressHUD chains_showActivityIndicatorWithTip:nil toView:[UIViewController chains_visibleViewController].view];
            }
        });
        
    }
    
    //log请求数据
    NSLog(@"\n===========request===========\n%@\n%@%@:\n%@", kNetworkMethodName[type], baseURL, path, params);
    
    //中文与特殊字符转码
    /*
     URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
     
     URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
     
     URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
     
     URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
     
     URLQueryAllowedCharacterSet    "#%<>[\]^`{|}
     
     URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     */
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,path];
    
    //遍历params,将所有NSString类型的值进行UTF-8编码与URLEncode
//    NSMutableDictionary *encodeParams = [NSMutableDictionary dictionary];
//    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSString class]])
//        {
//            obj = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            //            [obj URLEncoding];
//        }
//        [encodeParams setObject:obj forKey:key];
//    }];
//    
//    params = encodeParams;
    
    NSURLSessionTask *sessionTask=nil;
    
    switch (type)
    {
        case GET:
        {
            sessionTask = [self GET:urlStr
                         parameters:params
                           progress:^(NSProgress * _Nonnull downloadProgress) {
                               
                           }
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                if (autoShowHud)
                                {
                                    [hud hideAnimated:YES];
                                }
                                
                                NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                NSLog(@"\n===========response===========\n%@:\n%@", urlStr, resultStr);
                                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                if (!resultDic) NSLog(@"无返回数据，请做处理");
                                
                                id error = [self handleResponse:resultDic withDomain:urlStr autoShowError:autoShowError];
                                
                                if (error)
                                {
                                    block(nil, error);
                                }
                                else
                                {
                                    block(resultDic, nil);
                                }
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                if (autoShowHud)
                                {
                                    [hud hideAnimated:YES];
                                }
                                
                                NSLog(@"\n===========response===========\n%@:\n%@", urlStr, error);
                                if (autoShowError)
                                {
                                    [MBProgressHUD chains_showTip:[self tipFromError:error] toView:nil hideAfterDelay:HUD_HIDE_DELAY];
                                }
                                block(nil, error);
                            }];
        }
            break;
        case POST:
        {
            sessionTask = [self POST:urlStr
                          parameters:params
                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                
                            }
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 NSLog(@"HTTPRequestHeaders:%@",self.requestSerializer.HTTPRequestHeaders);
                                 if (autoShowHud)
                                 {
                                     [hud hideAnimated:YES];
                                 }
                                 
                                 NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                 NSLog(@"\n===========response===========\n%@:\n%@", urlStr, resultStr);
                                 NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                 if (!resultDic) NSLog(@"无返回数据，请做处理");
                                 
                                 id error = [self handleResponse:resultDic withDomain:urlStr autoShowError:autoShowError];
                                 
                                 if (error)
                                 {
                                     block(nil, error);
                                 }
                                 else
                                 {
                                     block(resultDic, nil);
                                 }
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSLog(@"HTTPRequestHeaders:%@",self.requestSerializer.HTTPRequestHeaders);
                                 if (autoShowHud)
                                 {
                                     [hud hideAnimated:YES];
                                 }
                                 
                                 NSLog(@"\n===========response===========\n%@:\n%@", urlStr, error);
                                 if (autoShowError)
                                 {
                                     [MBProgressHUD chains_showTip:[self tipFromError:error] toView:nil hideAfterDelay:HUD_HIDE_DELAY];
                                 }
                                 block(nil, error);
                             }];
        }
            break;
            
        default:
            break;
    }
    
    if (sessionTask)
    {
        [self.taskArr addObject:sessionTask];
    }
    
    return sessionTask;
}

- (NSURLSessionTask *)uploadWithImages:(NSArray *)imageArr baseURL:(NSString *)baseURL path:(NSString *)path fileNames:(NSArray *)fileNameArr name:(NSString *)name params:(NSDictionary *)params autoShowHud:(BOOL)autoShowHud progress:(void (^)(int64_t, int64_t))progress success:(void (^)(id))success fail:(void (^)(NSError *))fail
{
    if (!baseURL || !path || baseURL.length == 0 || path.length == 0)
    {
        return nil;
    }
    
    __block MBProgressHUD *hud;
    
    if (autoShowHud)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud = [MBProgressHUD chains_showActivityIndicatorWithTip:nil toView:nil];
        });
    }
    
    //log请求数据
    NSLog(@"\n===========request===========\n%@%@:\n%@", baseURL, path, params);
    
    //中文过滤
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,path];
    
    //遍历params,将所有NSString类型的值进行UTF-8编码与URLEncode
    NSMutableDictionary *encodeParams = [NSMutableDictionary dictionary];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            obj = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            //            [obj URLEncoding];
        }
        [encodeParams setObject:obj forKey:key];
    }];
    
    params = encodeParams;
    NSURLSessionTask *sessionTask=nil;
    sessionTask = [self POST:urlStr
                                    parameters:params
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         for (int i = 0; i < imageArr.count; i ++)
                         {
                             UIImage *image = (UIImage *)imageArr[i];
                             NSData *imageData = UIImageJPEGRepresentation(image,1.0);
                             if ((float)imageData.length/1024 > 1000)
                             {
                                 imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
                             }
                             
                             NSString *imageFileName;
                             if (fileNameArr == nil || ![fileNameArr isKindOfClass:[NSArray class]] || fileNameArr.count != imageArr.count)
                             {
                                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                 formatter.dateFormat = @"yyyyMMddHHmmss";
                                 NSString *str = [formatter stringFromDate:[NSDate date]];
                                 imageFileName = [NSString stringWithFormat:@"%@%zd.png", str,i];
                             }
                             else
                             {
                                 imageFileName = fileNameArr[i];
                             }
                             
                             
                             [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpg"];
                             
                             NSLog(@"\nuploadImageSize\n%@ : %.0f", imageFileName, (float)imageData.length/1024);
                         }
                     }
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                                          
                                          if (progress)
                                          {
                                              progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                                          }
                                      }
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           if (autoShowHud)
                                           {
                                               [hud hideAnimated:YES];
                                           }
                                           
                                           NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                           NSLog(@"\n===========response===========\n%@:\n%@", urlStr, resultStr);
                                           NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                           if (!resultDic) NSLog(@"无返回数据，请做处理");
                                           
                                           id error = [self handleResponse:resultDic withDomain:urlStr autoShowError:NO];
                                           
                                           if (error)
                                           {
                                               fail(error);
                                           }
                                           else
                                           {
                                               success(resultDic);
                                           }
                                           
                                           [self.taskArr removeObject:sessionTask];
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           if (autoShowHud)
                                           {
                                               [hud hideAnimated:YES];
                                           }
                                           
                                           if (fail)
                                           {
                                               fail(error);
                                           }
                                           [self.taskArr removeObject:sessionTask];
                                       }];
    
    if (sessionTask) {
        [self.taskArr addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark - ToolMethod

- (NSString *)tipFromError:(NSError *)error
{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"moreInfo"]) {
            if ([[error.userInfo objectForKey:@"moreInfo"] isKindOfClass:[NSString class]])
            {
                tipStr = [error.userInfo objectForKey:@"moreInfo"];
            }
            else
            {
                NSArray *msgArray = [[error.userInfo objectForKey:@"error"] allValues];
                NSUInteger num = [msgArray count];
                for (int i = 0; i < num; i++) {
                    NSString *msgStr = [msgArray objectAtIndex:i];
                    if (i+1 < num) {
                        [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                    }else{
                        [tipStr appendString:msgStr];
                    }
                }
            }
            
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

- (id)handleResponse:(id)responseJSON withDomain:(NSString *)domain autoShowError:(BOOL)autoShowError
{
    NSError *error = nil;
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"errorCode"];
    
    //code为非0(有时候是200，根据实际情况而定)值时，表示有错
    if (resultCode.intValue != 200)
    {
        error = [NSError errorWithDomain:domain code:resultCode.intValue userInfo:responseJSON];
        
        if (autoShowError)
        {
            [MBProgressHUD chains_showTip:[self tipFromError:error] toView:nil hideAfterDelay:HUD_HIDE_DELAY];
        }
    }
    return error;
}

@end
