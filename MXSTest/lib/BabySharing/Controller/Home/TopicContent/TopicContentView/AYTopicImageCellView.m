//
//  AYTopicImageCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 16/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYTopicImageCellView.h"

@implementation AYTopicImageCellView {
	UIImageView *BGImgView;
	UILabel *titleLabel;
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
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		BGImgView = [[UIImageView alloc] init];
		[BGImgView setImageViewContentMode];
		[self addSubview:BGImgView];
		[BGImgView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.height.mas_equalTo(96);
			make.bottom.equalTo(self);
		}];
		
		titleLabel = [UILabel creatLabelWithText:@"Content" textColor:[UIColor white] fontSize:317 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		titleLabel.numberOfLines = 1;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(BGImgView);
		}];
	}
	return self;
}

#pragma mark -- actions
- (void)showHideLabelTap {
	
//	NSNumber *tmp = [NSNumber numberWithBool:showHideBtn.selected];
//	[(AYViewController*)self.controller performSel:@"showHideDetail:" withResult:&tmp];
	
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	NSString *album = [args objectForKey:kAYServiceArgsAlbum];
	NSInteger index = [kAY_home_album_titles indexOfObject:album];
	
	NSString *imgName = [NSString stringWithFormat:@"album_content_bg_%ld", index];
	BGImgView.image = [UIImage imageNamed:imgName];
	
	titleLabel.text = [kAY_home_album_titles_sub objectAtIndex:index];
	
	return nil;
}

@end
