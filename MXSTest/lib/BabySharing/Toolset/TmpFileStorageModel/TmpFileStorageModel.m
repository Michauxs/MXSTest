//
//  TmpFileStorageModel.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
//#import "ModelDefines.h"
#import <AVFoundation/AVFoundation.h>

#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

#define TMP_IMAGE_DIR           @"images"
#define TMP_MOVIE_DIR           @"movies"

static NSString* const kDongDaCacheKey = @"DongDaCacheKey";

//#define ATT_DOWNLOAD_HOST       @"http://localhost:9000/query/downloadFile/"

@implementation TmpFileStorageModel

+ (NSString*)BMTmpDir {
    return NSTemporaryDirectory();
}

+ (NSString*)BMTmpImageDir {
    NSString* image_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_IMAGE_DIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath:image_dir]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:image_dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return image_dir;
}

+ (void)deleteBMTmpImageDir {
    NSString* image_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_IMAGE_DIR];
    if([[NSFileManager defaultManager] fileExistsAtPath:image_dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:image_dir error:nil];
    }
	[[SDImageCache sharedImageCache] clearDisk];
}

+ (NSString*)BMTmpMovieDir {
    NSString* movie_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_MOVIE_DIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath:movie_dir]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:movie_dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return movie_dir;
}

+ (void)deleteBMTmpMovieDir {
     NSString* movie_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_MOVIE_DIR];
    if([[NSFileManager defaultManager] fileExistsAtPath:movie_dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:movie_dir error:nil];
    }   
}

