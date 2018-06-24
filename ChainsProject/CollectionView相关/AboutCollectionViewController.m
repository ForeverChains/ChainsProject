//
//  AboutCollectionViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/1/18.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "AboutCollectionViewController.h"
#import "PageCollectionViewController.h"
#import "HorizontalViewController.h"
#import "WaterFallViewController.h"

static NSString *const kCellIdentifier = @"Cell";

@interface AboutCollectionViewController ()
@property (nonatomic ,weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation AboutCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"CollectionView相关";
    self.dataArr = [NSMutableArray arrayWithArray:@[@"横向滑动分页",@"图片水平滚动",@"瀑布流"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    cell.textLabel.text = _dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_dataArr[indexPath.row] isEqualToString:@"横向滑动分页"])
    {
        PageCollectionViewController *vc = [[PageCollectionViewController alloc] init];
        vc.dataArr = @[@"image1",@"image2",@"image3",@"image4",@"image5",@"image6",@"image7",@"image8",@"image10",@"image9"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"图片水平滚动"])
    {
        HorizontalViewController *vc = [[HorizontalViewController alloc] init];
        vc.dataArr = @[@"image1",@"image2",@"image3",@"image4",@"image5",@"image6",@"image7",@"image8"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"瀑布流"])
    {
        WaterFallViewController *vc = [[WaterFallViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
