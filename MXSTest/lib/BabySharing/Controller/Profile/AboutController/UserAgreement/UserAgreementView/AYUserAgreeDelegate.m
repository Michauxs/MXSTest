//
//  AYUserAgreeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 13/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYUserAgreeDelegate.h"
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

//@interface AYUserAgreeCell : UITableViewCell
//
//@property (nonatomic, strong) UITextView *textContent;
//
//@end
//
//@implementation AYUserAgreeCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        NSLog(@"init reuse identifier");
//
//    }
//    return self;
//}
//@end
//

@implementation AYUserAgreeDelegate {
    NSArray* title;
}

#pragma mark -- commands
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;


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


#pragma mark -- life cycle

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    AYUserAgreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
//    
//    if (cell == nil) {
//        cell = [[AYUserAgreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
//    }
//    
//    UIWebView *userPrivacyView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 108)];
//    [userPrivacyView setBackgroundColor:[UIColor clearColor]];
//    [userPrivacyView setOpaque:NO];
////    NSString* path = @"/Users/alfredyang/Desktop/privacy.html";
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"privacy" ofType:@"html"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSURL* url = [NSURL fileURLWithPath:path];
////    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
////    [webView loadRequest:request];
//    [userPrivacyView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:url];
//    
//    [cell addSubview:userPrivacyView];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    
//    return cell;
//    
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [UIScreen mainScreen].bounds.size.height;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

+ (CGFloat)preferredHeightWithTags:(NSArray*)arr {
    return PREFERRED_HEIGHT;
}

@end
