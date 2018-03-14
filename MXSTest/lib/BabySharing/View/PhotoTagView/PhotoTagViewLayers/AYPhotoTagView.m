//
//  PhotoTagView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "AYPhotoTagView.h"
#import "WKFRadarView.h"
#import "Tools.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "PhotoTagEnumDefines.h"

//#define VER_MARGIN      10
//#define HER_MARGIN      10

#define TEXT_LEFT_MARGIN        22
#define TEXT_RIGHT_MARGIN       4
#define TAG_HEIGHT              21
#define TEXT_FONT_SIZE          12.f
#define TEXT_FONT               [UIFont systemFontOfSize:TEXT_FONT_SIZE]
#define TAG_CONSTRAINS_SIZE     CGSizeMake(FLT_MAX, FLT_MAX)

@interface AYPhotoTagView ()

@end

@implementation AYPhotoTagView {
    
    CALayer* tri;
    CALayer* tail;
    
    CATextLayer* text_content;
    CALayer* text_bg;
    
    WKFRadarView *radarView;
}

@synthesize status = _status;
@synthesize content = _content;
@synthesize type = _type;

@synthesize offset_x = _offset_x;
@synthesize offset_y = _offset_y;

- (id)initWithTagName:(NSString*)name andType:(TagType)type {
    self = [super init];
    if (self) {
        _content = name;
        _type = type;
        [self setUpTagView];
        self.tag = kAYPhotoTagViewTag + type;
    }
    
    return self;
}

- (CGSize)preferredSizeWithTagTitle:(NSString*)title {
//    CGSize sz = [title sizeWithFont:TEXT_FONT constrainedToSize:TAG_CONSTRAINS_SIZE];
    CGSize sz = [Tools sizeWithString:title withFont:TEXT_FONT andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    return CGSizeMake(TEXT_LEFT_MARGIN + sz.width + TEXT_RIGHT_MARGIN, MAX(sz.height, TAG_HEIGHT));
}

- (CGRect)preferredBoundsWithTagTitle:(NSString *)title {
    CGSize sz = [self preferredSizeWithTagTitle:title];
    return CGRectMake(0, 0, sz.width, sz.height);
}

- (CGSize)getTitleSizeWithTagTitle:(NSString *)title {
//    return [title sizeWithFont:TEXT_FONT constrainedToSize:TAG_CONSTRAINS_SIZE];
    return [Tools sizeWithString:title withFont:TEXT_FONT andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
}

- (CGRect)getTitleBoundsWithTagTitle:(NSString *)title {
    CGSize sz = [self getTitleSizeWithTagTitle:title];
    return CGRectMake(0, 0, sz.width, sz.height);
}

- (void)setUpTagView {
    self.bounds = [self preferredBoundsWithTagTitle:_content];
//    self.backgroundColor = [UIColor redColor];
    
    // 脉冲动画
    if (radarView != nil) {
        [radarView removeFromSuperview];
    }
    radarView = [[WKFRadarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds) * 1.4, CGRectGetHeight(self.bounds) * 1.4)];
    radarView.backgroundColor = [UIColor clearColor];
    
    radarView.center = CGPointMake(0 + 3.5, CGRectGetHeight(self.bounds) / 2);
    [self addSubview:radarView];
  
    if (tri != nil) {
        [tri removeFromSuperlayer];
    }
    tri = [CALayer layer];
    tri.frame = CGRectMake(0, 0, TEXT_LEFT_MARGIN, TAG_HEIGHT);
    tri.contents = (id)PNGRESOURCE(@"tag_tri").CGImage;
    tri.masksToBounds = YES;
    [self.layer addSublayer:tri];
    
    CGRect text_bounds = [self getTitleBoundsWithTagTitle:_content];
    if (text_bg != nil) {
        [text_bg removeFromSuperlayer];
    }
    text_bg = [CALayer layer];
    text_bg.frame = CGRectMake(TEXT_LEFT_MARGIN, 0, text_bounds.size.width, TAG_HEIGHT);
    text_bg.contents = (id)PNGRESOURCE(@"tag_text").CGImage;
    [self.layer addSublayer:text_bg];
    
    if (text_content != nil) {
        [text_content removeFromSuperlayer];
    }
    text_content = [CATextLayer layer];
    text_content.frame = CGRectMake(0, (TAG_HEIGHT - text_bounds.size.height) / 2 - 1, text_bounds.size.width, text_bounds.size.height + 2);
    text_content.string = _content;
    text_content.font = CFBridgingRetain(TEXT_FONT);
    text_content.fontSize = [TEXT_FONT pointSize];
    text_content.foregroundColor = [UIColor whiteColor].CGColor;
    text_content.backgroundColor = [UIColor clearColor].CGColor;
    text_content.contentsScale = 2.f;
    
    [text_bg addSublayer:text_content];
    text_bg.masksToBounds = YES;
    
    if (tail != nil) {
        [tail removeFromSuperlayer];
    }
    tail = [CALayer layer];
    tail.frame = CGRectMake(self.bounds.size.width - TEXT_RIGHT_MARGIN, 0, TEXT_RIGHT_MARGIN, TAG_HEIGHT);
    tail.contents = (id)PNGRESOURCE(@"tag_tail").CGImage;
    [self.layer addSublayer:tail];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _offset_x = self.frame.origin.x / self.frame.size.width;
    _offset_y = self.frame.origin.y / self.frame.size.height;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == text_content) {
    }
}

- (void)setTagDirection:(PhotoTagViewDirection)direction {
   
    if (_direction != direction) {
        _direction = direction;
        
        if (_direction == PhotoTagViewDirectionLeftToRight) {
            self.transform = CGAffineTransformIdentity;

            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [text_content setAnchorPoint:CGPointMake(0.5, 0.5)];
            [text_content setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
            [CATransaction commit];
            
        } else {
            CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
            self.transform = CGAffineTransformIdentity;
            self.transform = trans;
           
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [text_content setAnchorPoint:CGPointMake(0.5, 0.5)];
            [text_content setTransform:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
            [CATransaction commit];
        }
    }
}

#pragma mark -- messages
- (void)setContent:(NSString *)content {
    _content = content;
    [self setUpTagView];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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

- (id)changeTagDirection {
    self.direction = (self.direction + 1) % 2;
    return nil;
}

- (id)queryTagType {
    return [NSNumber numberWithInteger:self.type];
}

- (id)queryContentInfo {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.content forKey:@"content"];
    [dic setValue:[NSNumber numberWithFloat:self.type] forKey:@"type"];
    [dic setValue:[NSNumber numberWithFloat:self.offset_x] forKey:@"offsetX"];
    [dic setValue:[NSNumber numberWithFloat:self.offset_y] forKey:@"offsetY"];
    
    return [dic copy];
}
@end
