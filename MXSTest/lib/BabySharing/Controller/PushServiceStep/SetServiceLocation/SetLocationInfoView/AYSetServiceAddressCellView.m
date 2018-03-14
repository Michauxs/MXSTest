//
//  AYSetServiceAddressCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceAddressCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYSetServiceAddressCellView {
	UILabel *titleLabel;
	UILabel *addressLabel;
	
	UILabel *adjustLabel;
	UITextView *editAdjustTextView;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"SetServiceAddressCell", @"SetServiceAddressCell");
	
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.userInteractionEnabled = YES;
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewTapKeyBroad)]];
		
		UIView *shadowBGView = [[UIView alloc] init];
		shadowBGView.layer.cornerRadius = 4.f;
		shadowBGView.layer.shadowColor = [Tools garyColor].CGColor;
		shadowBGView.layer.shadowRadius = 4.f;
		shadowBGView.layer.shadowOpacity = 0.5f;
		shadowBGView.layer.shadowOffset = CGSizeMake(0, 0);
		shadowBGView.backgroundColor = [Tools whiteColor];
		[self addSubview:shadowBGView];
		[shadowBGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.self.insets(UIEdgeInsetsMake(8, 20, 8, 20));
		}];
		
		UIView *radiusBGView = [[UIView alloc] init];
		[self addSubview:radiusBGView];
		[radiusBGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(shadowBGView);
		}];
		[Tools setViewBorder:radiusBGView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
		
		titleLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(radiusBGView).offset(15);
			make.top.equalTo(radiusBGView).offset(12);
		}];
		
		addressLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(radiusBGView).offset(15);
			make.top.equalTo(titleLabel.mas_bottom).offset(20);
			make.right.equalTo(radiusBGView).offset(-15);
		}];
		addressLabel.userInteractionEnabled = YES;
		[addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddressLabelTap)]];
		
		UIImageView *accessView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"plan_time_icon")];
		[self addSubview:accessView];
		[accessView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(radiusBGView).offset(-15);
			make.centerY.equalTo(addressLabel);
			make.size.mas_equalTo(CGSizeMake(15, 15));
		}];
		
		UIView *lineView = [[UIView alloc] init];
		lineView.backgroundColor = [Tools garyLineColor];
		[radiusBGView addSubview:lineView];
		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(radiusBGView);
			make.right.equalTo(radiusBGView);
			make.top.equalTo(addressLabel.mas_bottom).offset(10);
			make.height.mas_equalTo(0.5);
		}];
		
		editAdjustTextView = [[UITextView alloc] init];
		[radiusBGView addSubview:editAdjustTextView];
		[editAdjustTextView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(lineView.mas_bottom).offset(15);
			make.left.equalTo(radiusBGView).offset(10);
			make.right.equalTo(radiusBGView).offset(-10);
//			make.height.mas_equalTo(54);55
		}];
		editAdjustTextView.font = [UIFont systemFontOfSize:15];
		editAdjustTextView.textColor = [Tools black];
		editAdjustTextView.scrollEnabled = NO;
		editAdjustTextView.delegate = self;
		editAdjustTextView.returnKeyType = UIReturnKeyDone;
//		[editAdjustTextView setContentInset:UIEdgeInsetsMake(-5, -3, -5, -3)];
//		[editAdjustTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
		
		adjustLabel = [Tools creatLabelWithText:@"请填写具体地址" textColor:[Tools garyColor] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:adjustLabel];
		[adjustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(editAdjustTextView).offset(5);
			make.top.equalTo(editAdjustTextView).offset(7);
			make.right.equalTo(radiusBGView).offset(-45);
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- textview delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	UITextView *mTextView = object;
	
	NSLog(@"the textView keypath:%@ -- change:%@", keyPath, mTextView.text);
}

- (void)textViewDidChange:(UITextView *)textView {	//52
	adjustLabel.hidden = textView.text.length != 0;
	
	id tmp = [textView.text copy];
	kAYViewSendNotify(self, @"adjustTextDidChange:", &tmp)
//	CGFloat textViewContentH = textView.contentSize.height;
//	if (textViewContentH > 54) {
//		textView.text = [textView.text substringToIndex:[textView.text length] - 1];
//	}
	//CGSize maxSize = CGSizeMake(inputView.bounds.size.width, CGFLOAT_MAX);
	//CGSize newSize = [inputView sizeThatFits:maxSize];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if (text.length != 0) {
		if([text isEqualToString:kAYStringLineFeed]) {
			[textView resignFirstResponder];
			return NO;
		} else {
			
			CGSize newsize = [Tools sizeWithString:[textView.text stringByAppendingString:text] withFont:textView.font andMaxSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT)];
			if (newsize.height > 52) {
				return NO;
			} else
				return YES;
		}
	}
	return YES;
}

#pragma mark -- actions
- (void)didViewTapKeyBroad {
	[editAdjustTextView resignFirstResponder];
}

- (id)setCellInfo:(id)args {
	NSString *title = [args objectForKey:@"title"];
	titleLabel.text = title;
	
	NSString *address = [args objectForKey:kAYServiceArgsAddress];
	if (address.length == 0) {
		address = @"场地地址";
		addressLabel.textColor = [Tools garyColor];
	}
	addressLabel.text = address;
	
	NSString *adjust = [args objectForKey:kAYServiceArgsAdjustAddress];
	if (adjust.length == 0) {
		adjustLabel.hidden = NO;
	} else {
		adjustLabel.hidden = YES;
		editAdjustTextView.text = adjust;
	}
	
	return nil;
}

- (void)didAddressLabelTap {
	kAYViewSendNotify(self, @"didAddressLabelTap", nil)
}

@end
