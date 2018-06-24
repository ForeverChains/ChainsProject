//
//  BaseViewController.m
//  EGov-iPad
//
//  Created by cdm on 13-4-28.
//  Copyright (c) 2013年 MyIdeaWay. All rights reserved.
//

#import "BaseViewController.h"

#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//防止ios11之前，系统自动偏移scrollview
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    - (void)addPreviousNextDoneOnKeyboardWithTarget:(nullable id)target previousAction:(nullable SEL)previousAction nextAction:(nullable SEL)nextAction doneAction:(nullable SEL)doneAction;
//textfield可以调用上面的方法设置工具栏的响应事件
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    //重置导航栏状态，默认不透明
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.barBgImage = [UIImage chains_imageWithColor:[UIColor cyanColor]];
    self.navigationController.barAlpha = 0.3;
    
    //更改应用支持的方向
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    delegate.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //更改设备方向，触发转屏事件，设备方向必须为界面所支持的方向
    [self forceChangeToOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)dealloc
{
    NSLog(@"%@ 释放",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 更新数据
 */
- (void)chains_loadData
{
    
}

#pragma mark - 定时器延时器
/**
 *  创建定时器
 *  注意:
 *  1.viewWillDisappear或适当时机调用dispatch_source_cancel来释放对象
 *  2.调用dispatch_resume启动定时器
 *  3.调用dispatch_suspend暂停定时器 注意暂停的timer资源不能直接销毁，需要先resume再cancel，否则会造成内存泄漏
 */
- (void)createTimerWithInterval:(float)interval event:(void(^)(dispatch_source_t timer))eventHandler cancel:(void (^)(dispatch_source_t))cancelHandler
{
    dispatch_queue_t queue = dispatch_queue_create("timer queue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //start:开始时间    interval:时间间隔    leeway:精确度
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (eventHandler)
        {
            eventHandler(_timer);
        }
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        NSLog(@"timer cancle");
        if (cancelHandler)
        {
            cancelHandler(_timer);
        }
        _timer = nil;
    });
    //启动定时器
    dispatch_resume(_timer);
}

/**
 *  创建延时器
 */
- (void)createDelayerWithTime:(float)time event:(void (^)(void))eventHandler
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (eventHandler)
        {
            eventHandler();
        }
    });
}

//info.plist文件中，View controller-based status bar appearance项设为YES，则View controller对status bar的设置优先级高于application的设置，在rootViewController实现该方法更改状态栏字体颜色。为NO则以application的设置为准，view controller的prefersStatusBarHidden方法无效，是根本不会被调用的。
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyleWhite;  //默认的值是黑色的
}


#pragma mark - 导航栏按钮
- (UIBarButtonItem *)createLeftBarButton:(id)content
{
    UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *barButton;
    if ([content isKindOfClass:[NSString class]])
    {
        barButton = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
        [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
        negativeSeparator.width = 0;
    }
    else if ([content isKindOfClass:[UIImage class]])
    {
        barButton = [[UIBarButtonItem alloc] initWithImage:[content imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
        negativeSeparator.width = -5;
    }
    else if ([content isKindOfClass:[UIButton class]])
    {
        barButton = [[UIBarButtonItem alloc] initWithCustomView:content];
        [content addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        negativeSeparator.width = -10;
    }
    else
    {
        //UIImageRenderingModeAlwaysOriginal  图片本色
        //UIImageRenderingModeAlwaysTemplate  跟随TintColor
        UIImage *img = (self.navigationController.barAlpha != 1.)?[[UIImage imageNamed:IMAGE_BACK_SHADOW] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:[[UIImage imageNamed:IMAGE_BACK] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //默认返回按钮
        barButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
        negativeSeparator.width = -5;
    }
    
    /**
     *  由于默认边界间距为5pix，所以width设为5时，间距正好调整为10；
     */
    
    if (barButton) self.navigationItem.leftBarButtonItems = @[negativeSeparator, barButton];
    else barButton = [[UIBarButtonItem alloc] init];
    return barButton;
}

- (UIBarButtonItem *)createRightBarButton:(id)content
{
    UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    UIBarButtonItem *barButton;
    if ([content isKindOfClass:[NSString class]])
    {
        barButton = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
        [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        negativeSeparator.width = 0;
    }
    else if ([content isKindOfClass:[UIImage class]])
    {
        barButton = [[UIBarButtonItem alloc] initWithImage:[content imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
        negativeSeparator.width = -5;
    }
    else if ([content isKindOfClass:[UIButton class]])
    {
        barButton = [[UIBarButtonItem alloc] initWithCustomView:content];
        [content addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        negativeSeparator.width = -10;
    }
    else
    {
        UIImage *img = (self.navigationController.barAlpha != 1.)?[[UIImage imageNamed:IMAGE_SHARE_SHADOW] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:[[UIImage imageNamed:IMAGE_SHARE] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //默认分享按钮
        barButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
        negativeSeparator.width = -5;
    }
    if (barButton) self.navigationItem.rightBarButtonItems = @[negativeSeparator, barButton];
    else barButton = [[UIBarButtonItem alloc] init];
    
    return barButton;
}

- (void)hideBackBarButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)leftBarButtonClick:(id)sender
{
    if (_isPresented)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBarButtonClick:(id)sender
{
    
}

#pragma mark - 旋转屏幕
//界面方向是否可以在设备方向发生变化时旋转。
//YES:调用- (UIInterfaceOrientationMask)supportedInterfaceOrientations与- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation方法，更改界面方向
//NO:界面方向无法更改
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回支持的界面方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//手动更改设备方向
- (void)forceChangeToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //更新屏幕宽高
        CGSize screen = [UIScreen mainScreen].bounds.size;
        //更新界面布局
        
        //动画播放完成之后
        if(screen.width > screen.height){
            NSLog(@"横屏");
        }else{
            NSLog(@"竖屏");
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"动画播放完之后处理");
    }];
}

#pragma mark - Text field delegete

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 点击屏幕结束编辑
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
