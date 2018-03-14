//
//  AYNapLocationController.m
//  BabySharing
//
//  Created by Alfred Yang on 22/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapLocationController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AYNapLocationController ()<UISearchBarDelegate, CLLocationManagerDelegate, AMapSearchDelegate>

@end

@implementation AYNapLocationController {
	
    CLLocation *loc;
    AMapSearchAPI *search;
    AMapBusLine *aBusMapTip;
}

- (void)postPerform{
    
}
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
    
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = kAMapApiKey;
    
    //初始化检索对象
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"NapLocation"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"LocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_hot_cell performWithResult:&class_name];
    
    UIView* titleSearch = [self.views objectForKey:@"SearchBar"];
    self.navigationItem.titleView = titleSearch;
    self.navigationItem.hidesBackButton = YES;
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 9, SCREEN_WIDTH, 1);
    [headView.layer addSublayer:line2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view resignFirstResponder];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 10+kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH - 10);
    view.backgroundColor = [UIColor whiteColor];
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"输入你的位置";
    [cmd_place_hold performWithResult:&place_holder];
    
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

#pragma mark -- search bar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) return;
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = searchText;
    tips.city     = @"北京";
    tips.cityLimit = YES; //是否限制城市
    [search AMapInputTipsSearch:tips];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    //    [self.tips setArray:response.tips];
    id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"NapLocation"];
    id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"changeLocationResultData:"];
    NSArray* tmp = response.tips;
    [cmd performWithResult:&tmp];
	
	id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
}

- (id)searchTextChanged:(id)obj {
    NSString* search_text = (NSString*)obj;
    NSLog(@"text %@", search_text);
    
    return nil;
}

- (id)hideKeyBoard {
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
    }
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

#pragma mark -- notifies
- (id)sendLocation:(NSDictionary*)args{
    
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:args forKey:kAYControllerChangeArgsKey];
    
    [self hideKeyBoard];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

@end
