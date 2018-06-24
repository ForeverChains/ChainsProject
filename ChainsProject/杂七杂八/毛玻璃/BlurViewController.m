//
//  BlurViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/2/9.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "BlurViewController.h"

@interface BlurViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@end

@implementation BlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 创建UIBlurEffect类的对象blur, 参数以UIBlurEffectStyleLight为例.
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // 创建UIVisualEffectView的对象visualView, 以blur为参数.
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    visualView.frame = CGRectMake(self.blurImageView.centerX-60, 0, 100, self.blurImageView.frame.size.height);
    
    visualView.alpha = 1.0;
    
    // 将visualView添加到blurImageView上.
    [self.blurImageView addSubview:visualView];
    
    //结合使用UIVibrancyEffect与UIVisualEffectView可以调整文本的颜色使得App看上去更加艳丽。UIVibrancyEffect必须添加到已经用UIBlurEffect配置过的UIVisualEffectView中去，否则就不会有任何的虚化图片会应用Vibrancy效果。
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
    vibrancyEffectView.frame = CGRectMake(0, 0, 100, self.blurImageView.frame.size.height);
    
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"Vibrant!!!";
    lab.font = [UIFont systemFontOfSize:17];
    [lab sizeToFit];
    lab.center = visualView.contentView.center;
    
    [vibrancyEffectView.contentView addSubview:lab];//lab需要加在vibrancyEffectView的contentView上才有效果
    [visualView.contentView addSubview:vibrancyEffectView];
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
