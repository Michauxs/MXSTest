//
//  AYFacilityController.m
//  BabySharing
//
//  Created by Alfred Yang on 1/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFacilityController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

//#import "AYSearchDefines.h"

#define HEADVIEWHEIGHT                          145

@interface AYFacilityController ()

@end

@implementation AYFacilityController {
    NSNumber *facility;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        facility = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"content_close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(4);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [closeBtn addTarget:self action:@selector(didCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [Tools creatLabelWithText:@"场地友好设施" textColor:[Tools black] fontSize:24.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(15);
    }];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"Facility"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"FacilityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    id<AYCommand> change_date = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSArray *tmp = [facility copy];
    [change_date performWithResult:&tmp];
    
//    CALayer *line_separator = [CALayer layer];
//    line_separator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f].CGColor;
//    line_separator.frame = CGRectMake(0, HEADVIEWHEIGHT - 1, SCREEN_WIDTH, 1);
//    [self.view.layer addSublayer:line_separator];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark -- layouts

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, HEADVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEADVIEWHEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    
//    ((UITableView*)view).estimatedRowHeight = 150;
//    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    
    return nil;
}

#pragma mark -- actions
-(void)didCloseBtnClick{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
}

#pragma mark -- notifies



-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
