//
//  AYSetNapCostController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapThemeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   228
#define kTableFrameY                64
#define reloadIndexPathForRow   6

@implementation AYSetNapThemeController {
    
    BOOL isAllowLeave;
    long notePow;
    
    CGFloat setY;
    UIButton *tmpNoteBtn;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
            isAllowLeave = ((NSNumber*)[dic_cost objectForKey:@"allow_leave"]).boolValue;
            notePow = ((NSNumber*)[dic_cost objectForKey:@"cans"]).longValue;
            
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetNapTheme"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_cell performWithResult:&class_name];
    
    id<AYCommand> cmd_query = [cmd_notify.commands objectForKey:@"queryData:"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSNumber numberWithBool:isAllowLeave] forKey:@"allow_leave"];
    
    if (notePow) {
        [dic setValue:[NSNumber numberWithLong:notePow] forKey:@"cans"];
    }
    
    [cmd_query performWithResult:&dic];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [costTextField becomeFirstResponder];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"服务类型";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:16.f backgroundColor:nil];
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 20.f;
    view.frame = CGRectMake(margin, kTableFrameY, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - kTableFrameY);
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {

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
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
    [dic_options setValue:[NSNumber numberWithLong:notePow] forKey:@"cans"];
    [dic_options setValue:[NSNumber numberWithInt:isAllowLeave] forKey:@"allow_leave"];
    [dic_options setValue:@"nap_theme" forKey:@"key"];
    [dic setValue:dic_options forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)didSetNoteBtn:(UIButton*)btn {
    tmpNoteBtn = btn;
    return nil;
}

- (id)didOptionBtnClick:(UIButton*)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.tag != 99) {
        if (btn.selected) {
            notePow = pow(2, btn.tag);
            
            if (btn.tag == 0) {
                isAllowLeave = NO;
                NSNumber *isEdit = [NSNumber numberWithBool:NO];
                kAYDelegatesSendMessage(@"SetNapTheme", @"changeEditMode:", &isEdit)
                
                UITableView *tableView = [self.views objectForKey:@"Table"];
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:reloadIndexPathForRow inSection:1]] withRowAnimation:NO];
            }
            else if(!tmpNoteBtn || tmpNoteBtn.tag == 0) {
                NSNumber *isEdit = [NSNumber numberWithBool:YES];
                kAYDelegatesSendMessage(@"SetNapTheme", @"changeEditMode:", &isEdit)
                
                UITableView *tableView = [self.views objectForKey:@"Table"];
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:reloadIndexPathForRow inSection:1]] withRowAnimation:NO];
            }
            
            if (tmpNoteBtn) {
                tmpNoteBtn.selected = NO;
            }
            tmpNoteBtn = btn;
            
        }
        else { //再次点击同一个btn: 即把唯一一个以选择的btn取消选择,此时没有已选择的btn,参数置0
            notePow = 0;
            tmpNoteBtn = nil;
            isAllowLeave = NO;
            NSNumber *isEdit = [NSNumber numberWithBool:NO];
            kAYDelegatesSendMessage(@"SetNapTheme", @"changeEditMode:", &isEdit)
            
            UITableView *tableView = [self.views objectForKey:@"Table"];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:reloadIndexPathForRow inSection:1]] withRowAnimation:NO];
            
        }
        
    } else {
        isAllowLeave = !isAllowLeave;
    }
    
    return nil;
}

-(id)textChange:(NSString*)text {
    
    return nil;
}
@end
