//
//  HangViewController.m
//  Summary
//
//  Created by 马腾飞 on 16/8/2.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "HangViewController.h"
#import "HangView.h"

@interface HangViewController ()
@property (nonatomic, strong) HangView *hangView;
@end

@implementation HangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"悬垂视图";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.hangView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hangView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HangView *)hangView
{
    if (!_hangView)
    {
        _hangView = [[HangView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth+100, kMainScreenHeight) image:@"0"];
    }
    
    return _hangView;
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
