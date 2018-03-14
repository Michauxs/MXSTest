//
//  AYMapMatchCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^touchUpInSubCell)(NSDictionary*);

@interface AYMapMatchCellView : UICollectionViewCell <AYViewBase, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *service_info;
@property (nonatomic, strong) touchUpInSubCell didTouchUpInSubCell;

//@property (nonatomic, strong) NSArray *serviceData;
@end
