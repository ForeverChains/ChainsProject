//
//  Chains_PlaceholderView.m
//  Ticket
//
//  Created by lianzun on 2018/5/30.
//  Copyright © 2018年 胡员外. All rights reserved.
//

#import "Chains_PlaceholderView.h"

@implementation Chains_PlaceholderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.innerView)
    {
        [self addSubview:self.innerView];
        [self sendSubviewToBack:self.innerView];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addSubview:self.innerView];
        [self sendSubviewToBack:self.innerView];
    }
    return self;
}

- (UIView *)innerView
{
    if (!_innerView)
    {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
            if (self.blockUpdateDataSource) self.blockUpdateDataSource();
        }];
        [_innerView addGestureRecognizer:tapGesture];
    }
    return _innerView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.innerView.frame = CGRectMake(0, 0, self.width, self.height);
}

+ (instancetype)defaultViewWithFrame:(CGRect)frame
{
    return [[Chains_PlaceholderView alloc] initWithFrame:frame];
}

@end
