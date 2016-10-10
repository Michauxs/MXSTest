//
//  ViewController.m
//  MXSTest
//
//  Created by Alfred Yang on 17/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self demo7];
}

- (void)drawNewImage {
    
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
    
    NSString *str = @"ss我是生世地方说";
    str = [str substringToIndex:6];
    NSLog(@"%@",str);
    return;
}
@end
