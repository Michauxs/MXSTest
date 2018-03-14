//
//  AYOrderContactCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderContactCellView.h"
#import "Notifications.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@interface AYOrderContactCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNo;

@end

@implementation AYOrderContactCellView {
    NSString *ones_id;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.backgroundColor = [Tools garyLineColor].CGColor;
    line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    [self.layer addSublayer:line_separator];
    
    _userPhotoImage.layer.cornerRadius = 25.f;
    _userPhotoImage.clipsToBounds = YES;
    _userPhotoImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _userPhotoImage.userInteractionEnabled = YES;
    [_userPhotoImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPhotoTap)]];
    
    _contactBtn.layer.cornerRadius = 2.f;
    _contactBtn.clipsToBounds = YES;
    _contactBtn.layer.borderColor = [Tools theme].CGColor;
    _contactBtn.layer.borderWidth = 1.f;
    
    // Initialization code
    [self setUpReuseCell];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderContactCell", @"OrderContactCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
- (void)userPhotoTap {
    UIViewController* des = DEFAULTCONTROLLER(@"OneProfile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:ones_id forKey:kAYControllerChangeArgsKey];
    
    [_controller performWithResult:&dic_push];
}

- (IBAction)didContactBtnClick:(id)sender {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didContactBtnClick"];
    [cmd performWithResult:nil];
}

- (id)setCellInfo:(NSDictionary*)args {
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    NSString *user_id = [info objectForKey:@"user_id"];
    
    NSString *order_user_id = [args objectForKey:@"user_id"];     //发单的人
    NSString *servant_owner_id = [[args objectForKey:@"service"] objectForKey:@"owner_id"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    
    if ([user_id isEqualToString:servant_owner_id]) {     //我发的服务 : -> 要看发单人的头像
        
        ones_id = order_user_id;
        _userNameLabel.text = [args objectForKey:@"screen_name"];
        [_userPhotoImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:[args objectForKey:@"screen_photo"]]] placeholderImage:IMGRESOURCE(@"default_user")];
        
    } else {
        
        ones_id = servant_owner_id;
        _userNameLabel.text = [[args objectForKey:@"service"] objectForKey:@"screen_name"];
        [_userPhotoImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:[[args objectForKey:@"service"] objectForKey:@"screen_photo"]]] placeholderImage:IMGRESOURCE(@"default_user")];
        
    }
    
    return nil;
}
@end
