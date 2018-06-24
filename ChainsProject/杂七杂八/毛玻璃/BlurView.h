//
//  BlurView.h
//  Summary
//
//  Created by 马腾飞 on 17/5/11.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurView : UIView
@property (nonatomic, weak) IBOutlet UIVisualEffectView *visualView;
@property (nonatomic, strong)IBOutlet UIView *innerView;
@end
