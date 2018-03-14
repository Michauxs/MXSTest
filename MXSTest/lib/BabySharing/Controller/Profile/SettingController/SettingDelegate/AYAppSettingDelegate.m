//
//  AYAppSettingDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAppSettingDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"

#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"

@interface SettingCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;

@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc]init];
        self.label.textColor = [Tools black];
        self.label.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
        
        CALayer* line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.20].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(8, 68 - 1, SCREEN_WIDTH - 16, 1);
        [self.layer addSublayer:line];
    }
    return self;
}

@end

@implementation AYAppSettingDelegate {
    NSArray* title;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    title = @[@"去评分", @"关于咚哒", @"清除缓存"];
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
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.label.text = [title objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 2) {
        cell.label.text = [cell.label.text stringByAppendingString:[NSString stringWithFormat:@"(%.2fM)", [TmpFileStorageModel tmpFileStorageSize]]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
//		//跳转到应用
//		NSString *appItuensURL = @"itms-apps://itunes.apple.com/cn/app/dong-da/id1095143390?mt=8";
//		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:appItuensURL]];
		
//		//跳转到应用评论页
//		NSString *appID = @"1095143390";
//		NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", appID];
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
		
		//APP内置AppStore
		[self loadAppStoreController];
		
    } else if(indexPath.row == 1) {
		
        id<AYCommand> AboutDD = DEFAULTCONTROLLER(@"AboutDD");
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:AboutDD forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [_controller performWithResult:&dic];
        
    } else {
        [TmpFileStorageModel deleteBMTmpImageDir];
        [TmpFileStorageModel deleteBMTmpMovieDir];
        NSIndexPath *currentIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)loadAppStoreController {
	
	SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc]init];
	
	storeProductViewContorller.delegate=self;
	
	NSString *appID = @"1095143390";
	[storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appID} completionBlock:^(BOOL result,NSError *error)   {
		
		if(error)  {
			NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
			
		} else{
			[_controller presentViewController:storeProductViewContorller animated:YES completion:nil];
			
		}
	}];
	
}

//AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController {
	
	[_controller dismissViewControllerAnimated:YES completion:nil];
	
}

@end
