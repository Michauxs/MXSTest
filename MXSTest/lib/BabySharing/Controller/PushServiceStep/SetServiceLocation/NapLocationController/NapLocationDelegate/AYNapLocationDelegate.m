//
//  AYNapLocationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 22/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapLocationDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#import <AMapSearchKit/AMapSearchKit.h>

@implementation AYNapLocationDelegate {
    NSArray* previewDic;
    NSString *auto_locationName;
    CLLocation *auto_location;
    
    int countDidClick;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    countDidClick = 0;
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
    return previewDic.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"LocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell =[tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    cell.controller = self.controller;
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"resetContent:"];
    AMapTip *tip = previewDic[indexPath.row];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tip.name forKey:@"location_name"];
    [dic setValue:tip.district forKey:@"district"];
    [cmd performWithResult:&dic];
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (previewDic == nil || previewDic.count == 0) {
    //        return 80;
    //    }
    //    else{
    return 44;
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dic_location = [[NSMutableDictionary alloc]init];
    
    AMapTip *tip = previewDic[indexPath.row];
    [dic_location setValue:tip.name forKey:kAYServiceArgsAddress];
    [dic_location setValue:tip.district forKey:kAYServiceArgsDistrict];
    double latitude = tip.location.latitude;
    double longitude = tip.location.longitude;
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
	NSMutableDictionary *loc = [[NSMutableDictionary alloc] init];
	[loc setValue:[NSNumber numberWithDouble:latitude] forKey:kAYServiceArgsLatitude];
	[loc setValue:[NSNumber numberWithDouble:longitude] forKey:kAYServiceArgsLongtitude];
    [dic_location setValue:loc forKey:kAYServiceArgsPin];
    
    if (tip.uid != nil && tip.location == nil) {
        id<AYCommand> cmd = [self.notifies objectForKey:@"hideKeyBoard"];
        [cmd performWithResult:nil];
        NSString *title = @"公交线路无法定位";
        AYShowBtmAlertView(title, BtmAlertViewTypeWitnBtn)
        return;
    }
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendLocation:"];
    [cmd performWithResult:&dic_location];
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToHideKeyBoard"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
-(id)autoLocationData:(id)args{
    NSDictionary *dic = (NSDictionary*)args;
    auto_locationName = [dic objectForKey:@"auto_location_name"];
    auto_location = [dic objectForKey:@"auto_location"];
    return nil;
}
- (id)changeLocationResultData:(id)obj {
    previewDic = (NSArray*)obj;
    return nil;
}
@end
