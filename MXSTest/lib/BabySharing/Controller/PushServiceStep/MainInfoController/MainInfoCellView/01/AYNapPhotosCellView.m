//
//  AYNapPhotosCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapPhotosCellView.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@implementation AYNapPhotosCellView {
    NSString *title;
    NSString *content;
    
    UIButton *addPhotoBtn;
    UILabel *subTitleLabel;
    UIButton *optionBtn;
    UIImageView *photoCover;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        addPhotoBtn = [Tools creatBtnWithTitle:@"添加照片" titleColor:[Tools theme] fontSize:620.f backgroundColor:nil];
        addPhotoBtn.userInteractionEnabled = NO;
        [self addSubview:addPhotoBtn];
        [addPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_centerY).offset(-5);
			make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
//        [addPhotoBtn addTarget:self action:@selector(addPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
//        subTitleLabel = [Tools creatUILabelWithText:@"分享您和孩子之间的故事更打动人" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
//        [self addSubview:subTitleLabel];
//        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(addPhotoBtn);
//            make.top.equalTo(self.mas_centerY).offset(5);
//        }];
		
        photoCover = [[UIImageView alloc]init];
        [self addSubview:photoCover];
        [photoCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        photoCover.hidden = YES;
        photoCover.contentMode = UIViewContentModeScaleAspectFill;
        photoCover.clipsToBounds = YES;
        
//        photoCover.userInteractionEnabled = YES;
//        [photoCover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPhoto:)]];
        
        self.backgroundColor = [Tools garyBackgroundColor];
        
        optionBtn = [[UIButton alloc]init];
        [self addSubview:optionBtn];
        [self bringSubviewToFront:optionBtn];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick"] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick_selected"] forState:UIControlStateSelected];
        [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-20);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        optionBtn.selected = NO;
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"NapPhotosCell", @"NapPhotosCell");
    
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
- (void)editPhoto:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"addPhotosAction"];
    [cmd performWithResult:nil];
}

- (void)addPhotoBtnClick {
    id<AYCommand> cmd = [self.notifies objectForKey:@"addPhotosAction"];
    [cmd performWithResult:nil];
}

- (id)setCellInfo:(id)args {
    
    photoCover.hidden = NO;
    optionBtn.selected = YES;
    
    if ([args isKindOfClass:[UIImage class]]) {
        photoCover.image = (UIImage*)args;
        
    } else if ([args isKindOfClass:[NSString class]]) {
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *prefix = cmd.route;
		
		NSString* photo_name = (NSString*)args;
		if (photo_name) {
			[photoCover sd_setImageWithURL:[NSURL URLWithString:[prefix stringByAppendingString:photo_name]] placeholderImage:IMGRESOURCE(@"default_image")];
		}
        
    }
    
    addPhotoBtn.hidden = YES;
    subTitleLabel.hidden = YES;
    return nil;
}
@end
