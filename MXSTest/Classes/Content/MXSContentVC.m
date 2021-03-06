//
//  MXSContentVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSContentVC.h"
#import <objc/runtime.h>
#import "MXSWebDianpingHandle.h"
#import "MXSWebSiteHandle.h"

#import <AudioToolbox/AudioToolbox.h>

static void completionCallback(SystemSoundID mySSID)
{
	// Play again after sound play completion
//	AudioServicesPlaySystemSound(mySSID);
}

@implementation MXSContentVC {
	
}

SystemSoundID ditaVoice;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_countNote = 0;
	_ObArr = [NSMutableArray array];
//	[_ObArr addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:nil];
	
	UIButton *ComeOnBtn = [Tools creatBtnWithTitle:@"Append" titleColor:[Tools whiteColor] fontSize:14.f backgroundColor:[Tools theme]];
	ComeOnBtn.layer.cornerRadius = 20.f;
	ComeOnBtn.clipsToBounds = YES;
	
	[self.view addSubview:ComeOnBtn];
	[ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(80, 40));
	}];
	[ComeOnBtn addTarget:self action:@selector(didComeOnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
//	ComeOnBtn.hidden = YES;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"count"]) {
		NSLog(@"%d", (int)(_ObArr.count));
	}
	
}

- (void)didComeOnBtnClick {
	[self demo05];
	
}

- (void)demo05 {
    NSMutableArray *tmp = [NSMutableArray array];
    [tmp addObject:@0];
    [tmp addObject:@1];
    [tmp insertObject:@2 atIndex:2];
    NSLog(@"cons: %@", tmp);
}


- (void)demo04 {    //++/-+的概率
    NSArray *arr = @[[NSMutableArray new], [NSMutableArray new]];
    NSMutableArray *div = [NSMutableArray new];
    for (int i = 0; i < 10000; ++i) {
        int tmp = arc4random()%2;
        NSLog(@"row:\t%d, make: %d", i, tmp);
        
        if (i == 0) {
            [div addObject:[NSNumber numberWithInt:tmp]];
            continue;
        }
        
        int last = [[div lastObject] intValue];
        if (last == 1 && tmp == 1) {
            [[arr objectAtIndex:0] addObject:@1];
        } else if (last == 0 && tmp == 1) {
            [[arr objectAtIndex:1] addObject:@1];
        }
        
        [div addObject:[NSNumber numberWithInt:tmp]];
    }
    
    NSLog(@"cons 0: %ld", [[arr objectAtIndex:0] count]);
    NSLog(@"cons 1: %ld", [[arr objectAtIndex:1] count]);
}
- (void)demo03 {    //for空数组
    NSMutableArray *tmp = [NSMutableArray new];
    NSArray *a = nil;
    for (NSString *name in a) {
        NSLog(@"%@", name);
    }
    
    [tmp addObjectsFromArray:a];
}

- (void)demo02 {    //数组中，可变字典与不可变子字典的替换
    NSMutableArray *tmp = [NSMutableArray arrayWithObject:@{@"key":@"value"}];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@"value2" forKey:@"key2"];
    [tmp replaceObjectAtIndex:0 withObject:dic];
}

- (void)demo01 {    //lock性能影响
	
	NSLock *lock = [[NSLock alloc] init];
	
	NSDate *node = [NSDate date];
	for (int i = 0; i<10000; ++i) {
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			[lock lock];
			_countNote++;
			NSLog(@"count\t\t: %d", _countNote);
			
			NSDate *now = [NSDate date];
			NSLog(@"duration\t: %lf", now.timeIntervalSince1970-node.timeIntervalSince1970);
			[lock unlock];
		});
	}
}

- (void)demoAudio {
	
	// 1. 定义要播放的音频文件的URL
	NSURL *voiceURL = [[NSBundle mainBundle]URLForResource:@"9205" withExtension:@"mp3"];
	// 2. 注册音频文件（第一个参数是音频文件的URL 第二个参数是音频文件的SystemSoundID）
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)(voiceURL),&ditaVoice);
	// 3. 为crash播放完成绑定回调函数
	AudioServicesAddSystemSoundCompletion(ditaVoice,NULL,NULL,(void*)completionCallback,NULL);
	// 4. 播放 ditaVoice 注册的音频 并控制手机震动
	AudioServicesPlayAlertSound(ditaVoice);
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	/*
	NSArray *list = [MXSWebSiteHandle handNodeWithSimple];
	[MXSFileHandle writeToJsonFile:list withFileName:@"webSiteComplete"];
	*/
	
    /**
    NSString *string = [NSString stringWithFormat:@"123 456"];
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound){
        //有空格
    } else{
        //没有空格
    }
	*/
    
	UITouch *touch = [[touches allObjects] firstObject];
	
	UIImageView *readView = [[UIImageView alloc] init];
	readView.image = IMGRESOURE(@"is_read");
	[self.view addSubview:readView];
	readView.bounds = CGRectMake(0, 0, 120, 120);
	readView.center = [touch locationInView:self.view];
	
	CASpringAnimation * ani = [CASpringAnimation animationWithKeyPath:@"bounds"];
	ani.mass = 10.0; //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
	ani.stiffness = 5000; //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
	ani.damping = 100.0;//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
	ani.initialVelocity = 5.f;//初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
	ani.duration = ani.settlingDuration;
	ani.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 60, 60)];
	ani.removedOnCompletion = NO;
	ani.fillMode = kCAFillModeForwards;
	ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[readView.layer addAnimation:ani forKey:@"boundsAni"];
	
	self.tabBarItem.badgeValue = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
