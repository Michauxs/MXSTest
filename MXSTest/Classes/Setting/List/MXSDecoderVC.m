//
//  MXSDecoderVC.m
//  MXSTest
//
//  Created by Sunfei on 2018/5/14.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSDecoderVC.h"
#import "MXSStudent.h"

@interface MXSDecoderVC ()

@end

@implementation MXSDecoderVC

- (void)ReceiveCmdArgsActionPost:(id)args {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"person.tt"];

    //2.从文件中读取对象
    MXSStudent *p = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    NSLog(@"keys = %@",p.keys);
    NSLog(@"%@", p);
}

- (id)navBarRightClick {
    [self writeDataCoder];
    return nil;
}

- (void)writeDataCoder {
    
    NSDictionary *dic= @{@"name":@"zero001",@"age":@25, @"height":@175};
    MXSStudent *stu = [[MXSStudent alloc] init];
    stu.infoData = dic;
//    NSArray *keys = [dic allKeys];
//    stu.keys = keys;
//    for (NSString *key in keys) {
//        [stu setValue:[dic objectForKey:key] forKey:key];
//    }
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"person.tt"];
    NSLog(@"path=%@",path);
    
    [NSKeyedArchiver archiveRootObject:stu toFile:path];
    
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:stu forKey:@"person"];
//    [archiver finishEncoding];
    
//    //5:写入文件当中
//    BOOL result = [data writeToFile:path atomically:YES];
//    if (result) {
//        NSLog(@"归档成功:%@",path);
//    }else {
//        NSLog(@"归档不成功!!!");
//    }
    
}

- (void)readDataCoder2 {
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"person.tt"];
    NSLog(@"path=%@",path);
    //准备解档路径
    NSData *myData = [NSData dataWithContentsOfFile:path];
    //创建反归档对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myData];
    //反归档
    MXSStudent *aper = [MXSStudent new];
    aper = [unarchiver decodeObjectForKey:@"person.tt"];
    //完成反归档
    [unarchiver finishDecoding];
    //测试
    NSLog(@"keys = %@",aper.keys);
    
    
}

@end
