//
//  AnimationViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/6/30.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "AnimationViewController.h"
#import "CircleRippleView.h"
#import "UICountingLabel.h"
#import "ReversalView.h"
#import "WaveView.h"

@interface AnimationViewController ()
@property (nonatomic, weak) IBOutlet CircleRippleView *rippleView;
@property (weak, nonatomic) IBOutlet UICountingLabel *label;
@property (nonatomic, weak) IBOutlet ReversalView *reversalView;
@property (nonatomic, weak) IBOutlet UIView *animationView;
@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.rippleView startAnimation];
    
    _label.method = UILabelCountingMethodLinear;
    _label.font = [UIFont boldSystemFontOfSize:20];
    _label.textColor = [UIColor chains_colorWithHexString:@"46C4B1" alpha:1];
    _label.format = @"%.1f";
    [self.label countFrom:1 to:430.4 withDuration:1.2];
    
    self.reversalView.imageName = @"biaoqian_hkg01";
    self.reversalView.text = @"新桥国际机场于2013年5月30日正式启用，是国内4E级区域性枢纽机场、国家一类航空口岸、安徽对外开放的重要窗口。已建成运营水果、冰鲜水产品进境指定口岸，申报建设可食用水生动物、药品进境等指定口岸，致力打造安徽门类最多、检验最便捷、最具成本优势的口岸高地。";
    
    [self.animationView chains_transitionWithType:PageUnCurl subtype:TransitionFromLeft duration:5];
    
    WaveView *firstWaveView = [[WaveView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) waveColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1] waveSpeed:0.02 waveA:12 waveW:0.5/30.0 wave4:0];
    firstWaveView.alpha = 0.6;
    WaveView *secondWaveView = [[WaveView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) waveColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1] waveSpeed:0.04 waveA:13 waveW:0.5/30.0 wave4:M_PI_2];
    secondWaveView.alpha = 0.6;
    [self.view addSubview:firstWaveView];
    [self.view addSubview:secondWaveView];
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
