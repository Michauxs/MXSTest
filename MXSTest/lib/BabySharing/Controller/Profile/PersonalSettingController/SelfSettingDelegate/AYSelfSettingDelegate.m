//
//  AYSelfSettingDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSelfSettingDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"
#import "SGActionView.h"
#import "AYViewController.h"
#import "AYSelfSettingCellView.h"

@implementation AYSelfSettingDelegate {
    NSDictionary* profile_dic;
    NSArray* titles;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    titles =  @[@"头像", @"昵称", @"角色"];
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return profile_dic == nil ? 0 : 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYSelfSettingCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(kAYSelfSettingCellName, kAYSelfSettingCellName);
    }
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 44 - 1, [UIScreen mainScreen].bounds.size.width , 1);
    [((UITableViewCell*)cell).layer addSublayer:line];
    
    cell.controller = self.controller;

    NSInteger index = indexPath.row;
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cell forKey:kAYSelfSettingCellCellKey];
    [dic setValue:[titles objectAtIndex:index] forKey:kAYSelfSettingCellTitleKey];
    [dic setValue:[NSNumber numberWithInteger:index] forKey:kAYSelfSettingCellTypeKey];
    
    switch (indexPath.row) {
        case 0:
            [dic setValue:[profile_dic objectForKey:@"screen_photo"] forKey:kAYSelfSettingCellScreenPhotoKey];
            break;
        case 1:
            [dic setValue:[profile_dic objectForKey:@"screen_name"] forKey:kAYSelfSettingCellScreenNameKey];
            break;
        case 2:
            [dic setValue:[profile_dic objectForKey:@"role_tag"] forKey:kAYSelfSettingCellRoleTagKey];
            break;
        default:
            break;
    }
    
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> view = VIEW(kAYSelfSettingCellName, kAYSelfSettingCellName);
    id<AYCommand> cmd = [view.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [SGActionView showSheetWithTitle:@"" itemTitles:@[@"打开照相机", @"从相册中选择", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
            switch (index) {
                case 0: {
                    
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
                    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerCamera" andArgs:[dic copy]];
                }
                    break;
                case 1: {
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
                    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerPicRoll" andArgs:[dic copy]];
                }
                    break;
                default:
                    break;
            }
        }];
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        AYViewController* des = DEFAULTCONTROLLER(@"RoleTagSearch");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        // [dic_push setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToHideKeyBoard"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
- (id)changeQueryData:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    profile_dic = dic;
    return nil;
}

- (id)changeScreenPhoto:(id)args {
    NSString* photo_name = (id)args;
    [profile_dic setValue:photo_name forKey:@"screen_photo"];
    return nil;
}
@end
