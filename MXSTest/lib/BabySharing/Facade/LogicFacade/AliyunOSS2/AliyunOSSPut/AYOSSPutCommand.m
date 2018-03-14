//
//  AYOSSPutCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYOSSPutCommand.h"

@implementation AYOSSPutCommand

@synthesize command_type;
@synthesize para;

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary *args = (NSDictionary*)*obj;
	NSData *img_data = [args objectForKey:@"img"];
	NSString *img_name = [args objectForKey:@"img_name"];
	__block NSMutableDictionary *back_args = [[NSMutableDictionary alloc] init];
	
	OSSPutObjectRequest * put = [OSSPutObjectRequest new];
	// 必填字段
	put.bucketName = AYOSSBucketName;
//	put.objectKey = [OSSFilePathPrefix stringByAppendingString:img_name];
	put.objectKey = [img_name stringByAppendingString:OSSFileSurfix];
//	put.uploadingFileURL = [NSURL fileURLWithPath:@"<filepath>"];
	put.uploadingData = img_data; // 直接上传NSData UIImagePNGRepresentation(img)
	// 可选字段，可不设置
	put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
		// 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
		NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
	};
	// 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
	// put.contentType = @"";
	// put.contentMd5 = @"";
	// put.contentEncoding = @"";
	// put.contentDisposition = @"";
	// put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
	
	AYAliyunOSSFacade *ossFacade = DEFAULTFACADE(@"AliyunOSS");
	OSSTask * putTask = [ossFacade.client putObject:put];
	
	[putTask continueWithBlock:^id(OSSTask *task) {
		if (!task.error) {
			NSLog(@"upload object success!");
			[back_args setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
			[back_args setValue:@"success" forKey:@"msg"];
		} else {
			NSLog(@"upload object failed, error: %@" , task.error);
			[back_args setValue:[NSNumber numberWithBool:NO] forKey:@"success"];
			[back_args setValue:task.error forKey:@"msg"];
		}
		return nil;
	}];
	
	[putTask waitUntilFinished];
	// [put cancel];
	
	*obj = [back_args copy];
	
}

- (void)postPerform {
	
}

@end
