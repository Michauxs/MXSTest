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
	NSMutableArray *divArr;
	
	NSArray *titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [Tools whiteColor];
	
	divArr  = [NSMutableArray array];
	titleArr = @[@"City58", @"WebVictory", @"Nuomi", @"WebPekingPeople", @"WebCityAround", @"HuiLongGuan", @"WebScoialPeking", @"TogetherBar", @"DoArt", @"WebDianping"];
//
//	ListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 20) style:UITableViewStylePlain];
//	[self.view addSubview:ListTableView];
//	ListTableView.delegate = self;
//	ListTableView.dataSource = self;
	
	
	_showTable = [[MXSTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain andDelegate:[MXSProfileTDlg new]];
	[self.view addSubview:_showTable];
	[_showTable registerClsaaWithCellName:@"MXShowTableCell" RowHeight:90 andController:self];
	_showTable.dlg.dlgData = titleArr;
	_showTable.backgroundColor = [UIColor clearColor];
	[_showTable mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.top.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BAR_TAB_HEIGHT));
	}];
	
	UIButton *testBtn = [[UIButton alloc] init];
	[testBtn setTitle:@"More" forState:UIControlStateNormal];
	[testBtn setTitleColor:[UIColor white] forState:UIControlStateNormal];
	testBtn.backgroundColor = [UIColor theme];
	testBtn.layer.cornerRadius = 4.f;
	testBtn.clipsToBounds = YES;
	[self.view addSubview:testBtn];
	[testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(20);
		make.bottom.equalTo(self.view).offset(-80);
		make.size.mas_equalTo(CGSizeMake(80, 40));
	}];
	[testBtn addTarget:self action:@selector(textBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view bringSubviewToFront:testBtn];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)textBtnClick {
	NSArray *tmp = [NSArray arrayWithArray:titleArr];
	[divArr addObjectsFromArray:tmp];
	_showTable.dlg.dlgData = [divArr copy];
	[_showTable reloadData];
}

#pragma mark - dlg notify
- (id)tableViewDidSelectRowAtIndexPath:(id)args {
	NSIndexPath *row = [args objectForKey:@"index_path"];
	NSLog(@"%@", row);
	
	[[MXSVCExchangeCmd shared] pushAnimatVCFrom:self to:@"MXSShowImageVC" withArgs:row];
	return nil;
}

- (id)cellDeleteFromTable:(id)args {
	return nil;
}

- (id)respondPopAnimat {
	
	_animatImgView.alpha = 1;
	[self.view addSubview: _animatImgView];
	
	[UIView animateWithDuration:0.5 animations:^{
		_animatImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- BAR_TAB_HEIGHT);;
		_animatImgView.alpha = 0;
	} completion:^(BOOL finished) {
		[_animatImgView removeFromSuperview];
		_animatImgView = nil;
	}];
	return nil;
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
