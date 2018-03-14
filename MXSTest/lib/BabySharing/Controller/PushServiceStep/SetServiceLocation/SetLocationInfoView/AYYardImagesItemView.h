//
//  AYYardImagesItemView.h
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@interface AYYardImagesItemView : UICollectionViewCell

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) NSDictionary *itemInfo;

@end
