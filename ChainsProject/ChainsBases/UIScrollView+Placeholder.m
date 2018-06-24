//
//  UIScrollView+Placeholder.m
//  Ticket
//
//  Created by lianzun on 2018/6/1.
//  Copyright © 2018年 胡员外. All rights reserved.
//

#import "UIScrollView+Placeholder.h"
#import "Chains_PlaceholderView.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIScrollView (Placeholder)

//https://blog.csdn.net/qq_31810357/article/details/70622276
+ (void)load
{
//    if (class_respondsToSelector(self, @selector(reloadData)))
//    {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            [self swizzleIfPossible:@selector(reloadData)];
//        });
//    }
}

- (BOOL)chains_shouldDisplayPlaceholder
{
    return ([objc_getAssociatedObject(self, _cmd) boolValue])?:NO;
}

- (void)setChains_shouldDisplayPlaceholder:(BOOL)chains_shouldDisplayPlaceholder
{
    objc_setAssociatedObject(self, @selector(chains_shouldDisplayPlaceholder), [NSNumber numberWithBool:chains_shouldDisplayPlaceholder], OBJC_ASSOCIATION_ASSIGN);
    
    if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]])
    {
        [self swizzleIfPossible:@selector(reloadData)];
    }
}

- (BOOL)chains_allowScrollWhenNoData
{
    return ([objc_getAssociatedObject(self, _cmd) boolValue])?:NO;
}

- (void)setChains_allowScrollWhenNoData:(BOOL)chains_allowScrollWhenNoData
{
    objc_setAssociatedObject(self, @selector(chains_allowScrollWhenNoData), [NSNumber numberWithBool:chains_allowScrollWhenNoData], OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)chains_placeholderView
{
    UIView *placeholderView = objc_getAssociatedObject(self, @selector(chains_placeholderView));
    if (!placeholderView)
    {
        //Default placeHolder view
        Chains_PlaceholderView *view = [Chains_PlaceholderView defaultViewWithFrame:CGRectZero];
        view.blockUpdateDataSource = self.blockUpdateDataSource;
        [self setChains_placeholderView:view];
    }
    return placeholderView;
}

- (void)setChains_placeholderView:(UIView *)chains_placeholderView
{
    objc_setAssociatedObject(self, @selector(chains_placeholderView),chains_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))blockUpdateDataSource
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBlockUpdateDataSource:(void (^)(void))blockUpdateDataSource
{
    objc_setAssociatedObject(self, @selector(blockUpdateDataSource), blockUpdateDataSource, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//注入- reloadData的方法
- (void)chains_reloadPlaceholder
{
    if (!([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]])) {
        return;
    }
    
    if (self.chains_shouldDisplayPlaceholder && [self chains_itemsCount] == 0)
    {
        // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
        dispatch_async(dispatch_get_main_queue(), ^{
            if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
                [self insertSubview:self.chains_placeholderView atIndex:0];
            }
            else {
                [self addSubview:self.chains_placeholderView];
            }
            
            self.chains_placeholderView.frame = CGRectMake(0, 0, self.width, self.height);
        });
        
        self.chains_placeholderView.hidden = NO;
        self.chains_placeholderView.clipsToBounds = YES;
        
        
        [UIView performWithoutAnimation:^{
            [self.chains_placeholderView layoutIfNeeded];
        }];
        
        self.scrollEnabled = self.chains_allowScrollWhenNoData;
        
    }
    else
    {
        [self.chains_placeholderView removeFromSuperview];
        self.chains_placeholderView = nil;
        self.scrollEnabled = YES;
    }
}

- (NSInteger)chains_itemsCount
{
    NSInteger count = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return count;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                count += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                count += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    
    return count;
}

#pragma mark - Method Swizzling

static NSMutableDictionary *_impLookupTable;
static NSString *const SwizzleInfoPointerKey = @"pointer";
static NSString *const SwizzleInfoSelectorKey = @"selector";

// Based on Bryce Buchanan's swizzling technique http://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
// And Juzzin's ideas https://github.com/juzzin/JUSEmptyViewController

void chains_new_implementation(id self, SEL _cmd)
{
    // Fetch original implementation from lookup table
    NSString *key = chains_implementationKey([self class], _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:SwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for display placeholder view
    [self chains_reloadPlaceholder];
    
    // If found, call original implementation
    if (impPointer) ((void(*)(id,SEL))impPointer)(self,_cmd);
}

NSString *chains_implementationKey(Class class, SEL selector)
{
    if (!class || !selector) return nil;
    
    NSString *className = NSStringFromClass([class class]);
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}

- (void)swizzleIfPossible:(SEL)selector
{
    // Create the lookup table
    if (!_impLookupTable)
    {
        _impLookupTable = [[NSMutableDictionary alloc] init];
    }
    
    NSString *key = chains_implementationKey([self class], selector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:SwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue || !key) return;
    
    Method method = class_getInstanceMethod([self class], selector);
    if (!method) return;
    // Swizzle by injecting additional implementation  用注入额外实现的新方法指针替换旧方法指针
    IMP original_Implementation = method_setImplementation(method, (IMP)chains_new_implementation);
    
    // Store the original implementation in the lookup table  将旧方法的指针存起来
    NSDictionary *swizzledInfo = @{SwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   SwizzleInfoPointerKey: [NSValue valueWithPointer:original_Implementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}

@end
