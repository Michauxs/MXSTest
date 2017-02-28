//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"

@interface MXSHomeVC ()

@end

@implementation MXSHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *cover = [[UIImageView alloc]init];
	cover.image = IMGRESOURE(@"launchimage");
	[self.view addSubview:cover];
	[cover mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.size.equalTo(self.view);
//		make.center.equalTo(self.view);
		make.edges.equalTo(self.view);
	}];
	
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	UITouch *touch = [[touches allObjects] firstObject];
	CGPoint centerP = [touch locationInView:[touch view]];
	
	NSString *title = @"你摊上大事了！002";
	UILabel *tipsLabel = [Tools creatUILabelWithText:title andTextColor:[Tools themeColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:1];
	[self.view addSubview:tipsLabel];
	tipsLabel.bounds = CGRectMake(0, 0, 300, 30);
	tipsLabel.center = centerP;
//	[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.center.equalTo(self.view);
//	}];
	
	MXSViewController *actVC = [self.tabBarController.viewControllers objectAtIndex:1];
	actVC.tabBarItem.badgeValue = @"2";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
