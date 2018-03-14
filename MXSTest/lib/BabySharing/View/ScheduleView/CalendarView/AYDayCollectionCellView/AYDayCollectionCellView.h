//
//  AYDayCollectionCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 23/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYDayCollectionCellView : UICollectionViewCell

/** 月 */
@property (nonatomic, copy) NSString *gregoiainDay;
@property (nonatomic, copy) NSString *dayDay;
@property (nonatomic, assign) BOOL isGone;
@property (nonatomic, assign) double timeSpan;
@property (nonatomic, assign) BOOL isLightColor;

@end
