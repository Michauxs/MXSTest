//
//  AYProfileServCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 7/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYProfileServCellView : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *confirLabel;
@property (nonatomic, strong) UIView *bottom_line;

@property (nonatomic, strong) NSDictionary *dic_info;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isConfirm;
@end