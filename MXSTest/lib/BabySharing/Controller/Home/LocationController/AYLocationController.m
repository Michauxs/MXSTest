//
//  AYSearchFriendController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
//#import "AYSearchDefines.h"

#import "AYInsetLabel.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface AYLocationController ()<UISearchBarDelegate, CLLocationManagerDelegate, AMapSearchDelegate>
@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *gecoder;
@end

@implementation AYLocationController{
    
    CLLocation *loc;
    AMapSearchAPI *search;
    AMapBusLine *aBusMapTip;
}

@synthesize manager = _manager;
@synthesize gecoder = _gecoder;

- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}
-(CLGeocoder *)gecoder{
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic objectForKey:kAYControllerChangeArgsKey];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
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
    
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    //   定位超时时间，最低2s，此处设置为10s
//    self.locationManager.locationTimeout =10;
//    //   逆地理请求超时时间，最低2s，此处设置为10s
//    self.locationManager.reGeocodeTimeout = 10;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"Location"];
    
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
    
    AYInsetLabel *h1 = [[AYInsetLabel alloc]initWithTitle:@"建议搜索" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    h1.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(69);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view becomeFirstResponder];
    [self startLocation];
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
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - 110);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"想安排孩子们去哪里";
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

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    } else
        return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"Location"];
        id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"changeLocationResultData:"];
        NSArray* tmp = [NSArray array];
        [cmd performWithResult:&tmp];
        
        kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
        return;
    };
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = searchText;
    tips.city     = @"北京";
    tips.cityLimit = YES; //是否限制城市
    [search AMapInputTipsSearch:tips];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    NSArray* tmp = response.tips;
    
    if (tmp.count == 0) {
        
        [self scrollToHideKeyBoard];
        
        NSString *title = [NSString stringWithFormat:@"暂时没有符合您要求的搜索"];
        id<AYFacadeBase> f_alert = DEFAULTFACADE(@"Alert");
        id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"ShowAlert"];
        
        NSMutableDictionary *dic_alert = [[NSMutableDictionary alloc]init];
        [dic_alert setValue:title forKey:@"title"];
        [dic_alert setValue:[NSNumber numberWithInt:2] forKey:@"type"];
        [cmd_alert performWithResult:&dic_alert];
    }
    
    id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"Location"];
    id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"changeLocationResultData:"];
    [cmd performWithResult:&tmp];
    
    id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
}
/* 公交搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        aBusMapTip = response.buslines.firstObject;
    }
    
}

- (id)searchTextChanged:(id)obj {
    
    return nil;
}

- (id)scrollToHideKeyBoard {
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
- (void)startLocation {
    
    //授权使用定位服务
    [self.manager requestWhenInUseAuthorization];
    //定位精度
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.manager.delegate = self;
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位
        [self.manager startUpdatingLocation];
    } else {
        NSString *title = @"请在iPhone的\"设置-隐私-定位\"中允许-咚哒-定位服务";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
//    return nil;
}

//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation  位置对象
    
    loc = [locations firstObject];
    
    //位置改变幅度大 ->重新定位
    [manager stopUpdatingLocation];
    
    [self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *pl = [placemarks firstObject];
        NSString *name = pl.locality;
        
        id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"Location"];
        id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"autoLocationData:"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:name forKey:@"auto_location_name"];
        [dic setValue:loc forKey:@"auto_location"];
        [cmd performWithResult:&dic];
        
        id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
        
    }];
}

@end
