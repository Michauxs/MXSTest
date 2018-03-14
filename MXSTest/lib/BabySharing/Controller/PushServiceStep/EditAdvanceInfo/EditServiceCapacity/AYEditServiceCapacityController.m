//
//  AYEditServiceCapacityController.m
//  BabySharing
//
//  Created by Alfred Yang on 6/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYEditServiceCapacityController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYServiceArgsDefines.h"
#import "AYInsetLabel.h"

#define LIMITNUMB                   228

@implementation AYEditServiceCapacityController {
    
    NSMutableDictionary *note_service_info;
	NSDictionary *service_info;
    
    UILabel *agesNumbLabel;
    UITextField *babyNumb;
    UITextField *servantNumb;
    
    UILabel *serThemeLabel;
    
    BOOL isAlreadyEnable;
    NSNumber *sepNumb;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	note_service_info = [[NSMutableDictionary alloc] init];
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
         UIView* picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"EditServiceCapacity"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"描述" textColor:[Tools theme] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 115, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_notify;
	[tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).offset(15);
		make.centerX.equalTo(self.view);
		make.width.mas_equalTo(SCREEN_WIDTH);
		make.bottom.equalTo(self.view);
	}];
	
	UIEdgeInsets labelInset = UIEdgeInsetsMake(0, 5, 0, 0);
	
	CGFloat labelHeight = 64.f;
	CGFloat setLabelHeight = 45.f;
	CGFloat rightMargin = 5.f;
	
    AYInsetLabel *babyAgesTitle = [[AYInsetLabel alloc]initWithTitle:@"接纳孩子年龄" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    babyAgesTitle.textInsets = labelInset;
    [tableView addSubview:babyAgesTitle];
    [babyAgesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView).offset(0);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, setLabelHeight));
    }];
    babyAgesTitle.userInteractionEnabled = YES;
    [babyAgesTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBabyAgesClick:)]];
    
    agesNumbLabel = [Tools creatLabelWithText:@"0岁 - 0岁" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
    [tableView addSubview:agesNumbLabel];
    [agesNumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(babyAgesTitle).offset(-rightMargin);
        make.centerY.equalTo(babyAgesTitle);
    }];
	
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
    NSDictionary *dic_ages = [info_detail objectForKey:kAYServiceArgsAgeBoundary];
    NSNumber *age_lsl = [dic_ages objectForKey:kAYServiceArgsAgeBoundaryLow];
    NSNumber *age_usl = [dic_ages objectForKey:kAYServiceArgsAgeBoundaryUp];
    if (age_lsl && age_usl) {
        agesNumbLabel.text = [NSString stringWithFormat:@"%@岁 - %@岁", age_lsl, age_usl];
    }
    
    /*capacity*/
    AYInsetLabel *babyNumbTitle = [[AYInsetLabel alloc]initWithTitle:@"最多接受孩子数量" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    babyNumbTitle.textInsets = labelInset;
    [tableView addSubview:babyNumbTitle];
    [babyNumbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyAgesTitle.mas_bottom).offset(1);
        make.centerX.equalTo(tableView);
        make.size.equalTo(babyAgesTitle);
    }];
    
    UILabel *babyNumbSign = [Tools creatLabelWithText:@"个" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
    [tableView addSubview:babyNumbSign];
    [babyNumbSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(babyNumbTitle).offset(-rightMargin);
        make.centerY.equalTo(babyNumbTitle);
    }];
    
    babyNumb = [[UITextField alloc]init];
    babyNumb.textColor = [Tools theme];
    babyNumb.font = kAYFontLight(14.f);
    babyNumb.textAlignment = NSTextAlignmentRight;
    babyNumb.keyboardType = UIKeyboardTypeNumberPad;
    babyNumb.delegate = self;
    [tableView addSubview:babyNumb];
    [babyNumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(babyNumbSign.mas_left).offset(-5);
        make.centerY.equalTo(babyNumbTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    NSNumber *capacityNumb = [info_detail objectForKey:kAYServiceArgsCapacity];
	babyNumb.text = [NSString stringWithFormat:@"%d", capacityNumb.intValue];
	
    /*servant*/
    AYInsetLabel *servantNumbTitle = [[AYInsetLabel alloc]initWithTitle:@"服务者数量" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    servantNumbTitle.textInsets = labelInset;
    [tableView addSubview:servantNumbTitle];
    [servantNumbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyNumbTitle.mas_bottom).offset(1);
        make.centerX.equalTo(tableView);
        make.size.equalTo(babyAgesTitle);
    }];
	
	UIView *servantBg = [[UIView alloc] init];
	[Tools creatCALayerWithFrame:CGRectMake(0, setLabelHeight - 0.5, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:servantBg];
	[tableView addSubview:servantBg];
	[servantBg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(servantNumbTitle).offset(5);
		make.left.equalTo(servantNumbTitle);
		make.size.equalTo(servantNumbTitle);
	}];
	[tableView sendSubviewToBack:servantBg];
    
    UILabel *servantNumbSign = [Tools creatLabelWithText:@"个" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
    [tableView addSubview:servantNumbSign];
    [servantNumbSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(servantNumbTitle).offset(-rightMargin);
        make.centerY.equalTo(servantNumbTitle);
    }];
    
    servantNumb = [[UITextField alloc]init];
    servantNumb.textColor  = [Tools theme];
    servantNumb.font  = kAYFontLight(14.f);
    servantNumb.textAlignment  = NSTextAlignmentRight;
    servantNumb.keyboardType  = UIKeyboardTypeNumberPad;
    servantNumb.delegate = self;
    [tableView addSubview:servantNumb];
    [servantNumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(servantNumbSign.mas_left).offset(-5);
        make.centerY.equalTo(servantNumbTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    NSNumber *servant_no = [info_detail objectForKey:kAYServiceArgsServantNumb];
	servantNumb.text = [NSString stringWithFormat:@"%d", servant_no.intValue];
    
    /*categary*/
    AYInsetLabel *serviceCatTitle = [[AYInsetLabel alloc]initWithTitle:@"服务类型" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    serviceCatTitle.textInsets = labelInset;
    [tableView addSubview:serviceCatTitle];
    [serviceCatTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servantNumbTitle.mas_bottom).offset(6);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, labelHeight));
    }];
    
    UILabel *serCatLabel = [Tools creatLabelWithText:@"服务类型" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
    [tableView addSubview:serCatLabel];
    [serCatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceCatTitle);
        make.right.equalTo(serviceCatTitle).offset(-rightMargin);
    }];
	
	UIView *serviceCatBg = [[UIView alloc] init];
	[Tools creatCALayerWithFrame:CGRectMake(0, labelHeight - 0.5, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:serviceCatBg];
	[tableView addSubview:serviceCatBg];
	[serviceCatBg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(serviceCatTitle).offset(1);
		make.left.equalTo(serviceCatTitle);
		make.size.equalTo(serviceCatTitle);
	}];
	[tableView sendSubviewToBack:serviceCatBg];
	
    /*theme*/
    AYInsetLabel *serviceThemeTitle = [[AYInsetLabel alloc]initWithTitle:@"服务主题" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    serviceThemeTitle.textInsets = labelInset;
    [tableView addSubview:serviceThemeTitle];
    [serviceThemeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceCatTitle.mas_bottom).offset(1);
        make.centerX.equalTo(tableView);
        make.size.equalTo(serviceCatTitle);
    }];
    
    serThemeLabel = [Tools creatLabelWithText:@"服务主题" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
    [tableView addSubview:serThemeLabel];
    [serThemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceThemeTitle);
        make.right.equalTo(serviceThemeTitle).offset(-rightMargin);
    }];
	
	UIView *serviceThemeBg = [[UIView alloc] init];
	[Tools creatCALayerWithFrame:CGRectMake(0, labelHeight - 0.5, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:serviceThemeBg];
	[tableView addSubview:serviceThemeBg];
	[serviceThemeBg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(serviceThemeTitle).offset(1);
		make.left.equalTo(serviceThemeTitle);
		make.size.equalTo(serviceThemeTitle);
	}];
	[tableView sendSubviewToBack:serviceThemeBg];
	
    NSString *catStr;
	NSDictionary *info_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_categ objectForKey:kAYServiceArgsCat];
	serCatLabel.text = service_cat;
	
    if ([service_cat isEqualToString:kAYStringNursery]) {
        catStr = @"看顾服务";
    }
    else if ([service_cat isEqualToString:kAYStringCourse]) {
        servantNumbTitle.text = @"老师数量";
        catStr = @"课程";
    }
	
    //服务主题分类
    NSString *cans_cat = [info_categ objectForKey:kAYServiceArgsCatSecondary];
	if (!cans_cat || [cans_cat isEqualToString:@""]) {
		cans_cat = [info_categ objectForKey:kAYServiceArgsCourseCoustom];
		if (!cans_cat || [cans_cat isEqualToString:@""]) {
			cans_cat = [info_categ objectForKey:kAYServiceArgsCatThirdly];
		}
	}
	serThemeLabel.text = cans_cat;
	
    
    babyNumbTitle.userInteractionEnabled = YES;
    servantNumbTitle.userInteractionEnabled = YES;
    [babyNumbTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBabyNumbTitle:)]];
    [servantNumbTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapServantNumbTitle:)]];
    
    tableView.userInteractionEnabled = YES;
    [tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewElseWhere:)]];
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
	
    UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:16.f backgroundColor:nil];
    bar_right_btn.userInteractionEnabled = NO;
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, 118, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - 64);
    //    ((UITableView*)view).contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT - 64, 0, 0, 0);
    return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    return nil;
}

