//
//  AYAboutDDController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAboutDDController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"

@implementation AYAboutDDController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_about = [self.delegates objectForKey:@"AboutDongda"];
        
        id obj = (id)cmd_about;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_about;
        [cmd_delegate performWithResult:&obj];
        
    }
    
    UIImageView *logoView = [[UIImageView alloc]init];
    logoView.image = IMGRESOURCE(@"dongda_logo");
    logoView.layer.cornerRadius = 30.f;
    logoView.clipsToBounds = YES;
    logoView.layer.rasterizationScale = [UIScreen mainScreen].scale;

    UIView *view_table = [self.views objectForKey:@"Table"];
    [view_table addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view_table).offset(-SCREEN_WIDTH * 0.25);
        make.centerX.equalTo(view_table);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.5, SCREEN_WIDTH *0.5));
    }];
    
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"关于咚哒";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(SCREEN_WIDTH, 0, 0, 0);
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
