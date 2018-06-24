//
//  SketchView.m
//  SKDrawingBoard
//
//  Created by 马腾飞 on 16/7/18.
//  Copyright © 2016年 youngxiansen. All rights reserved.
//

#import "SketchView.h"

@implementation SketchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    
    _move = CGPointMake(0, 0);
    _start = CGPointMake(0, 0);
    _lineWidth = 2;
    _color = [UIColor blackColor];
    _pathArray = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
    
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _move = CGPointMake(0, 0);
    _start = CGPointMake(0, 0);
    _lineWidth = 2;
    _color = [UIColor blackColor];
    _pathArray = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    if (self.backgroundImage)
    {
        [_backgroundImage drawInRect:rect];
    }
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}

- (void)drawPicture:(CGContextRef)context
{
    
    for (NSArray * attribute in _pathArray)
    {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _hasCleared = NO;
    UITouch *touch = [touches anyObject];
    _path = CGPathCreateMutable(); //创建路径
    
    UIColor *lineColor = [self isRubber]?self.backgroundColor:_color;
    NSArray *attributeArry = @[(__bridge id)(_path),lineColor,[NSNumber numberWithFloat:_lineWidth]];
    
    [_pathArray addObject:attributeArry]; //路径及属性数组
    _start = [touch locationInView:self]; //起始点
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    释放路径
    CGPathRelease(_path);
    //    记录当前全部路径
    self.tempArray = [_pathArray mutableCopy];
    //    重置计数器
    _count = _tempArray.count;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    
    [self setNeedsDisplay];
    
}

#pragma mark - 操作事件
- (void)undoEvent
{
    if (_hasCleared)
    {
        NSLog(@"已清除，不能够执行撤销");
        return;
    }
    
    [_pathArray removeLastObject];
    _hasCleared = NO;
    if (_count > 0)
    {
        _count--;
        [self setNeedsDisplay];
    }
    else
    {
        NSLog(@"已无可撤销的操作");
    }
}

- (void)recoverEvent
{
    if (_hasCleared)
    {
        self.pathArray = [_tempArray mutableCopy];
        _hasCleared = NO;
        
        if (_pathArray.count > 0)
        {
            _count = _tempArray.count;
            [self setNeedsDisplay];
            
            if (self.needPlayAnimation)
            {
                [UIView beginAnimations:@"animation" context:nil];
                [UIView setAnimationDuration:1.0f];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
                [UIView commitAnimations];
            }
        }
        else
        {
            NSLog(@"已无可执行的操作，请重新绘制");
        }
    }
    else
    {
        _count++;
        //防止恢复时数组越界
        if (_count < _tempArray.count + 1)
        {
            [_pathArray addObject:_tempArray[_count - 1]];
            [self setNeedsDisplay];
        }
        else
        {
            _count = _tempArray.count;
            NSLog(@"已无可恢复的操作");
        }
    }
}

- (void)clearEvent
{
    if (_hasCleared)
    {
        NSLog(@"已清空");
        return;
    }
    self.tempArray = [_pathArray mutableCopy];
    [_pathArray removeAllObjects];
    _hasCleared = YES;
    
    if (_tempArray.count > 0)
    {
        [_pathArray removeAllObjects];
        _count = 0;
        [self setNeedsDisplay];
        
        if (self.needPlayAnimation)
        {
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
            [UIView commitAnimations];
        }
    }
    else
    {
        NSLog(@"已无可执行的操作，请重新绘制");
    }
}

#pragma mark - 图片获取与保存
- (UIImage *)getPictureDrawedOnTheSketchView
{
    if (_pathArray.count)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        [self.layer renderInContext:context];
        
        return UIGraphicsGetImageFromCurrentImageContext();
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"请先绘制图形" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return nil;
}

- (BOOL)savePictureToDocument
{
    UIImage *image = [self getPictureDrawedOnTheSketchView];
    if (image)
    {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [documentPath stringByAppendingPathComponent:@"signature.png"];
        NSFileManager* manager = [NSFileManager defaultManager];
        return [manager createFileAtPath:imagePath contents:UIImagePNGRepresentation(image) attributes:nil];
    }
    return NO;
}

- (void)savePictureToAlbum
{
    UIImage *image = [self getPictureDrawedOnTheSketchView];
    if (image)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

@end
