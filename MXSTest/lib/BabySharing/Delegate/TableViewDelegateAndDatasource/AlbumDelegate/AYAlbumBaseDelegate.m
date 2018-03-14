//
//  AYAlbumBaseDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAlbumBaseDelegate.h"

#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "QueryContent.h"
#import "QueryContentItem.h"
#import "AYAlbumDefines.h"
#import "AYQueryModelDefines.h"

@implementation AYAlbumBaseDelegate
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize querydata = _querydata;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma mark -- message
- (id)changeQueryData:(id)obj {
    _querydata = obj;
    return nil;
}

#pragma mark -- table
#define PHOTO_PER_LINE  3
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return (querydata.count / PHOTO_PER_LINE) + 1;
    return (_querydata.count / PHOTO_PER_LINE) + (_querydata.count % PHOTO_PER_LINE != 0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYAlbumTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(kAYAlbumTableCellName, kAYAlbumTableCellName);
    }
    
    cell.controller = self.controller;
    
    [self changeCellInfo:cell];
    NSInteger row = indexPath.row;
    [self resetImageContent:row cell:cell];
    
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> v = VIEW(kAYAlbumTableCellName, kAYAlbumTableCellName);
    [self changeCellInfo:v];
    id<AYCommand> cmd_height = [v.commands objectForKey:@"queryPerferedHeight"];
    NSNumber* height = nil;
    [cmd_height performWithResult:&height];
    return height.floatValue;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -- arcitons
- (void)changeCellInfo:(id<AYViewBase>)cell {
    id<AYCommand> cmd_info = [cell.commands objectForKey:@"setCellInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cell forKey:kAYAlbumTableCellSelfKey];
    [dic setValue:[NSNumber numberWithFloat:0.f] forKey:kAYAlbumTableCellMarginLeftKey];
    [dic setValue:[NSNumber numberWithFloat:0.f] forKey:kAYAlbumTableCellMarginRightKey];
    // [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginLeftKey];
    // [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginRightKey];
    [dic setValue:[NSNumber numberWithFloat:3.f] forKey:kAYAlbumTableCellCornerRadiusKey];
    [dic setValue:[NSNumber numberWithFloat:2.f] forKey:kAYAlbumTableCellMarginBetweenKey];
    [cmd_info performWithResult:&dic];
}

- (void)resetImageContent:(NSInteger)row cell:(id<AYViewBase>)cell {
    #define PHOTO_PER_LINE 3
    NSMutableArray* arr_content = nil;
    @try {
        NSArray* arr_tmp = [_querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        arr_content = [[NSMutableArray alloc] initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            for (QueryContentItem * cur in item.items) {
                if (cur.item_type.unsignedIntegerValue != PostPreViewMovie) {
                    [arr_content addObject:cur.item_name];
                    break;
                }
            }
        }
    } @catch (NSException *exception) {
        NSArray* arr_tmp = [_querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, _querydata.count - row * PHOTO_PER_LINE)]];
        arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            for (QueryContentItem *cur in item.items) {
                if (cur.item_type.unsignedIntegerValue != PostPreViewMovie) {
                    [arr_content addObject:cur.item_name];
                    break;
                }
            }
        }
    }
    
    id<AYCommand> cmd_item = [cell.commands objectForKey:@"setUpItems:"];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:arr_content forKey:kAYAlbumTableCellItemKey];
    [dic setValue:cell forKey:kAYAlbumTableCellSelfKey];
    [dic setValue:[NSNumber numberWithInteger:row] forKey:kAYAlbumTableCellRowKey];
    [dic setValue:[NSNumber numberWithInt:AlbumControllerTypePhoto] forKey:kAYAlbumTableCellControllerTypeKey];
    
    [cmd_item performWithResult:&dic];
}
@end
