//
//  AYSearchSKUController.m
//  BabySharing
//
//  Created by Alfred Yang on 24/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSearchSKUController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYModelFacade.h"

@implementation AYSearchSKUController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"SearchSKU"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SearchSKUResultCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools garyBackgroundColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools whiteColor];
	
	UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:view.bounds];
	[view addSubview:searchBar];
	searchBar.placeholder = @"搜索全部服务";
	searchBar.tintColor = [Tools black];
	searchBar.barTintColor = [Tools garyBackgroundColor];
	UIImageView* iv = [[UIImageView alloc] initWithImage:[Tools imageWithColor:[Tools garyBackgroundColor] size:CGSizeMake(searchBar.bounds.size.width, searchBar.bounds.size.height)]];
	iv.tag = -1;
	[searchBar insertSubview:iv atIndex:1];
	for (UIView* v in searchBar.subviews.firstObject.subviews) {
		if ( [v isKindOfClass: [UITextField class]] ) {
			((UITextField*)v).tintColor = [Tools theme];
			((UITextField*)v).backgroundColor = [Tools whiteColor];
			((UITextField*)v).textAlignment = NSTextAlignmentLeft;
			((UITextField*)v).leftView = nil;
			break;
		}
	}
//	searchBar.searchBarStyle = UISearchBarStyleProminent;
//	searchBar.backgroundColor = [Tools whiteColor];
//	searchBar.backgroundImage = [UIImage new];
	searchBar.delegate = self;
	searchBar.showsCancelButton = YES;
//	[searchBar becomeFirstResponder];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarHideBarBotLineMessage, nil)
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
	view.backgroundColor = [Tools garyBackgroundColor];
	return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

#pragma UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self leftBtnSelected];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self leftBtnSelected];
}

@end
