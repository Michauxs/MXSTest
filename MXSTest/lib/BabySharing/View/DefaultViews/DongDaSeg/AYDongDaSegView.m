//
//  AYDongDaSegView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDongDaSegView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "SearchSegImgItem.h"
#import "SearchSegItem.h"
#import "SearchSegImgTextItem.h"
#import "SearchSegTextTextItem.h"
#import "AYDongDaSegDefines.h"

@implementation AYDongDaSegView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize items = _items;
@synthesize count = _count;
@synthesize selectedIndex = _selectedIndex;
//@synthesize delegate = _delegate;

@synthesize margin_to_edge = _margin_to_edge;
@synthesize margin_between_items = _margin_between_items;
@synthesize isLayerHidden = _isLayerHidden;

@synthesize font_size = _font_size;
@synthesize font_color = _font_color;
@synthesize select_font_color = _select_font_color;

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

#pragma mark -- life cycle
- (id)init {
    self = [super init];
    if (self) {
        self.tag = -99;
//        self.theme = Light;
        self.font_color = [Tools black];
        self.select_font_color = [Tools theme];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -99;
//        self.theme = Light;
        self.font_color = [Tools black];
        self.select_font_color = [Tools theme];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame theme:(Theme)theme {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.tag = -99;
////        self.theme = theme;
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tag = -99;
        self.font_color = [Tools black];
        self.select_font_color = [Tools theme];
    }
    return self;
}


- (NSArray*)getSegItems {
    return self.subviews;
}

- (NSInteger)getSegItemsCount {
    return self.subviews.count;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGSize sz = [SearchSegItem preferredSize];
    CGFloat step = sz.width;
    
    CGFloat content_width = [self getSegItemsCount] * step + ([self getSegItemsCount] - 1) * _margin_between_items;
    _margin_to_edge = (width - content_width) / 2;
    
    for (UIView* iter in [self getSegItems]) {
        NSInteger index = iter.tag - 1;
        iter.frame = CGRectMake(_margin_to_edge + step * index + _margin_between_items * index, 0, step, height);
    }
}

- (NSInteger)getSegSelectedIndex {
    for (SearchSegItem* iter in [self getSegItems]) {
        if (iter.status == 1)
            return iter.tag - 1;
    }
    
    return -1;
}

- (void)setSegSelectedIndex:(NSInteger)i {
    SearchSegItem* tmp = [self viewWithTag:i + 1];
    
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
}
//resetSegSelectedIndex
- (void)resetSegSelectedIndex:(NSInteger)i {
    SearchSegItem* tmp = [self viewWithTag:i + 1];
    
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
}

- (void)setItemLayerHidden:(BOOL)h {
    _isLayerHidden = h;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.isLayerHidden = h;
    }
}

- (void)resetFontSize:(CGFloat)font_size {
    _font_size = font_size;;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.font_size = _font_size;
    }
}

- (void)resetFontColor:(UIColor *)font_color {
    _font_color = font_color;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.font_color = _font_color;
    }
}

- (void)resetSelectFontColor:(UIColor *)select_font_color {
    _select_font_color = select_font_color;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.select_font_color = _select_font_color;
    }
}

- (NSString*)queryItemTitleAtIndex:(NSInteger)i {
    SearchSegItem* tmp = [self viewWithTag:i + 1];
    return tmp.title;
}

- (void)refreshItemTitle:(NSString*)title atIndex:(NSInteger)index {
    id item = [self viewWithTag:index + 1];
    if ([item isKindOfClass:[SearchSegTextTextItem class]]) {
        ((SearchSegTextTextItem*)item).title = title;
        
    } else if ([item isKindOfClass:[SearchSegImgTextItem class]] || [item isKindOfClass:[SearchSegItem class]]) {
        
    }
}

