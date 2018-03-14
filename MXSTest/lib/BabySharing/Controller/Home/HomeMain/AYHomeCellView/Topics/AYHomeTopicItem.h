//
//  AYHomeTopicItem.h
//  BabySharing
//
//  Created by Alfred Yang on 12/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYHomeTopicItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImage;

- (void)setItemInfo:(NSDictionary*)itemInfo;
@end
