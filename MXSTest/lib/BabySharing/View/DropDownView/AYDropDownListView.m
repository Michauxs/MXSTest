//
//  DropDownView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "AYDropDownListView.h"
#import "DropDownItem.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"

#import "AYDropDownListDefines.h"

#define DROP_DOWN_WIDTH         20
#define DROP_DOWN_HEIGHT        20
#define DROP_DOWN_ICON_MARGIN   5

@implementation AYDropDownListView {
    UITableView *albumTableView;
    CALayer* drop_down_layer;
    BOOL isDroped;
    
    NSArray* querydata;
}

- (void)clickHandler:(id)sender {
    NSLog(@"show list");
    if (!isDroped) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        albumTableView.bounds = CGRectMake(0, 0, width, [UIScreen mainScreen].bounds.size.height - 64);
       
        id<AYCommand> cmd = [self.notifies objectForKey:@"showDropDownList:"];
        id args = albumTableView;
        [cmd performWithResult:&args];
        
        drop_down_layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        isDroped = !isDroped;
    } else {
        [self dismissListFromSuper];
    }
}

- (void)dismissListFromSuper {
    
    drop_down_layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        albumTableView.frame = CGRectMake(0, 64 - albumTableView.frame.size.height, albumTableView.frame.size.width, albumTableView.frame.size.height);
    } completion:^(BOOL finished) {
        [albumTableView removeFromSuperview];
    }];
    isDroped = NO;
}

- (void)setMessageHandler {
   
    isDroped = NO;
    
    drop_down_layer = [CALayer layer];
    drop_down_layer.contents = (id)PNGRESOURCE(@"post_drop_down").CGImage;
    drop_down_layer.bounds = CGRectMake(0, 0, DROP_DOWN_WIDTH, DROP_DOWN_HEIGHT);
    [self.layer addSublayer:drop_down_layer];
    
    
    [self addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
    albumTableView = [[UITableView alloc]init];
    albumTableView.delegate = self;
    albumTableView.dataSource = self;
    albumTableView.scrollEnabled = YES;
    albumTableView.bounces = YES;
    albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [albumTableView registerClass:[DropDownItem class] forCellReuseIdentifier:@"drop item"];
    
    self.clipsToBounds = YES;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [self setMessageHandler];
    }
    return self;   
}

- (void)sizeToFit {
    [super sizeToFit];
    CGRect bounds = self.bounds;
    CGPoint ct = self.center;
    self.bounds = CGRectMake(0, 0, bounds.size.width + DROP_DOWN_WIDTH + 2 * DROP_DOWN_ICON_MARGIN, bounds.size.height);
    self.center = ct;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UILabel *label = self.titleLabel;
    [label sizeToFit];
    CGRect frame = label.frame;
    CGPoint center = self.center;
    
    self.frame = CGRectMake(0, 0, frame.size.width + 30, self.frame.size.height);
    label.frame = CGRectMake(0, 0, label.frame.size.width, self.frame.size.height);
    self.layer.delegate = self;
    self.center = center;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        CGRect bounds = self.bounds;
        drop_down_layer.position = CGPointMake(bounds.size.width - DROP_DOWN_ICON_MARGIN - DROP_DOWN_WIDTH / 2, bounds.size.height / 2);
    }
}

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYCommand> cmd = [self.notifies objectForKey:@"itemDidSelected:"];
    id args = [NSNumber numberWithInteger:indexPath.row];
    [cmd performWithResult:&args];
    [self dismissListFromSuper];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropDownItem *cell = [tableView dequeueReusableCellWithIdentifier:@"drop item"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.album = [querydata objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return querydata.count;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle

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

#pragma mark -- message
- (id)setListInfo:(id)args {
    querydata = (NSArray*)args;
    return nil;
}

- (id)setTitle:(id)args {
    NSString* str = (NSString*)args;
    [self setTitle:str forState:UIControlStateNormal];
    return nil;
}
@end
