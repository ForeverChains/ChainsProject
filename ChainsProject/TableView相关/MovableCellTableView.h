//
//  MovableCellTableView.h
//  Summary
//
//  Created by 马腾飞 on 17/5/3.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovableCellTableView;

@protocol MovableCellTableViewDataSource <UITableViewDataSource>

@required
/**
 *  获取tableView的数据源数组
 */
- (NSArray *)dataSourceArrayInTableView:(MovableCellTableView *)tableView;
/**
 *  返回移动之后调换后的数据源
 */
- (void)tableView:(MovableCellTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray;

@end

@interface MovableCellTableView : UITableView

@property (nonatomic, weak) id<MovableCellTableViewDataSource> dataSource;

/**
 *  是否允许拖动到屏幕边缘后，开启边缘滚动，默认YES
 */
@property (nonatomic, assign) BOOL canEdgeScroll;
/**
 *  边缘滚动触发范围，默认150，越靠近边缘速度越快
 */
@property (nonatomic, assign) CGFloat edgeScrollRange;
/**
 *  长按手势最小触发时间，默认1.0，最小0.2
 */
@property (nonatomic, assign) CGFloat gestureMinimumPressDuration;

/**
 结束编辑，收起键盘事件处理
 */
@property (nonatomic, copy) void(^tapEventBlock)();

@end
