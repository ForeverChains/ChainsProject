//
//  UILabel+Chains.m
//  MyConclusion
//
//  Created by 马腾飞 on 15/8/21.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import "UILabel+Chains.h"

@implementation UILabel (Chains)

- (void)chains_setParagraphStyleWithLineSpace:(CGFloat)space
{
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:space];//调整行间距
    
    [attribtStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    
    self.attributedText = attribtStr;
}

- (void)chains_changeTextColor:(UIColor *)color text:(NSString *)text
{
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange range = [self.text rangeOfString:text];
    [attribtStr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    self.attributedText = attribtStr;
}

//@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
- (void)chains_drawLineOnTheCenterWithLineStyle:(NSUnderlineStyle)style lineColor:(UIColor *)color
{
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    //@{NSBaselineOffsetAttributeName: @(0)},iOS10以后添加
    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:@(style) range:NSMakeRange(0, self.text.length)];
    [attribtStr addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    self.attributedText = attribtStr;
}

- (void)chains_drawLineOnTheBottomWithLineStyle:(NSUnderlineStyle)style lineColor:(UIColor *)color
{
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:@(style) range:NSMakeRange(0, self.text.length)];
    [attribtStr addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    self.attributedText = attribtStr;
}

@end
