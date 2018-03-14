//
//  AYSetServiceThemeController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceThemeController.h"
#import "AYServiceArgsDefines.h"
#import "AYServiceCategOptView.h"

#define CellHeight			100

@implementation AYSetServiceThemeController {
	
    BOOL isEdit;
	
	NSInteger backArgsOfRowNumb;
	
	NSMutableDictionary *service_info;
	NSMutableDictionary *info_categ;
	NSString *CatStr;
	NSString *secondaryTmp;
	
	NSMutableArray *optViewArr;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([tmp isKindOfClass:[NSMutableDictionary class]]) {
			service_info = tmp;
			info_categ  = [service_info objectForKey:kAYServiceArgsCategoryInfo];
			CatStr = [info_categ objectForKey:kAYServiceArgsCat];
			
        } else if ([tmp isKindOfClass:[NSString class]]) {
            isEdit = YES;
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
		id back_args = [dic objectForKey:kAYControllerChangeArgsKey];
		if (([back_args isKindOfClass:[NSNumber class]] && [back_args boolValue]) || [back_args isKindOfClass:[NSString class]]) {
			NSString *args;
			if([back_args isKindOfClass:[NSString class]]) {
				args = [dic objectForKey:kAYControllerChangeArgsKey];
				[info_categ setValue:args forKey:kAYServiceArgsCourseCoustom];
				[info_categ removeObjectForKey:kAYServiceArgsCatThirdly];
			} else
				args = [info_categ objectForKey:kAYServiceArgsCatThirdly];
			
			for (AYServiceCategOptView *opt in optViewArr) {
				if ([opt.optArgs isEqualToString:[info_categ objectForKey:kAYServiceArgsCatSecondary]]) {
					opt.subArgs = args;
				} else
					opt.subArgs = nil;
			}
			UIButton *btn_right = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools theme] fontSize:616 backgroundColor:nil];
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
			
		} else {
			[info_categ setValue:secondaryTmp forKey:kAYServiceArgsCatSecondary];
		}
		
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
//    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetServiceTheme"];
//	id obj = (id)cmd_notify;
//	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
//	obj = (id)cmd_notify;
//	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
//	
//    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetServiceThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	
	NSString *titleStr;
	NSArray *titles;
	if ([CatStr isEqualToString:kAYStringNursery]) {
		titleStr = @"看顾类型?";
		titles = kAY_service_options_title_nursery;
		
		NSNumber *is_hidden = [NSNumber numberWithBool:YES];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
		
	} else if ([CatStr isEqualToString:kAYStringCourse]) {
		titleStr = @"课程类型?";
		titles = kAY_service_options_title_course;
		
		UIButton *btn_right = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools RGB225GaryColor] fontSize:316 backgroundColor:nil];
		btn_right.userInteractionEnabled = NO;
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
		
	} else {
		titleStr = @"参数设置错误";
	}
	
	UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools black] fontSize:630.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(40);
		make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 168/667);
	}];
	
	CGFloat unitHeight = 56.f;
	CGFloat betMargin = 16.f;
	CGFloat topMargin = SCREEN_HEIGHT * 300/667;
	
	optViewArr = [NSMutableArray array];
	for (int i = 0; i < titles.count; ++i) {
		AYServiceCategOptView *optView = [[AYServiceCategOptView alloc] initWithTitle:[titles objectAtIndex:i]];
		[self.view addSubview:optView];
		optView.optArgs = [titles objectAtIndex:i];
		optView.userInteractionEnabled = YES;
		[optView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didServiceCategOptTap:)]];
		[optView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view).offset(topMargin + i*(unitHeight+betMargin));
			make.left.equalTo(self.view).offset(40);
			make.right.equalTo(self.view).offset(-40);
			make.height.mas_equalTo(unitHeight);
		}];
		[optViewArr addObject:optView];
	}
	
//	NSMutableDictionary *tmp = [info_categ copy];
//    kAYDelegatesSendMessage(@"SetServiceTheme", @"changeQueryData:", &tmp);
//	
//	backArgsOfRowNumb = ((NSNumber*)tmp).integerValue;
//	
//	UIView *tableView = [self.views objectForKey:kAYTableView];
//	tableView.frame = CGRectMake(0, SCREEN_HEIGHT - backArgsOfRowNumb * CellHeight, SCREEN_WIDTH, backArgsOfRowNumb * CellHeight);
//	
//	UIButton *nextBtn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools whiteColor] andFontSize:316.f andBackgroundColor:[Tools themeColor]];
//	[self.view addSubview:nextBtn];
//	[nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerX.equalTo(self.view);
//		make.bottom.equalTo(self.view);
//		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
//	}];
////	nextBtn.hidden = YES;
//	[self.view sendSubviewToBack:nextBtn];
//	[nextBtn addTarget:self action:@selector(didServiceThemeNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    return nil;
}

//- (id)TableLayout:(UIView*)view {
//    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//    view.backgroundColor = [Tools whiteColor];
//    return nil;
//}

#pragma mark -- actions
- (void)didServiceCategOptTap:(UITapGestureRecognizer*)tap {
	
	UIView *tapView = tap.view;
	NSString *catSecondary = ((AYServiceCategOptView*)tapView).optArgs;
	
	if ([CatStr isEqualToString:kAYStringNursery]) {
		[info_categ setValue:catSecondary forKey:kAYServiceArgsCatSecondary];
		[self rightBtnSelected];
		
	} else if ([CatStr isEqualToString:kAYStringCourse]) {
		// 变换选项: 修改/仅浏览?
		secondaryTmp = [info_categ objectForKey:kAYServiceArgsCatSecondary];
		[info_categ setValue:catSecondary forKey:kAYServiceArgsCatSecondary];
		
		id<AYCommand> des = DEFAULTCONTROLLER(@"SetCourseSign");
		NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
		[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
		
		[dic_push setValue:info_categ forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd = PUSH;
		[cmd performWithResult:&dic_push];
		
	} else {
		
	}
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
	id<AYCommand> des = DEFAULTCONTROLLER(@"InputNapTitle");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
    return nil;
}

- (id)serviceThemeSeted:(NSString*)args {
    
    if (isEdit) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:args forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
        
    } else {
		if ([CatStr isEqualToString:kAYStringNursery]) {
			[info_categ setValue:args forKey:kAYServiceArgsCatSecondary];
			[self rightBtnSelected];
			
		} else if ([CatStr isEqualToString:kAYStringCourse]) {
			// 变换选项:修改/仅浏览
			secondaryTmp = [info_categ objectForKey:kAYServiceArgsCatSecondary];
			[info_categ setValue:args forKey:kAYServiceArgsCatSecondary];
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"SetCourseSign");
			NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
			[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
			
			[dic_push setValue:info_categ forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd = PUSH;
			[cmd performWithResult:&dic_push];
			
		} else {
			
		}
    }
    return nil;
}

@end
