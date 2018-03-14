//
//  AYLocationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 31/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
//#import "AYSearchDefines.h"

#import <AMapSearchKit/AMapSearchKit.h>

@interface AutoLocationCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationlabel;
@property (nonatomic, strong) UIImageView *locationIcon;
@end

@implementation AutoLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.locationIcon = [[UIImageView alloc]init];
        [self.locationIcon setImage:IMGRESOURCE(@"position")];
        [self addSubview:self.locationIcon];
        [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        self.locationlabel = [[UILabel alloc]init];
        self.locationlabel.font = [UIFont systemFontOfSize:14.f];
        self.locationlabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.f];
        self.locationlabel.textAlignment = NSTextAlignmentLeft;
        self.locationlabel.text = @"正在定位...";
        [self addSubview:self.locationlabel];
        [self.locationlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationIcon.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return self;
}

@end

@implementation AYLocationDelegate {
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
    if (previewDic.count == 0) {
        return 1;
    } else {
        return previewDic.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (previewDic == nil || previewDic.count == 0) {
        AutoLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        if (cell == nil) {
            cell = [[AutoLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        if (auto_locationName && ![auto_locationName isEqualToString:@""]) {
            cell.locationlabel.text = auto_locationName;
        }
        return cell;
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"LocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell =[tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = VIEW(@"LocationCell", @"LocationCell");
        }
        cell.controller = self.controller;
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"resetContent:"];
        //        NSDictionary *dic = previewDic[indexPath.row];
        
        AMapTip *tip = previewDic[indexPath.row];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:tip.name forKey:@"location_name"];
        [dic setValue:tip.district forKey:@"district"];
        [cmd performWithResult:&dic];
        
        return (UITableViewCell*)cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dic_location = [[NSMutableDictionary alloc]init];
    
    if (previewDic == nil || previewDic.count == 0) {
        if (!auto_locationName || [auto_locationName isEqualToString:@""]) {
            
            NSString *title = @"请稍等,正在定位...";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return;
        }
        
        if (![auto_locationName isEqualToString:@"北京市"] && ![auto_locationName isEqualToString:@"Beijing"]) {
            id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToHideKeyBoard"];
            [cmd performWithResult:nil];
            
            NSString *title = [NSString stringWithFormat:@"咚哒目前只支持北京地区. 我们正在努力达到\n%@",auto_locationName];
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return;
        }
        
        [dic_location setValue:auto_locationName forKey:@"location_name"];
        [dic_location setValue:auto_location forKey:@"location"];
        
    } else {
        
        AMapTip *tip = previewDic[indexPath.row];
        [dic_location setValue:tip.name forKey:@"location_name"];
        [dic_location setValue:tip.district forKey:@"district"];
        double latitude = tip.location.latitude;
        double longitude = tip.location.longitude;
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        [dic_location setValue:loc forKey:@"location"];
        
        if (tip.uid != nil && tip.location == nil) {
            id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToHideKeyBoard"];
            [cmd performWithResult:nil];
            NSString *title = @"公交线路暂无法定位";
            AYShowBtmAlertView(title, BtmAlertViewTypeWitnBtn)
            return;
        }
    }
    
    AYViewController* des = DEFAULTCONTROLLER(@"LocationResult");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    [dic_push setValue:dic_location forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
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
