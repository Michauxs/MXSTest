//
//  MXSShowImageVC.m
//  MXSTest
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSShowImageVC.h"

@interface MXSShowImageVC ()

@end

@implementation MXSShowImageVC {
//    BOOL isViewAppear;
}

//- (instancetype)init {
//	self = [super init];
//	if (self) {
//
//	}
//	return  self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_showImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weiwei"]];
	[self.view addSubview:_showImg];
	_showImg.frame = CGRectMake(0, 60, SCREEN_WIDTH, 160);
	
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(100, 1000, 50, 50);
//    btn.backgroundColor = [UIColor orangeColor];
//    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}

- (void)clicked {
    [MXSVCExchangeCmd.shared popAnimatVCFrom:self withArgs:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	[MXSVCExchangeCmd.shared fromVC:self popOneStepWithArgs:nil];
//    [MXSVCExchangeCmd.shared popAnimatVCFrom:self withArgs:nil];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent) {
        NSLog(@"will controller :%@", self);
    } else {
        NSLog(@"willMove to %@", parent);
        NSLog(@"___appear___");
    }
    NSLog(@"-------------------");
}
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if (!parent) {
        NSLog(@"did controller :%@", self);     //did controller :<MXSShowImageVC: 0x7fb0bd4427c0>
    } else {
        NSLog(@"didMove to %@", parent);
        NSLog(@"___appear___");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    isViewAppear = YES;
}

//- (BOOL)isMovingToParentViewController {
//    NSLog(@"isMovingToParentViewController\n");
//    return YES;
//}
//- (BOOL)isMovingFromParentViewController {
//    NSLog(@"isMovingFromParentViewController\n");
//    return YES;
//}
@end
