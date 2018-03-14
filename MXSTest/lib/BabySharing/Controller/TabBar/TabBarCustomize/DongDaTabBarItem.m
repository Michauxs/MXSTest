//
//  DongDaTabBarItem.m
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "DongDaTabBarItem.h"

#define LAYER_ICON_MID_WIDTH_S     32
#define LAYER_ICON_MID_HEIGHT_S    LAYER_ICON_MID_WIDTH_S

#define LAYER_ICON_NORMAL_WIDTH     28
#define LAYER_ICON_NORMAL_HEIGHT    LAYER_ICON_NORMAL_WIDTH

#define LAYER_ICON_MID_WIDHT    75
//#define LAYER_ICON_MID_WIDHT    60
//#define LAYER_ICON_MID_HEIGHT   LAYER_ICON_MID_WIDHT
#define LAYER_ICON_MID_HEIGHT   49

#define LAYER_TITLE_WIDTH       22
#define LAYER_TITLE_HEIGHT      11

@implementation DongDaTabBarItem {
    
    CALayer* img_layer;
    CATextLayer* title_layer;
}

@synthesize img = _img;
@synthesize select_img = _select_img;

- (id)initWithMidImage:(UIImage*)image {
    self = [super init];
    if (self) {
        _img = image;
        _select_img = nil;

        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        UIImage* bg_img = [UIImage imageNamed:[resourceBundle pathForResource:@"tab_publish_bg" ofType:@"png"]];

        CALayer* bg_layer = [CALayer layer];
        bg_layer.contents = (id)bg_img.CGImage;
        
        CGFloat mid_width = [UIScreen mainScreen].bounds.size.width / 5;
        
        bg_layer.frame = CGRectMake(0, 0, mid_width, LAYER_ICON_MID_HEIGHT);
        [self.layer addSublayer:bg_layer];
        
        img_layer = [CALayer layer];
        img_layer.contents = (id)image.CGImage;
        img_layer.frame = CGRectMake(0, 0, LAYER_ICON_MID_WIDTH_S, LAYER_ICON_MID_HEIGHT_S);
        [self.layer addSublayer:img_layer];
    }
    return self;
}

- (id)initWithImage:(UIImage*)image andSelectImage:(UIImage*)selectImg {
    self = [super init];
    if (self) {
        _img = image;
        _select_img = selectImg;
        
        img_layer = [CALayer layer];
        img_layer.contents = (id)image.CGImage;
        img_layer.frame = CGRectMake(0, 0, LAYER_ICON_NORMAL_WIDTH, LAYER_ICON_NORMAL_HEIGHT);
        [self.layer addSublayer:img_layer];
    }
    return self;
}

- (id)initWithImage:(UIImage*)image andSelectImage:(UIImage*)selectImg andTitle:(NSString*)title {
    self = [super init];
    if (self) {
        _img = image;
        _select_img = selectImg;
        
        img_layer = [CALayer layer];
        img_layer.contents = (id)image.CGImage;
        img_layer.frame = CGRectMake(0, 0, LAYER_ICON_NORMAL_WIDTH, LAYER_ICON_NORMAL_HEIGHT);
        [self.layer addSublayer:img_layer];
        
        title_layer = [CATextLayer layer];
        title_layer.string = title;
        title_layer.contentsScale = 2.f;
        title_layer.fontSize = 9.f;
        title_layer.foregroundColor = [Tools RGB153GaryColor].CGColor;
        title_layer.frame = CGRectMake(0, 0, LAYER_TITLE_WIDTH, LAYER_TITLE_HEIGHT);
        title_layer.alignmentMode = @"center";
        [self.layer addSublayer:title_layer];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == self.layer) {
        img_layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height/ 2);
        
        if (title_layer != nil) {
            img_layer.position = CGPointMake(img_layer.position.x, img_layer.position.y - 4.5);
            title_layer.position = CGPointMake(img_layer.position.x, img_layer.position.y + LAYER_ICON_NORMAL_HEIGHT / 2  + 7.5);
        }
    }
}

- (void)setNormalImg:(UIImage *)img {
    _img = img;
    img_layer.contents = (id)_img.CGImage;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (!_select_img) return;

    if (selected) {
        img_layer.contents = (id)_select_img.CGImage;
        title_layer.foregroundColor = [Tools theme].CGColor;
    } else {
        img_layer.contents = (id)_img.CGImage;
        title_layer.foregroundColor = [Tools RGB153GaryColor].CGColor;
    }
}
@end
