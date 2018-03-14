//
//  DongDaTabBar.m
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "DongDaTabBar.h"
#import "DongDaTabBarItem.h"

@implementation DongDaTabBar {
//    NSMutableArray* btns;
    CALayer* selected_layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize items = _items;
@synthesize count = _count;
@synthesize selectIndex = _selectIndex;

- (id)initWithBar:(UITabBarController*)bar {
    self = [super init];
    if (self) {
        self.tag = -99;
        _bar = bar;
        
        CGFloat height = 49;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        self.backgroundColor = [UIColor whiteColor];
    
        [bar.tabBar addSubview:self];
        [bar.tabBar bringSubviewToFront:self];
        
        CALayer* shadow = [CALayer layer];
        shadow.borderColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25].CGColor;
        shadow.borderWidth = 1.f;
        shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        [self.layer addSublayer:shadow];
        
        bar.delegate = self;
    }
    return self;
}

- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg {
    DongDaTabBarItem* item = [[DongDaTabBarItem alloc]initWithImage:image andSelectImage:selectedImg];
    item.tag = self.count;
    [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    if (item.tag == 0) {
        [item setSelected:YES];
    }
    
    [self addSubview:item];
}

- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg andTitle:(NSString*)title {
    
    DongDaTabBarItem* item = [[DongDaTabBarItem alloc]initWithImage:image andSelectImage:selectedImg andTitle:title];
    item.tag = self.count;
    [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    if (item.tag == 0) {
        [item setSelected:YES];
    }

    [self addSubview:item];
}

- (void)addMidItemWithImg:(UIImage*)image {
    DongDaTabBarItem* item = [[DongDaTabBarItem alloc] initWithMidImage:image];
    item.tag = self.count;
    [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 49;
    CGFloat step = width / self.count;
   
    for (int index = 0; index < self.count; ++index) {
        UIButton* tmp = (UIButton*)[self viewWithTag:index];
        if (index == 1) {
            tmp.frame = CGRectMake(index * step , 0, step, height);
        } else if (index == 3) {
            tmp.frame = CGRectMake(index * step , 0, step, height);
        } else {
            tmp.frame = CGRectMake(index * step, 0, step, height);
        }
//        tmp.frame = CGRectMake(index * step, index == 2 ? -8 : 0 , step, height);
        if ([tmp isSelected]) {
            selected_layer.position = CGPointMake(tmp.center.x, 5);
        }
    }
}

- (NSArray*)getTabBarItems {
    return self.subviews;
}

- (NSInteger)getTabBarItemCount {
    return self.subviews.count;
}

- (void)itemSelected:(UIButton*)sender {
    NSInteger index = sender.tag;
    _selectIndex = index;
    _bar.selectedIndex = index;
    
    for (UIButton* iter in self.subviews) {
        [iter setSelected:NO];
    }
    [sender setSelected:YES];
}

- (void)changeItemImage:(UIImage*)img andIndex:(NSInteger)index {
    DongDaTabBarItem* btn = (DongDaTabBarItem*)[self viewWithTag:index];
    if (btn.img != img) {
        btn.img = img;
    }
}

#pragma mark -- tabbar controller delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {

    UIButton* btn = [self viewWithTag:_selectIndex];
    for (UIButton* iter in self.subviews) {
        [iter setSelected:NO];
    }
    [btn setSelected:YES];
    return nil;
}
@end
