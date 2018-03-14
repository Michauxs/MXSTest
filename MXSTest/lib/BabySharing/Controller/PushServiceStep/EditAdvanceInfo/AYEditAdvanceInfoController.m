//
//  AYEditAdvanceInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 6/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYEditAdvanceInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYServiceArgsDefines.h"
#import "AYInsetLabel.h"
#import "AYAdvanceOptView.h"

#define LIMITNUMB                   228

@implementation AYEditAdvanceInfoController {
    
    NSMutableDictionary *service_info;
    UILabel *addressLabel;
	AYAdvanceOptView *positionTitle;
	
    BOOL isChanged;
	NSMutableDictionary *note_service_info;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        isChanged = YES;
        
        NSDictionary *dic_args = [dic objectForKey:kAYControllerChangeArgsKey];
		for (NSString *key in dic_args.allKeys) {
			
			[note_service_info setValue:[dic_args objectForKey:key] forKey:key];
			
			if ([key isEqualToString:kAYServiceArgsAddress] || [key isEqualToString:kAYServiceArgsAdjustAddress] || [key isEqualToString:kAYServiceArgsPin] || [key isEqualToString:kAYServiceArgsDistrict]) {
				[[service_info objectForKey:kAYServiceArgsLocationInfo] setValue:[dic_args objectForKey:key] forKey:key];
				
				positionTitle.subTitleLabel.text = [note_service_info objectForKey:kAYServiceArgsAddress];
				
			}
			else if ([key isEqualToString:kAYServiceArgsAgeBoundary] || [key isEqualToString:kAYServiceArgsCapacity] || [key isEqualToString:kAYServiceArgsServantNumb] || [key isEqualToString:kAYServiceArgsFacility]) {
				[[service_info objectForKey:kAYServiceArgsDetailInfo] setValue:[dic_args objectForKey:key] forKey:key];
			}
//			else if ([key isEqualToString:kAYServiceArgs]) {
//				
//			}
			else {
				
			}
		}
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	note_service_info = [[NSMutableDictionary alloc] init];
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_notify;
	
	UILabel *placelabel = [Tools creatLabelWithText:@"场地信息" textColor:[Tools theme] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *placeTitle = [[AYAdvanceOptView alloc] initWithTitle:placelabel];
	placeTitle.access.hidden = YES;
	[tableView addSubview:placeTitle];
	[placeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tableView).offset(10);
		make.centerX.equalTo(tableView);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 50));
	}];
	
	UILabel *positionLabel = [Tools creatLabelWithText:@"位置" textColor:[Tools black] fontSize:316.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	positionTitle = [[AYAdvanceOptView alloc] initWithTitle:positionLabel];
	[tableView addSubview:positionTitle];
	[positionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(placeTitle.mas_bottom).offset(0);
		make.centerX.equalTo(tableView);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 64));
	}];
	positionTitle.userInteractionEnabled = YES;
	[positionTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPositionLabelTap)]];
	
	NSString *addressStr = [[service_info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsAddress];
	if (addressStr && ![addressStr isEqualToString:@""]) {
		positionTitle.subTitleLabel.text = addressStr;
	} else {
		positionTitle.subTitleLabel.text = @"场地地址";
	}
	
	UILabel *facilityLabel = [Tools creatLabelWithText:@"场地友好性" textColor:[Tools black] fontSize:316.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *facilityTitle = [[AYAdvanceOptView alloc] initWithTitle:facilityLabel];
    [tableView addSubview:facilityTitle];
    [facilityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(positionTitle.mas_bottom).offset(0);
        make.centerX.equalTo(tableView);
        make.size.equalTo(positionTitle);
    }];
    facilityTitle.userInteractionEnabled = YES;
    [facilityTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didFacilityLabelTap)]];
    
    UILabel *detailLabel = [Tools creatLabelWithText:@"详情" textColor:[Tools theme] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *detailTitle = [[AYAdvanceOptView alloc] initWithTitle:detailLabel];
	detailTitle.access.hidden = YES;
    [tableView addSubview:detailTitle];
    [detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableView);
        make.top.equalTo(facilityTitle.mas_bottom).offset(25);
		make.size.equalTo(placeTitle);
    }];
	
    UILabel *infoLabel = [Tools creatLabelWithText:@"服务详情" textColor:[Tools black] fontSize:316.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *infoTitle = [[AYAdvanceOptView alloc]initWithTitle:infoLabel];
    [tableView addSubview:infoTitle];
    [infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailTitle.mas_bottom).offset(20);
        make.centerX.equalTo(tableView);
        make.size.equalTo(positionTitle);
    }];
    infoTitle.userInteractionEnabled = YES;
    [infoTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didInfoLabelTap)]];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    NSNumber *isHidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &isHidden)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - 64);
    
//    ((UITableView*)view).contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT - 64, 0, 0, 0);
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    return nil;
}

#pragma mark -- actions
- (void)didPositionLabelTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapArea");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
	
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didFacilityLabelTap {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
	
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didInfoLabelTap {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"EditServiceCapacity");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:[service_info copy] forKey:kAYControllerChangeArgsKey];
	
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (isChanged) {		//整合数据
        NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
        [dic_info setValue:kAYServiceArgsSelf forKey:@"key"];
        [dic_info setValue:service_info forKey:kAYServiceArgsSelf];
		[dic_info setValue:note_service_info forKey:@"handle"];
        [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    }
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    //整合数据
	NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
	
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
