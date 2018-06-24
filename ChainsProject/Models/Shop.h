//
//  Shop.h
//  Summary
//
//  Created by 马腾飞 on 17/4/17.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property (nonatomic, strong) NSNumber *h; // 高度
@property (nonatomic, strong) NSNumber *w; // 宽度
@property (nonatomic, copy) NSString *img; // 图片urlString
@property (nonatomic, copy) NSString *price; // 价格

@end
