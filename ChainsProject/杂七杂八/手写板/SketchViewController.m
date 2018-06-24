//
//  SketchViewController.m
//  Summary
//
//  Created by 马腾飞 on 16/8/2.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "SketchViewController.h"
#import "SketchView.h"

@interface SketchViewController ()

@property (weak, nonatomic) IBOutlet SketchView *sketch;

@end

@implementation SketchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"手写板";
    self.sketch.playAnimation = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toolBarClick:(UIBarButtonItem *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [self.sketch undoEvent];
        }
            break;
        case 1:
        {
            [self.sketch recoverEvent];
        }
            break;
        case 2:
        {
            [self.sketch clearEvent];
        }
            break;
        case 3:
        {
            [self.sketch savePictureToAlbum];
        }
            break;
        case 4:
        {
            self.sketch.rubber = !self.sketch.isRubber;
        }
            break;
            
        default:
            break;
    }
}

@end
