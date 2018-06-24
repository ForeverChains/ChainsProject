//
//  Chains_PlaceholderView.h
//  Ticket
//
//  Created by lianzun on 2018/5/30.
//  Copyright © 2018年 胡员外. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chains_PlaceholderView : UIView
@property (nonatomic) IBOutlet UIView *innerView;
@property (copy, nonatomic) void(^blockUpdateDataSource)(void);

+ (instancetype)defaultViewWithFrame:(CGRect)frame;
@end
