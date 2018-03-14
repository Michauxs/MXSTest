//
//  AYHomeBannerCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeBannerCellView.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYHomeBannerItemCellView.h"
#import "AYHomeBannerFlowLayout.h"

#define TimeInterval 5
#define kBANNERCOUNT 4

@implementation AYHomeBannerCellView {
	UICollectionView *bannerCollectionView;
	NSMutableArray *imagesArray;
	UIPageControl *pageControl;
	
	NSArray *topCategArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

-(void)initView {
	
	imagesArray = [NSMutableArray array];
	for (int i = 0; i < kBANNERCOUNT; ++i) {
		UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"home_dongda_choice_%d", i]];
		[imagesArray addObject:img];
	}
	[imagesArray insertObject:imagesArray[imagesArray.count - 1] atIndex:0];
	[imagesArray insertObject:imagesArray[1] atIndex:imagesArray.count];
	
	[self setBackgroundColor:[UIColor clearColor]];
	
	CGSize cellSize = CGSizeMake(SCREEN_WIDTH, 160);
//	AYHomeBannerFlowLayout *flowLayout = [AYHomeBannerFlowLayout new];
	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
	flowLayout.itemSize  = cellSize;
	flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.minimumLineSpacing = 0;
	
	bannerCollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) collectionViewLayout:flowLayout];
	bannerCollectionView.delegate = self;
	bannerCollectionView.dataSource = self;
	bannerCollectionView.pagingEnabled = YES;
	bannerCollectionView.showsVerticalScrollIndicator = NO;
	bannerCollectionView.showsHorizontalScrollIndicator = NO;
//	bannerCollectionView.contentSize = cellSize;
	[bannerCollectionView setBackgroundColor:[UIColor clearColor]];
	[bannerCollectionView registerClass:NSClassFromString(@"AYHomeBannerItemCellView") forCellWithReuseIdentifier:@"AYHomeBannerItemCellView"];
	[self addSubview:bannerCollectionView];
	
	pageControl = [[UIPageControl alloc]init];
	pageControl.numberOfPages = imagesArray.count - 2;
	CGSize size = [pageControl sizeForNumberOfPages:imagesArray.count - 2];
	pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.75f alpha:0.5f];
	pageControl.currentPageIndicatorTintColor = [Tools garyColor];
	pageControl.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[self addSubview:pageControl];
	[pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self).offset(0);
		make.centerX.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(size.width, 10));
	}];
	
	[self setupCollectionView];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		self.timer = [NSTimer timerWithTimeInterval:TimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
		[self.timer fire];
		[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode]; //mainRunLoop
		
	});
	
}

-(void)nextPage:(NSTimer *)timer {
	
	int page = bannerCollectionView.contentOffset.x / bannerCollectionView.frame.size.width;
	page ++;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
	[bannerCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
	
}

//当用户开始拖拽的时候就调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self.timer invalidate];
}

//当用户停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	self.timer = [NSTimer timerWithTimeInterval:TimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];//mainRunLoop
	
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	int page = scrollView.contentOffset.x / scrollView.frame.size.width;
	
	if(page == imagesArray.count-1 && scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width - 30){
		//最后一张
		page = 0+1;
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
		[bannerCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
		
	}else if (page == 0 && scrollView.contentOffset.x <= 30){
		//第一张
		page = (int)imagesArray.count - 2;
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
		[bannerCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
	}
	
	pageControl.currentPage = page -1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return imagesArray.count ;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString  *bannerCellID = @"AYHomeBannerItemCellView";
	AYHomeBannerItemCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerCellID forIndexPath:indexPath];
	[cell setItemImageWithImage:[imagesArray objectAtIndex:indexPath.row]];
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = (indexPath.row - 1) % 4;
	NSLog(@"%ld", row);
//	NSNumber *index = [NSNumber numberWithInteger:row];
	NSString *categ = [topCategArr objectAtIndex:row];
	kAYViewSendNotify(self, @"didSomeOneChoiceClick:", &categ)
}

-(void)setupCollectionView {
	//有 无限轮播
	[bannerCollectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		topCategArr = @[@"艺术", @"运动", @"科学", @"看顾"];
		[self initView];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"HomeBannerCell", @"HomeBannerCell");
	
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
- (void)didLikeBtnClick {

}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
//	imagesArray = [args mutableCopy];
//	
//	[imagesArray insertObject:imagesArray[imagesArray.count-1] atIndex:0];
//	[imagesArray insertObject:imagesArray[0+1] atIndex:imagesArray.count];
	
	return nil;
}

@end
