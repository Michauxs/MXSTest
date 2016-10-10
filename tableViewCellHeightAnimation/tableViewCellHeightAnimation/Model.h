//
//  Model.h
//  tableViewCellHeightAnimation
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Model : NSObject

@property (nonatomic) CGFloat  normalHeight;
@property (nonatomic) CGFloat  expendHeight;
@property (nonatomic) BOOL     expend;

+ (instancetype)ModelWithNormalHeight:(CGFloat)normalHeight expendHeight:(CGFloat)expendHeight expend:(BOOL)expend;

@end
