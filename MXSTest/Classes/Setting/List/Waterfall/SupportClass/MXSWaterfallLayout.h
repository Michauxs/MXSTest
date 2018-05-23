//
//  MXSWaterfallLayout.h
//  MXSTest
//
//  Created by Sunfei on 2018/5/23.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXSWaterfallLayout : UICollectionViewLayout


//总列数
@property (nonatomic, assign) NSInteger columnCount;
//列间距
@property (nonatomic, assign) NSInteger columnSpacing;
//行间距
@property (nonatomic, assign) NSInteger rowSpacing;
//section到collectionView的边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
//保存每一列最大y值的数组
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
//保存每一个item的attributes的数组
@property (nonatomic, strong) NSMutableArray *attributesArray;


@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemHeight,NSIndexPath *indexPath);


@end
