//
//  BaseViewController.h
//  EGov-iPad
//
//  Created by cdm on 13-4-28.
//  Copyright (c) 2013年 MyIdeaWay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) SharedModel *sharedModel;
@property (assign, nonatomic) BOOL isPresented;//是否为模态弹出
@property (strong, nonatomic) dispatch_source_t timer;
@property (assign, nonatomic) BOOL statusBarStyleWhite;//设置状态栏是否为白色

/**
 *  创建定时器
 *
 *  @param interval     时间间隔
 *  @param eventHandler 响应事件
 */
- (void)createTimerWithInterval:(float)interval event:(void(^)(dispatch_source_t timer))eventHandler cancel:(void(^)(dispatch_source_t timer))cancelHandler;

/**
 *  创建延时器
 *
 *  @param time         延时时间
 *  @param eventHandler 响应事件
 */
- (void)createDelayerWithTime:(float)time event:(void(^)(void))eventHandler;


- (UIBarButtonItem *)createLeftBarButton:(id)content;
- (IBAction)leftBarButtonClick:(id)sender;

- (UIButton *)createRightBarButton:(id)content;
- (IBAction)rightBarButtonClick:(id)sender;

/**
 隐藏导航返回按钮
 */
- (void)hideBackBarButtonItem;

/**
 更新数据
 */
- (void)chains_loadData;


@end
