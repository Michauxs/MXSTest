//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"

@implementation MXSHomeVC {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *urlStr;
	
	//教育
//	NSString *categaryUrlStr = @"https://www.dianping.com/search/category/2/70/g188";
//	NSString *fileName = @"urlList_education";
	
	//	//托班
	NSString *categaryUrlStr = @"http://www.dianping.com/search/category/2/70/g20009";
	NSString *fileName = @"urlList_nursery";
	fileName = @"urlList_nap";
	
	//才艺
//	NSString *categaryUrlStr = @"http://www.dianping.com/search/category/2/70/g27763";
//	NSString *fileName = @"urlList_art";
	
	NSMutableArray *courseList = [NSMutableArray array];
	for (int i = 1; i < 11; ++i) {
		urlStr = [NSString stringWithFormat:@"%@p%d", categaryUrlStr, i];
		NSArray *subServArr_p = [NodeHandle handUrlListFromCategoryUrl:urlStr];
		[courseList addObjectsFromArray:subServArr_p];
	}
	
	[self writeToPlistFile:courseList withFileName:fileName];
	
	//待存入课程 arr
	NSMutableArray *coursesArr = [NSMutableArray array];
	
	for (NSDictionary *course in courseList) {
		NSString *course_href = [course valueForKey:@"href"];
		
		//课程参数 ：需mutable 追加参数
		NSMutableDictionary *course_args = [[NodeHandle handNodeWithServiceUrl:course_href] mutableCopy];
		NSArray *promoteArr = [course_args objectForKey:@"promotes"];
		
		if (promoteArr.count != 0) {	//没/有推荐课
			
			NSMutableArray *promoteCourseArgsArr = [NSMutableArray array];
			for (NSDictionary *promote in promoteArr) {
				NSString *promote_href = [promote objectForKey:@"promote_href"];
				NSDictionary *promote_course_args = [NodeHandle handNodeWithPromoteUrl:promote_href];
				[promoteCourseArgsArr addObject:promote_course_args];
			}
			
			[course_args setValue:promoteCourseArgsArr forKey:@"promotes_args"];
		} // end .count == 0 ?
		
		[coursesArr addObject:[course_args copy]];
		
	}
	
	[self writeToPlistFile:[coursesArr copy] withFileName:[NSString stringWithFormat:@"courses_%@", [[fileName componentsSeparatedByString:@"_"] lastObject]]];
	
}

- (void)writeToPlistFile:(id)info withFileName:(NSString*)fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
	[info writeToFile:filename atomically:YES];
	
}

/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	
}
/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
	
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
