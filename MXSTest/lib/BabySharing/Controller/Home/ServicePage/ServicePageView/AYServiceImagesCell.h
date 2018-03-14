//
//  AYServiceImagesCell.h
//  BabySharing
//
//  Created by Alfred Yang on 5/6/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@interface AYServiceImagesCell : UICollectionViewCell

- (void)setItemImageWithImageName:(NSString*)imageName;
- (void)setItemImageWithImage:(UIImage*)image;

@end
