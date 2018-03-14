//
//  AYAliyunOSSFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYFacade.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import <AliyunOSSiOS/AliyunOSSiOS.h>


//lC2a3NXist8peEDm WP59s7IZkHBqIWWs57Ho0yx9B28S9m
#define AYOSSAccessID  @"LTAINO7wSDoWJRfN"
#define AYOSSAccessKey  @"PcDzLSOE86DsnjQn8IEgbaIQmyBzt6"
//http://blackmirror.
#define AYOSSEndPoint  @"oss-cn-beijing.aliyuncs.com/upload"


#define OSSFilePathPrefix		@"upload/"
#define OSSFileSurfix			@".jpg"
#define AYOSSBucketName			@"bm-dongda"

@interface AYAliyunOSSFacade : AYFacade

@property (nonatomic, strong) OSSClient *client;

//- (OSSClient*)OSSClient;

@end
