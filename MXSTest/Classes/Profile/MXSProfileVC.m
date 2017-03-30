//
//  MXSProfileVC.m
//  MXSTest
//
//  Created by Alfred Yang on 24/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSProfileVC.h"
#import "NodeHandle.h"
#import <objc/runtime.h>

@interface MXSProfileVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MXSProfileVC {
	
	UITableView *ListTableView;
	NSArray *titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [Tools whiteColor];
	
	titleArr = @[@"City58", @"WebVictory", @"Nuomi", @"WebPekingPeople", @"WebCityAround", @"WebScoialDragon", @"WebScoialPeking", @"TogetherBar", @"DoArt"];
	
	ListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 20) style:UITableViewStylePlain];
	[self.view addSubview:ListTableView];
	ListTableView.delegate = self;
	ListTableView.dataSource = self;
	
}

#pragma mark --  Stringactions From Array
- (void)didSelectedWeb:(NSString *)webName {
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	NSString* name = [NSString stringWithFormat:@"MXS%@Handle", webName];
	Class c = NSClassFromString(name);
	[c handNodeWithSimple];
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	//	Method m = class_getClassMethod(c, @selector(handNodeWithSimple));//获取类方法
	//	IMP im = method_getImplementation(m);
	//	NSDictionary *back_args = im(c, @selector(handNodeWithSimple));
	
//	SEL sel = NSSelectorFromString(webName);
//	Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
//	if (m) {
//		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
//		func(cur, sel, name);
//	}
	
}


#pragma mark -- UItableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellID = @"listCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell) {
	 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
		
	cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self didSelectedWeb:[titleArr objectAtIndex:indexPath.row]];
}

@end
