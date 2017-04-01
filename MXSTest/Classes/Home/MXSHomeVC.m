//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"

@implementation MXSHomeVC {
	UITableView *FuncTableView;
	NSArray *titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [Tools whiteColor];
	
	titleArr = @[@"demo01", @"WebVictoryTest", @"Nuomi", @"WebPekingPeople", @"WebCityAround", @"WebScoialDragon", @"WebScoialPeking", @"TogetherBar", @"DoArt"];
	
	FuncTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 20) style:UITableViewStylePlain];
	[self.view addSubview:FuncTableView];
	FuncTableView.delegate = self;
	FuncTableView.dataSource = self;
	
}

- (id)WebVictoryTest {
	
	NSString *urlstring = @"http://bj.juesheng.com/shop/586840.html";
	NSString *htmlStr;
	htmlStr = [NodeHandle requestHtmlStringWith:urlstring];
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	HTMLNode *listNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"list" allowPartial:NO];
	
	return nil;
}

- (id)demo01 {
	NSString *urlstring = @"http://www.dianping.com/shop/66526819";
	
	NSString *htmlStr;
	htmlStr = [NodeHandle requestHtmlStringWith:urlstring];
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSArray *arrayNode = [bodyNode findChildrenOfClass:@"shop-title"];
	
	NSString *name = [[arrayNode firstObject] rawContents];
	name = [NodeHandle delHTMLTag:name];
	return nil;
}

- (void)didSelectedFunc:(NSString*)funcName {
	
	SEL sel = NSSelectorFromString(funcName);
	Method m = class_getInstanceMethod([self class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL, ...) = (id (*)(id, SEL, ...))imp;
		func(self, sel);
	}
	
}

#pragma mark -- UItableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellID = @"funcCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell) {
	 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	
	cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.f;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self didSelectedFunc:[titleArr objectAtIndex:indexPath.row]];
	
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	
//	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//	
//	UITouch *touch = [[touches allObjects] firstObject];
//	CGPoint centerP = [touch locationInView:[touch view]];
//	
//	NSString *title = @"You have a new message 002";
//	UILabel *tipsLabel = [Tools creatUILabelWithText:title andTextColor:[Tools themeColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:1];
//	[self.view addSubview:tipsLabel];
//	tipsLabel.bounds = CGRectMake(0, 0, 300, 30);
//	tipsLabel.center = centerP;
//	
//	MXSViewController *actVC = [self.tabBarController.viewControllers objectAtIndex:1];
//	actVC.tabBarItem.badgeValue = @"2";
//}

@end
