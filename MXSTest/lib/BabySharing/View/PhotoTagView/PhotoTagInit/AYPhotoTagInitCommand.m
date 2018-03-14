//
//  AYPhotoTagInitCommand.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPhotoTagInitCommand.h"
#import "AYCommandDefines.h"
#import "PhotoTagEnumDefines.h"
#import "AYPhotoTagView.h"
#import "AYFactoryManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"

@implementation AYPhotoTagInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {

    NSDictionary* args = (NSDictionary*)*obj;
    NSString* tag_text = [args objectForKey:@"tag_text"];
    TagType tag_type = ((NSNumber*)[args objectForKey:@"tag_type"]).integerValue;
    CGFloat width = ((NSNumber*)[args objectForKey:@"width"]).floatValue;
    CGFloat height = ((NSNumber*)[args objectForKey:@"height"]).floatValue;
    NSNumber* offset_x = [args objectForKey:@"offsetX"];
    NSNumber* offset_y = [args objectForKey:@"offsetY"];
    
    AYPhotoTagView *tmp = [[AYPhotoTagView alloc] initWithTagName:tag_text andType:tag_type ];
    [self setUpReuseView:tmp];
    
    CGPoint point_tmp;
    
    if (offset_x && offset_y) {
        point_tmp = CGPointMake(width * offset_x.floatValue, height * offset_y.floatValue);
    } else {
        switch (tag_type) {
            case TagTypeLocation:
                point_tmp = CGPointMake(width / 4 - tmp.bounds.size.width / 2, height / 2);
                break;
            case TagTypeTime:
                point_tmp = CGPointMake(width / 2 - tmp.bounds.size.width / 2, height * 3 / 4);
                break;
            case TagTypeTags:
                point_tmp = CGPointMake(width * 3 / 4 - tmp.bounds.size.width / 2, height / 2);
                break;
            case TagTypeBrand:
                point_tmp = CGPointMake(width * 3 / 4 - tmp.bounds.size.width / 2, height / 2);
                break;
            default:
                break;
        }       
    }

    tmp.offset_x = point_tmp.x / width;
    tmp.offset_y = point_tmp.y / height;
    tmp.frame = CGRectMake(point_tmp.x, point_tmp.y, tmp.bounds.size.width, tmp.bounds.size.height);
    
    *obj = tmp;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (void)setUpReuseView:(id<AYViewBase>)view {
    id<AYViewBase> cell = VIEW(@"PhotoTag", @"PhotoTag");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = view;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    view.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = view;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    view.notifies = [arr_notifies copy];
}
@end
