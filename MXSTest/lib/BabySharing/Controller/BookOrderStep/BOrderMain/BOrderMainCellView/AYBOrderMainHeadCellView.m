//
//  AYOrderInfoHeadCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderMainHeadCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#define kOwnerPhotoWH           50

@implementation AYBOrderMainHeadCellView {
    
    UIImageView *coverPhoto;
    UILabel *titleLabel;
    UILabel *priceLabel;
    
    NSDictionary *service_info;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
		
		coverPhoto = [[UIImageView alloc]init];
		coverPhoto.contentMode = UIViewContentModeScaleAspectFill;
		coverPhoto.image = IMGRESOURCE(@"default_image");
		coverPhoto.backgroundColor = [Tools garyBackgroundColor];
		[self addSubview:coverPhoto];
		[coverPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self);
			make.top.equalTo(self);
			make.width.mas_equalTo(126);
			make.height.equalTo(self);
		}];
		
        titleLabel = [Tools creatLabelWithText:@"Service Title" textColor:[Tools black] fontSize:316.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(15);
            make.right.lessThanOrEqualTo(coverPhoto.mas_left).offset(-30);
        }];
        
        priceLabel = [Tools creatLabelWithText:@"Service Price" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
            make.left.equalTo(titleLabel);
        }];
		
//		UIView *btmLine = [[UIView alloc] init];
//		btmLine.backgroundColor = [Tools garyLineColor];
//		[self addSubview:btmLine];
//		[btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.bottom.equalTo(self);
//			make.centerX.equalTo(self);
//			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
//		}];
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"BOrderMainHeadCell", @"BOrderMainHeadCell");
    
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
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args{
	service_info = args;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *prefix = cmd.route;
    NSString* photo_name = [[args objectForKey:@"images"] objectAtIndex:0];
	if (photo_name) {
		[coverPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photo_name]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	NSDictionary *data = [Tools montageServiceInfoWithServiceData:service_info];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@", [data objectForKey:kAYProfileArgsScreenName], [data objectForKey:@"montage"]];
	
	NSString *price = [data objectForKey:kAYServiceArgsPrice];
	int length = (int)price.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", price, [data objectForKey:@"unit"]];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName :[Tools theme]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(14.f), NSForegroundColorAttributeName :[Tools theme]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
    return nil;
}

@end
