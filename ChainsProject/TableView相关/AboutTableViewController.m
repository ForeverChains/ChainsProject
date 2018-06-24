//
//  AboutTableViewController.m
//  Summary
//
//  Created by 马腾飞 on 16/9/1.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "AboutTableViewController.h"
#import "MultiSelectViewController.h"
#import "MoveCellViewController.h"

static NSString *const kCellIdentifier = @"Cell";

@interface AboutTableViewController ()
@property (nonatomic ,weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"TableView相关";
    self.dataArr = [NSMutableArray arrayWithArray:@[@"多选删除",@"cell移动"]];
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
    
    if ([_dataArr[indexPath.row] isEqualToString:@"多选删除"])
    {
        MultiSelectViewController *vc = [[MultiSelectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"cell移动"])
    {
        MoveCellViewController *vc = [[MoveCellViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置分割线顶头开始
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsZero];
//        }
//    
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsZero];
//        }
    
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];
    
        scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
        [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
    
//    CATransform3D rotation;
//    
//    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34 = 1.0/ -600;
//    cell.layer.transform = rotation;
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    //    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
}

@end
