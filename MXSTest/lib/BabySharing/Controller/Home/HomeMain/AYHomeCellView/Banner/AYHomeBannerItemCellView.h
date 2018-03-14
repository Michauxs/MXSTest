//
//  AYHomeBannerItemCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYHomeBannerItemCellView : UICollectionViewCell

- (void)setItemImageWithImageUrl:(NSString *)imageUrl;
- (void)setItemImageWithImage:(UIImage *)image;
- (void)setItemImageWithImageName:(NSString*)imageName;

@end
