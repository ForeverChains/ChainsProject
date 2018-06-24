//
//  MultiSelectViewController.m
//  Summary
//
//  Created by 马腾飞 on 16/4/17.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "MultiSelectViewController.h"
#import "User.h"

static NSString *const kCellIdentifier = @"Cell";

@interface MultiSelectViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *sectionArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *selectedArr;
@property (strong, nonatomic) UIButton *editBtn;
@property (strong, nonatomic) UIButton *leftBtn;

@end

@implementation MultiSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"多选删除";
    
    self.isTypeGroup = YES;//必须根据实际情况进行赋值
    
    self.sectionArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.selectedArr = [NSMutableArray array];
    NSArray *arr = @[@[@"科比·布莱恩特",@"德里克·罗斯",@"勒布朗·詹姆斯"],@[@"凯文·杜兰特",@"德怀恩·韦德",@"克里斯·保罗"],@[@"德怀特·霍华德",@"德克·诺维斯基",@"德隆·威廉姆斯",@"斯蒂夫·纳什",@"保罗·加索尔",@"布兰顿·罗伊"],@[@"约翰·沃尔",@"史蒂芬·库里",@"乔·约翰逊"]];
    for (NSArray *sectionArr in arr)
    {
        NSMutableArray *modelArr = [NSMutableArray array];
        [sectionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                NSDictionary *dic = @{@"name":obj};
                User *model = [User modelWithDic:dic];
                [modelArr addObject:model];
            }
        }];
        [self.dataArr addObject:modelArr];
    }
    
//    NSArray *arr = @[@"悬垂视图",@"延展视图",@"扫码",@"手写板"];
//    for (NSString *name in arr)
//    {
//        @autoreleasepool {
//            NSDictionary *dic = @{@"name":name};
//            User *model = [User modelWithDic:dic];
//            [self.dataArr addObject:model];
//        }
//    }
    
    //将不可变数组转为可变
    if (_isTypeGroup)
    {
        [_dataArr enumerateObjectsUsingBlock:^(NSArray *  _Nonnull sectionArr, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *multiArr = [NSMutableArray arrayWithArray:sectionArr];
            [_dataArr replaceObjectAtIndex:idx withObject:multiArr];
        }];
    }
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.bounds = CGRectMake(0, 0, 40, 40);
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"取消" forState:UIControlStateSelected];
    [_editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.bounds = CGRectMake(0, 0, 40, 40);
    _leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [_leftBtn setImage:[UIImage imageNamed:IMAGE_BACK_SHADOW] forState:UIControlStateNormal];
    [_leftBtn setTitle:nil forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setDataArr:(NSMutableArray *)dataArr
//{
//    _dataArr = dataArr;
//    if (dataArr.count > 0)
//    {
//        if ([[dataArr firstObject] isKindOfClass:[NSArray class]])
//        {
//            self.isTypeGroup = YES;
//        }
//        else
//        {
//            self.isTypeGroup = NO;
//        }
//    }
//}

- (void)editButtonClick:(UIButton *)sender
{
    _tableView.editing = NO;//解决左滑后立马点击编辑的Bug
    _editBtn.selected = !sender.selected;
    _tableView.editing = _editBtn.selected;
    [_selectedArr removeAllObjects];
    
    if (_tableView.editing)
    {
        [_leftBtn setImage:nil forState:UIControlStateNormal];
        [_leftBtn setTitle:@"全选" forState:UIControlStateNormal];
        _leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _bottomViewToView.constant = 0;
    }
    else
    {
        [_leftBtn setImage:[UIImage imageNamed:IMAGE_BACK_SHADOW] forState:UIControlStateNormal];
        [_leftBtn setTitle:nil forState:UIControlStateNormal];
        _leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        _bottomViewToView.constant = -50;
    }
}

- (void)leftBarButtonClick:(id)sender
{
    if (_tableView.editing)
    {
        //全选  先清空，再全部添加
        [_selectedArr removeAllObjects];
        NSLog(@"全部选中");
        for (NSInteger i = 0; i < _dataArr.count; i++)
        {
            if (_isTypeGroup)
            {
                NSArray *sectionArr = _dataArr[i];
                [sectionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.selectedArr addObject:sectionArr[idx]];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:i];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    });
                }];
            }
            else
            {
                [self.selectedArr addObject:_dataArr[i]];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                });
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)deleteButtonClick:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"删除已选项:\n%@",_selectedArr);
        //删除的操作
        //删除数据
        for (User *model in _selectedArr)
        {
            if (_isTypeGroup)
            {
                [_dataArr enumerateObjectsUsingBlock:^(NSMutableArray *  _Nonnull sectionArr, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([sectionArr containsObject:model])
                    {
                        [sectionArr removeObject:model];
                        //分区内没有数据对象则移除该分区
                        if (!(sectionArr.count > 0))
                        {
                            [_dataArr removeObject:sectionArr];
                            if (_sectionArr.count > 0)
                            {
                                [_sectionArr removeObjectAtIndex:idx];
                            }
                            
                        }
                        * stop = YES;
                    }
                }];
                
            }
            else
            {
                [_dataArr removeObject:model];
            }
        }
        NSLog(@"dataArr:%@",_dataArr);
        //刷新表
        [_tableView reloadData];
        
        
        [self editButtonClick:_editBtn];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_isTypeGroup)?_dataArr.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isTypeGroup)
    {
        NSArray *arr = _dataArr[section];
        return arr.count;
    }
    else
    {
        return _dataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_sectionArr.count > 0)
    {
        return _sectionArr[section];
    }
    else
    {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    //dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath这个方法的cell在group类型的tableview中全选有bug
    
    User *model = (_isTypeGroup)?_dataArr[indexPath.section][indexPath.row]:_dataArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *model = (_isTypeGroup)?[_dataArr[indexPath.section] objectAtIndex:indexPath.row]:[_dataArr objectAtIndex:indexPath.row];
    if (tableView.editing)
    {
        if (![_selectedArr containsObject:model]) {
            [_selectedArr addObject:model];
        }
        
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    if (tableView.editing)
    {
        User *model = (_isTypeGroup)?[_dataArr[indexPath.section] objectAtIndex:indexPath.row]:[_dataArr objectAtIndex:indexPath.row];
        if ([_selectedArr containsObject:model]) {
            [_selectedArr removeObject:model];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

//设置是否响应滑动编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if (_isTypeGroup)
            {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:_dataArr[indexPath.section]];
                [arr removeObjectAtIndex:indexPath.row];
                _dataArr[indexPath.section] = arr;
                //分区内没有数据对象则移除该分区
                if (!(arr.count > 0))
                {
                    [_dataArr removeObject:arr];
                    if (_sectionArr.count > 0)
                    {
                        [_sectionArr removeObjectAtIndex:indexPath.section];
                    }
                    
                }
            }
            else
            {
                [_dataArr removeObjectAtIndex:indexPath.row];
            }
            [tableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
