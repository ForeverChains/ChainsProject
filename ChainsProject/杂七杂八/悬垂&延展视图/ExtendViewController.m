//
//  ExtendViewController.m
//  Summary
//
//  Created by 马腾飞 on 16/8/2.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "ExtendViewController.h"
#import "ExtendView.h"

@interface ExtendViewController ()

@end

@implementation ExtendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"延展视图";
    ExtendView *view = [[ExtendView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) image:[UIImage imageNamed:@"1"] unidirectionMode:YES];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
