//
//  AYAboutDongdaCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAboutDongdaDelegate.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
//#import "FoundHotTagBtn.h"
#import "Tools.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"

#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"

#define MARGIN                  13
#define MARGIN_VER              12

// 内部
#define ICON_WIDTH              12
#define ICON_HEIGHT             12

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

#define PREFERRED_HEIGHT        62

@interface AYAboutDongdaCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation AYAboutDongdaCell
@synthesize imageView = _imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        self.label = [[UILabel alloc]init];
        self.label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        self.label.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.label];
    }
    return self;
}
@end


@implementation AYAboutDongdaDelegate {
    NSArray* title;
}

#pragma mark -- commands
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;


- (void)postPerform {
    title = @[@"用户协议"];
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


#pragma mark -- life cycle
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AYAboutDongdaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (cell == nil) {
        cell = [[AYAboutDongdaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    if (indexPath.row == 0){
    
        cell.label.text = title[indexPath.row];
        [cell.label sizeToFit];
        cell.label.frame = CGRectMake(20, (44 - CGRectGetHeight(cell.label.frame)) / 2, cell.label.frame.size.width, cell.label.frame.size.height);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CALayer* line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.20].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(8, 44 - 1, tableView.frame.size.width, 1);
        [cell.layer addSublayer:line];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        
        id<AYCommand> UserAgree = DEFAULTCONTROLLER(@"UserAgree");
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic setValue:UserAgree forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
        [_controller performWithResult:&dic];
        
    }
}


+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

+ (CGFloat)preferredHeightWithTags:(NSArray*)arr {
    return PREFERRED_HEIGHT;
}

@end
