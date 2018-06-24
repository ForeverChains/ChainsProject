//
//  VersionUpdateView.h
//  CommonProject
//
//  Created by lianzun on 2018/1/18.
//  Copyright © 2018年 MTF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LewPopupViewHeader.h"

#define VersionUpdateView_Width             220
#define VersionUpdateView_Height            175

@class Version;

@interface VersionUpdateView : UIView
@property (nonatomic) IBOutlet UIView *innerView;
@property (nonatomic, weak) UIViewController *parentVC;
+ (instancetype)defaultViewWithFrame:(CGRect)frame;

@property (strong, nonatomic) Version *model;
@end
