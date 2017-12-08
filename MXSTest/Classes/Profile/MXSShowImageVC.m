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

@implementation MXSShowImageVC

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
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[MXSVCExchangeCmd.shared fromVC:self popOneStepWithArgs:nil];
}

@end