#pragma mark -- actions
- (void)tapTableViewElseWhere:(UITapGestureRecognizer*)tap {
    [babyNumb resignFirstResponder];
    [servantNumb resignFirstResponder];
}

- (void)editBabyAgesClick:(UIGestureRecognizer*)tap {
    [self tapTableViewElseWhere:nil];
    kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
}

- (void)tapServiceThemeTitle:(UIGestureRecognizer*)tap {
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"SetServiceTheme");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"editTheme" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}

- (void)tapBabyNumbTitle:(UIGestureRecognizer*)tap {
    [babyNumb becomeFirstResponder];
}

- (void)tapServantNumbTitle:(UIGestureRecognizer*)tap {
    [servantNumb becomeFirstResponder];
}

- (void)resetRightAbleStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:16.f backgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}

#pragma mark -- textfied delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
		
	if (![string isEqualToString:@""] && ![[textField.text stringByAppendingString:string] isEqualToString:@""]) {
		[self resetRightAbleStatus];
	}
    return YES;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    //整合数据
	NSNumber *babyNumbArgs = [NSNumber numberWithInt:babyNumb.text.intValue];
	NSNumber *servantNumbArgs = [NSNumber numberWithInt:servantNumb.text.intValue];
	if ([babyNumbArgs isEqualToNumber:@0] || [servantNumbArgs isEqualToNumber:@0]) {
		NSString *tipsTitle = @"限制数量不能设置为 0 ";
		AYShowBtmAlertView(tipsTitle, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	[note_service_info setValue:babyNumbArgs forKey:kAYServiceArgsCapacity];
	[note_service_info setValue:servantNumbArgs forKey:kAYServiceArgsServantNumb];
	
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[note_service_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"EditServiceCapacity"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSDictionary *dic = nil;
    [cmd_index performWithResult:&dic];
    
    if (dic) {
        NSNumber* usl = ((NSNumber *)[dic objectForKey:kAYServiceArgsAgeBoundaryUp]);
        NSNumber* lsl = ((NSNumber *)[dic objectForKey:kAYServiceArgsAgeBoundaryLow]);
        
        if (usl.intValue < lsl.intValue) {
            NSString *title = @"年龄设置错误";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return nil;
        }
        
        [note_service_info setValue:dic forKey:kAYServiceArgsAgeBoundary];
        NSString *ages = [NSString stringWithFormat:@"%@岁 - %@岁",lsl, usl];
        agesNumbLabel.text = ages;
        
		[self resetRightAbleStatus];
    }
    
    return nil;
}

- (id)didCancelClick {
    //do nothing else ,but be have to invoke this methed
    return nil;
}
@end
