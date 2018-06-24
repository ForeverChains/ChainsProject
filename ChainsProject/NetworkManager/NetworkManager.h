//
//  NetworkManager.h
//  AFNetworkingDemo
//
//  Created by 马腾飞 on 16/10/13.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 *  请求方式 GET OR POST
 */
typedef enum HttpMethod {
    GET,
    POST
} HttpMethod;


typedef void( ^ NMResponseSuccess)(id response);
typedef void( ^ NMResponseFail)(NSError *error);

typedef void( ^ NMUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);

typedef void( ^ NMDownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);

@interface NetworkManager : AFHTTPSessionManager

@property (nonatomic, strong) NSMutableArray *taskArr;

+ (NetworkManager *)sharedManager;

@property (strong, nonatomic) NSString *safeToken;

- (NSURLSessionTask *)requestDataWithType:(HttpMethod)type
                                  baseURL:(NSString *)baseURL
                                     path:(NSString *)path
                                   params:(NSDictionary *)params
                                 andBlock:(void (^)(id data, NSError *error))block;

- (NSURLSessionTask *)requestDataWithType:(HttpMethod)type
                                  baseURL:(NSString *)baseURL
                                     path:(NSString *)path
                                   params:(NSDictionary *)params
                              autoShowHud:(BOOL)autoShowHud
                          loadingImageArr:(NSMutableArray *)loadingImageArr
                            autoShowError:(BOOL)autoShowError
                                 andBlock:(void (^)(id data, NSError *error))block;

- (NSURLSessionTask *)uploadWithImages:(NSArray *)imageArr
                               baseURL:(NSString *)baseURL
                                  path:(NSString *)path
                             fileNames:(NSArray *)fileNameArr
                                  name:(NSString *)name
                                params:(NSDictionary *)params
                           autoShowHud:(BOOL)autoShowHud
                              progress:(void(^)(int64_t bytesProgress, int64_t totalBytesProgress))progress
                               success:(void(^)(id response))success
                                  fail:(void(^)(NSError *error))fail;


@end
