//
//  UIView+IBInspectable.m
//  WYPatient
//
//  Created by qiumx on 15/10/27.
//  Copyright © 2015年 FLy. All rights reserved.
//

#import "UIView+IBInspectable.h"

@implementation UIView (WYIBInspectable)
#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(NSInteger)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (NSInteger)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(NSInteger)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (NSInteger)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setMasksToBounds:(BOOL)bounds{
    self.layer.masksToBounds = bounds;
}

- (BOOL)masksToBounds{
    return self.layer.masksToBounds;
}
@end
