//
//  AYNewVersionNavController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNewVersionNavController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYModelFacade.h"
#import "AYBOrderTimeDefines.h"
#import "AYNavigationController.h"

#define NumbOfNavCover		3

@interface AYNewVersionNavController ()

@end

@implementation AYNewVersionNavController {
	UIPageControl *navControl;
	UIButton *enterBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Collection"];
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"NewVersionNav"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"VersionNavCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name];
	
	CGFloat coverImageMaxY = SCREEN_HEIGHT * 475/667 + 25;
	
	navControl = [[UIPageControl alloc]init];
	navControl.numberOfPages = NumbOfNavCover;
	CGSize size = [navControl sizeForNumberOfPages:NumbOfNavCover];
	navControl.pageIndicatorTintColor = [UIColor whiteColor];
	navControl.currentPageIndicatorTintColor = [Tools theme];
	[self.view addSubview:navControl];
	[navControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(coverImageMaxY - size.height - 20);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(size);
	}];
	navControl.currentPage = 0;
	
	enterBtn = [Tools creatBtnWithTitle:@"立即加入" titleColor:[Tools theme] fontSize:316.f backgroundColor:nil];
	[Tools setViewBorder:enterBtn withRadius:18.f andBorderWidth:1.f andBorderColor:[Tools theme] andBackground:[Tools whiteColor]];
	[self.view addSubview:enterBtn];
	[enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(112, 36));
		make.top.equalTo(self.view).offset(coverImageMaxY + 75 - (SCREEN_HEIGHT == 480?15:0));
		make.right.equalTo(self.view).offset(-25);
	}];
	enterBtn.alpha = 0;
	[enterBtn addTarget:self action:@selector(didEnterBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark -- layouts
- (id)CollectionLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	view.backgroundColor = [UIColor clearColor];
	((UICollectionView*)view).pagingEnabled = YES;
	((UICollectionView*)view).bounces = NO;
	return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- actions
- (void)didEnterBtnClick {
	
	NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
	NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:app_Version forKey:kAYDongDaAppVersion];
	[defaults synchronize];
	
	/**
	 * create controller factory
	 */
	id<AYCommand> cmd = COMMAND(kAYFactoryManagerCommandTypeInit, kAYFactoryManagerCommandTypeInit);
	AYViewController* controller = nil;
	[cmd performWithResult:&controller];
	
	/**
	 * Navigation Controller
	 */
	AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
	[rootContorller pushViewController:controller animated:NO];
	
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
	[dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:rootContorller forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd_exchange = EXCHANGEWINDOWS;
	[cmd_exchange performWithResult:&dic_show_module];
}

- (id)scrollOffsetX:(NSNumber*)args {
	
	int page = (int)(args.floatValue / SCREEN_WIDTH + 0.5) % NumbOfNavCover;
	navControl.currentPage = page;
	if (page >= NumbOfNavCover - 1) {
		
		[UIView animateWithDuration:0.25 animations:^{
			enterBtn.alpha = 1.f;
		}];
		
	}
	return nil;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}
@end
