//
//  MXSPageVC.m
//  MXSTest
//
//  Created by Sunfei on 2018/6/21.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSPageVC.h"

@interface MXSPageVC ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;

@end

@implementation MXSPageVC {
    UIButton *certainBtn;
}

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        for (int i = 1; i < 5; i++) {
            NSString *contentString = [[NSString alloc] initWithFormat:@"This is the page %d of content displayed using UIPageViewController", i];
            [arrayM addObject:contentString];
        }
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.NavBar.hidden = YES;
    
    // 设置UIPageViewController的配置项
    //    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    // UIPageViewControllerTransitionStyleScroll - 滚动 /UIPageViewControllerTransitionStylePageCurl
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
    MXSPageContentVC *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.bounds;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    certainBtn = [UIButton creatBtnWithTitle:@"ViewDone" titleColor:[UIColor theme] fontSize:314 backgroundColor:[UIColor white]];
    [self.view addSubview:certainBtn];
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUS_NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    certainBtn.hidden = YES;
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate
//返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(MXSPageContentVC *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序  不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
    
}

//返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(MXSPageContentVC *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    if (index == [self.pageContentArray count]-1) {
        certainBtn.hidden = NO;
    }
    
    index++;
    
    if (index == [self.pageContentArray count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController*)pageViewController {
//    return self.pageContentArray.count;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController*)pageViewController {
//    return 0;
//}


#pragma mark - 根据index得到对应的UIViewController
- (MXSPageContentVC *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    MXSPageContentVC *contentVC = [[MXSPageContentVC alloc] init];
    contentVC.content = [self.pageContentArray objectAtIndex:index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(MXSPageContentVC *)viewController {
    return [self.pageContentArray indexOfObject:viewController.content];
}

@end

