//
//  InfoCell.h
//  tableViewCellHeightAnimation
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface InfoCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath  *indexPath;
@property (nonatomic, weak) UITableView  *tableView;

- (void)loadData:(id)data;

@end
