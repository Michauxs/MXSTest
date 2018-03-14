//
//  PersonInfoCell.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RoleLable.h"
#import "AYViewBase.h"

typedef NS_ENUM(NSInteger, PersonalSettingCellType) {
    //以下是枚举成员
    HeadViewType = 0,
    NickNameType = 1,
    RoleType = 2,
};

@interface AYSelfSettingCellView : UITableViewCell <UITextFieldDelegate, AYViewBase>

@property (nonatomic, strong, getter=getScreenNameContainer) UITextField *nickTextFiled;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong, getter=getHeadView) UIImageView *headView;
@property (nonatomic, strong, getter=getTitleLabel) UILabel *titleLable;;
@property (nonatomic, strong, getter=getRoleLabel) UILabel *roleLable;
@property (nonatomic, weak) NSArray<RoleLable *> *arr;
@property (nonatomic, setter=setCurrentCellType:) PersonalSettingCellType type;

@property (nonatomic, strong, getter=getArrorView) UIImageView *arrowImageView;


//- (instancetype)initWithCellType:(PersonalSettingCellType)cellType;

- (void)changeCellWithNickName:(NSString *)content;
- (void)changeCellWithImageName:(NSString *)imageName;
- (void)changeCellRoleArr:(NSArray<NSString *> *)roleArr;
- (void)changeCellRoleRoleStr:(NSString *)roleStr;

@end
