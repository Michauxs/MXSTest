//
//  AYOrderPriceCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 14/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderPriceCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderPriceCellView {
    
    UILabel *priceLabel;
    
    UILabel *themeTitleLabel;
    UILabel *themePriceLabel;
    
    UILabel *isLeaveTitleLabel;
    UILabel *isLeavePriceLabel;
    
    UIButton *isShowDetail;
    
    NSDictionary *servicePrice;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [Tools creatLabelWithText:@"价格" textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(25);
            make.left.equalTo(self).offset(15);
        }];
		
        priceLabel = [Tools creatLabelWithText:@"￥ 000" textColor:[Tools black] fontSize:30.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(self).offset(-15);
        }];
		
        themeTitleLabel = [Tools creatLabelWithText:@"主题服务" textColor:[Tools garyColor] fontSize:15.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:themeTitleLabel];
        [themeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(45);
            make.left.equalTo(titleLabel);
        }];
		
        themePriceLabel = [Tools creatLabelWithText:@"￥ 00 × 0 Hour" textColor:[Tools garyColor] fontSize:15.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:themePriceLabel];
        [themePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(themeTitleLabel);
            make.right.equalTo(priceLabel);
        }];
        
//        UIView *sperator = [[UIView alloc]init];
//        sperator.backgroundColor = [Tools garyLineColor];
//        [self addSubview:sperator];
//        [sperator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(themeTitleLabel.mas_bottom).offset(20);
//            make.left.equalTo(self).offset(10);
//            make.right.equalTo(self).offset(-10);
//            make.height.mas_equalTo(0.5f);
//        }];
        
        isShowDetail = [[UIButton alloc]init];
        [isShowDetail setTitle:@"查看详情" forState:UIControlStateNormal];
        [isShowDetail setTitleColor:[Tools theme] forState:UIControlStateNormal];
        isShowDetail.titleLabel.font = kAYFontLight(15.f);
        isShowDetail.titleLabel.textAlignment = NSTextAlignmentRight;
        [isShowDetail sizeToFit];
        [self addSubview:isShowDetail];
        [isShowDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-3);
            make.right.equalTo(priceLabel);
            make.size.mas_equalTo(CGSizeMake(isShowDetail.bounds.size.width, isShowDetail.bounds.size.height));
        }];
        [isShowDetail addTarget:self action:@selector(didShowDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        CALayer *line_separator = [CALayer layer];
        line_separator.backgroundColor = [Tools garyLineColor].CGColor;
        line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
        [self.layer addSublayer:line_separator];
        
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
    id<AYViewBase> cell = VIEW(@"OrderPriceCell", @"OrderPriceCell");
    
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
- (void)didShowDetailClick:(UIButton*)btn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didShowDetailClick"];
    [cmd performWithResult:nil];
    
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"查看详情"]) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        
    } else if([title isEqualToString:@"收起"]) {
        [btn setTitle:@"查看详情" forState:UIControlStateNormal];
        
    }
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
    
    
    NSDictionary *dic_args = [args objectForKey:@"service"];
    NSNumber *unit_price = [dic_args objectForKey:@"price"];            //单价
    
    CGFloat sumPrice = 0;
    
//    BOOL isLeave = ((NSNumber*)[dic_args objectForKey:@"allow_leave"]).boolValue;
//    if (isLeave) {
//        isLeavePriceLabel.text = @"￥40";
//        sumPrice += 40;
//    }
    
    NSDictionary *dic_times = [args objectForKey:@"order_date"];
    double start = ((NSNumber*)[dic_times objectForKey:@"start"]).doubleValue * 0.001;
    double end = ((NSNumber*)[dic_times objectForKey:@"end"]).doubleValue * 0.001;
    
    NSDateFormatter *formatTimes = [[NSDateFormatter alloc] init];
    [formatTimes setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [formatTimes setTimeZone:timeZone];
    
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:start];
    NSString *startStr = [formatTimes stringFromDate:startTime];
    
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:end];
    NSString *endStr = [formatTimes stringFromDate:endTime];
    
    
    int startClock = [startStr substringToIndex:2].intValue;
    int endClock = [endStr substringToIndex:2].intValue;
    
    themePriceLabel.text = [NSString stringWithFormat:@"￥%.f×%d小时",unit_price.floatValue,(endClock - startClock)];
    
    sumPrice = sumPrice + unit_price.floatValue * (endClock - startClock);
    priceLabel.text = [NSString stringWithFormat:@"￥%.f",sumPrice];
    
    return nil;
}

@end
