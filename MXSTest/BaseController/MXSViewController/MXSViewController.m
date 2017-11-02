//
//  MXSViewController.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSViewController.h"

@interface MXSViewController ()

@end

@implementation MXSViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.view.backgroundColor = [Tools garyBackgroundColor];
	
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
