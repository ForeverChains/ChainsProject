//
//  Chains_BaseTableView.m
//  CommonProject
//
//  Created by lianzun on 2018/1/20.
//  Copyright © 2018年 MTF. All rights reserved.
//

#import "Chains_BaseTableView.h"

#define GoTopButtonWidth                    44

@interface Chains_BaseTableView()
//@property (strong, nonatomic) UIButton *goTopButton;
@end

@implementation Chains_BaseTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self.superview addSubview:self.goTopButton];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
//    [self.superview addSubview:self.goTopButton];//先于tableview添加，被遮盖看不到
    
    return self;
}

//- (UIButton *)goTopButton
//{
//    if (!_goTopButton)
//    {
//        _goTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _goTopButton.frame = CGRectMake(self.width - GoTopButtonWidth - 10 + self.x, self.height - GoTopButtonWidth - 10 + self.y, GoTopButtonWidth, GoTopButtonWidth);
//        NSLogRect(_goTopButton.frame);
//        [_goTopButton setImage:[UIImage imageNamed:@"icon_zhiding"] forState:UIControlStateNormal];
//        [_goTopButton addTarget:self action:@selector(goTopAction:) forControlEvents:UIControlEventTouchUpInside];
////        _goTopButton.hidden = YES;
//    }
//    
//    return _goTopButton;
//}

- (void)goTopAction:(UIButton *)button
{
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UIscrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    _goTopButton.hidden = (scrollView.contentOffset.y < self.height*2);
}

@end
