//
//  HorizontalFlowLayout.m
//  Summary
//
//  Created by 马腾飞 on 17/2/6.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "HorizontalFlowLayout.h"
static CGFloat const ActiveDistance = 140;
static CGFloat const ScaleFactor = 0.2;
static CGFloat const NotFocusAlpha = 1.0;
@implementation HorizontalFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}


//如果返回YES，那么collectionView显示的范围发生改变时，就会重新刷新布局
//一旦重新刷新布局，就会按顺序调用下面的方法：
//- prepareLayout
//- layoutAttributesForElementsInRect:
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//做一些初始化操作
- (void)prepareLayout
{
    [super prepareLayout];
    
}

//数组中的UICollectionViewLayoutAttributes对象决定了cell的排布方式(这里设置放大范围)
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //如果cell在屏幕上则进行缩放
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            attributes.alpha = NotFocusAlpha;
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//距离中点的距离
            CGFloat normalizedDistance = distance / ActiveDistance;
            NSLog(@"distance:%f====normalizedDistance:%f",distance,normalizedDistance);
            if (ABS(distance) < ActiveDistance)
            {
                CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance)); //放大渐变
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
                attributes.alpha = NotFocusAlpha+NotFocusAlpha*(1-ABS(normalizedDistance));
            }
        }
    }
    
    return array;
}

//scroll 停止对中间位置进行偏移量校正
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    ////  |-------[-------]-------|
    ////  |滑动偏移|可视区域 |剩余区域|
    //是整个collectionView在滑动偏移后的当前可见区域的中点
    CGFloat centerX = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    //    CGFloat centerX = self.collectionView.center.x; //这个中点始终是屏幕中点
    //所以这里对collectionView的具体尺寸不太理解，输出的是屏幕大小，但实际上宽度肯定超出屏幕的
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttr in array) {
        CGFloat itemCenterX = layoutAttr.center.x;
        
        if (ABS(itemCenterX - centerX) < ABS(offsetAdjustment)) { // 找出最小的offset 也就是最中间的item 偏移量
            offsetAdjustment = itemCenterX - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
