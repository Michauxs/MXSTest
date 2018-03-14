//
//  AYServiceImagesCell.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceImagesCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

#import "AYImageItemCellView.h"

#import "AYOnceTipView.h"

@implementation AYSetServiceImagesCellView {
	UILabel *titleLabel;
	AYOnceTipView *tipView;
	
	UICollectionView *imagesCollectionView;
	NSArray *imagesData;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
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
//			make.top.equalTo(self).offset(8);
//			make.left.equalTo(self).offset(15);
//			make.right.equalTo(self).offset(-15);
//			make.bottom.equalTo(self).offset(-8);
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
		
		NSNumber *isHide = [[NSUserDefaults standardUserDefaults] objectForKey:@"dongda_oncetip_service_images"];
		if (!isHide.boolValue) {
			tipView = [[AYOnceTipView alloc] initWithTitle:@"首张图片将成为服务封面"];
			[self addSubview:tipView];
			[tipView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(titleLabel.mas_right).offset(5);
//				make.right.equalTo(radiusBGView).offset(-5);
				make.centerY.equalTo(titleLabel);
				make.height.equalTo(@26);
			}];
			[tipView.delBtn addTarget:self action:@selector(didOnceTipViewClick) forControlEvents:UIControlEventTouchUpInside];
		}
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		layout.itemSize = CGSizeMake(68, 68);
		layout.minimumLineSpacing = 10;
		layout.minimumInteritemSpacing = 10;
		
		imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
		[self addSubview:imagesCollectionView];
		[imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(radiusBGView).offset(15);
			make.top.equalTo(titleLabel.mas_bottom).offset(20);
			make.right.equalTo(radiusBGView.mas_right).offset(-15);
			make.bottom.equalTo(radiusBGView);
		}];
		imagesCollectionView.scrollEnabled = NO;
		imagesCollectionView.delegate = self;
		imagesCollectionView.dataSource = self;
		imagesCollectionView.backgroundColor = [UIColor clearColor];
		[imagesCollectionView registerClass:NSClassFromString(@"AYImageItemCellView") forCellWithReuseIdentifier:@"AYImageItemCellView"];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"SetServiceImagesCell", @"SetServiceImagesCell");
	
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
- (void)didOnceTipViewClick {
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"dongda_oncetip_service_images"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	tipView.hidden = YES;
}



- (id)setCellInfo:(id)args {
	NSString *title = [args objectForKey:@"title"];
	titleLabel.text = title;
	
	imagesData = [args objectForKey:kAYServiceArgsImages];
	[imagesCollectionView reloadData];
	return nil;
}


#pragma mark -- collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return imagesData.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *Identifier = @"AYImageItemCellView";
	AYImageItemCellView *item = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"index"];
		
	if (indexPath.row > 0) {
		[tmp setValue:[imagesData objectAtIndex:indexPath.row-1] forKey:@"image"];
	}
	item.itemInfo = [tmp copy];
	[item.delBtn addTarget:self action:@selector(didItemDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	return item;
}

- (void)didItemDelBtnClick:(UIButton*)btn {
	NSNumber *index = [NSNumber numberWithInteger:btn.tag-1];
	kAYViewSendNotify(self, @"deletedImageWithIndex:", &index)
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		kAYViewSendNotify(self, @"beginImagePicker", nil)
	}
}

@end
