//
//  MovableCellTableView.m
//  Summary
//
//  Created by 马腾飞 on 17/5/3.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "MovableCellTableView.h"

static NSTimeInterval kMovableCellAnimationTime = 0.25;

@interface MovableCellTableView()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;///< Initial index path, where gesture begins.
@property (nonatomic, strong) UIView *snapshot;///< A snapshot of the row user is moving.
@property (nonatomic, strong) NSMutableArray *tempDataSource;
@property (nonatomic, strong) CADisplayLink *edgeScrollTimer;

@end

@implementation MovableCellTableView

@dynamic dataSource;//禁止编译器为@property产生setter和getter方法

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initData];
        [self addGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
        [self addGesture];
    }
    return self;
}

- (void)initData
{
    _gestureMinimumPressDuration = 1.f;
    _canEdgeScroll = YES;
    _edgeScrollRange = 150.f;
}

- (void)setGestureMinimumPressDuration:(CGFloat)gestureMinimumPressDuration
{
    _gestureMinimumPressDuration = gestureMinimumPressDuration;
    _longPressGesture.minimumPressDuration = MAX(0.2, gestureMinimumPressDuration);
}

#pragma mark Gesture

- (void)addGesture
{
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    _longPressGesture.minimumPressDuration = _gestureMinimumPressDuration;
    [self addGestureRecognizer:_longPressGesture];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    //cancelsTouchesInView为YES的时候，系统会识别手势，并取消触摸事件；为NO的时候，手势跟触摸事件都将识别。
    _tapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_tapGesture];
}

- (void)tapGestureRecognized:(id)sender
{
    if (self.tapEventBlock)
    {
        self.tapEventBlock();
    }
}

- (void)longPressGestureRecognized:(id)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:longPress.view];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath)
            {
                //开启边缘滚动
                if (_canEdgeScroll) [self startEdgeScroll];
                
                //每次移动开始获取一次数据源
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataSourceArrayInTableView:)]) {
                    _tempDataSource = [self.dataSource dataSourceArrayInTableView:self].mutableCopy;
                }
                _sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                _snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                _snapshot.center = center;
                _snapshot.alpha = 0.0;
                [self addSubview:_snapshot];
                
                [UIView animateWithDuration:kMovableCellAnimationTime animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    _snapshot.center = center;
                    _snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    _snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            if (!_canEdgeScroll) [self gestureChanged:longPress];
            break;
        }
            
        default: {
            if (_canEdgeScroll) [self stopEdgeScroll];
            
            //返回交换后的数据源
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:newDataSourceArrayAfterMove:)]) {
                [self.dataSource tableView:self newDataSourceArrayAfterMove:_tempDataSource.copy];
            }
            
            // Clean up.
            UITableViewCell *cell = [self cellForRowAtIndexPath:_sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:kMovableCellAnimationTime animations:^{
                
                _snapshot.center = cell.center;
                _snapshot.transform = CGAffineTransformIdentity;
                _snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                _sourceIndexPath = nil;
                [_snapshot removeFromSuperview];
                _snapshot = nil;
                
            }];
            
            break;
        }
    }
}

- (void)gestureChanged:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    
    //让截图跟随手势
    CGPoint center = _snapshot.center;
    center.y = location.y;
    _snapshot.center = center;
    
    // Is destination valid and is it different from source?
    if (indexPath && ![indexPath isEqual:_sourceIndexPath]) {
        //交换数据源和cell
        [self updateDataSourceAndCellFromIndexPath:_sourceIndexPath toIndexPath:indexPath];
        // ... and update source so it is in sync with UI changes.
        _sourceIndexPath = indexPath;
    }
}

#pragma mark Private action

- (void)updateDataSourceAndCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self numberOfSections] == 1) {
        //只有一组
        [_tempDataSource exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        //交换cell
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }else {
        //有多组
        if (fromIndexPath.section == toIndexPath.section)
        {
            //同区交换
            NSMutableArray *arr = [_tempDataSource[fromIndexPath.section] mutableCopy];
            [arr exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
            [_tempDataSource replaceObjectAtIndex:fromIndexPath.section withObject:arr];
            [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        }
        else
        {
            id fromData = _tempDataSource[fromIndexPath.section][fromIndexPath.row];
            id toData = _tempDataSource[toIndexPath.section][toIndexPath.row];
            NSMutableArray *fromArray = [_tempDataSource[fromIndexPath.section] mutableCopy];
            NSMutableArray *toArray = [_tempDataSource[toIndexPath.section] mutableCopy];
            [fromArray replaceObjectAtIndex:fromIndexPath.row withObject:toData];
            [toArray replaceObjectAtIndex:toIndexPath.row withObject:fromData];
            [_tempDataSource replaceObjectAtIndex:fromIndexPath.section withObject:fromArray];
            [_tempDataSource replaceObjectAtIndex:toIndexPath.section withObject:toArray];
            //交换cell
            [self beginUpdates];
            [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            [self moveRowAtIndexPath:toIndexPath toIndexPath:fromIndexPath];
            [self endUpdates];
        }
        
    }
}

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark EdgeScroll

- (void)startEdgeScroll
{
    _edgeScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(processEdgeScroll)];
    [_edgeScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)processEdgeScroll
{
    [self gestureChanged:_longPressGesture];
    CGFloat minOffsetY = self.contentOffset.y + _edgeScrollRange;
    CGFloat maxOffsetY = self.contentOffset.y + self.bounds.size.height - _edgeScrollRange;
    CGPoint touchPoint = _snapshot.center;
    //处理上下达到极限之后不再滚动tableView，其中处理了滚动到最边缘的时候，当前处于edgeScrollRange内，但是tableView还未显示完，需要显示完tableView才停止滚动
    if (touchPoint.y < _edgeScrollRange) {
        if (self.contentOffset.y <= 0) {
            return;
        }else {
            if (self.contentOffset.y - 1 < 0) {
                return;
            }
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - 1) animated:NO];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y - 1);
        }
    }
    if (touchPoint.y > self.contentSize.height - _edgeScrollRange) {
        if (self.contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
            return;
        }else {
            if (self.contentOffset.y + 1 > self.contentSize.height - self.bounds.size.height) {
                return;
            }
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + 1) animated:NO];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y + 1);
        }
    }
    //处理滚动
    CGFloat maxMoveDistance = 20;
    if (touchPoint.y < minOffsetY) {
        //cell在往上移动
        CGFloat moveDistance = (minOffsetY - touchPoint.y)/_edgeScrollRange*maxMoveDistance;
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - moveDistance) animated:NO];
        _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y - moveDistance);
    }else if (touchPoint.y > maxOffsetY) {
        //cell在往下移动
        CGFloat moveDistance = (touchPoint.y - maxOffsetY)/_edgeScrollRange*maxMoveDistance;
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + moveDistance) animated:NO];
        _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y + moveDistance);
    }
}

- (void)stopEdgeScroll
{
    if (_edgeScrollTimer) {
        [_edgeScrollTimer invalidate];
        _edgeScrollTimer = nil;
    }
}

@end
