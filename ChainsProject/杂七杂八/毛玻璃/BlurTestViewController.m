//
//  BlurTestViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/5/11.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "BlurTestViewController.h"
#import "BlurView.h"

@interface BlurTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *visualView;
@property (nonatomic, strong) BlurView *topView;
@property (nonatomic, strong) BlurView *bottomView;
@end

@implementation BlurTestViewController

- (BlurView *)topView
{
    if (!_topView)
    {
        _topView = [[BlurView alloc] initWithFrame:CGRectMake(0, -150, kMainScreenWidth, 150)];
        _topView.backgroundColor = [UIColor clearColor];
        _topView.innerView.backgroundColor = [UIColor chains_colorWithHexString:@"ffffff" alpha:0.6];
        _topView.innerView.alpha = 0;
        _topView.visualView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((kMainScreenWidth-200)/2, 50, 200, 60);
        view.backgroundColor = [UIColor cyanColor];
        [_topView addSubview:view];
    }
    
    return _topView;
}

- (BlurView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[BlurView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-150, kMainScreenWidth, 150)];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.innerView.backgroundColor = [UIColor chains_colorWithHexString:@"000000" alpha:0.5];
        _bottomView.visualView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _bottomView.visualView.alpha = 0.8;
        _bottomView.alpha = 0;
    }
    
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftButtonClick:(UIButton *)sender
{
    [self.view bringSubviewToFront:sender];
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [UIView animateWithDuration:1
                         animations:^{
                             self.visualView.alpha = 1;
                             self.topView.frame = CGRectMake(0, 0, kMainScreenWidth, 150);
                             
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5 animations:^{
                                 self.topView.innerView.alpha = 0.6;
                                 self.topView.visualView.alpha = 0.6;
                                 
                                 self.bottomView.alpha = 0.5;
                             }];
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.topView.innerView.alpha = 0;
                             self.topView.visualView.alpha = 0;
                             
                             self.bottomView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:1 animations:^{
                                 self.visualView.alpha = 0;
                                 self.topView.frame = CGRectMake(0, -150, kMainScreenWidth, 150);
                             }];
                         }];
    }
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