+ (void)deleteOneMovieFileWithName:(NSString*)name {
    NSString *path = [[TmpFileStorageModel BMTmpMovieDir] stringByAppendingPathComponent:name];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (void)deleteOneMovieFileWithUrl:(NSURL*)url {
    NSString* path = [url absoluteString];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}


+ (NSString*) uuidWithString:(NSString*)token {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString*)generateFileName {
    
    return [TmpFileStorageModel uuidWithString:nil];
}

+ (NSString*)saveToTmpDirWithImage:(UIImage*)img {
    NSString* extent = [TmpFileStorageModel generateFileName];
    NSString* file = [[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:extent];
    file = [file stringByAppendingPathExtension:@"png"];
    
//    [UIImagePNGRepresentation(img) writeToFile:file atomically:YES];
    [UIImageJPEGRepresentation(img, 1.f) writeToFile:file atomically:YES];
    return extent;
}

+ (void)saveToTmpDirWithImage:(UIImage*)img withName:(NSString*)name {
    NSString* file = [[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:name];
    file = [file stringByAppendingPathExtension:@"png"];
    
//    [UIImagePNGRepresentation(img) writeToFile:file atomically:YES];
    [UIImageJPEGRepresentation(img, 1.f) writeToFile:file atomically:YES];
}

+ (void)saveAsToAlbumWithImageName:(NSString*)name {
    
}

+ (void)saveAsToAlbumWithMovieName:(NSString *)name {
    
}

+ (NSURL*)enumFileWithName:(NSString*)name andType:(PostPreViewType)type withDownLoadFinishBlock:(fileDidDownloadBlock)block {
    NSString* path = nil;
    if (type == PostPreViewPhote) {
        path = [TmpFileStorageModel BMTmpImageDir];
    } else {
        path = [TmpFileStorageModel BMTmpMovieDir];
    }
    
    NSString* fullname = [path stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullname]) {
        return [NSURL fileURLWithPath:fullname];
    } else {
        /**
         * down load from server
         */
        dispatch_queue_t aq = dispatch_queue_create("download queue", nil);
        dispatch_async(aq, ^{
            
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            
            NSData* data = [RemoteInstance remoteDownloadFileWithName:name andHost:cmd.route];
            NSURL* url = [NSURL fileURLWithPath:fullname];
//            unlink([fullname UTF8String]);
            NSLog(@"%@", url);
            NSError* error = nil;
            if ([data writeToFile:fullname options:NSDataWritingFileProtectionComplete error:&error]) {
                NSLog(@"write data to file success");
                if (block) block(YES, url);
            } else {
                NSLog(@"write data to file error: %@", error);
                if(block) block(NO, nil);
            }
        });
        
        return nil;
    }
}

+ (UIImage*)enumImageWithName:(NSDictionary*)args withDownLoadFinishBolck:(imageDidDownloadBlock)block {
    
    NSString* name = [args objectForKey:@"image"];
    NSString* sizeType = [args objectForKey:@"expect_size"];//icon-120 thum-240 desc-750
    
    NSString* path = [[[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"png"];
    UIImage* fileImg = [UIImage imageWithContentsOfFile:path];
    if ([sizeType isEqualToString:@"img_local"] && fileImg) {
        if (block) {
            block(YES, fileImg);
        }
        return fileImg;
    }
    
    UIImage* reVal = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[name stringByAppendingString:sizeType]];
    if (!reVal) {
        /**
         * down load from server
         */
        NSString* path = [[[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:[name stringByAppendingString:sizeType]] stringByAppendingPathExtension:@"png"];
        UIImage* cacheImg = [UIImage imageWithContentsOfFile:path];
        if (cacheImg) {
            [[SDImageCache sharedImageCache] storeImage:cacheImg forKey:[name stringByAppendingString:sizeType] toDisk:NO];
            if (block) {
               block(YES, cacheImg);
            }
        }else
        {
            
            dispatch_queue_t aq = dispatch_queue_create("download queue", nil);
            dispatch_async(aq, ^{
                
                id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
                AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
                NSData* data = [RemoteInstance remoteDownloadFileWithName:name andHost:cmd.route];
                UIImage* img = [UIImage imageWithData:data];
                
                UIImage *imageSizeIcon = [self pressImageWith:img andExpectedWidth:120];
                NSData *icon_data = UIImageJPEGRepresentation(imageSizeIcon, 1);
                UIImage *imageIcon = [UIImage imageWithData:icon_data];
                
                UIImage *imageSizeThum = [self pressImageWith:img andExpectedWidth:240];
                NSData *thum_data = UIImageJPEGRepresentation(imageSizeThum, 1);
                UIImage *imageThum = [UIImage imageWithData:thum_data];
                
                UIImage *imageSizeDecs = [self pressImageWith:img andExpectedWidth:750];
                NSData *desc_data = UIImageJPEGRepresentation(imageSizeDecs, 1);
                UIImage *imageDesc = [UIImage imageWithData:desc_data];
                
                [TmpFileStorageModel saveToTmpDirWithImage:imageIcon withName:[name stringByAppendingString:sizeType]];
                [TmpFileStorageModel saveToTmpDirWithImage:imageThum withName:[name stringByAppendingString:sizeType]];
                [TmpFileStorageModel saveToTmpDirWithImage:imageDesc withName:[name stringByAppendingString:sizeType]];
                
                if ([sizeType isEqualToString:@"img_icon"]) {
                    [[SDImageCache sharedImageCache] storeImage:imageIcon forKey:[name stringByAppendingString:sizeType] toDisk:NO];
                    if (block) {
                        block(YES, imageIcon);
                    }
                }
                else if([sizeType isEqualToString:@"img_thum"]) {
                    [[SDImageCache sharedImageCache] storeImage:imageThum forKey:[name stringByAppendingString:sizeType] toDisk:NO];
                    if (block) {
                        block(YES, imageThum);
                    }
                }
                else if([sizeType isEqualToString:@"img_desc"]) {
                    [[SDImageCache sharedImageCache] storeImage:imageDesc forKey:[name stringByAppendingString:sizeType] toDisk:NO];
                    if (block) {
                        block(YES, imageDesc);
                    }
                }else {
                   [[SDImageCache sharedImageCache] storeImage:img forKey:name toDisk:NO];
                    if (block) {
                        block(YES, img);
                    }
                    return ;
                }
				
            });
        }
    }
    return reVal;
}

+(UIImage *)pressImageWith:(UIImage *)image andExpectedWidth:(CGFloat)width
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark -- get file stroage size
+ (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (CGFloat)tmpFileStorageSize {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:[self BMTmpDir]]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[self BMTmpDir]] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [[self BMTmpDir] stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
	
	SDImageCache *cache = [SDImageCache sharedImageCache];
	long long cacheSize = cache.getSize;
	
    return (folderSize + cacheSize)/(1024.0*1024.0);
}

//+ (CGFloat)SDWebImageFileStorageSize {
//	
//}

@end
