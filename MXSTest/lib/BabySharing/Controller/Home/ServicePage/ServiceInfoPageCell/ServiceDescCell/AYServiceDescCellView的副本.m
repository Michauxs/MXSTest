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
	
	UIImageView *olock_icon;
	UILabel *courseLengthLabel;
	UILabel *descLabel;
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
	
	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
	paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
	paraStyle.alignment = NSTextAlignmentLeft;
	paraStyle.lineSpacing = 8.f;
	
	dic_attr = @{ NSParagraphStyleAttributeName:paraStyle,
				  NSForegroundColorAttributeName:[UIColor gary],
				  NSFontAttributeName:[UIFont systemFontOfSize:16.f]
				  };
	
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.clipsToBounds = YES;
		
		tipsTitleLabel = [Tools creatUILabelWithText:@"服务介绍" andTextColor:[Tools lightGaryColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
		}];
		
		courseLengthLabel = [Tools creatUILabelWithText:@"Lection Length" andTextColor:[Tools themeColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[self addSubview:courseLengthLabel];
		[courseLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.centerY.equalTo(tipsTitleLabel);
		}];
		
		olock_icon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"lessondetails_icon_time")];
		[self addSubview:olock_icon];
		[olock_icon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(courseLengthLabel.mas_left).offset(-3);
			make.centerY.equalTo(courseLengthLabel);
			make.size.mas_equalTo(CGSizeMake(12, 12));
		}];
		
		descTextView = [[UITextView alloc] init];
		[self addSubview:descTextView];
		descTextView.textColor= [Tools blackColor];
		descTextView.font = [UIFont systemFontOfSize:15.f];
		descTextView.editable = NO;
		descTextView.scrollEnabled = NO;
		descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
		
		showhideBtn = [[UIButton alloc] init];
		[showhideBtn setImage:IMGRESOURCE(@"details_icon_arrow_down") forState:UIControlStateNormal];
		[showhideBtn setImage:IMGRESOURCE(@"details_icon_arrow_down") forState:UIControlStateSelected];
		[self addSubview:showhideBtn];
		[showhideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(descTextView.mas_bottom).offset(15);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(26, 26));
		}];
		[showhideBtn addTarget:self action:@selector(didShowhideBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- commands
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"ServiceDescCell", @"ServiceDescCell");
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

#pragma mark -- actions
-(CGFloat)getAttrStrHeight:(NSAttributedString*)str width:(CGFloat)width {
	
	CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin /*attributes:dic_attr*/ context:nil].size;
	return size.height;
}


- (void)didShowhideBtnClick {
	
	NSNumber *tmp = [NSNumber numberWithBool:showhideBtn.selected];
	kAYViewSendNotify(self, @"showHideDescDetail:", &tmp);
	
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
	descTextView.attributedText = descAttri;
	
	NSDictionary *info_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSDictionary *info_deatil = [service_info objectForKey:kAYServiceArgsDetailInfo];
	NSString *service_cat = [info_categ objectForKey:kAYServiceArgsCat];
	if([service_cat isEqualToString:kAYStringCourse]) {
		olock_icon.hidden = courseLengthLabel.hidden = NO;
		
		NSNumber *course_length = [info_deatil objectForKey:kAYServiceArgsCourseduration];
		NSString *lengthStr = [NSString stringWithFormat:@"%@分钟", course_length];
		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:lengthStr];
		[attributedText setAttributes:@{NSFontAttributeName:kAYFontMedium(18.f)} range:NSMakeRange(0, lengthStr.length - 2)];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} range:NSMakeRange(lengthStr.length - 2, 2)];
		courseLengthLabel.attributedText = attributedText;
		
	} else {
		olock_icon.hidden = courseLengthLabel.hidden = YES;
	}
		
	
	CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 40, CGFLOAT_MAX);
	CGSize newSize = [descTextView sizeThatFits:maxSize];
	NSNumber *expend_args = [service_info objectForKey:@"is_expend"];

	if (newSize.height < 130) {
		showhideBtn.hidden = YES;
		[descTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.left.equalTo(self).offset(16);
			make.right.equalTo(self).offset(-16);
			make.bottom.equalTo(self).offset(-30);
		}];
	} else {
		showhideBtn.hidden = NO;
		if (expend_args.boolValue) {
			showhideBtn.transform = CGAffineTransformMakeRotation(M_PI);
			[descTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
				make.left.equalTo(self).offset(16);
				make.right.equalTo(self).offset(-16);
				make.bottom.equalTo(self).offset(-60);
			}];
//			[self layoutIfNeeded];
		} else {
//			showhideBtn.transform = CGAffineTransformMakeRotation(M_PI);
			[descTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
				make.left.equalTo(self).offset(16);
				make.right.equalTo(self).offset(-16);
				make.bottom.equalTo(self).offset(-60);
				make.height.mas_equalTo(130);
			}];
//			[self layoutIfNeeded];
		}
	}
	
	return nil;
}

@end
