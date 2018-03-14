//
//  PersonInfoCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "AYSelfSettingCellView.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYSelfSettingCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

static NSString* const kAYSelfSettingCellHideCancelBtn = @"hideCancel";

@interface AYSelfSettingCellView() 

@end;

@implementation AYSelfSettingCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAYSelfSettingCellHideCancelBtn object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (UIImageView*)getHeadView {
    if (_headView == nil) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self.contentView addSubview:_headView];
    }
   
    return _headView;
}

- (UILabel*)getTitleLabel {
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLable];
    }
    return _titleLable;
}

- (void)changeTitleWithArgs:(NSDictionary*)dic {
    NSString* title = [dic objectForKey:kAYSelfSettingCellTitleKey];
    self.titleLable.text = title;
    [self.titleLable sizeToFit];
}

- (UITextField*)getScreenNameContainer {
    if (_nickTextFiled == nil) {
        self.nickTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCancel) name:kAYSelfSettingCellHideCancelBtn object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_nickTextFiled];
        self.cancelBtn.hidden = YES;
        [self.cancelBtn setBackgroundImage:PNGRESOURCE(@"cancel_circle") forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(deleleNickName) forControlEvents:UIControlEventTouchUpInside];
        self.nickTextFiled.font = [UIFont systemFontOfSize:12];
        self.nickTextFiled.textAlignment = NSTextAlignmentRight;
        self.nickTextFiled.delegate  = self;
        
        [self.contentView addSubview:self.nickTextFiled];
        [self.contentView addSubview:self.cancelBtn];
        self.nickTextFiled.placeholder = @"4-16个字符，限中英文，数字，表情符号";
        self.nickTextFiled.delegate = self;
        [self.contentView addSubview:_nickTextFiled];
    }
    
    return _nickTextFiled;
}

- (UILabel*)getRoleLabel {
    if (_roleLable == nil) {
        _roleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.roleLable.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_roleLable];
    }
    
    return _roleLable;
}

- (UIImageView*)getArrorView {
    if (_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithImage:PNGRESOURCE(@"common_icon_arrow@2x")];
        [self.contentView addSubview:_arrowImageView];
    }
    
    return _arrowImageView;
}

- (void)setCurrentCellType:(PersonalSettingCellType)t {
    _type = t;
    
    switch (_type) {
        case HeadViewType:
            self.headView.hidden = NO;
            self.nickTextFiled.hidden = YES;
            self.roleLable.hidden = YES;
            break;
        case NickNameType:
            self.headView.hidden = YES;
            self.nickTextFiled.hidden = NO;
            self.roleLable.hidden = YES;
            break;
        case RoleType:
            self.headView.hidden = YES;
            self.nickTextFiled.hidden = YES;
            self.roleLable.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLable.center = CGPointMake(CGRectGetWidth(self.titleLable.frame) / 2 + 10, CGRectGetHeight(self.frame) / 2);
    if (self.type == HeadViewType) {
        self.headView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.headView.frame) / 2 - 30, CGRectGetHeight(self.frame) / 2);
        self.headView.clipsToBounds = YES;
        self.headView.layer.cornerRadius = CGRectGetWidth(self.headView.frame) / 2;
    }
    self.nickTextFiled.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 150, CGRectGetHeight(self.frame));
//    [self.nickTextFiled sizeToFit];
    if (self.type == NickNameType) {
        self.nickTextFiled.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.nickTextFiled.frame) / 2 - 30 - 12, CGRectGetHeight(self.frame) / 2);
        self.cancelBtn.frame = CGRectMake(0, 0, 13, 13);
        self.cancelBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 25, 22);
    }
    [self.roleLable sizeToFit];
    
    if (self.type == RoleType) self.roleLable.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.roleLable.frame) / 2 - 30, CGRectGetHeight(self.frame) / 2);
    self.arrowImageView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.arrowImageView.frame) / 2 - 10, CGRectGetHeight(self.frame) / 2);
}

- (void)changeCellWithNickName:(NSString *)content {
    self.nickTextFiled.text = [Tools subStringWithByte:18 str:content];
}
- (void)changeCellWithImageName:(NSString *)photo_name {
    
    if (photo_name == nil || photo_name.length == 0) {
        return;
    }

    [self.headView setImage:IMGRESOURCE(@"default_user")];
   
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_local" forKey:@"expect_size"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [self.headView setImage:img];
        }
    }];
}

- (void)changeCellRoleRoleStr:(NSString *)roleStr {
    self.roleLable.text = roleStr;
}

- (void)changeCellRoleArr:(NSArray<NSString *> *)roleArr {
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cancelBtn.hidden = NO;
}

- (void)deleleNickName {
    self.nickTextFiled.text = @"";
}

- (void)hideCancel{
    [self.nickTextFiled resignFirstResponder];
    self.cancelBtn.hidden = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nickTextFiled resignFirstResponder];
    return NO;
}

- (void)textFieldChanged:(NSNotification *)noti {
    UITextField *textFile = (UITextField *)noti.object;
    NSString *toBeString = textFile.text;
    NSString *lang = textFile.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textFile markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textFile positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ([Tools bityWithStr:textFile.text] > 16) {
                textFile.text = [Tools subStringWithByte:16 str:toBeString];
            }
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 16) {
            textFile.text = [Tools subStringWithByte:16 str:textFile.text];
        }
    }
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"screenNameChanged:"];
    id args = toBeString;
    [cmd performWithResult:&args];
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYSelfSettingCellName, kAYSelfSettingCellName);
    
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

#pragma mark -- messages
- (id)setCellInfo:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
    
    AYSelfSettingCellView* cell = [dic objectForKey:kAYSelfSettingCellCellKey];
    
    [cell changeTitleWithArgs:dic];
    [cell changeCellWithImageName:[dic objectForKey:kAYSelfSettingCellScreenPhotoKey]];
    [cell changeCellWithNickName:[dic objectForKey:kAYSelfSettingCellScreenNameKey]];
    [cell changeCellRoleRoleStr:[dic objectForKey:kAYSelfSettingCellRoleTagKey]];
    cell.type = ((NSNumber*)[dic objectForKey:kAYSelfSettingCellTypeKey]).integerValue;
    [cell.arrowImageView sizeToFit];
   
    return nil;
}

- (id)queryCellHeight {
    return [NSNumber numberWithFloat:44.f];
}
@end
