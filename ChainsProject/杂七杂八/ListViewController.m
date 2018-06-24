//
//  ListViewController.m
//  Summary
//
//  Created by 马腾飞 on 16/8/2.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "ListViewController.h"
#import "HangViewController.h"
#import "ExtendViewController.h"
#import "SketchViewController.h"
#import "BlurViewController.h"
#import "LayerTestViewController.h"
#import "BlurTestViewController.h"
#import "AnimationViewController.h"

static NSString *const kCellIdentifier = @"Cell";

@interface ListViewController ()

@property (nonatomic ,weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"功能列表";
    self.dataArr = [NSMutableArray arrayWithArray:@[@"悬垂视图",@"延展视图",@"手写板",@"毛玻璃",@"Core Animation",@"动画"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
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
    if ([_dataArr[indexPath.row] isEqualToString:@"悬垂视图"])
    {
        HangViewController *vc = [[HangViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"延展视图"])
    {
        ExtendViewController *vc = [[ExtendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"手写板"])
    {
        SketchViewController *vc = [[SketchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"毛玻璃"])
    {
        BlurViewController *vc = [[BlurViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
//        BlurTestViewController *vc = [[BlurTestViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"Core Animation"])
    {
        LayerTestViewController *vc = [[LayerTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"动画"])
    {
        AnimationViewController *vc = [[AnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置分割线顶头开始
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    
//    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];
//    
//    scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
//    
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
    
    CATransform3D rotation;
    
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    cell.layer.transform = rotation;
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

@end
