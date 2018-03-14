//
//  TZTestCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

typedef void(^loadImageFinish)(UIImage*);

#import <UIKit/UIKit.h>

@interface TZTestCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isPlusIcon;

@property (nonatomic, strong) NSDictionary *cellInfo;
@property (nonatomic, strong) loadImageFinish imageBlock;

- (UIView *)snapshotView;

@end

