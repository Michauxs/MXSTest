//
//  AYHomeContentDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYContentDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

#import "QueryContent.h"
//#import "GPUImage.h"
//#import "MJRefresh.h"

@implementation AYContentDelegate {
    NSArray* querydata;
    UITableView* queryView;
    
    NSTimer *timer;
    CGFloat duration;
    CGFloat velocity;
    CGFloat distance;
    CGFloat allDistance;
    CGFloat acceleration;
    CGFloat startIndex;
    CGFloat endIndex;
    BOOL isDecelerate;
    CGFloat rowHeight;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    rowHeight = [UIScreen mainScreen].bounds.size.height - 60 - 44 - 35;
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

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"home_cell_name"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell =[tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(@"home_cell_name", @"home_cell_name");
    }

    cell.controller = self.controller;
    
    QueryContent* tmp = [querydata objectAtIndex:indexPath.row];
    id<AYCommand> cmd = [cell.commands objectForKey:@"resetContent:"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tmp forKey:@"home_cell_content"];
    [dic setValue:cell forKey:@"home_cell"];
    [dic setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"home_cell_index"];
    
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = VIEW(@"home_cell_name", @"home_cell_name");
    id<AYCommand> cmd = [cell.commands objectForKey:@"queryContentCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> homeCell = (id<AYViewBase>)cell;
    id<AYCommand> cmd = [homeCell.commands objectForKey:@"willDisappear:"];

    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cell forKey:@"home_cell"];
    
    [cmd performWithResult:&dic];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //    contentOffsetY = scrollView.contentOffset.y;
    //    [timer invalidate];
    //    timer = nil;
    [self stopAnimation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (queryView.mj_header.state == MJRefreshStateRefreshing || queryView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (queryView.mj_header.state == MJRefreshStateRefreshing || queryView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y > (scrollView.contentSize.height -CGRectGetHeight(scrollView.frame))) {
        return;
    }
    isDecelerate = decelerate;
    [scrollView setContentOffset:scrollView.contentOffset];
    velocity = -[[scrollView panGestureRecognizer] velocityInView:scrollView].y / rowHeight;
    acceleration = -velocity * 30 * (1.0 - 0.9);
    distance = -pow(velocity, 2.0) / (2.0 * acceleration);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        [self scrollToItemWithScrollView:scrollView];
    });
}

- (void)scrollToItemWithScrollView:(UIScrollView *)scrollView {
    NSLog(@"%@ === %f", @"速度", velocity);
    if (!isDecelerate) {
        NSLog(@"拖动终止为0");
        CGFloat offsetY = scrollView.contentOffset.y - floor(scrollView.contentOffset.y / rowHeight) * rowHeight;
        if (offsetY > rowHeight / 2) {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y + rowHeight - offsetY) animated:YES];
        } else {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - offsetY) animated:YES];
        }
        return;
    }
    
    if (fabs(velocity) > 2.0) {
        NSLog(@"正常滚动");
        startIndex = scrollView.contentOffset.y / rowHeight;
        endIndex = startIndex + distance;
        endIndex = distance > 0 ? ceil(endIndex) : floor(endIndex);
        // 归位
        distance = endIndex - startIndex;
        duration = fabs(distance) / fabs(0.5 * velocity);
        acceleration = -velocity / duration;
    } else {
        CGFloat offsetY = scrollView.contentOffset.y - floor(scrollView.contentOffset.y / rowHeight) * rowHeight;
        if (offsetY > rowHeight / 2) {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y + rowHeight - offsetY) animated:YES];
        } else {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - offsetY) animated:YES];
        }
        return;
    }
    allDistance = 0;
    [self starAnimation];
}

- (void)starAnimation {
    if (!timer) {
        timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                        target:self
                                      selector:@selector(step)
                                      userInfo:nil
                                       repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)step {
    CGFloat time = MIN(duration, 1.000000 / 60.000000); // 时间
    CGFloat offsetIndex = velocity * time + 0.5 * acceleration * pow(time, 2.0);
    velocity = velocity + acceleration * time;
    allDistance += offsetIndex;
    if (offsetIndex < 0.0 && distance > 0.0) {
        offsetIndex = distance - allDistance + offsetIndex;
        [self stopAnimation];
        allDistance = 0;
    } else if (offsetIndex > 0.0 && distance < 0.0) {
        offsetIndex = distance - allDistance + offsetIndex;
        [self stopAnimation];
        allDistance = 0;
    }
    CGPoint offset = CGPointMake(0, queryView.contentOffset.y + offsetIndex * rowHeight);
    if (offset.y > 0 && offset.y < (queryView.contentSize.height - queryView.frame.size.height)) {
        [queryView setContentOffset:CGPointMake(0, queryView.contentOffset.y + offsetIndex * rowHeight)];
        [queryView layoutIfNeeded];
    } else {
        if (offset.y <= 0) {
            [queryView setContentOffset:CGPointMake(0, 0)];
        } else if(offset.y >= (queryView.contentSize.height - queryView.frame.size.height)){
            [queryView setContentOffset:CGPointMake(0, queryView.contentSize.height - queryView.frame.size.height)];
        }
        [queryView layoutIfNeeded];
        [self stopAnimation];
    }
}

- (void)stopAnimation {
    [timer invalidate];
    timer = nil;
}

#pragma mark -- messages
- (id)changeQueryData:(id)obj {
    querydata = (NSArray*)obj;
    return nil;
}

- (id)setCallBackTableView:(id)obj {
    queryView = (UITableView*)obj;
    return nil;
}

- (id)likePostItemResult:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
    id<AYViewBase> cell = [dic objectForKey:@"home_cell"];
    id<AYCommand> cmd = [cell.commands objectForKey:@"resetLike:"];
    
    NSDictionary* args = [dic copy];
    [cmd performWithResult:&args];
    
//    NSIndexPath* currentIndex = [queryView indexPathForCell:(UITableViewCell*)cell];
//    [queryView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
    
    return nil;
}

- (id)pushPostItemResult:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
    id<AYViewBase> cell = [dic objectForKey:@"home_cell"];
    
    id<AYCommand> cmd = [cell.commands objectForKey:@"resetPush:"];
    
    NSDictionary* args = [dic copy];
    [cmd performWithResult:&args];
    
//    NSIndexPath* currentIndex = [queryView indexPathForCell:(UITableViewCell*)cell];
//    [queryView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
    return nil;
}
@end
