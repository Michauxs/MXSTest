//
//  AYPostMovieCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/21/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostMovieCommand.h"
#import <UIKit/UIKit.h>
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYQueryModelDefines.h"

#import "TmpFileStorageModel.h"

@implementation AYPostMovieCommand
- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {
    
    /**
     * 0. 得到需要上传的照片数量, 并初始化数据
     */
    NSURL* movie_url = [args objectForKey:@"movie_url"];
    dispatch_semaphore_t movie_semephore = dispatch_semaphore_create(0);        // 没一个图片是一个上传线程，需要一个semaphores等待上传完成
    __block BOOL post_movie_result = NO;                                         // 记录上传用户数据线程的结果
    
    UIImage* cover_img = [args objectForKey:@"cover_img"];
    dispatch_semaphore_t cover_semephore = dispatch_semaphore_create(0);        // 没一个图片是一个上传线程，需要一个semaphores等待上传完成
    __block BOOL post_cover_result = NO;                                         // 记录上传用户数据线程的结果
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);              // 用户上传数据库信息
    __block BOOL post_data_result = NO;                                         // 记录上传用户数据线程的结果
    __block NSDictionary* server_reture_data = nil;                             // 服务器返回的数据
    
    /**
     * 1. 主线程 调用loading 阻塞用户消息
     */
    [self beforeAsyncCall];
    
    /**
     * 2. 子线程1:
     *      等待所有线程执行完毕, 最近进行主线程返回
     */
    dispatch_queue_t qw = dispatch_queue_create("wait thread", nil);
    dispatch_async(qw, ^{
//        dispatch_semaphore_wait(movie_semephore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
//        dispatch_semaphore_wait(cover_semephore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             * 2.1 最后一步，回到主线程，说明执行完了
             */
            [self endAsyncCall];
            block((post_movie_result && post_cover_result && post_data_result), server_reture_data);
        });
    });
   
    /**
     * 4. 启动异步上传文件
     */
    {
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [photo_dic setValue:movie_url forKey:@"url"];
        
        AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadFile");
        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"upload movie file result are %d", success);
            post_movie_result = success;
            dispatch_semaphore_signal(movie_semephore);
        }];
    }
    
    /**
     * 3. 启动异步线程对图片进行上传
     */
    NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:cover_img];
    {
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [photo_dic setValue:extent forKey:@"image"];
        [photo_dic setValue:cover_img forKey:@"upload_image"];
        
        AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"upload result are %d", success);
            post_cover_result = success;
            dispatch_semaphore_signal(cover_semephore);
        }];
    }
    
    
    /**
     * 5. 组合上传内容
     */
    dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
    dispatch_async(qp, ^{
        NSDictionary* user = nil;
        CURRENUSER(user);
        
        NSMutableDictionary* post_args = [user mutableCopy];
        [post_args setValue:[args objectForKey:@"description"] forKey:@"description"];
        [post_args setValue:[args objectForKey:@"tags"] forKey:@"tags"];
       
        {
            NSMutableArray* arr_items = [[NSMutableArray alloc]init];
            NSNumber* type = [NSNumber numberWithInteger:ModelAttchmentTypeMovie];
            NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
            [dic_tmp setObject:type forKey:@"type"];
            [dic_tmp setObject:[[movie_url path] lastPathComponent] forKey:@"name"];
            [arr_items addObject:dic_tmp];
            
            NSNumber* type1 = [NSNumber numberWithInteger:ModelAttchmentTypeImage];
            NSMutableDictionary* dic_tmp1 = [[NSMutableDictionary alloc]init];
            [dic_tmp1 setObject:type1 forKey:@"type"];
            [dic_tmp1 setObject:extent forKey:@"name"];
            [arr_items addObject:dic_tmp1];
            
            [post_args setObject:arr_items forKey:@"items"];
        }
        
        dispatch_semaphore_wait(movie_semephore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        dispatch_semaphore_wait(cover_semephore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        
        if (post_movie_result && post_cover_result) {
            AYRemoteCallCommand* cmd = COMMAND(@"Remote", @"PostContent");
            [cmd performWithResult:[post_args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                post_data_result = success;
                server_reture_data = result;
                dispatch_semaphore_signal(semaphore);
            }];
        } else {
            post_data_result = NO;
            server_reture_data = @{@"error":@"post attachment error"};
            dispatch_semaphore_signal(semaphore);
        }
    });
}
@end
