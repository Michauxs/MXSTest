//
//  MXSContentVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSContentVC.h"
#import <objc/runtime.h>

@implementation MXSContentVC {
	UITableView *FuncTableView;
	NSArray *titleArr;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [Tools whiteColor];
	
	titleArr = @[@"demo01", @"WebVictory", @"Nuomi", @"WebPekingPeople", @"WebCityAround", @"WebScoialDragon", @"WebScoialPeking", @"TogetherBar", @"DoArt"];
	
	FuncTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 20) style:UITableViewStylePlain];
	[self.view addSubview:FuncTableView];
	FuncTableView.delegate = self;
	FuncTableView.dataSource = self;
	
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


- (void)transPlistToJsonWith:(NSString*)fileName {
	
//	NSString *fullpath=[[NSBundle mainBundle] pathForResource:@"courses_art.plist" ofType:nil];
//	NSArray *array01=[NSArray arrayWithContentsOfFile:fullpath];
//	[NodeHandle writeToJsonFile:array01 withFileName:@"courses_art"];
//
//	fullpath=[[NSBundle mainBundle]pathForResource:@"courses_education.plist" ofType:nil];
//	NSArray *array02=[NSArray arrayWithContentsOfFile:fullpath];
//	[NodeHandle writeToJsonFile:array02 withFileName:@"courses_edu"];
//
//	fullpath=[[NSBundle mainBundle]pathForResource:@"courses_nursery.plist" ofType:nil];
//	NSArray *array03=[NSArray arrayWithContentsOfFile:fullpath];
//	[NodeHandle writeToJsonFile:array03 withFileName:@"courses_nur"];

//	NSString *urlstring = @"http://www.dianping.com/shop/66526819";
//	NSDictionary *dic = [NodeHandle handNodeWithServiceUrl:urlstring];
//
//	[NodeHandle writeToPlistFile:dic withFileName:@"oneNursery"];
	
	//1.1首先获取路径
	NSString *path = [[NSBundle mainBundle]pathForResource:@"city58.json" ofType:nil];
	//.读取文件内容
	NSData *data = [NSData dataWithContentsOfFile:path];
	//对其解析
	NSArray *array =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	
	for (NSDictionary *dic in array) {
		
		NSArray *arr = [dic valueForKey:@"arr"];
		
		for (NSMutableDictionary *dic_course in arr) {
			NSString *desc = [dic_course valueForKey:@"desc"];
			desc = [NodeHandle delHTMLTag:desc];
			desc = [desc stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
			[dic_course setValue:desc forKey:@"desc"];
		}
	}
	
	[NodeHandle writeToJsonFile:array withFileName:@"city58_v2"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
//	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	UITouch *touch = [[touches allObjects] firstObject];
	
	UIImageView *readView = [[UIImageView alloc] init];
	readView.image = IMGRESOURE(@"is_read");
	[self.view addSubview:readView];
	readView.bounds = CGRectMake(0, 0, 120, 120);
	readView.center = [touch locationInView:self.view];
	
	CASpringAnimation * ani = [CASpringAnimation animationWithKeyPath:@"bounds"];
	ani.mass = 10.0; //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
	ani.stiffness = 5000; //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
	ani.damping = 100.0;//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
	ani.initialVelocity = 5.f;//初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
	ani.duration = ani.settlingDuration;
	ani.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 60, 60)];
	ani.removedOnCompletion = NO;
	ani.fillMode = kCAFillModeForwards;
	ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[readView.layer addAnimation:ani forKey:@"boundsAni"];
	
	self.tabBarItem.badgeValue = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
