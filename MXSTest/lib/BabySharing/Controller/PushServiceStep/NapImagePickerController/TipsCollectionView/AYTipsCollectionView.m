//
//  AYTipsCollectionView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYTipsCollectionView.h"
#import "AYCommandDefines.h"
#import "AYControllerBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

static NSString *tipsItemID = @"tipsItem";
#define tipsItemNumb        4

@implementation AYTipsCollectionView {
    
    UICollectionView *tipsCollectionView;
    UIPageControl *pageControl;
    UIButton *addPhotoBtn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (id)showTipsView {
    
    pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = tipsItemNumb;
    CGSize size = [pageControl sizeForNumberOfPages:tipsItemNumb];
    
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCREEN_HEIGHT  * 0.6);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(size);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    tipsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    tipsCollectionView.backgroundColor = [UIColor clearColor];
    tipsCollectionView.delegate = self;
    tipsCollectionView.dataSource = self;
    [tipsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:tipsItemID];
    tipsCollectionView.pagingEnabled = YES;
    tipsCollectionView.showsHorizontalScrollIndicator = NO;
    tipsCollectionView.showsVerticalScrollIndicator = NO;
    tipsCollectionView.bounces = NO;
    tipsCollectionView.contentSize = CGSizeMake(tipsItemNumb * SCREEN_WIDTH, 0);
    [self addSubview:tipsCollectionView];
    
    pageControl.currentPage = 0;
    
    addPhotoBtn = [Tools creatBtnWithTitle:@"添加图片" titleColor:[Tools whiteColor] fontSize:16.f backgroundColor:[Tools theme]];
    [addPhotoBtn addTarget:self action:@selector(didAddPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    addPhotoBtn.hidden = YES;
    addPhotoBtn.alpha = 0;
    addPhotoBtn.layer.cornerRadius = 2.f;
    addPhotoBtn.clipsToBounds = YES;
    [self addSubview:addPhotoBtn];
    [addPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 70, 44));
    }];
    return nil;
}

- (void)didAddPhotoBtnClick {
    kAYViewSendNotify(self, @"hideTipsView", nil)
}

#pragma mark --<UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return tipsItemNumb;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tipsItemID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *tipView = [[UIImageView alloc]init];
    tipView.contentMode = UIViewContentModeBottom;
    NSString *imageName = [NSString stringWithFormat:@"tips_first_%ld",indexPath.row];
    tipView.image = IMGRESOURCE(imageName);
    [cell addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell).offset(-SCREEN_HEIGHT * 0.55);
        make.centerX.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 180));
    }];
    
    return cell;
}

//设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int page = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5)%tipsItemNumb;
    pageControl.currentPage = page;
    if (page >= tipsItemNumb - 1) {
        
        addPhotoBtn.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            addPhotoBtn.center = CGPointMake(addPhotoBtn.center.x, SCREEN_HEIGHT * 0.8 - 22);
            addPhotoBtn.alpha = 1.f;
        }];
        
    }
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

@end
