//
//  MultiSelectViewController.h
//  Summary
//
//  Created by 马腾飞 on 16/4/17.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "BaseViewController.h"

@interface MultiSelectViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewToView;
@property (assign, nonatomic) BOOL isTypeGroup;

@end
