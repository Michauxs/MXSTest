//
//  MXSFileHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 30/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSFileHandle.h"

@implementation MXSFileHandle

+ (void)writeToPlistFile:(id)info withFileName:(NSString*)fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
	[info writeToFile:filename atomically:YES];
	
}

+ (void)writeToJsonFile:(id)info withFileName:(NSString*)fileName {
	
	NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", fileName]];
	[data writeToFile:filename atomically:YES];
	
}

+ (void)transPlistToJsonWithPlistFile:(NSString*)plistName andJsonFile:(NSString*)jsonName {
	
	NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
	
	id fileData = [NSArray arrayWithContentsOfFile:plistFilePath];
	if (!fileData) {
		fileData = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
	}
	
	[MXSFileHandle writeToJsonFile:fileData withFileName:jsonName];
	
}



- (void)tmpFunc {
	
//	NSString *urlstring = @"http://www.dianping.com/shop/66526819";
//	NSDictionary *dic = [NodeHandle handNodeWithServiceUrl:urlstring];
//	[MXSFileHandle writeToPlistFile:dic withFileName:@"oneNursery"];
	
	//1.1首先获取路径
	NSString *path = [[NSBundle mainBundle]pathForResource:@"city58.json" ofType:nil];
	//.读取文件内容
	NSData *data = [NSData dataWithContentsOfFile:path];
	//对其解析
	NSArray *array =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	
	for (NSDictionary *dic in array) {
		
		NSArray *arr = [dic valueForKey:@"arr"];
		for (NSMutableDictionary *dic_course in arr) {
			NSString *desc = [dic_course valueForKey:@"desc"];
			desc = [NodeHandle delHTMLTag:desc];
			desc = [desc stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
			[dic_course setValue:desc forKey:@"desc"];
		}
	}
	
	[MXSFileHandle writeToJsonFile:array withFileName:@"city58_v2"];
}

@end
