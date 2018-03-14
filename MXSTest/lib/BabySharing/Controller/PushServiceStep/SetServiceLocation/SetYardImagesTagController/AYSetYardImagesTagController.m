//
//  AYSetYardImagesTagController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetYardImagesTagController.h"

#import "AYCourseSignView.h"
#import "AYOnceTipView.h"

@implementation AYSetYardImagesTagController {
	NSArray *imagesData;
	int pageIndex;
	
	AYOnceTipView *tipView;
	
	NSArray *tagArr;
	NSMutableArray *tagViewArr;
	AYCourseSignView *tmpTagView;
	
	NewPagedFlowView *pageFlowView;
	UILabel *pageCountLabel;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		imagesData = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:kAYServiceArgsYardImages];
		pageIndex = [[[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"index"] intValue];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"场地标签" textColor:[Tools black] fontSize:622.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(kStatusAndNavBarH+20);
		make.left.equalTo(self.view).offset(40);
	}];
	
	NSNumber *isHide = [[NSUserDefaults standardUserDefaults] objectForKey:@"dongda_oncetip_service_yard_images"];
	if (!isHide.boolValue) {
		tipView = [[AYOnceTipView alloc] initWithTitle:@"设置图片对应的区域"];
		[self.view addSubview:tipView];
		[tipView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel.mas_right).offset(5);
//			make.right.equalTo(self.view).offset(-5);
			make.centerY.equalTo(titleLabel);
			make.height.equalTo(@26);
		}];
		[tipView.delBtn addTarget:self action:@selector(didOnceTipViewClick) forControlEvents:UIControlEventTouchUpInside];
	}
	
	pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*144/667, SCREEN_WIDTH, 200)];
	pageFlowView.delegate = self;
	pageFlowView.dataSource = self;
	pageFlowView.minimumPageAlpha = 0.5;
	pageFlowView.isCarousel = NO;
	pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
	pageFlowView.isOpenAutoScroll = NO;
	
	//初始化pageControl
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, SCREEN_WIDTH, 8)];
	pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
	pageControl.currentPageIndicatorTintColor = [Tools theme];
	pageFlowView.pageControl = pageControl;
	pageFlowView.pageControl.hidden = YES;
	[pageFlowView addSubview:pageControl];
	[pageFlowView reloadData];
	
	[self.view addSubview:pageFlowView];
	[pageFlowView scrollToPage:pageIndex];
	
	pageCountLabel = [Tools creatLabelWithText:@"0/0" textColor:[Tools garyColor] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self.view addSubview:pageCountLabel];
	[pageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(pageFlowView.mas_bottom).offset(15);
		make.centerX.equalTo(self.view);
	}];
	pageCountLabel.text = [NSString stringWithFormat:@"%d/%d", pageIndex+1, (int)imagesData.count];
	
	tagViewArr = [NSMutableArray array];
	tagArr = kAY_service_options_yard_images_tag;
	int row = 0, col = 0;
	int colInRow = 3;
	CGFloat margin = 16;
	if (SCREEN_WIDTH < 375) {
		margin = 12;
	}
	CGFloat itemWith = (SCREEN_WIDTH - 80 - margin*(colInRow-1)) / colInRow;
	CGFloat itemHeight = 33;
	for (int i = 0; i < tagArr.count; ++i) {
		row = i / colInRow;
		col = i % colInRow;
		AYCourseSignView *signView = [[AYCourseSignView alloc] initWithFrame:CGRectMake(40+col*(margin+itemWith), SCREEN_HEIGHT*430/667 +row*(margin+itemHeight), itemWith, itemHeight) andTitle:[tagArr objectAtIndex:i]];
		[self.view addSubview:signView];
		signView.tag = i;
		signView.userInteractionEnabled = YES;
		[signView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagViewTap:)]];
		
		if ([[imagesData[pageIndex] objectForKey:kAYServiceArgsTag] isEqualToString:[tagArr objectAtIndex:i]]) {
			[signView setSelectStatus];
			tmpTagView = signView;
		}
		[tagViewArr addObject:signView];
	}
	
}

#pragma mark -- actios
- (void)didOnceTipViewClick {
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"dongda_oncetip_service_yard_images"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	tipView.hidden = YES;
}

- (void)didTagViewTap:(UITapGestureRecognizer*)tap {
	AYCourseSignView *tapView = (AYCourseSignView*)tap.view;
	if (tapView == tmpTagView) {
		return;
	}
	NSString *key = tapView.sign;
	NSInteger currentIndex= [pageFlowView currentPageIndex];
	[imagesData[currentIndex] setValue:key forKey:kAYServiceArgsTag];
	[imagesData[currentIndex] setValue:[NSNumber numberWithInt:(int)tapView.tag] forKey:@"tag_index"];
	
	[tapView setSelectStatus];
	[tmpTagView setUnselectStatus];
	tmpTagView = tapView;
	
	if ([self isAllTagDone]) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	}
}

- (BOOL)isAllTagDone {
	int count = 0;
	for (NSDictionary *info in imagesData) {
		if ([info objectForKey:kAYServiceArgsTag]) {
			count ++;
		}
	}
	return count >= imagesData.count;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:16.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
	return CGSizeMake(SCREEN_WIDTH - 80, 200);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
	NSLog(@"点击了第%d张图",(int)subIndex);
	
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
	NSLog(@"滚动到了第%d页", (int)pageNumber);
	NSString *tag = [imagesData[pageNumber] objectForKey:kAYServiceArgsTag];
	pageCountLabel.text = [NSString stringWithFormat:@"%d/%d", (int)pageNumber+1, (int)imagesData.count];
	
	[tmpTagView setUnselectStatus];
	if (tag.length != 0) {
		AYCourseSignView *currentView = [tagViewArr objectAtIndex:[[imagesData[pageNumber] objectForKey:@"tag_index"] integerValue]];
		[currentView setSelectStatus];
		tmpTagView = currentView;
	} else {
		tmpTagView = nil;
	}
	
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
	return imagesData.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
	PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
	if (!bannerView) {
		bannerView = [[PGIndexBannerSubiew alloc] init];
		bannerView.tag = index;
		bannerView.layer.cornerRadius = 4;
		bannerView.layer.masksToBounds = YES;
	}
	//在这里下载网络图片
	//	[bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
	
	id image = [imagesData[index] objectForKey:kAYServiceArgsPic];
	if ([image isKindOfClass:[NSString class]]) {
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *prefix = cmd.route;
		
		[bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, image]] placeholderImage:[UIImage imageNamed:@"default_image"] options:SDWebImageLowPriority];
	} else if ([image isKindOfClass:[UIImage class]]) {
		bannerView.mainImageView.image = image;
	}
	
	return bannerView;
}

#pragma mark -- notification
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_img_tag = [[NSMutableDictionary alloc] init];
	[dic_img_tag setValue:imagesData forKey:kAYServiceArgsYardImages];
	[dic setValue:dic_img_tag forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

@end
