//
//  UIScrollView+Placeholder.h
//  Ticket
//
//  Created by lianzun on 2018/6/1.
//  Copyright © 2018年 胡员外. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Placeholder)
@property (assign, nonatomic) BOOL chains_shouldDisplayPlaceholder;
@property (assign, nonatomic) BOOL chains_allowScrollWhenNoData;
@property (strong, nonatomic) UIView * chains_placeholderView;
@property (copy, nonatomic) void(^blockUpdateDataSource)(void);
@end
