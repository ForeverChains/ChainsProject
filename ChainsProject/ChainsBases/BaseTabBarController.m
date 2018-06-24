//
//  BaseTabBarController.m
//  CommonProject
//
//  Created by lianzun on 2017/9/20.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseWebViewController.h"
#import "CustomTabBar.h"

#import "MBProgressHUD.h"

//跳转AppStore评价
#import <StoreKit/StoreKit.h>

@interface BaseTabBarController ()<UITabBarControllerDelegate, SKStoreProductViewControllerDelegate>
@property (assign, nonatomic) NSInteger selectedVC;
@property (strong, nonatomic) UIButton *centerBtn;
@property (weak, nonatomic) id notificationObserver;
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationMaskPortrait] forKey:@"orientation"];
    
    self.delegate = self;
    self.tabBar.translucent = NO;
    
//    self.tabBar.backgroundImage = [UIImage new];
//    self.tabBar.shadowImage = [UIImage new];
    
//    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye_dibulan"]];
//    bgImgView.frame = CGRectMake(0, 0, kMainScreenWidth, kTabBarHeight);
//    [self.tabBar insertSubview:bgImgView atIndex:0];
    
    if (self.needCustomTabBar)
    {
        CustomTabBar *tabBar = [[CustomTabBar alloc] init];
        tabBar.blockCenterButtonClick = ^{
            
        };
        self.specialIndex = 2;
        [self setValue:tabBar forKey:@"tabBar"];
    }
    else
    {
        self.specialIndex = -1;
    }
    
    self.vcNameArr = @[@"ListViewController",@"AboutTableViewController",@"AboutCollectionViewController"];
    self.titleArr = @[@"杂七杂八",@"Table相关",@"Collection相关"];
    self.normalImageArr = @[@"",@"",@""];
    self.selectedImageArr = @[@"",@"",@""];
    [self addAllChildViewController];
    
    //~~~~~~~~~to do ~~~~~~~~这里改为通知
    weakReference(self);
    [ApplicationContext sharedInstance].blockGiveUpLogin = ^{
        weakVar.selectedIndex = _selectedVC;
        weakVar.centerBtn.selected = (weakVar.selectedVC == weakVar.specialIndex);
    };
    
    
    // 引导图 初次安装启动展示
    NSLog(@"kUserDefaults_NotFirstLaunch====>%d",[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaults_NotFirstLaunch]);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaults_NotFirstLaunch])
    {
        
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.notificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    //    NSLog(@"shouldAutorotate:%d",[self.selectedViewController shouldAutorotate]);
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //    NSLog(@"supportedInterfaceOrientations:%lu",(unsigned long)[self.selectedViewController supportedInterfaceOrientations]);
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

// 添加全部的 childViewcontroller
- (void)addAllChildViewController
{
    [self.vcNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseViewController *vc = [[NSClassFromString(obj) alloc] init];
        [self addChildViewController:vc title:_titleArr[idx] normalImage:_normalImageArr[idx] selectedImage:_selectedImageArr[idx] index:idx];
    }];
}

// 添加某个 childViewController
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage index:(NSUInteger)index
{
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    // 字体样式
    NSDictionary *normalFontDictionary = @{NSForegroundColorAttributeName:COLOR_RGBA(117, 117, 117, 1),
                                                NSFontAttributeName:[UIFont systemFontOfSize:10]};
    
    NSDictionary *selectedFontDictionary = @{NSForegroundColorAttributeName:[UIColor chains_colorWithHexString:COLOR_THEME alpha:1],
                                                NSFontAttributeName:[UIFont systemFontOfSize:10]};
    [nav.tabBarItem setTitleTextAttributes:normalFontDictionary forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectedFontDictionary forState:UIControlStateSelected];
    
    if (index == self.specialIndex)
    {
        [self addCenterButtonWithNormalImage:normalImage selectedImage:selectedImage];
    }
    else
    {
        nav.tabBarItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [self addChildViewController:nav];
}

//添加中间按钮（根据需求变动）
-(void)addCenterButtonWithNormalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage
{
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGFloat buttonWidth = self.tabBar.frame.size.width / 5 - 6;
    
    centerButton.frame = CGRectMake(origin.x - buttonWidth/2, origin.y - buttonWidth/2 - 13, buttonWidth, buttonWidth);
    
    [centerButton setImage:[UIImage imageNamed:normalImage]  forState:UIControlStateNormal];
    [centerButton setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [centerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:centerButton];
    self.centerBtn = centerButton;
}

- (void)buttonClick:(id)sender
{
    [self setSelectedIndex:_specialIndex];
}

/**
 *  Pass events for center button
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.centerBtn.frame;
    if (CGRectContainsPoint(rect, point)) return self.centerBtn;
    return [self.view hitTest:point withEvent:event];
}

- (void)evaluateApp
{
    //判断是否评价过
    BOOL everEvaluate = [[NSUserDefaults standardUserDefaults] boolForKey:@"EverEvaluate"];
    if (everEvaluate)
    {
        return;
    }
    else
    {
        //判断启动次数,对30取余等29,则提示评分
        NSInteger launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"CountOfLaunch"];
        NSLog(@"CountOfLaunch:%ld",(long)launchCount);
        if (launchCount % 30 == 29)
        {
            NSLog(@"提示评分");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的支持与建议是我们不断完善的动力" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"前往评分" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EverEvaluate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
                storeProductViewContorller.delegate = self;
                //显示菊花
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"1000954710"}
                                                      completionBlock:^(BOOL result, NSError * _Nullable error) {
                                                          //隐藏菊花
                                                          [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                          if (error)
                                                          {
                                                              NSLog(@"获取应用信息失败:%@",error);
                                                          }
                                                          else
                                                          {
                                                              [self presentViewController:storeProductViewContorller animated:YES completion:nil];
                                                          }
                                                      }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"暂不评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [[NSUserDefaults standardUserDefaults] setInteger:launchCount+1 forKey:@"CountOfLaunch"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *bottomVC;
    if ([viewController isKindOfClass:[BaseNavigationController class]])
    {
        BaseNavigationController *baseNav = (BaseNavigationController *)viewController;
        bottomVC = baseNav.viewControllers[0];
    }
    else
    {
        bottomVC = viewController;
    }
    //点击直接跳转新界面，不展示bottomVC，return NO
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //记录上次选中，放弃登录时跳转该界面
    UIViewController *bottomVC;
    if ([viewController isKindOfClass:[BaseNavigationController class]])
    {
        BaseNavigationController *baseNav = (BaseNavigationController *)viewController;
        bottomVC = baseNav.viewControllers[0];
    }
    else
    {
        bottomVC = viewController;
    }
    //非登录不能展示的界面不记录，防止循环跳转登录
    if (![bottomVC isKindOfClass:NSClassFromString(@"TFMineVC")])
        _selectedVC = self.selectedIndex;
    //中间按钮选中状态
    if (self.centerBtn) self.centerBtn.selected = (self.specialIndex == self.selectedIndex);
}

@end
