//
//  AYPersonalInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 27/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalInfoDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

@implementation AYPersonalInfoDelegate {
    NSDictionary* querydata;
    NSArray *validateArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    validateArr = [NSArray arrayWithObjects:@"已验证的身份", @"已被评价", @"手机号码", @"实名认证", nil];
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

- (id)changeQueryData:(id)array {
    querydata = (NSDictionary*)array;
    return nil;
}

#pragma mark -- table
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
//    if (section == 0 || section == 1) {
//        return 1;
//    } else return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name;
    id<AYViewBase> cell;
    if (indexPath.section == 0) {
        
        class_name = @"AYPersonalDescCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [querydata copy];
        [(UITableViewCell*)cell performAYSel:kAYCellSetInfoMessage withResult:&tmp];
        
    } else if (indexPath.section == 1) {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalDescCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [querydata copy];
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    } else {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalValidateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
//        [tmp setValue:[querydata copy] forKey:@"cell_info"];
        [tmp setValue:[validateArr objectAtIndex:indexPath.row] forKey:@"title"];
        if (indexPath.row == 0) {
            [tmp setValue:[NSNumber numberWithBool:YES] forKey:@"is_first"];
        }
        if (indexPath.row == 3) {
            [tmp setValue:[NSNumber numberWithBool:YES] forKey:@"is_last"];
        }
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).clipsToBounds = YES;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 100;
//    } else if (indexPath.section == 1) {
//
//		NSString *descStr = [querydata objectForKey:kAYProfileArgsDescription];
//		if (!descStr || [descStr isEqualToString:@""]) {
//			return 110;
//		} else {
//			NSString *descStr = [querydata objectForKey:kAYProfileArgsDescription];
//			CGSize filtSize = [Tools sizeWithString:descStr withFont:kAYFontLight(14.f) andMaxSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)];
//			return filtSize.height + 60;
//			//			return 135;
//		}
////        return 135;
//    } else {
//        if (indexPath.row == 0) {
//            return 64;
//        } else if (indexPath.row == 1) {
//
//            NSNumber *has_comment = [querydata objectForKey:@"has_comment"];
//            return has_comment.boolValue?64:0.001;
//
//        } else if (indexPath.row == 2) {
//
//            NSNumber *has_phone = [querydata objectForKey:kAYProfileArgsIsHasPhone];
//            return has_phone.boolValue?64:0.001;
//        } else {
//
//            NSNumber *is_real_name_cert = [querydata objectForKey:kAYProfileArgsIsProvider];
//            return is_real_name_cert.boolValue ? 64:0.001;
//        }
//    }
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *separtor = [UIView new];
//    separtor.backgroundColor = [Tools garyBackgroundColor];
//    return separtor;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section != 2) {
//        return 5.f;
//    } else return 0.001f;
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
    CGFloat offset = scrollView.contentOffset.y;
    NSNumber *offset_y = [NSNumber numberWithFloat:offset];
    [cmd performWithResult:&offset_y];
}

@end
