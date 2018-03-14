//
//  AYQueryAlbumNameWithAlbumCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryAlbumNameWithAlbumCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+fixOrientation.h"

@implementation AYQueryAlbumNameWithAlbumCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    id tmp = (*obj);
    if ([tmp isKindOfClass:[PHFetchResult class]]) {
        *obj = @"所有照片";
    } else if([tmp isKindOfClass:[PHAssetCollection class]]) {
        *obj = ((PHAssetCollection*)tmp).localizedTitle;
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
