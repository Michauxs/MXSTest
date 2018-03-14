//
//  AYEnumAlbumNameCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEnumAlbumNameCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+fixOrientation.h"

@implementation AYEnumAlbumNameCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    // 获取所有相册
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    // 所有照片集合
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    // 获取所有自定义相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSMutableArray *albumArr = [NSMutableArray array];
    [albumArr addObject:allPhotos];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    for (PHCollection *album in topLevelUserCollections) {
        [albumArr addObject:album];
    }
    *obj = albumArr;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
