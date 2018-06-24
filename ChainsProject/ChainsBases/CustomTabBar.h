//
//  CustomTabBar.h
//  CommonProject
//
//  Created by lianzun on 2017/9/20.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBar : UITabBar
@property (copy, nonatomic) void(^blockCenterButtonClick)(void);
@end
