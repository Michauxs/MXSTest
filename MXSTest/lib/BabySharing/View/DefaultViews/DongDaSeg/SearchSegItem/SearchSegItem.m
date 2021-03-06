//
//  SearchSegItem.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchSegItem.h"
#import "Define.h"

#define ITEM_WIDTH                  77
#define ITEM_HEIGHT                 44
#define ITME_LAYER_LINE_HEIGHT      2

@implementation SearchSegItem {
//    UILabel* label;
    CALayer* layer;
}

@synthesize title = _title;
@synthesize status = _status;
@synthesize isLayerHidden = _isLayerHidden;
@synthesize font_size = _font_size;
@synthesize select_font_color = _select_font_color;

- (id)init {
    self = [super init];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (void)changeItemTitle:(NSString *)title {
    _title = title;
    
    UILabel* label = [self viewWithTag:-1];
    label.textColor = TextColor;
    label.text = _title;
    [label sizeToFit];
    label.center = CGPointMake(ITEM_WIDTH / 2, ITEM_HEIGHT / 2);
    
    [self setNeedsDisplay];
}

- (void)setUpValues {
    
    if (_font_size == 0) {
        _font_size = 18.f;
    }
    
    UILabel* label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:_font_size];
    label.tag = -1;
    [self addSubview:label];
	
	CGFloat layWidth = 20.f;
    layer = [CALayer layer];
    UIImage* img = [UIImage imageNamed:@"dongda_seg_selected"];
    layer.contents = (id)img.CGImage;
    layer.frame = CGRectMake((self.frame.size.width - layWidth)*0.5, self.frame.size.height - ITME_LAYER_LINE_HEIGHT, layWidth, ITME_LAYER_LINE_HEIGHT);
    [self.layer addSublayer:layer];
    
    layer.hidden = _status == 0;
    label.textColor = _status == 0 ? _font_color : _select_font_color;
    
    if (_isLayerHidden) {
        layer.hidden = YES;
    }
}

- (void)resetFontSize:(CGFloat)font_size {
    _font_size = font_size;
    UILabel* label = [self viewWithTag:-1];
    label.font = [UIFont boldSystemFontOfSize:_font_size];
}

- (void)resetFontColor:(UIColor *)font_color {
    _font_color = font_color;
    if (_status == 0) {
        UILabel* label = [self viewWithTag:-1];
        label.textColor = _font_color;
    }
}

- (void)resetSelectFontColor:(UIColor *)select_font_color {
    _select_font_color = select_font_color;
    if (_status == 1) {
        UILabel* label = [self viewWithTag:-1];
        label.textColor = _select_font_color;
    }
}

- (void)changeStatus:(NSInteger)s {
    _status = s;
    layer.hidden = _status == 0;
    UILabel* label = [self viewWithTag:-1];
    label.textColor = _status == 0 ? _font_color : _select_font_color;
    
    if (_isLayerHidden) {
        layer.hidden = YES;
    }
}

+ (CGSize)preferredSize {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}
@end
