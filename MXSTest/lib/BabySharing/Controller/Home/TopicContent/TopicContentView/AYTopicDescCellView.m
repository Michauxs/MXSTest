//
//  AYTopicDescCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 16/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYTopicDescCellView.h"

@implementation AYTopicDescCellView {
	
	UILabel *contentLabel;
	UIButton *showHideBtn;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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

#pragma mark -- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
//		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		contentLabel = [Tools creatLabelWithText:@"Content" textColor:[UIColor white] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
//		contentLabel.numberOfLines = 3;
		contentLabel.numberOfLines = 0;
		[self addSubview:contentLabel];
		[contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(16);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self).offset(-29);
		}];
//		contentLabel.userInteractionEnabled = YES;
//		[contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideLabelTap)]];
//
//		showHideBtn = [UIButton creatBtnWithTitle:@"查看全部" titleColor:[UIColor colorWithWhite:1 alpha:0.6] fontSize:613 backgroundColor:nil];
//		[showHideBtn setTitle:@"收起" forState:UIControlStateSelected];
//		[showHideBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateSelected];
//		[showHideBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//		[self addSubview:showHideBtn];
//		[showHideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(contentLabel);
////			make.right.equalTo(contentLabel);
//			make.size.mas_equalTo(CGSizeMake(60, 13));
//			make.top.equalTo(contentLabel.mas_bottom).offset(4);
//			make.bottom.equalTo(self).offset(-24);
//		}];
//		[showHideBtn addTarget:self action:@selector(showHideLabelTap) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

#pragma mark -- actions
- (void)showHideLabelTap {
	
	NSNumber *tmp = [NSNumber numberWithBool:showHideBtn.selected];
	[(AYViewController*)self.controller performAYSel:@"showHideDetail:" withResult:&tmp];
	
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	NSString *album = [args objectForKey:kAYServiceArgsAlbum];
	NSString *countstr = [kAY_home_album_desc_dic objectForKey:album];
	//	NSDictionary *shadowAttr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f],NSForegroundColorAttributeName :[UIColor white],NSShadowAttributeName:sdw};
	
//	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//	paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//	paraStyle.alignment = NSTextAlignmentLeft;
//	paraStyle.minimumLineHeight = 22;
	
	NSDictionary *dic_attr = @{
							   //							   NSParagraphStyleAttributeName:paraStyle,
							   NSKernAttributeName:@(0.3),
							   NSForegroundColorAttributeName:[UIColor gary115],
							   NSFontAttributeName:[UIFont systemFontOfSize:14]
							   };

	NSString *montStr = @"Montessori";
	if ([countstr containsString:montStr]) {
		NSString *prefix = [[countstr componentsSeparatedByString:montStr] firstObject];
		
		NSDictionary *dic_attr_mont = @{NSKernAttributeName:@(0.3), NSForegroundColorAttributeName:[UIColor gary115], NSFontAttributeName:[UIFont systemFontOfSize:13] };
		
		NSMutableAttributedString *albumAttrStr = [[NSMutableAttributedString alloc] initWithString:countstr];
		[albumAttrStr setAttributes:dic_attr_mont range:NSMakeRange(prefix.length, montStr.length)];
		[albumAttrStr setAttributes:dic_attr range:NSMakeRange(0, prefix.length)];
		[albumAttrStr setAttributes:dic_attr range:NSMakeRange(prefix.length+montStr.length, countstr.length-(prefix.length+montStr.length))];
		contentLabel.attributedText = albumAttrStr;
	} else {
		
		NSAttributedString *countAttrStr = [[NSAttributedString alloc] initWithString:countstr attributes:dic_attr];
		contentLabel.attributedText = countAttrStr;
	}
	
	
//	BOOL isExpend = [[args objectForKey:@"is_expend"] boolValue];
//	if (isExpend) {
//		contentLabel.numberOfLines = 0;
//		showHideBtn.selected = YES;
//	} else {
//		contentLabel.numberOfLines = 3;
//		showHideBtn.selected = NO;
//	}
	
	return nil;
}

@end
