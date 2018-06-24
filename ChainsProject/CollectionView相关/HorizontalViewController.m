//
//  HorizontalViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/2/6.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "HorizontalViewController.h"

#import "HorizontalFlowLayout.h"
#import "ImageCell.h"

@interface HorizontalViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation HorizontalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    HorizontalFlowLayout *layout = [[HorizontalFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ImageCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ImageCell class]) forIndexPath:indexPath];
    cell.pic.image = [UIImage imageNamed:self.dataArr[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    //滚动到中间
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(120, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

//使前后项都能居中显示
- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
    
    
}

@end
