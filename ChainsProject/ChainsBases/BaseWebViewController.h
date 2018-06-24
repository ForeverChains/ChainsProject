//
//  CommonWebViewController.h
//  NanShaProject
//
//  Created by 马腾飞 on 16/4/11.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : BaseViewController

@property (strong, nonatomic) NSURL *link;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end
