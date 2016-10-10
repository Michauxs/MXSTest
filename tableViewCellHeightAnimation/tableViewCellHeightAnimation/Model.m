//
//  Model.m
//  tableViewCellHeightAnimation
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (instancetype)ModelWithNormalHeight:(CGFloat)normalHeight expendHeight:(CGFloat)expendHeight expend:(BOOL)expend {
    
    Model *model = [[Model alloc] init];
    
    model.normalHeight = normalHeight;
    model.expendHeight = expendHeight;
    model.expend = expend;
    
    return model;
}

@end
