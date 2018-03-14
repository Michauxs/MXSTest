//
//  AYOSSGetCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYOSSGetCommand.h"

@implementation AYOSSGetCommand

@synthesize command_type;
@synthesize para;

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary *args = (NSDictionary*)*obj;
	NSString *img_name = [args objectForKey:@"key"];
	UIImageView *imageView = [args objectForKey:@"imageView"];
	NSNumber *processWH = [args objectForKey:@"wh"];
	//imageView holdImage
	imageView.image = IMGRESOURCE(@"default_image");
	
	//cache
	NSString *img_name_storage = [NSString stringWithFormat:@"%@_%@", img_name, processWH];
	
	UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:img_name_storage];
	if (cacheImg) {
		imageView.image = cacheImg;
		return;
	}
	
//	__block UIImage *img;
	OSSGetObjectRequest * request = [OSSGetObjectRequest new];
	// 必填字段
	request.bucketName = AYOSSBucketName;
//	request.objectKey = [OSSFilePathPrefix stringByAppendingString:img_name];
	request.objectKey = [img_name stringByAppendingString:OSSFileSurfix];
	// 图片处理
	request.xOssProcess = [NSString stringWithFormat:@"image/resize,m_lfit,w_%@,h_%@", processWH, processWH];
	// 可选字段
	request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
		// 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
		NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
	};
	// request.range = [[OSSRange alloc] initWithStart:0 withEnd:99]; // bytes=0-99，指定范围下载
//	 request.downloadToFileURL = [NSURL fileURLWithPath:@"<filepath>"]; // 如果需要直接下载到文件，需要指明目标文件地址

	AYAliyunOSSFacade *ossFacade = DEFAULTFACADE(@"AliyunOSS");
	OSSTask * getTask = [ossFacade.client getObject:request];
	[getTask continueWithBlock:^id(OSSTask *task) {
		if (!task.error) {
			NSLog(@"download object success!");
			OSSGetObjectResult * getResult = task.result;
//			NSLog(@"download result: %@", getResult.downloadedData);
			UIImage *getImg = [UIImage imageWithData:getResult.downloadedData];
			dispatch_async(dispatch_get_main_queue(), ^{
				imageView.image = getImg;
			});
			
			[[SDImageCache sharedImageCache] storeImage:getImg forKey:img_name_storage];
			
		} else {
			NSLog(@"download object failed, error: %@" ,task.error);
//			imageView.image = IMGRESOURCE(@"default_image");
		}
		return nil;
	}];

//	[getTask waitUntilFinished];

//	*obj = img;
}

- (void)postPerform {
	
}


@end
