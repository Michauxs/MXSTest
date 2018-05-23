//
//  MXSWaterfallVC.m
//  MXSTest
//
//  Created by Sunfei on 2018/5/23.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSWaterfallVC.h"
#import "MXSWaterfallLayout.h"

@interface MXSWaterfallVC ()

@end

@implementation MXSWaterfallVC {
    UICollectionView *demoCollectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MXSWaterfallLayout *waterfall = [[MXSWaterfallLayout alloc] init];
    waterfall.columnCount = 3;
    waterfall.columnSpacing = 10;
    waterfall.rowSpacing = 10;
    waterfall.sectionInset = UIEdgeInsetsMake(10, 10 , 10, 10);
    [waterfall setItemHeightBlock:^CGFloat(CGFloat itemWidth, NSIndexPath *indexPath) {
//        XRImage *image = self.images[indexPath.item];
//        return image.imageH / image.imageW * itemWidth;
        return arc4random()%60+40;
    }];
//    demoCollectView.collectionViewLayout = waterfall;
//    waterfall.dele
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    demoCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:waterfall];
    [self.view addSubview:demoCollectView];
    [demoCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    demoCollectView.delegate = self;
    demoCollectView.dataSource = self;
    [demoCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MXSItem"];
}



- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXSItem" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor random];
    return  cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

@end
