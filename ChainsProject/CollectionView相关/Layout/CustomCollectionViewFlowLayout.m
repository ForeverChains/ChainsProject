//
//  CustomCollectionViewFlowLayout.m
//  JianHuEducation
//
//  Created by 马腾飞 on 17/1/17.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

#define WIDTH_ITEM            80
#define HEIGHT_ITEM           80

@interface CustomCollectionViewFlowLayout()
@property (strong, nonatomic) NSMutableArray *allAttributes;
@end

@implementation CustomCollectionViewFlowLayout

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
    
    
    
    self.allAttributes = [NSMutableArray array];
    
    NSInteger page = 0;
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        page = i /(_itemCountPerRow * _rowCount);
        
        float x = WIDTH_ITEM * (i % _itemCountPerRow) + page * 300;
        float y = HEIGHT_ITEM * (i - page*_itemCountPerRow*_rowCount)/_itemCountPerRow;
        attributes.frame = CGRectMake(x, y, WIDTH_ITEM, HEIGHT_ITEM);
        
        [self.allAttributes addObject:attributes];
    }
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger item = indexPath.item;
//    NSUInteger x;
//    NSUInteger y;
//    [self targetPositionWithItem:item resultX:&x resultY:&y];
//    NSUInteger item2 = [self originItemAtX:x y:y];
//    NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:item2 inSection:indexPath.section];
//    
//    UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];
//    theNewAttr.indexPath = indexPath;
//    return theNewAttr;
//}

// 根据 item 计算目标item的位置
// x 横向偏移  y 竖向偏移
- (void)targetPositionWithItem:(NSUInteger)item
                       resultX:(NSUInteger *)x
                       resultY:(NSUInteger *)y
{
    NSUInteger page = item/(self.itemCountPerRow*self.rowCount);
    
    NSUInteger theX = item % self.itemCountPerRow + page * self.itemCountPerRow;
    NSUInteger theY = item / self.itemCountPerRow - page * self.rowCount;
    if (x != NULL) {
        *x = theX;
    }
    if (y != NULL) {
        *y = theY;
    }
}

// 根据偏移量计算item
- (NSUInteger)originItemAtX:(NSUInteger)x
                          y:(NSUInteger)y
{
    NSUInteger item = x * self.rowCount + y;
    return item;
}

//数组中的UICollectionViewLayoutAttributes对象决定了cell的排布方式
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attr in array) {
        for (UICollectionViewLayoutAttributes *attr2 in self.allAttributes) {
            if (attr.indexPath.item == attr2.indexPath.item) {
                [tmp addObject:attr2];
                break;
            }
        }
    }
    return tmp;
}

//返回值决定了collectionView停止滚动时最终的偏移量
//proposedContentOffset:更改最终的偏移量
//velocity:滚动速率，通过这个参数可以了解滚动的方向
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.pageBlock)
    {
        // 除法取整 取余数
        div_t x = div(proposedContentOffset.x,self.collectionView.bounds.size.width);
        if (x.quot == 0)
        {
            self.pageBlock(1);
        }
        else
        {
            if (x.quot > 0 && x.rem > 0) {
                self.pageBlock(x.quot + 2);
            }
            if (x.quot > 0 && x.rem == 0) {
                self.pageBlock(x.quot + 1);
            }
        }
    }
    return proposedContentOffset;
}

@end
