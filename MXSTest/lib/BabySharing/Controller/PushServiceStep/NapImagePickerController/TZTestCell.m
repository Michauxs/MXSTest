//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"
#import "UIView+Layout.h"

#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [Tools garyBackgroundColor];
        _imageView = [[UIImageView alloc] init];
//        _imageView.backgroundColor = [Tools garyBackgroundColor];
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        _deleteBtn.alpha = 0.6;
        [self addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}


- (void)setCellInfo:(NSDictionary *)cellInfo {
    _cellInfo = cellInfo;
    
//    BOOL isFirst = ((NSNumber*)[cellInfo objectForKey:@"is_first"]).boolValue;
//    if(isFirst) {
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    } else
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    /**/
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.size.equalTo(self);
    }];
    
    id image = [cellInfo objectForKey:@"image"];
    if ([image isKindOfClass:[UIImage class]] || !image) {
        _imageView.image = image;
        
    } else if ([image isKindOfClass:[NSString class]]) {
        
        NSString* photo_name = image;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:photo_name forKey:@"image"];
        [dic setValue:@"img_local" forKey:@"expect_size"];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* img = (UIImage*)result;
            if (img != nil) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                });
                _imageView.image = img;
//                    self.imageBlock(img);
            }
        }];
    }
    
    BOOL isHidden = ((NSNumber*)[cellInfo objectForKey:@"is_hidden"]).boolValue;
    _deleteBtn.hidden = isHidden;
    NSInteger tag_index = ((NSNumber*)[cellInfo objectForKey:@"tag_index"]).integerValue;
    _deleteBtn.tag = tag_index;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
