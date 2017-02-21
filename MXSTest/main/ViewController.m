//
//  ViewController.m
//  MXSTest
//
//  Created by Alfred Yang on 17/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "Tools.h"

@interface ViewController ()

@end

@implementation ViewController {
    UIImageView *showImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    showImageView = [[UIImageView alloc]init];
    showImageView.contentMode = UIViewContentModeTopLeft;
    [self.view addSubview:showImageView];
    [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(200, 120));
        make.size.equalTo(self.view);
    }];
    
}

#pragma mark -- start
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self demo1];
    
}

- (void)drawNewImage2 {
    
    UIImage * image = [UIImage imageNamed:@"theme"];
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    NSLog(@"%lu", imageData.length);
    
    // 开始上下文，下面不使用时一定要关闭，从上下文栈中移除
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * 0.5, image.size.height * 0.5), YES , 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //裁切
    CGRect rect = CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
//    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
    
    // 在圆区内画出image原图
    [image drawInRect:rect];
    
    // 围绕当前路径画一条线，镶边线,注意在调用strokePath之前必须先添加线，fillPath也一样要先添加线才可操作
//    CGContextAddEllipseInRect(context, rect);
    
    //从上下文环境中获取切好的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    
    NSData * imageData2 = UIImageJPEGRepresentation(newImg,1);
    NSLog(@"%lu", imageData2.length);
    // 使用了beginImgacontext需要关闭上下文 并从上下文栈中移除
    UIGraphicsEndImageContext();
    
    showImageView.image = newImg;
}

- (void)drawNewImage {
    
    UIImage * image = [UIImage imageNamed:@"lol"];
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    NSLog(@"%lu", imageData.length);
    
    //    转化为位图
    CGImageRef temImg = image.CGImage;
    
    //根据范围截图
//    CGRect rect = CGRectMake(0, 0, 100, 100);
    
    CGRect rect2 = CGRectMake(0, 0, image.size.width * 2, image.size.height * 2);
    temImg = CGImageCreateWithImageInRect(temImg, rect2);
    
    //得到新的图片
    UIImage *newImage = [UIImage imageWithCGImage:temImg];
    NSData * newImageData = UIImageJPEGRepresentation(newImage,1);
    NSLog(@"%lu", newImageData.length);
    //释放位图对象
    CGImageRelease(temImg);
    
    showImageView.image = nil;
    showImageView.image = newImage;
    
}

-(void)demo8{
    NSMutableArray *testArr = [[NSMutableArray alloc]init];
    [testArr addObject:@"1"];
    NSLog(@"%@",testArr);
    
    [testArr addObject:@"2"];
    [testArr insertObject:@"3" atIndex:0];
    NSLog(@"%@",testArr);
    
}

-(void)demo7{
    UIDevice *device = [UIDevice currentDevice];
    NSString *systemVersion = device.systemVersion;
    NSString *systemName = device.systemName;
    NSLog(@"systemName -- %@",systemName);
    NSLog(@"systemVersion -- %@",systemVersion);
    NSLog(@"model -- %@",device.model);
    NSLog(@"name -- %@",device.name);
    NSLog(@"local -- %@\n\n",device.localizedModel);
}

-(void)demo6{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"asffjjj jjjjjjjj"];
    NSAttributedString* nnn = [[NSAttributedString alloc]initWithString:@"\n"];
    [str insertAttributedString:nnn atIndex:6];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 300)];
    la.attributedText = str;
    la.numberOfLines = 0;
    [self.view addSubview:la];
}
-(void)demo5{
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 300)];
    la.text = @"ScaleScaleSca\nleScaleScale";
    la.numberOfLines = 0;
    [self.view addSubview:la];
    
    //    NSLog(@"ScaleScaleSca\nleScaleScale");
}

-(void)demo4{
    //屏幕缩放因子
    NSLog(@"Scale-->%f",[UIScreen mainScreen].scale);
}

-(void)demo3{
    //    弹出两次 分两层 点击一层消失一层
    //    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享已成功发布1" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    //    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享已成功发布2" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"123" message:@"456789" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil ];
}
-(id)demo{
    
    NSLog(@"%@",[self classForCoder]);
    return nil;
}

-(void)demo2{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程-1
        for (int i = 0; i<20; ++i) {
            NSLog(@"1-123");
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程-2
        for (int i = 0; i<20; ++i) {
            NSLog(@"2-123");
        }
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        // 等待执行的线程
        for (int i = 0; i<20; ++i) {
            NSLog(@"246");
        }
    });
}
-(void)demo1{
    
    NSLog(@"%d",INT_MAX);
    return;
}
@end
