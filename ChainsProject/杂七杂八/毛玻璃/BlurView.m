//
//  BlurView.m
//  Summary
//
//  Created by 马腾飞 on 17/5/11.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "BlurView.h"

@interface BlurView()

@end

@implementation BlurView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_innerView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    [self addSubview:self.innerView];
}

@end
