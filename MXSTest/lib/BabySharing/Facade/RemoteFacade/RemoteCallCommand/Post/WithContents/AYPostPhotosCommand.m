//
//  AYPostPhotosCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/21/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPhotosCommand.h"
#import <UIKit/UIKit.h>
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYQueryModelDefines.h"

#import "TmpFileStorageModel.h"

@implementation AYPostPhotosCommand

- (void)performWithResult:(id)args andFinishBlack:(asynCommandFinishBlock)block {
	
	NSDictionary* info_images = args;
	
	NSMutableArray *imgArr = [NSMutableArray array];
	NSMutableDictionary *dic_images = [[NSMutableDictionary alloc] init];
	
	//handle所有元素（key-value）
	for (NSString *key in [info_images allKeys]) {
		[dic_images setValue:[NSMutableArray array] forKey:key];
		
		for (UIImage *img in [info_images objectForKey:key]) {
			[imgArr addObject:@{key:img}];
		}
	}
	
    NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 每一个图片是一个上传线程，需要一个semaphores等待上传完成
	NSMutableArray* post_image_result = [[NSMutableArray alloc]init];           // 记录每一个图片在线中上传的结果
	
    for (int index = 0; index < imgArr.count; ++index) {
        dispatch_semaphore_t tmp = dispatch_semaphore_create(0);
        [semaphores_upload_photos addObject:tmp];
		[post_image_result addObject:[NSNumber numberWithBool:NO]];
    }
	
    // 5. 组合上传内容
    dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
    dispatch_async(qp, ^{
		
//        NSMutableArray* arr_items = [[NSMutableArray alloc]init];
		
        for (int index = 0; index < imgArr.count; ++index) {
            UIImage* iter = [[[imgArr objectAtIndex:index] allValues] firstObject];
			NSString* extent = [TmpFileStorageModel generateFileName];
        
            // 3. 启动异步线程对图片进行上传
			NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
			[photo_dic setValue:extent forKey:@"image"];
			[photo_dic setValue:iter forKey:@"upload_image"];
			
			AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
			[up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
				NSLog(@"upload result are %d", success);
				[post_image_result replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:success]];
				dispatch_semaphore_signal([semaphores_upload_photos objectAtIndex:index]);
			}];
			
            [[dic_images objectForKey:[[[imgArr objectAtIndex:index] allKeys] firstObject]] addObject:extent];
        } //for end

        // 4. 等待图片进程全部处理完成
        for (dispatch_semaphore_t iter in semaphores_upload_photos) {
            dispatch_semaphore_wait(iter, dispatch_time(DISPATCH_TIME_NOW, 60.f * NSEC_PER_SEC));
        }
        
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
		NSArray* image_result = [post_image_result filteredArrayUsingPredicate:p];
		dispatch_async(dispatch_get_main_queue(), ^{
			// 2.1 最后一步，回到主线程，说明执行完了
			
			if (image_result.count == 0) {
				block(YES, [dic_images copy]);
			} else {
				block(NO, nil);
			}
		});
    });
}
@end
