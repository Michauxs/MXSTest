//
//  AYServicePageDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServicePageDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#define WIDTH               SCREEN_WIDTH - 15*2

@implementation AYServicePageDelegate {
    NSDictionary *querydata;
    
    BOOL isExpend;
    CGFloat expendHeight;
	
	NSArray *CellNameArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    isExpend = NO;
	
	CellNameArr = @[@"AYServiceTitleCellView",
					@"AYServiceCapacityCellView",
					@"AYServiceOwnerInfoCellView",
					@"AYServiceDescCellView",
					@"AYServiceFacilityCellView",
					@"AYServiceMapCellView",
					/*@"AYServiceNotiCellView",
					 @"AYServiceTAGCellView",*/ ];
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(NSDictionary*)args {
    querydata = args;
	
//	NSString *service_cat = [querydata objectForKey:kAYServiceArgsCat];
	NSArray *facilities = [[querydata objectForKey:kAYServiceArgsLocationInfo] objectForKey:@"friendliness"];;
	if (facilities.count == 0 || (facilities.count == 1 && [facilities.firstObject length] == 0)) {
		
		CellNameArr = @[@"AYServiceTitleCellView",
						@"AYServiceCapacityCellView",
						@"AYServiceOwnerInfoCellView",
						@"AYServiceDescCellView",
						@"AYServiceMapCellView", ];
	}
    return nil;
}

- (id)TransfromExpend:(NSNumber*)args {

	isExpend = !isExpend;
    expendHeight = args.floatValue;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return querydata ? CellNameArr.count : 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSString* class_name = [CellNameArr objectAtIndex:indexPath.row];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	id tmp = [querydata copy];
	if (tmp) {
		if (indexPath.row == 3) {
			NSMutableDictionary *dic_desc = [querydata mutableCopy];
			[dic_desc setValue:[NSNumber numberWithBool:isExpend] forKey:@"is_expend"];
			tmp = [dic_desc copy];
		}
		
		[(UITableViewCell*)cell performAYSel:@"setCellInfo:" withResult:&tmp];
	}
    cell.controller = self.controller;
    return (UITableViewCell*)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return 155;
//    }
//    else if (indexPath.row == 1) {
//        NSString *descStr = [querydata objectForKey:@"description"];
//        if (!descStr || [descStr isEqualToString:@""]) {
//            return 85;
//        }
//        else {
//            if (descStr.length > 60) {
//                if (isExpend) {
//                    return 85 + expendHeight + 30;
//                } else
//                    return 200;
//            } else {
//                CGSize filtSize = [Tools sizeWithString:descStr withFont:kAYFontLight(14.f) andMaxSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)];
////                return 85 + filtSize.height + 40;
//                return 85 + filtSize.height + 20;
//            }
//        }
//    }//
//    else if (indexPath.row == 2) {
//        return 60;
//    }
//    else if (indexPath.row == 3) {
//        
//        long options = ((NSNumber*)[querydata objectForKey:@"facility"]).longValue;
//        return options == 0 ? 0.001 : 90;
//    }
//    else if (indexPath.row == 4) {
//        return 225;
//    }
//    else
//        return 70;
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.row == 1) {
//		return YES;
//	} else
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id<AYCommand> des = DEFAULTCONTROLLER(@"OneProfile");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:[[querydata objectForKey:@"owner"]objectForKey:kAYCommArgsUserID] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = SHOWMODULEUP;
	[cmd performWithResult:&dic_push];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat off_y = scrollView.contentOffset.y;
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
    NSNumber *y = [NSNumber numberWithFloat:off_y];
    [cmd performWithResult:&y];
}

#pragma mark -- actions


@end
