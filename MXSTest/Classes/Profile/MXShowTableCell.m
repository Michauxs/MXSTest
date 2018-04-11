//
//  MXShowTableCell.m
//  MXSTest
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXShowTableCell.h"

@implementation MXShowTableCell {
	UILabel *titleLabel;
}

@synthesize cellInfo = _cellInfo;

- (void)setCellUI {
    [super setCellUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *btmLine = [[UIView alloc] init];
    btmLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    [self addSubview:btmLine];
    [btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    titleLabel = [Tools creatLabelWithText:@"Title" textColor:[UIColor random] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(5);
        //            make.left.equalTo(_img.mas_right).offset(10);
        //            make.centerY.equalTo(self);
    }];
    
    _img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weiwei"]];
    [self addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self).offset(15);
        //            make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5 - 30, 80));
    }];
}

- (void)setCellInfo:(id)cellInfo {
	_cellInfo = cellInfo;
	titleLabel.text = cellInfo;
}

@end
