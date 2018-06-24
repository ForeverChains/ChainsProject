//
//  SketchView.h
//  SKDrawingBoard
//
//  Created by 马腾飞 on 16/7/18.
//  Copyright © 2016年 youngxiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  画布
 */
@interface SketchView : UIView
{
    CGPoint _start;
    CGPoint _move;
    CGMutablePathRef _path;
    NSMutableArray *_pathArray;
    NSMutableArray *_tempArray;
    CGFloat _lineWidth;
    UIColor *_color;
    NSUInteger _count;
    BOOL _hasCleared;
}

@property (nonatomic,strong) UIImage *backgroundImage;/**< 背景图片 */
@property (nonatomic,assign) CGFloat lineWidth;/**< 线宽 */
@property (nonatomic,strong) UIColor *color;/**< 线的颜色 */
@property (nonatomic,strong) NSMutableArray *pathArray;/**< 当前路径 */
@property (nonatomic,strong) NSMutableArray *tempArray;/**< 历史路径 */
@property (nonatomic,assign,getter=isRubber) BOOL rubber;/**< 是否为橡皮擦模式 */
@property (nonatomic,assign,getter=needPlayAnimation) BOOL playAnimation;/**< 是否播放动画 */

- (void)undoEvent;//撤销
- (void)recoverEvent;//恢复
- (void)clearEvent;//清除

- (UIImage *)getPictureDrawedOnTheSketchView;
- (BOOL)savePictureToDocument;
- (void)savePictureToAlbum;

@end
