//
//  AYServTimesBtn.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServTimesBtn.h"
#import "AYBOrderTimeDefines.h"

#define TitleFontSize		12.f

@implementation AYServTimesBtn {
	UILabel *topTitle;
	UILabel *btmtitle;
	
	UIView *normalBg;
	UIView *selectedBg;
}

- (instancetype)initWithOffsetX:(CGFloat)offsetX andTimesDic:(NSDictionary*)args {
	self = [super init];
	if (self) {
		
//		self.clipsToBounds = YES;
		
		NSNumber *top = [args objectForKey:kAYServiceArgsStart];
		NSNumber *btm = [args objectForKey:kAYServiceArgsEnd];
		
		CGFloat offsetY = itemUintHeight * (top.intValue / 100 - 6) + 40;
		CGFloat height =  itemUintHeight * (btm.intValue / 100 - top.intValue / 100);
		if (height == 0) {
			height = itemUintHeight;
		}
		self.frame = CGRectMake(offsetX, offsetY + AdjustFiltVertical, itemWidth, height);
		
		normalBg = [[UIView alloc]init];
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, itemWidth - 1, height) andColor:[Tools garyBackgroundColor] inSuperView:normalBg];
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, itemWidth - 1, 3) andColor:[Tools theme] inSuperView:normalBg];
		[self addSubview:normalBg];
		[normalBg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, -1));
		}];
		
		selectedBg = [[UIView alloc]init];
		[Tools creatCALayerWithFrame:CGRectMake(0, 0, itemWidth - 1, height) andColor:[Tools theme] inSuperView:selectedBg];
		[self addSubview:selectedBg];
		[selectedBg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(normalBg);
		}];
		
		// init status
		selectedBg.hidden = YES;
		normalBg.hidden = NO;
		selectedBg.userInteractionEnabled = normalBg.userInteractionEnabled = NO;
		
		NSMutableString *tmp = [NSMutableString stringWithFormat:@"%.4d", top.intValue];
		[tmp insertString:@":" atIndex:tmp.length - 2];
		
//		topTitle = [Tools creatUILabelWithText:[tmp stringByAppendingString:@"开始"] andTextColor:[Tools themeColor] andFontSize:TitleFontSize andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		topTitle = [Tools creatLabelWithText:tmp textColor:[Tools theme] fontSize:TitleFontSize backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:topTitle];
		[topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(3);
			make.left.equalTo(self).offset(2);
		}];
		
		tmp = [NSMutableString stringWithFormat:@"%.4d", btm.intValue];
		[tmp insertString:@":" atIndex:tmp.length - 2];
		
//		btmtitle = [Tools creatUILabelWithText:[tmp stringByAppendingString:@"结束"] andTextColor:[Tools themeColor] andFontSize:TitleFontSize andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		btmtitle = [Tools creatLabelWithText:tmp textColor:[Tools theme] fontSize:TitleFontSize backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:btmtitle];
		[btmtitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.left.equalTo(topTitle);
		}];
		
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		
		topTitle.textColor = btmtitle.textColor = [Tools whiteColor];
		selectedBg.hidden = NO;
		normalBg.hidden = YES;
	} else {
		
		topTitle.textColor = btmtitle.textColor = [Tools theme];
		selectedBg.hidden = YES;
		normalBg.hidden = NO;
	}
}

@end
