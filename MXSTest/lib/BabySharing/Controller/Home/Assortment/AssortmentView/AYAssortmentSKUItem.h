//
//  AYAssortmentSKUItem.h
//  BabySharing
//
//  Created by Alfred Yang on 27/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYAssortmentSKUItem : UICollectionViewCell

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSString *titleStr;

- (void)setCornerRadius:(CGFloat)radius;

@end
