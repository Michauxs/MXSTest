//
//  DongDaTabBar.h
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongDaTabBar : UIView <UITabBarDelegate, UITabBarControllerDelegate>

@property (nonatomic, readonly, getter=getTabBarItems) NSArray* items;
@property (nonatomic, readonly, getter=getTabBarItemCount) NSInteger count;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, weak) UITabBarController* bar;

- (id)initWithBar:(UITabBarController*)bar;
- (void)addMidItemWithImg:(UIImage*)image;
- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg;
- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg andTitle:(NSString*)title;
- (void)itemSelected:(UIButton*)sender;

- (void)changeItemImage:(UIImage*)img andIndex:(NSInteger)index;
@end
