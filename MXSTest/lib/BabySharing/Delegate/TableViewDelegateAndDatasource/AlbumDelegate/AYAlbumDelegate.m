//
//  AYAlbumDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAlbumDelegate.h"

#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "AYAlbumDefines.h"
#import "AYQueryModelDefines.h"

@implementation AYAlbumDelegate {
    NSArray* pHAssets;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:[[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYAlbumTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix] forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(kAYAlbumTableCellName, kAYAlbumTableCellName);
    }
    
    cell.controller = self.controller;
    {
        id<AYCommand> cmd_info = [cell.commands objectForKey:@"setCellInfo:"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:cell forKey:kAYAlbumTableCellSelfKey];
        [dic setValue:[NSNumber numberWithFloat:0.f] forKey:kAYAlbumTableCellMarginLeftKey];
        [dic setValue:[NSNumber numberWithFloat:0.f] forKey:kAYAlbumTableCellMarginRightKey];
        [dic setValue:[NSNumber numberWithFloat:3.f] forKey:kAYAlbumTableCellCornerRadiusKey];
        [dic setValue:[NSNumber numberWithFloat:2.f] forKey:kAYAlbumTableCellMarginBetweenKey];
        [cmd_info performWithResult:&dic];
    }
#define PHOTO_PER_LINE 3
    {
        NSInteger row = indexPath.row;
        NSArray* arr_content = nil;
        @try {
            arr_content = [self.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        
        } @catch (NSException *exception) {
            arr_content = [self.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, self.querydata.count - row * PHOTO_PER_LINE)]];
        }
        
        id<AYCommand> cmd_item = [cell.commands objectForKey:@"setUpItems:"];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setValue:arr_content forKey:kAYAlbumTableCellItemKey];
        [dic setValue:cell forKey:kAYAlbumTableCellSelfKey];
        [dic setValue:[NSNumber numberWithInteger:row] forKey:kAYAlbumTableCellRowKey];
        [dic setValue:[NSNumber numberWithInt:AlbumControllerTypePhoto] forKey:kAYAlbumTableCellControllerTypeKey];
        
        [cmd_item performWithResult:&dic];
    }
    
    return (UITableViewCell*)cell;
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat offset_origin_y = 0;
    CGFloat offset_now_y = scrollView.contentOffset.y;
    if (offset_now_y - offset_origin_y > 15) {
        id<AYCommand> cmd = [self.notifies objectForKey:@"scrollForMoreSize"];
        [cmd performWithResult:nil];
    }
    offset_origin_y = offset_now_y;
}

#pragma mark -- notifications
- (id)changeQueryData:(id)args {
    NSDictionary* tmp = (NSDictionary*)args;
    self.querydata = [tmp objectForKey:@"images"];
    pHAssets = [tmp objectForKey:@"assets"];
    return nil;
}

@end
