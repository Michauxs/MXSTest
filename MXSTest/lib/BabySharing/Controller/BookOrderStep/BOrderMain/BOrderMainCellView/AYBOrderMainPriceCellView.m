//
//  AYOrderInfoPriceCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderMainPriceCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYBOrderMainPriceCellView {
    
    UILabel *priceLabel;
	UILabel *unitPriceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UILabel *sumTitleLabel =  [Tools creatLabelWithText:@"总价" textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:sumTitleLabel];
		[sumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(self).offset(15);
		}];
		
		priceLabel =  [Tools creatLabelWithText:@"Total Price" textColor:[Tools theme] fontSize:317.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
		[self addSubview:priceLabel];
		[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(sumTitleLabel);
			make.right.equalTo(self).offset(-15);
		}];
		
		UILabel *priceTitleLabel =  [Tools creatLabelWithText:@"详情" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:priceTitleLabel];
		[priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self).offset(-15);
			make.left.equalTo(self).offset(15);
		}];
		
		unitPriceLabel =  [Tools creatLabelWithText:@"Unit Price" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
		[self addSubview:unitPriceLabel];
		[unitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(priceTitleLabel);
			make.right.equalTo(self).offset(-15);
		}];
		
		[Tools creatCALayerWithFrame:CGRectMake(15, 55, SCREEN_WIDTH - 30, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
        
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
    id<AYViewBase> cell = VIEW(@"BOrderMainPriceCell", @"BOrderMainPriceCell");
    
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

- (void)didShowDetailClick:(UIButton*)btn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didShowDetailClick"];
    [cmd performWithResult:nil];
    
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"查看详情"]) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        NSString *tmp = btn.titleLabel.text;
        NSLog(@"%@",tmp);
        
    } else if([title isEqualToString:@"收起"]){
//        [btn setImage:nil forState:UIControlStateNormal];
        [btn setTitle:@"查看详情" forState:UIControlStateNormal];
        
    }
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
	
	NSDictionary *service_info = [args objectForKey:kAYServiceArgsInfo];
	NSArray *order_times = [args objectForKey:@"order_times"];
	
	NSString *unitCat = @"UNIT";
	NSString *service_cat = [[service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	__block int count_times = 0;
	
	if ([service_cat isEqualToString:kAYStringNursery]) {
		
		unitCat = @"小时";
		[order_times enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			NSNumber *start = [obj objectForKey:kAYServiceArgsStart];
			NSNumber *end = [obj objectForKey:kAYServiceArgsEnd];
			
			double duration = end.doubleValue * 0.001 - start.doubleValue * 0.001 ;
			count_times += (duration / 60 / 60);
		}];
		
	} else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
		count_times = (int)order_times.count;
	} else {
		
	}
	
	NSNumber *price = [[service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%.f", price.floatValue * 0.01];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@ × %d", tmp, unitCat, count_times];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName :[Tools black]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(14.f), NSForegroundColorAttributeName :[Tools black]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	unitPriceLabel.attributedText = attributedText;
	
	CGFloat total_price = price.floatValue * 0.01 * count_times;
	priceLabel.text = [NSString stringWithFormat:@"¥%.f", total_price];
	
    return nil;
}

@end
