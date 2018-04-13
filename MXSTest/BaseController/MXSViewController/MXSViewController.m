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

- (instancetype)init {
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.view.backgroundColor = [Tools garyBackgroundColor];
	
    [self initNavBar];
    
    // Do any additional setup after loading the view.
}

- (void)initNavBar {
    _NavBar = [[MXSNavigationBar alloc] initWithVC:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (id)navBarLeftClick {
    NSLog(@"navBarLeftClick");
    [MXSVCExchangeCmd.shared fromVC:self popOneStepWithArgs:nil];
    return nil;
}

- (id)navBarRightClick {
    NSLog(@"navBarRightClick");
    return nil;
}

@end
