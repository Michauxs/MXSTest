//
//  AYHomeAssortmentCellItem.h
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

typedef void(^didLikeBtnClick)(NSDictionary*);


@interface AYNurseryItem : UICollectionViewCell

@property (nonatomic, strong) didLikeBtnClick likeBtnClick;

@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) NSDictionary *itemInfo;
@property (nonatomic, strong) UIButton *likeBtn;

@end
