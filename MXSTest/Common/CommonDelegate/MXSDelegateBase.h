//
//  MXSDelagateBase.h
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXSTableViewCell.h"

@interface MXSDelegateBase : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id dlgData;
@property (nonatomic, weak) id controller;
@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, assign) CGFloat rowHeight;

@end
