//
//  WaterPullCell.m
//  Summary
//
//  Created by 马腾飞 on 17/4/17.
//  Copyright © 2017年 chains. All rights reserved.
//

#import "WaterPullCell.h"
#import "UIImageView+WebCache.h"
#import "Shop.h"


@interface WaterPullCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation WaterPullCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.priceLabel.text = shop.price;
}

@end
