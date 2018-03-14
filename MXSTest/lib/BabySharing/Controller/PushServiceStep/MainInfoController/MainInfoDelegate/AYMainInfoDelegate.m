//
//  AYMainInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMainInfoDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"
#import <CoreLocation/CoreLocation.h>

#import "AYServiceArgsDefines.h"

@interface AYMainInfoDelegate ()
//@property (nonatomic, strong) NSArray* querydata;
@end

@implementation AYMainInfoDelegate {
    NSMutableArray *titles;
    NSMutableArray *sub_titles;
    NSString *service_cat;
    
    id napPhoto;
    
    NSString *napTitle;
    NSDictionary *napTitleInfo;
    
    NSString *napDesc;
    
    NSString *catSecondary;
    NSDictionary *napThemeInfo;
    
//    NSNumber *napCost;
    NSDictionary *napCostInfo;
	
	NSNumber *isAllowLeaves;
	NSString *otherWords;
    
    NSDictionary *napAdressInfo;
    
//    NSDictionary *dic_device;
    NSArray *napFacilities;
    NSString *customDeviceName;
    
    BOOL isEditModel;
    NSMutableDictionary *service_info;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    titles = [NSMutableArray arrayWithObjects:@"添加图片", @"撰写标题", @"撰写描述", @"设置价格", @"制定《服务守则》", @"场地友好性(选填)", nil];
    sub_titles = [NSMutableArray arrayWithObjects:
                  @"添加图片",
                  @"与众不同的标题可以展示您的魅力",
                  @"总结您的服务亮点",
                  @"一开始可以试试具有吸引力的价格",
                  @"预定前家长需要同意服务守则",
                  @"为孩子提供更友好的场地体验", nil];
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

#pragma marlk -- commands
- (id)changeQueryData:(id)args {
    
    NSDictionary *info = (NSDictionary*)args;
	service_info = args;
	
	NSDictionary *info_categ = [info objectForKey:kAYServiceArgsCategoryInfo];
	service_cat = [info_categ objectForKey:kAYServiceArgsCat];
	catSecondary = [info_categ objectForKey:kAYServiceArgsCatSecondary];
	
	id photo = [[info objectForKey:kAYServiceArgsImages] objectAtIndex:0];
	if (photo) {
		napPhoto = photo;
	}
	id title = [info objectForKey:kAYServiceArgsTitle];
	if(title) {
		napTitle = title;
	}
	
	NSMutableDictionary *dic_title = [[NSMutableDictionary alloc]init];
	[dic_title setValue:[info objectForKey:kAYServiceArgsTitle] forKey:kAYServiceArgsTitle];
	[dic_title setValue:[[info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCatThirdly] forKey:kAYServiceArgsCatThirdly];
	[dic_title setValue:[[info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCourseCoustom] forKey:kAYServiceArgsCourseCoustom];
	napTitleInfo = [dic_title copy];
	
	napDesc = [info objectForKey:kAYServiceArgsDescription];
	
	NSDictionary *info_detail = [info objectForKey:kAYServiceArgsDetailInfo];
	
	NSMutableDictionary *dic_cost = [[NSMutableDictionary alloc]init];
	[dic_cost setValue:[info_detail objectForKey:kAYServiceArgsPrice] forKey:kAYServiceArgsPrice];
	[dic_cost setValue:[info_detail objectForKey:kAYServiceArgsLeastHours] forKey:kAYServiceArgsLeastHours];
	[dic_cost setValue:[info_detail objectForKey:kAYServiceArgsLeastTimes] forKey:kAYServiceArgsLeastTimes];
	[dic_cost setValue:[info_detail objectForKey:kAYServiceArgsCourseduration] forKey:kAYServiceArgsCourseduration];
	napCostInfo = [dic_cost copy];
	
	NSMutableDictionary *dic_address = [[NSMutableDictionary alloc]init];
	[dic_address setValue:[[info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsPin] forKey:kAYServiceArgsPin];
	[dic_address setValue:[[info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsAddress] forKey:kAYServiceArgsAddress];
	[dic_address setValue:[[info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsAdjustAddress] forKey:kAYServiceArgsAdjustAddress];
	napAdressInfo = [dic_address copy];
	
	napFacilities = [info_detail objectForKey:kAYServiceArgsFacility];
	
	NSNumber *isAllowLev = [info_detail objectForKey:kAYServiceArgsAllowLeave];
	if (isAllowLev) {
		isAllowLeaves = isAllowLev;
	}
	otherWords = [info_detail objectForKey:kAYServiceArgsNotice];
	
    return nil;
}

- (id)changeQueryInfo:(id)info {
	
    isEditModel = YES;
    service_info = info;
	
    titles = [NSMutableArray arrayWithObjects:
                  @"编辑图片",
                  @"编辑标题",
                  @"编辑描述",
                  @"编辑价格",
                  @"编辑《服务守则》",
                  @"更多信息",  nil];
    service_cat = [[info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	catSecondary = [[info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCatSecondary];
    napPhoto = [[info objectForKey:kAYServiceArgsImages] objectAtIndex:0];
    napTitle = [info objectForKey:kAYServiceArgsTitle];
	
    NSMutableDictionary *dic_title = [[NSMutableDictionary alloc]init];
    [dic_title setValue:[info objectForKey:kAYServiceArgsTitle] forKey:kAYServiceArgsTitle];
    [dic_title setValue:[[info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCatThirdly] forKey:kAYServiceArgsCatThirdly];
    [dic_title setValue:[[info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCourseCoustom] forKey:kAYServiceArgsCourseCoustom];
    napTitleInfo = [dic_title copy];
    
    napDesc = [info objectForKey:kAYServiceArgsDescription];
	
	NSDictionary *info_detail = [info objectForKey:kAYServiceArgsDetailInfo];
    
    NSMutableDictionary *dic_cost = [[NSMutableDictionary alloc]init];
    [dic_cost setValue:[info_detail objectForKey:kAYServiceArgsPrice] forKey:kAYServiceArgsPrice];
    [dic_cost setValue:[info_detail objectForKey:kAYServiceArgsLeastHours] forKey:kAYServiceArgsLeastHours];
    [dic_cost setValue:[info_detail objectForKey:kAYServiceArgsLeastTimes] forKey:kAYServiceArgsLeastTimes];
    [dic_cost setValue:[info_detail objectForKey:kAYServiceArgsCourseduration] forKey:kAYServiceArgsCourseduration];
    napCostInfo = [dic_cost copy];
	
    NSMutableDictionary *dic_address = [[NSMutableDictionary alloc]init];
    [dic_address setValue:[[info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsPin] forKey:kAYServiceArgsPin];
    [dic_address setValue:[[info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsAddress] forKey:kAYServiceArgsAddress];
    [dic_address setValue:[[info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsAdjustAddress] forKey:kAYServiceArgsAdjustAddress];
    napAdressInfo = [dic_address copy];
    
    napFacilities = [info_detail objectForKey:kAYServiceArgsFacility];
	
	isAllowLeaves = [info_detail objectForKey:kAYServiceArgsAllowLeave];
	otherWords = [info_detail objectForKey:kAYServiceArgsNotice];
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell = nil;
    if (indexPath.row == 0) {
        NSString* class_name = @"AYNapPhotosCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
        if (napPhoto) {
            id info = [napPhoto copy];
            kAYViewSendMessage(cell, @"setCellInfo:", &info)
        }
        
    }  else if (indexPath.row == 5 ) {
        
        NSString* class_name = @"AYOptionalInfoCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSString *title = titles[indexPath.row];
        kAYViewSendMessage(cell, @"setCellInfo:", &title)
        
    }
    else {
        
        NSString* class_name = isEditModel? @"AYNapEditInfoCellView" : @"AYNapBabyAgeCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *cell_info = [[NSMutableDictionary alloc]init];
        [cell_info setValue:[titles objectAtIndex:indexPath.row] forKey:@"title"];
        [cell_info setValue:[sub_titles objectAtIndex:indexPath.row] forKey:@"sub_title"];
        [cell_info setValue:[NSNumber numberWithBool:NO] forKey:@"is_seted"];
        
        if (napTitle && ![napTitle isEqualToString:@""] && indexPath.row == 1) {
            [cell_info setValue:napTitle forKey:@"sub_title"];
			
			if(napTitle && ![napTitle isEqualToString:@""]) {
                [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
            }
        }
        else if (napDesc && ![napDesc isEqualToString:@""] && indexPath.row == 2) {
            [cell_info setValue:napDesc forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        else if ( indexPath.row == 3) {
            
            NSNumber *price = [napCostInfo objectForKey:kAYServiceArgsPrice];
            NSNumber *leastHours = [napCostInfo objectForKey:kAYServiceArgsLeastHours];
            NSNumber *duration = [napCostInfo objectForKey:kAYServiceArgsCourseduration];
            NSNumber *leastTimes = [napCostInfo objectForKey:kAYServiceArgsLeastTimes];
            
            if (price && price.floatValue != 0) {
                NSString *priceTitleStr ;
                
                if ([service_cat isEqualToString:kAYStringNursery]) {
					priceTitleStr = [NSString stringWithFormat:@"￥%.f/小时",price.floatValue * 0.01];
                    if ( leastHours && leastHours.floatValue != 0) {
                        [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
                    }
                } else {
					priceTitleStr = [NSString stringWithFormat:@"￥%.f/次",price.floatValue * 0.01];
                    if (duration && duration.floatValue != 0 && leastTimes && leastTimes.floatValue != 0) {
                        [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
                    }
                }//
				
				[cell_info setValue:priceTitleStr forKey:@"sub_title"];
				
            }
			
        }
        else if (isAllowLeaves && indexPath.row == 4) {
            NSString *notice =  isAllowLeaves.boolValue ? @"需要家长陪伴" : @"不需要家长陪伴";
            [cell_info setValue:notice forKey:@"sub_title"];
            [cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_seted"];
        }
        
        id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [set_cmd performWithResult:&cell_info];
        
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250;
    } else if (indexPath.row == 5) {
//        return isEditModel? 90 : 70;
        return 90 ;
    } else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        kAYDelegateSendNotify(self, @"addPhotosAction", nil)
        return;
    }
    else if (indexPath.row == 1) {
        [self setNapTitle];
    }
    else if (indexPath.row == 2) {
        [self setServiceDesc];
    }else if (indexPath.row == 3) {
        [self setNapCost];
    } else if (indexPath.row == 4) {        //notice
        [self setServiceNotice];
    } else if (indexPath.row == 5) {
        [self setNapDeviceOrUpdateAdvance];
    } else {
        
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [Tools garyBackgroundColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark -- notifies set service info
- (void)setNapTitle {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"InputNapTitle");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	
    [dic_push setValue:napTitle forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapCost {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapCost");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithDictionary:napCostInfo];
    [tmp setValue:service_cat forKey:kAYServiceArgsCat];
    [dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setServiceNotice {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetServiceNotice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
	[dic_args setValue:isAllowLeaves forKey:kAYServiceArgsAllowLeave];
	[dic_args setValue:otherWords forKey:kAYServiceArgsNotice];
	
    [dic_push setValue:[dic_args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setServiceDesc {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"ServiceDesc");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[napDesc copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)setNapDeviceOrUpdateAdvance {
    if (isEditModel) {
		id<AYCommand> dest = DEFAULTCONTROLLER(@"EditAdvanceInfo");
		NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
		[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
		[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
		
		id tmp = [service_info mutableCopy];
		[dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd = PUSH;
		[cmd performWithResult:&dic_push];
		
    } else {
		
        id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
        NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
		
        [dic_push setValue:napFacilities forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
    
}

@end
