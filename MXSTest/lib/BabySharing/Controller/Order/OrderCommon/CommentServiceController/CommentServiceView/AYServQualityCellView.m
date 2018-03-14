//
//  AYServQualityCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServQualityCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYServQualityCellView {
    
    UIImageView *starRangImage;
    UILabel *titleLabel;
    NSNumber *index_tag;
    
    NSDictionary *comment_args;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        NSLog(@"init reuse identifier");
        
        self.backgroundColor = [UIColor clearColor];
        
        titleLabel = [Tools creatLabelWithText:nil textColor:[Tools whiteColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        starRangImage = [UIImageView new];
        starRangImage.image = IMGRESOURCE(@"star_rang_5");
        [self addSubview: starRangImage];
        [starRangImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(90, 14));
        }];
        starRangImage.userInteractionEnabled = YES;
        [starRangImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetStarRangTap:)]];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServQualityCell", @"ServQualityCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

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

#pragma mark -- actions

- (void)didSetStarRangTap:(UIGestureRecognizer*)tap {
    
    CGPoint tapPoint = [tap locationInView:starRangImage];
    CGFloat tapOffSetX = tapPoint.x;
    CGFloat rang_note = 0;
    
    if (tapOffSetX > 0 && tapOffSetX < 15) {
        starRangImage.image = IMGRESOURCE(@"star_rang_1");
        rang_note = 1.f;
    } else if (tapOffSetX > 20 && tapOffSetX < 35) {
        starRangImage.image = IMGRESOURCE(@"star_rang_2");
        rang_note = 2.f;
    } else if (tapOffSetX > 40 && tapOffSetX < 55) {
        starRangImage.image = IMGRESOURCE(@"star_rang_3");
        rang_note = 3.f;
    } else if (tapOffSetX > 60 && tapOffSetX < 75) {
        starRangImage.image = IMGRESOURCE(@"star_rang_4");
        rang_note = 4.f;
    } else {
        starRangImage.image = IMGRESOURCE(@"star_rang_5");
        rang_note = 5.f;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:index_tag forKey:@"index_tag"];
    [dic setValue:[NSNumber numberWithFloat:rang_note] forKey:@"star_rang"];
    kAYViewSendNotify(self, @"didSetServiceRang:", &dic)
}

-(void)didPushInfo {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didPushInfo"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args{
    
    titleLabel.text = [args objectForKey:@"title"];
    
    index_tag = [args objectForKey:@"index"];
//    index_tag = index.integerValue;
    return nil;
}

@end
