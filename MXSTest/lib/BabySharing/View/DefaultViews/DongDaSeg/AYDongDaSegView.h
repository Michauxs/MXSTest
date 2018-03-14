//
//  AYDongDaSegView.h
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYDongDaSegView : UIView <AYViewBase>
@property (nonatomic, getter=getSegItems, readonly) NSArray* items;
@property (nonatomic, getter=getSegItemsCount, readonly) NSInteger count;
@property (nonatomic, getter=getSegSelectedIndex, setter=setSegSelectedIndex:) NSInteger selectedIndex;
//@property (nonatomic, weak) id<SearchSegViewDelegate> delegate;
@property (nonatomic, setter=setItemLayerHidden:) BOOL isLayerHidden;
@property (nonatomic, setter=resetFontSize:) CGFloat font_size;
@property (nonatomic, strong, setter=resetFontColor:) UIColor* font_color;
@property (nonatomic, strong, setter=resetSelectFontColor:) UIColor* select_font_color;

// view location property
@property (nonatomic) CGFloat margin_to_edge;
@property (nonatomic) CGFloat margin_between_items;


//- (instancetype)initWithFrame:(CGRect)frame theme:(Theme)theme;
- (NSString*)queryItemTitleAtIndex:(NSInteger)index;

- (void)refreshItemTitle:(NSString*)title atIndex:(NSInteger)index;

// title
- (void)addItemWithTitle:(NSString *)title andSubTitle:(NSString*)subTitle;
- (void)addItemWithTitle:(NSString *)title;
- (void)removeItemAtIndex:(NSInteger)index;

// img
- (void)addItemWithImg:(UIImage*)normal_img andSelectImage:(UIImage*)selected_img;

// title and img
- (void)addItemWithImg:(UIImage *)normal_img andSelectImage:(UIImage *)selected_img andTitle:(NSString*)title;

+ (CGFloat)preferredHeight;
+ (CGFloat)preferredHeightWithImgAndText;
@end

@interface AYDongDaSeg2View : AYDongDaSegView

@end