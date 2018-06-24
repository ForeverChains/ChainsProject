//
//  MoveCellViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/5/3.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "MoveCellViewController.h"
#import "MovableCellTableView.h"

@interface MoveCellViewController ()<MovableCellTableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MoveCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [NSMutableArray new];
    for (NSInteger section = 0; section < 6; section ++) {
        NSMutableArray *sectionArray = [NSMutableArray new];
        for (NSInteger row = 0; row < 5; row ++) {
            [sectionArray addObject:[NSString stringWithFormat:@"section -- %ld row -- %ld", section, row]];
        }
        [_dataSource addObject:sectionArray];
    }
    
//    for (int i = 0; i <20; i++)
//    {
//        [_dataSource addObject:[NSString stringWithFormat:@"row -- %d", i]];
//    }
    
    MovableCellTableView *tableView = [[MovableCellTableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (NSArray *)dataSourceArrayInTableView:(MovableCellTableView *)tableView
{
    return _dataSource.copy;
}

- (void)tableView:(MovableCellTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray
{
    _dataSource = newDataSourceArray.mutableCopy;
    [_dataSource enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"section:%d",idx);
        [obj enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",obj);
        }];
    }];
}

@end
