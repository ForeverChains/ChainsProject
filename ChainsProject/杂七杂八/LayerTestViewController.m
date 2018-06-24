//
//  LayerTestViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/5/8.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "LayerTestViewController.h"

@interface LayerTestViewController ()
@property (nonatomic, weak) IBOutlet UIView *layerView;
@end

@implementation LayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
     CALayer是UIView内部实现细节
     和UIView最大的不同是CALayer不处理用户的交互。
     
     CALayer能做,视图不能做的:
     阴影，圆角，带颜色的边框
     3D变换
     非矩形范围
     透明遮罩
     多级非线性动画
     
     当满足以下条件的时候，你可能更需要使用CALayer而不是UIView:
     开发同时可以在Mac OS上运行的跨平台应用
     使用多种CALayer的子类，并且不想创建额外的UIView去包封装它们所有
     做一些对性能特别挑剔的工作，比如对UIView一些可忽略不计的操作都会引起显著的不同（尽管如此，你可能会直接想使用OpenGL绘图）
     */
//    CALayer *blueLayer = [CALayer layer];
//    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    //add it to our view
//    [self.layerView.layer addSublayer:blueLayer];
    
    
    /*
     关于CALayer的寄宿图（即图层中包含的图）
     
     CALayer 有一个属性叫做contents，这个属性的类型被定义为id，意味着它可以是任何类型的对象。在这种情况下，你可以给contents属性赋任何值，你的app仍然能够编译通过。但是，在实践中，如果你给contents赋的不是CGImage，那么你得到的图层将是空白的。
     contents这个奇怪的表现是由Mac OS的历史原因造成的。它之所以被定义为id类型，是因为在Mac OS系统上，这个属性对CGImage和NSImage类型的值都起作用。如果你试图在iOS平台上将UIImage的值赋给它，只能得到一个空白的图层。
     */
    UIImage *image = [UIImage imageNamed:@"0"];
    self.layerView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    /*
     contentsGravity的目的是为了决定内容在图层的边界中怎么对齐
     
     我们将使用kCAGravityResizeAspect，它的效果等同于UIViewContentModeScaleAspectFit， 同时它还能在图层中等比例拉伸以适应图层的边界
     */
    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
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
