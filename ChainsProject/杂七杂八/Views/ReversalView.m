//
//  ReversalView.m
//  JingShanFuse
//
//  Created by 马腾飞 on 17/6/20.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "ReversalView.h"

@implementation ReversalView

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(6, 6, self.width-12, self.height-30)];
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.textColor = [UIColor chains_colorWithHexString:@"666666" alpha:1];
        _textView.editable = NO;
        _textView.selectable = NO;
    }
    
    return _textView;
}

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    }
    
    return _imgView;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.textView.text = text;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    self.imgView.image = [UIImage imageNamed:imageName];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    if (!self.backView)
    {
        self.backView = [[UIView alloc] init];
        self.backView.frame = CGRectMake(0, 0, self.width, self.height);
        self.backView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"biaoqian_kjdz02"]];
        bgImageView.frame = CGRectMake(0, 0, self.width, self.height);
        [self.backView addSubview:bgImageView];
        
        
        [self.backView addSubview:self.textView];
    }
    if (!self.frontView)
    {
        self.frontView = [[UIView alloc] init];
        self.frontView.frame = CGRectMake(0, 0, self.width, self.height);
        self.frontView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.frontView];
        
        [self.frontView addSubview:self.imgView];
    }
    if (!self.tapRecognizer)
    {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [self addGestureRecognizer:self.tapRecognizer];
    }
}

- (void)tapEvent:(UITapGestureRecognizer *)sender
{
    sender.enabled = NO;
    
    UIView *fromView = self.goingToFrontView ? self.backView : self.frontView;
    UIView *toView = self.goingToFrontView ? self.frontView : self.backView;
    
    
    UIViewAnimationOptions transitionDirection = self.goingToFrontView ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:transitionDirection
                    completion:^(BOOL finished) {
                        sender.enabled = YES;
                    }];
    
    self.goingToFrontView = !self.goingToFrontView;
}

@end
