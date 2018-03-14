//
//  AYLocationCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationCellView.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "Define.h"
#import "QueryContentTag.h"
#import "QueryContentChaters.h"
#import "QueryContent+ContextOpt.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import <CoreLocation/CoreLocation.h>

@implementation AYLocationCellView{
    UILabel *locationLabel;
    NSString *locationName;
    
    UILabel *destrictLabel;
    NSString *districtName;
    
    CLLocation *location;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            
            locationLabel = [[UILabel alloc]init];
            [self addSubview:locationLabel];
            locationLabel.font = [UIFont systemFontOfSize:14.f];
            locationLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.f];
            locationLabel.textAlignment = NSTextAlignmentLeft;
            [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(20);
                make.centerY.equalTo(self);
                make.width.equalTo(self);
            }];
            
            CALayer *line_separator = [CALayer layer];
            line_separator.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
            line_separator.borderWidth = 1.f;
            line_separator.frame = CGRectMake(0, self.bounds.size.height - 1, SCREEN_WIDTH, 1);
            [self.layer addSublayer:line_separator];
            
            [self setUpReuseCell];
        }
    }
    return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"LocationCell", @"LocationCell");
    
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

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (id)resetContent:(id)obj {
    NSDictionary* dic = (NSDictionary*)obj;
    locationName = [dic objectForKey:@"location_name"];
    if (locationName && ![locationName isEqualToString:@""] ) {
        locationLabel.text = locationName;
    }
    districtName = [dic objectForKey:@"district"];
    location = [dic objectForKey:@"location"];
    return nil;
}
@end
