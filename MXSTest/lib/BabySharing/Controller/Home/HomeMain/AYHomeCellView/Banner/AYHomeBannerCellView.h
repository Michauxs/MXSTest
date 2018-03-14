//
//  AYHomeBannerCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 19/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYHomeBannerCellView : UITableViewCell <AYViewBase, UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic ,strong) NSString           *placeholderImage;
@property (nonatomic ,assign) BOOL               isNetworkding;
@property (nonatomic ,strong) NSTimer            *timer;

@end
