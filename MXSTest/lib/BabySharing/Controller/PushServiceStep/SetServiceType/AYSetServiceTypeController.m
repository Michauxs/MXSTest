//
//  AYSetServiceTypeController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceTypeController.h"
#import "AYServiceCategOptView.h"

@implementation AYSetServiceTypeController {
	NSMutableDictionary *push_service_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UILabel *titleLabel = [Tools creatLabelWithText:@"您要发布的服务" textColor:[Tools black] fontSize:630.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 168/667);
    }];
	
	CGFloat unitHeight = 56.f;
	CGFloat betMargin = 16.f;
	CGFloat topMargin = SCREEN_HEIGHT * 300/667;
	
	NSArray *titles = @[@"看顾", @"课程"];
	for (int i = 0; i < titles.count; ++i) {
		AYServiceCategOptView *optView = [[AYServiceCategOptView alloc] initWithTitle:[titles objectAtIndex:i]];
		[self.view addSubview:optView];
		optView.optArgs = [titles objectAtIndex:i];
		optView.userInteractionEnabled = YES;
		[optView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didServiceCategLabelTap:)]];
		[optView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view).offset(topMargin + i*(unitHeight+betMargin));
			make.left.equalTo(self.view).offset(40);
			make.right.equalTo(self.view).offset(-40);
			make.height.mas_equalTo(unitHeight);
		}];
	}
    
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
	
//	NSString *title = @"服务类型";
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- actions
- (void)didServiceCategLabelTap:(UITapGestureRecognizer*)tap {
	UIView *tapL = tap.view;
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"SetServiceTheme");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *info_categ = [[NSMutableDictionary alloc] init];
	[info_categ setValue:((AYServiceCategOptView*)tapL).optArgs forKey:kAYServiceArgsCat];
	[push_service_info setValue:info_categ forKey:kAYServiceArgsCategoryInfo];
	
    [dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

@end
