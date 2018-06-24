//
//  PageCollectionViewController.m
//  Summary
//
//  Created by 马腾飞 on 17/1/19.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "PageCollectionViewController.h"
#import "PagedCollectionView.h"
#import "ImageCell.h"

#define WIDTH_CELL     80
#define HEIGHT_CELL    80
#define SPACE          20

@interface PageCollectionViewController ()<PagedCollectionViewDataSource, PagedCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet PagedCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *pageLab;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (assign, nonatomic) NSInteger pageNum;
@end

@implementation PageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cellIdentifier = @"ImageCell";
    self.collectionView.cellIdentifier = self.cellIdentifier;
    self.collectionView.cellClassName = @"ImageCell";
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.itemSize = CGSizeMake(WIDTH_CELL, HEIGHT_CELL);
    self.collectionView.columnCount = 3;
    self.collectionView.lineCount = 2;
    
    [self.collectionView reloadData];
    
    self.collectionView.pageBlock = ^(NSInteger pageNum){
        self.pageControl.currentPage = pageNum;
        self.pageLab.text = [NSString stringWithFormat:@"%ld/%d",pageNum+1,2];
    };
    
    if (self.pageNum == 1)
    {
        self.pageLab.hidden = YES;
    }
    else
    {
        self.pageLab.text = [NSString stringWithFormat:@"1/%ld",self.pageNum];
    }
    self.pageControl.numberOfPages = self.pageNum;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    div_t rs = div((int)dataArr.count,6);
    if (rs.rem == 0)
    {
        self.pageNum = rs.quot;
    }
    else
    {
        self.pageNum = rs.quot +1;
    }
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    cell.pic.image = [UIImage imageNamed:self.dataArr[indexPath.item]];
    NSLog(@"%@",_dataArr[indexPath.item]);
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}

#pragma mark -  PagedCollectionViewDataSource
- (void)pagedCollectionView:(PagedCollectionView *)collectionView secionChanged:(NSInteger)section{
    NSLog(@"change section to %ld", (long)section);
}

- (BOOL)pageControlViewShouldHideForSection:(NSInteger)section
{
    return YES;
}

@end
