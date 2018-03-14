//
//  AYServiceDescCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceDescCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceDescCellView {
	
	UILabel *tipsTitleLabel;
	UILabel *descLabel;
	UIImageView *maskView;
	UILabel *TAGsLabel;
	UIButton *showhideBtn;
	
	NSDictionary *dic_attr;
	NSDictionary *service_info;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	
}


#pragma mark -- commands
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
		paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
		paraStyle.alignment = NSTextAlignmentLeft;
		paraStyle.minimumLineHeight = 22;
		
		dic_attr = @{
					 NSParagraphStyleAttributeName:paraStyle,
					 NSForegroundColorAttributeName:[UIColor black],
					 NSFontAttributeName:[UIFont systemFontOfSize:16.f]
					 };
		
		self.clipsToBounds = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		tipsTitleLabel = [UILabel creatLabelWithText:@"服务介绍" textColor:[UIColor black13] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.top.equalTo(self).offset(20);
		}];

//		descLabel = [UILabel creatLabelWithText:@"" textColor:[UIColor black] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		descLabel = [UILabel new];
		descLabel.numberOfLines = 0;
		[self addSubview:descLabel];
//		[descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(tipsTitleLabel);
//			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
//			make.bottom.equalTo(self).offset(0);
//		}];
		
		maskView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"mask_detail_desc")];
		[self addSubview:maskView];
		[maskView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(descLabel);
			make.left.equalTo(descLabel);
			make.right.equalTo(descLabel);
			make.height.mas_equalTo(19);
		}];
		maskView.hidden = YES;
		
		TAGsLabel = [UILabel creatLabelWithText:@"##" textColor:[UIColor gary166] fontSize:316.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:TAGsLabel];
		[TAGsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.centerY.equalTo(descLabel.mas_bottom).offset(30);
//			make.bottom.equalTo(self).offset(20);
		}];
		TAGsLabel.hidden = YES;
		
		showhideBtn = [UIButton creatBtnWithTitle:@"展开" titleColor:[UIColor gary166] fontSize:615 backgroundColor:nil];
//		[showhideBtn setTitle:@"展开" forState:UIControlStateNormal];
		[showhideBtn setTitle:@"收起" forState:UIControlStateSelected];
		[self addSubview:showhideBtn];
		[showhideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(tipsTitleLabel);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR+5);
			make.size.mas_equalTo(CGSizeMake(40, 40));
		}];
		[showhideBtn addTarget:self action:@selector(didShowhideBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			//			make.top.equalTo(userPhoto.mas_bottom).offset(30);
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
	}
	return self;
}


#pragma mark -- actions
-(CGFloat)getAttrStrHeight:(NSAttributedString*)str width:(CGFloat)width {
	
	CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//	CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:dic_attr context:nil].size;
	return size.height;
}

//-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
//	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//	//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//	/** 行高 */
//	paraStyle.lineSpacing = lineSpeace;
//	// NSKernAttributeName字体间距
//	NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//						  };
//	CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//	return size.height;
//}


- (void)didShowhideBtnClick {
	
	NSNumber *tmp = [NSNumber numberWithBool:showhideBtn.selected];
	[(AYViewController*)self.controller performAYSel:@"showHideDescDetail:" withResult:&tmp];
}

- (void)didOwnerPhotoClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"OneProfile");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

- (BOOL)isEmpty:(NSString *)str {
	
	if (!str || [str isEqualToString:@""]) {
		return YES;
	} else {
		//A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
//		NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//		NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_//|~＜＞$€^•'@#$%^&*()_+'/"""];
		NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" \n	"];
		//Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
		NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
		return [trimedString length] == 0;
	}
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	service_info = (NSDictionary*)args;
	
	NSString *descStr = [service_info objectForKey:kAYServiceArgsDescription];
	if ([self isEmpty:descStr]) {
		descStr = @"服务者还没来得及介绍服务，你可以通过沟通向他咨询。";
	}
	NSAttributedString *descAttri = [[NSAttributedString alloc] initWithString:descStr attributes:dic_attr];
	descLabel.attributedText = descAttri;
	
	CGFloat marginBtm = 20;
	NSString *album = [service_info objectForKey:kAYServiceArgsAlbum];
	if (album.length != 0) {
		marginBtm = 62;
//		NSString *tagStr = @"#";
//		for (NSString *tag in tags) {
//			if (tags.lastObject == tag) {
//				tagStr = [[tagStr stringByAppendingString:tag] stringByAppendingString:@"#"];
//			} else
//				tagStr = [[tagStr stringByAppendingString:tag] stringByAppendingString:@"# #"];
//		}
		album = [[@"#" stringByAppendingString:album] stringByAppendingString:@"#"];
//		NSAttributedString *tsgsAttri = [[NSAttributedString alloc] initWithString:album attributes:dic_attr];
//		TAGsLabel.attributedText = tsgsAttri;
		
		TAGsLabel.text = album;
		TAGsLabel.hidden = NO;
	}
	
	CGFloat textHeight = [self getAttrStrHeight:descAttri width:SCREEN_WIDTH - SERVICEPAGE_MARGIN_LR*2];
	NSNumber *expend_args = [service_info objectForKey:@"is_expend"];

	if (textHeight <= 88) {
		showhideBtn.hidden = YES;
		[descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
			make.bottom.equalTo(self).offset(- marginBtm);
		}];
	} else {
		showhideBtn.hidden = NO;
		if (expend_args.boolValue) {
			showhideBtn.selected = YES;
			[descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
				make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
				make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
				make.bottom.equalTo(self).offset(-marginBtm);
			}];
		} else {
			showhideBtn.selected = NO;
			maskView.hidden = NO;
			descLabel.numberOfLines = 4;
			[descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
				make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
				make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
				make.bottom.equalTo(self).offset(-marginBtm);
			}];
		}
	}
	
	return nil;
}

@end
