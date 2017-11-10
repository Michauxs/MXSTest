//
//  MXSTableView.h
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSDelegateBase.h"

@interface MXSTableView : UITableView

@property (nonatomic, strong) MXSDelegateBase *dlg;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andDelegate:(MXSDelegateBase*)dlg;

- (void)registerClsaaWithCellName:(NSString *)class_name RowHeight:(CGFloat)height andController:(id)controller;

@end
