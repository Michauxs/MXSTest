//
//  AYSetServiceCapacityController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceCapacityController.h"

@implementation AYSetServiceCapacityController {
    
	NSMutableDictionary *service_info;
    NSMutableDictionary *info_detail;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
	
	//default args
    info_detail = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *dic_boundary = [[NSMutableDictionary alloc] init];
    [dic_boundary setValue:[NSNumber numberWithInt:2] forKey:kAYServiceArgsAgeBoundaryLow];
    [dic_boundary setValue:[NSNumber numberWithInt:11] forKey:kAYServiceArgsAgeBoundaryUp];
	[info_detail setValue:dic_boundary forKey:kAYServiceArgsAgeBoundary];
	[info_detail setValue:[NSNumber numberWithInt:4] forKey:kAYServiceArgsCapacity];
	[info_detail setValue:[NSNumber numberWithInt:1] forKey:kAYServiceArgsServantNumb];
	
    [service_info setValue:info_detail forKey:kAYServiceArgsDetailInfo];
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetServiceCapacity"];
    id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
    
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetServiceCapacityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
    id tmp = [service_info copy];
    kAYDelegatesSendMessage(@"SetServiceCapacity", @"changeQueryData:", &tmp);
    
    UIButton *nextBtn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools whiteColor] andFontSize:17.f andBackgroundColor:[Tools themeColor]];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(didNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
//    NSString *title = @"更多信息";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
//    view.backgroundColor = [Tools whiteColor];
//    ((UITableView*)view).contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
	view.clipsToBounds = YES;
    return nil;
}

#pragma mark -- actions
- (void)didNextBtnClick {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"MainInfo");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    [dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)resetCapacityNumb:(NSDictionary*)args {
    NSNumber *index = [args objectForKey:@"index"];
    NSNumber *count = [args objectForKey:@"count"];
    
    if (index.intValue == 0) {      //lsl
        [[info_detail objectForKey:kAYServiceArgsAgeBoundary] setValue:count forKey:kAYServiceArgsAgeBoundaryLow];
    }
    else if (index.intValue == 1) {     //usl
        [[info_detail objectForKey:kAYServiceArgsAgeBoundary] setValue:count forKey:kAYServiceArgsAgeBoundaryUp];
    }
    else if (index.intValue == 2) {     //capacity
        [info_detail setValue:count forKey:kAYServiceArgsCapacity];
    }
    else if (index.intValue == 3) {     //servant_no
        [service_info setValue:count forKey:kAYServiceArgsServantNumb];
    }
    else {
        
    }
    
    return nil;
}

@end
