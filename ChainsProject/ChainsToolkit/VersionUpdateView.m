//
//  VersionUpdateView.m
//  CommonProject
//
//  Created by lianzun on 2018/1/18.
//  Copyright © 2018年 MTF. All rights reserved.
//

#import "VersionUpdateView.h"

#import "Version.h"

@interface VersionUpdateView()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation VersionUpdateView

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
        
        [UIView chains_cutCornerWithRadius:10. forViews:@[_innerView]];
        [UIView chains_cutCornerWithRadius:4. forViews:@[_updateBtn]];
        self.topView.backgroundColor = [UIColor chains_colorWithHexString:COLOR_THEME];
        self.updateBtn.backgroundColor = [UIColor chains_colorWithHexString:COLOR_THEME];
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
    return [[VersionUpdateView alloc] initWithFrame:frame];
}

- (void)setModel:(Version *)model
{
    _model = model;
    self.textView.text = model.versionDescribe;
}

- (IBAction)updateButtonClick:(id)sender
{
    [self.parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
    //更新版本
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.marketUrl]];
}

- (IBAction)cancelButtonClick:(id)sender
{
    [self.parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

@end
