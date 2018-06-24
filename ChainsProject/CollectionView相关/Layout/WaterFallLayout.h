//
//  WaterFallLayout.h
//  Summary
//
//  Created by 马腾飞 on 17/4/18.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFallLayout;

@protocol WaterFallLayoutDelegate <NSObject>

@required
// 返回index位置下的item的高度
- (CGFloat)waterFallLayout:(WaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width;

@optional
// 返回瀑布流显示的列数
- (NSUInteger)columnCountOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;
// 返回行间距
- (CGFloat)rowMarginOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;
// 返回列间距
- (CGFloat)columnMarginOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;
// 返回边缘间距
- (UIEdgeInsets)edgeInsetsOfWaterFallLayout:(WaterFallLayout *)waterFallLayout;


@end

@interface WaterFallLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id<WaterFallLayoutDelegate> delegate;

@end
