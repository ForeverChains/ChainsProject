//
//  ReversalView.h
//  JingShanFuse
//
//  Created by 马腾飞 on 17/6/20.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReversalView : UIView
//@property (nonatomic, weak) IBOutlet UIView *innerView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (strong, nonatomic) UIView *frontView;
@property (strong, nonatomic) UIView *backView;
@property (nonatomic) BOOL goingToFrontView;

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imgView;
@end
