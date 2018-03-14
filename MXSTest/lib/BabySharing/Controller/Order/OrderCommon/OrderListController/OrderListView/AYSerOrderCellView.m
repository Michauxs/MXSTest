//
//  AYSerPaidOrderCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 24/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSerOrderCellView.h"
#import "AYControllerActionDefines.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYSerOrderCellView {
    UIImageView *pushUserImageview;
    UILabel *orderDateLabel;
    UILabel *detailInfoLabel;
    
    UIImageView *signIsReaden;
    UILabel *countTimeOrStatesLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        pushUserImageview = [[UIImageView alloc]init];
        pushUserImageview.layer.cornerRadius = 30.f;
        pushUserImageview.clipsToBounds = YES;
        pushUserImageview.layer.rasterizationScale = [UIScreen mainScreen].scale;
        pushUserImageview.layer.borderColor = [Tools borderAlphaColor].CGColor;
        pushUserImageview.layer.borderWidth = 2.f;
        [self addSubview:pushUserImageview];
        [pushUserImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        orderDateLabel = [Tools creatLabelWithText:@"" textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:orderDateLabel];
        [orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pushUserImageview);
            make.left.equalTo(pushUserImageview.mas_right).offset(15);
        }];
        
        detailInfoLabel = [Tools creatLabelWithText:@"" textColor:[Tools black] fontSize:15.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        detailInfoLabel.numberOfLines = 2;
        [self addSubview:detailInfoLabel];
        [detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderDateLabel.mas_bottom).offset(8);
            make.left.equalTo(orderDateLabel);
            make.right.equalTo(self).offset(-85);
        }];
        
        signIsReaden = [[UIImageView alloc]init];
        signIsReaden.image = IMGRESOURCE(@"");
        [self addSubview:signIsReaden];
        [signIsReaden mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        countTimeOrStatesLabel = [Tools creatLabelWithText:@"" textColor:[Tools garyColor] fontSize:15.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
        [self addSubview:countTimeOrStatesLabel];
        [countTimeOrStatesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
        
        CALayer *btm_seprtor = [CALayer layer];
        CGFloat margin = 0;
        btm_seprtor.frame = CGRectMake(margin, 120- 0.5, SCREEN_WIDTH - margin * 2, 0.5);
        btm_seprtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:btm_seprtor];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SerOrderCell", @"SerOrderCell");
    
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


#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    NSDictionary *cell_info = (NSDictionary*)args;
    NSString *photo_name = [cell_info objectForKey:@"screen_photo"];
    if (photo_name) {
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        NSString *pre = cmd.route;
        [pushUserImageview sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
                             placeholderImage:IMGRESOURCE(@"default_user")];
    }
    
    detailInfoLabel.text = [[[cell_info objectForKey:@"screen_name"] stringByAppendingString:@" · "] stringByAppendingString:[[args objectForKey:@"service"] objectForKey:@"title"]];
    
//    NSTimeInterval book = ((NSNumber*)[args objectForKey:@"date"]).longValue * 0.001;
//    NSDate *bookDate = [NSDate dateWithTimeIntervalSince1970:book];
//    NSDateFormatter *formatterBookDay = [[NSDateFormatter alloc]init];
//    [formatterBookDay setDateFormat:@"yyyy年MM月dd日"];
//    NSString *bookStr = [formatterBookDay stringFromDate:bookDate];
//    _dateLabel.text = bookStr;
    
    /*******************/
    
    NSDictionary *order_date = [args objectForKey:@"order_date"];
    NSTimeInterval start = ((NSNumber*)[order_date objectForKey:@"start"]).longValue;
    NSTimeInterval end = ((NSNumber*)[order_date objectForKey:@"end"]).longValue;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start * 0.001];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end * 0.001];
    
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc]init];
    [formatterDay setDateFormat:@"MM月dd日"];
    NSString *dayStr = [formatterDay stringFromDate:startDate];
    
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"HH:mm"];
    NSString *startStr = [formatterTime stringFromDate:startDate];
    NSString *endStr = [formatterTime stringFromDate:endDate];
    
    orderDateLabel.text = [NSString stringWithFormat:@"%@, %@ - %@",dayStr,startStr,endStr];
    
    OrderStatus OrderStatus = ((NSNumber*)[args objectForKey:@"status"]).intValue;
    switch (OrderStatus) {
        case OrderStatusReady:
        {
            signIsReaden.hidden = YES;
            countTimeOrStatesLabel.hidden = NO;
            countTimeOrStatesLabel.text = @"待支付";
        }
            break;
        case OrderStatusConfirm:
        {
            signIsReaden.hidden = YES;
            countTimeOrStatesLabel.hidden = NO;
            countTimeOrStatesLabel.text = [Tools compareFutureTime:startDate];
        }
            break;
        case OrderStatusPaid:
        {
            signIsReaden.hidden = NO;
            signIsReaden.image = IMGRESOURCE(@"icon_badge_red");
            countTimeOrStatesLabel.hidden = YES;
        }
            break;
        case OrderStatusDone:
        {
            signIsReaden.hidden = YES;
            countTimeOrStatesLabel.hidden = NO;
            countTimeOrStatesLabel.text = @"已完成";
        }
            break;
        case OrderStatusReject:
        {
            signIsReaden.hidden = YES;
            countTimeOrStatesLabel.hidden = NO;
            countTimeOrStatesLabel.text = @"已拒绝";
        }
            break;
        default:
            signIsReaden.hidden = YES;
            countTimeOrStatesLabel.hidden = NO;
            countTimeOrStatesLabel.text = @"系统错误";
            break;
    }
    
    return nil;
}

@end
