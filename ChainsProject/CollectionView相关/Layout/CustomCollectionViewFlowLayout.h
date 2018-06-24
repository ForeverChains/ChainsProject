//
//  CustomCollectionViewFlowLayout.h
//  JianHuEducation
//
//  Created by 马腾飞 on 17/1/17.
//  Copyright © 2017年 chains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewFlowLayout : UICollectionViewFlowLayout
// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@property (copy, nonatomic) void(^pageBlock)(NSInteger pageNum);
@end
