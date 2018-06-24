//
//  WaterFallViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/4/18.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "WaterFallViewController.h"
#import "Shop.h"
#import "WaterPullCell.h"
#import "WaterFallLayout.h"
#import "MJRefresh.h"
#import "MJExtension.h"

@interface WaterFallViewController ()<UICollectionViewDataSource, WaterFallLayoutDelegate>

/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView;

/** shops */
@property (nonatomic, strong) NSMutableArray *shops;

/** 当前页码 */
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation WaterFallViewController

- (NSMutableArray *)shops
{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置当前页码为0
    self.currentPage = 0;
    
    // 初始化瀑布流view
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCollectionView
{
    // 创建瀑布流layout
    WaterFallLayout *layout = [[WaterFallLayout alloc] init];
    // 设置代理
    layout.delegate = self;
    
    // 创建瀑布流view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterPullCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WaterPullCell class])];
    
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            
            // 清空数据
            [self.shops removeAllObjects];
            
            [self.shops addObjectsFromArray:[self newShops]];
            
            // 刷新数据
            [self.collectionView reloadData];
            
            // 停止刷新
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    // 第一次进入则自动加载
    [self.collectionView.mj_header beginRefreshing];
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            
            [self.shops addObjectsFromArray:[self moreShopsWithCurrentPage:self.currentPage]];
            
            // 刷新数据
            [self.collectionView reloadData];
            
            // 停止刷新
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - 内部方法
- (NSArray *)newShops
{
    return [Shop mj_objectArrayWithFilename:@"0.plist"];
}

- (NSArray *)moreShopsWithCurrentPage:(NSUInteger)currentPage
{
    // 页码的判断
    if (currentPage == 3) {
        self.currentPage = 0;
    } else {
        self.currentPage++;
    }
    
    NSString *nextPage = [NSString stringWithFormat:@"%lu.plist", self.currentPage];
    
    return [Shop mj_objectArrayWithFilename:nextPage];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    WaterPullCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WaterPullCell class]) forIndexPath:indexPath];
    
    // 给cell传递模型
    cell.shop = self.shops[indexPath.item];
    
    // 返回cell
    return cell;
}

#pragma mark - <JRWaterFallLayoutDelegate>
/**
 *  返回每个item的高度
 */
- (CGFloat)waterFallLayout:(WaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width
{
    Shop *shop = self.shops[index];
    CGFloat shopHeight = [shop.h doubleValue];
    CGFloat shopWidth = [shop.w doubleValue];
    return shopHeight * width / shopWidth;
}



@end
