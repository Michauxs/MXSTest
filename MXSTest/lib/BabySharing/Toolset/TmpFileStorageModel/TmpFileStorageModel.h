//
//  TmpFileStorageModel.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "PostDefine.h"
#import "AYQueryModelDefines.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

typedef void(^imageDidDownloadBlock)(BOOL success, UIImage* img);
typedef void(^fileDidDownloadBlock)(BOOL success, NSURL* img);

@interface TmpFileStorageModel : NSObject

#pragma mark -- item image dir
+ (NSString*)BMTmpImageDir;
+ (void)deleteBMTmpImageDir;
+ (NSString*)generateFileName;
+ (NSString*)saveToTmpDirWithImage:(UIImage*)img;
+ (void)saveToTmpDirWithImage:(UIImage*)img withName:(NSString*)name;
+ (void)saveAsToAlbumWithImageName:(NSString*)name;
// for item
+ (NSURL*)enumFileWithName:(NSString*)name andType:(PostPreViewType)type withDownLoadFinishBlock:(fileDidDownloadBlock)block;
+ (UIImage*)enumImageWithName:(NSDictionary*)name withDownLoadFinishBolck:(imageDidDownloadBlock)block;

#pragma mark -- item movie dir
+ (NSString*)BMTmpMovieDir;
+ (void)deleteBMTmpMovieDir;
+ (void)saveAsToAlbumWithMovieName:(NSString *)name;
+ (void)deleteOneMovieFileWithName:(NSString*)name;
+ (void)deleteOneMovieFileWithUrl:(NSURL*)path;

#pragma mark -- get file stroage size
+ (CGFloat)tmpFileStorageSize;
//+ (CGFloat)SDWebImageFileStorageSize;
@end
