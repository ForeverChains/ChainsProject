//
//  NSDictionary+Chains.m
//  CommonProject
//
//  Created by lianzun on 2017/9/16.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import "NSDictionary+Chains.h"

@implementation NSDictionary (Chains)

- (NSString *)chains_jsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

//NSJSONWritingPrettyPrinted：将生成的json数据格式化输出，这样可读性高，不设置则输出的json字符串就是一整行。
- (NSString *)chains_jsonPrettyString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

- (NSString *)chains_URLQueryString
{
    NSMutableArray *entries = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *entry = [NSString stringWithFormat:@"%@=%@", [key chains_URLEncoding], [obj chains_URLEncoding]];
        [entries addObject:entry];
    }];
    return [entries componentsJoinedByString:@"&"];
}

- (NSString *)chains_XMLString
{
    NSString *xmlStr = @"<xml>";
    
    for (NSString *key in self.allKeys) {
        
        NSString *value = [self objectForKey:key];
        
        xmlStr = [xmlStr stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, value, key]];
    }
    
    xmlStr = [xmlStr stringByAppendingString:@"</xml>"];
    
    return xmlStr;
}

@end