- (void)addItemWithTitle:(NSString *)title andSubTitle:(NSString*)subTitle {
    CGSize sz = [SearchSegTextTextItem preferredSize];
    SearchSegTextTextItem* item = [[SearchSegTextTextItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    item.title = title;
    item.subTitle = subTitle;
    item.status = 0;
    item.tag = [self getSegItemsCount] + 1;
    item.isLayerHidden = _isLayerHidden;
    item.select_font_color = _select_font_color;
    item.font_color = _font_color;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segTextTextSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)addItemWithTitle:(NSString *)title {
    CGSize sz = [SearchSegItem preferredSize];
    SearchSegItem* item = [[SearchSegItem alloc] initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    item.title = title;
    item.status = 0;
    item.tag = [self getSegItemsCount] + 1;
    item.isLayerHidden = _isLayerHidden;
    item.select_font_color = _select_font_color;
    item.font_color = _font_color;
    //    item.font_color = TextColor;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)addItemWithImg:(UIImage*)normal_img andSelectImage:(UIImage*)selected_img {
    CGSize sz = [SearchSegImgItem preferredSize];
    SearchSegImgItem* item = [[SearchSegImgItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    
    //    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    //    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    //    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"found-tab-layer" ofType:@"png"]];
    
    item.tag = [self getSegItemsCount] + 1;
    item.normal_img = normal_img;
    item.selected_img = selected_img;
    item.status = 0;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segImgSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)addItemWithImg:(UIImage *)normal_img andSelectImage:(UIImage *)selected_img andTitle:(NSString *)title {
    
    CGSize sz = [SearchSegImgTextItem preferredSize];
    SearchSegImgTextItem* item = [[SearchSegImgTextItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    
    item.tag = [self getSegItemsCount] + 1;
    item.normal_img = normal_img;
    item.selected_img = selected_img;
    item.title = title;
    item.isLayerHidden = _isLayerHidden;
    item.status = 0;
    item.select_font_color = _select_font_color;
    item.font_color = _font_color;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segImgTextSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)segSelected:(UITapGestureRecognizer*)gesture {
    SearchSegItem* tmp = (SearchSegItem*)gesture.view;
    //    if (tmp.status != 1) {
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
   
    id<AYCommand> n = [self.notifies objectForKey:@"segValueChanged:"];
    id args = self;
    [n performWithResult:&args];
}

- (void)segImgSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegImgItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    id<AYCommand> n = [self.notifies objectForKey:@"segValueChanged:"];
    id args = self;
    [n performWithResult:&args];
}

- (void)segImgTextSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegImgTextItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    id<AYCommand> n = [self.notifies objectForKey:@"segValueChanged:"];
    id args = self;
    [n performWithResult:&args];
}

- (void)segTextTextSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegTextTextItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    id<AYCommand> n = [self.notifies objectForKey:@"segValueChanged:"];
    id args = self;
    [n performWithResult:&args];
}

- (void)removeItemAtIndex:(NSInteger)index {
    
}

+ (CGFloat)preferredHeight {
    return 44;
}

+ (CGFloat)preferredHeightWithImgAndText {
    return 70;
}

//- (void)setTheme:(Theme)theme {
//    _theme = theme;
//    switch (_theme) {
//        case Dark:
//            self.font_color = Background;
//            self.select_font_color = [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
//            break;
//        case Light:
//            self.font_color = TextColor;
//            self.select_font_color = [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
//            break;
//        default:
//            break;
//    }
//}

#pragma mark -- commands
- (id)setSegInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    
    for (NSString* key in dic.allKeys) {
        if ([key isEqualToString:kAYSegViewMarginToEdgeKey]) {
            self.margin_to_edge = ((NSNumber*)[dic objectForKey:key]).floatValue;
        }
		else if ([key isEqualToString:kAYSegViewMarginBetweenKey]) {
            self.margin_between_items = ((NSNumber*)[dic objectForKey:key]).floatValue;
        }
		else if ([key isEqualToString:kAYSegViewNormalFontColorKey]) {
            self.font_color = (UIColor*)[dic objectForKey:key];
        }
		else if ([key isEqualToString:kAYSegViewSelectedFontColorKey]) {
            self.select_font_color = (UIColor*)[dic objectForKey:key];
        }
		else if ([key isEqualToString:kAYSegViewLineHiddenKey]) {
            self.isLayerHidden = ((NSNumber*)[dic objectForKey:key]).boolValue;
        }
		else if ([key isEqualToString:kAYSegViewBackgroundColorKey]) {
            self.backgroundColor = (UIColor*)[dic objectForKey:key];
        }
		else if ([key isEqualToString:kAYSegViewCornerRadiusKey]) {
            self.layer.cornerRadius = ((NSNumber*)[dic objectForKey:key]).floatValue;
        }
		else if ([key isEqualToString:kAYSegViewCurrentSelectKey]) {
            self.selectedIndex = ((NSNumber*)[dic objectForKey:key]).intValue;
        }
		else if ([key isEqualToString:kAYSegViewSelectedFontSizeKey]) {
            self.font_size = ((NSNumber*)[dic objectForKey:key]).floatValue;
        }
    }
    return nil;
}

- (id)addItem:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
  
    AYSegViewItemType type = ((NSNumber*)[dic objectForKey:kAYSegViewItemTypeKey]).intValue;
    switch (type) {
        case AYSegViewItemTypeTitle: {
                NSString* title = [dic objectForKey:kAYSegViewTitleKey];
                [self addItemWithTitle:title];
            }
            break;
        case AYSegViewItemTypeTitleWithSubTitle: {
                NSString* title = [dic objectForKey:kAYSegViewTitleKey];
                NSString* subTitle = [dic objectForKey:kAYSegViewSubTitleKey];
                [self addItemWithTitle:title andSubTitle:subTitle];
            }
            break;
        case AYSegViewItemTypeTitleWithImage: {
                NSString* title = [dic objectForKey:kAYSegViewTitleKey];
                UIImage* img = [dic objectForKey:kAYSegViewNormalImageKey];
                UIImage* img_select = [dic objectForKey:kAYSegViewSelectedImageKey];
                [self addItemWithImg:img andSelectImage:img_select andTitle:title];
            }
            break;
        case AYSegViewItemTypeImage : {
                UIImage* img = [dic objectForKey:kAYSegViewNormalImageKey];
                UIImage* img_select = [dic objectForKey:kAYSegViewSelectedImageKey];
                [self addItemWithImg:img andSelectImage:img_select];
            }
            break;
        default:
            break;
    }
    
    return nil;
}

- (id)removeItem:(id)args {
    int index = ((NSNumber*)args).intValue;
    [self removeItemAtIndex:index];
    return nil;
}

- (id)queryPerferedHeight {
    return [NSNumber numberWithFloat:[AYDongDaSegView preferredHeight]];
}

- (id)queryPerferedHeightWithImage {
    return [NSNumber numberWithFloat:[AYDongDaSegView preferredHeightWithImgAndText]];
}

- (id)queryCurrentSelectedIndex {
    return [NSNumber numberWithInteger:self.selectedIndex];
}

- (id)resetItemInfo:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    NSString* title = [dic objectForKey:kAYSegViewTitleKey];
    int index = ((NSNumber*)[dic objectForKey:kAYSegViewIndexTypeKey]).intValue;
    [self refreshItemTitle:title atIndex:index];
    return nil;
}
@end

@implementation AYDongDaSeg2View

@end
