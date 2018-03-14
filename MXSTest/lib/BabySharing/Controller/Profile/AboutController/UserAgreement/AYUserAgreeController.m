//
//  AYUserAgreeController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYUserAgreeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "SGActionView.h"
#import "AYModel.h"
#import "AYRemoteCallCommand.h"
#import "MBProgressHUD.h"

@implementation AYUserAgreeController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *Web = [self.views objectForKey:@"Web"];
    Web.delegate = self;
    
    UIButton *state = [Tools creatBtnWithTitle:@"登陆即表示同意用户协议" titleColor:[UIColor whiteColor] fontSize:17.f backgroundColor:[Tools theme]];
    state.layer.cornerRadius = 4.f;
    state.clipsToBounds = YES;
    state.layer.rasterizationScale = [UIScreen mainScreen].scale;
    state.userInteractionEnabled = NO;
    [self.view addSubview:state];
    [state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(4 - HOME_IND_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 48));
    }];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"咚哒用户协议";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIImage *right = IMGRESOURCE(@"tips_off_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnImgMessage, &right)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)WebLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - kStatusAndNavBarH - HOME_IND_HEIGHT);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSURL* url = [NSURL fileURLWithPath:path];
    [(UIWebView*)view loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:url];
    
//    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
//    [webView loadRequest:request];
//    [((UIWebView*)view) setOpaque:NO];
    [((UIWebView*)view) setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:((UIWebView*)view)];
    return nil;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [super startRemoteCall:nil];
}

#pragma mark -- webdelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super endRemoteCall:nil];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    NSLog(@"controller alter...");
    [SGActionView showSheetWithTitle:@"" itemTitles:@[@"发送协议", @"以邮件的形式发送", @"复制全文", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
        switch (index) {
            case 0:
                break;
            case 1:
                [self sendEmailBtnSelected];
                break;
            case 2:
                break;
            default:
                break;
        }
    }];
    
    return nil;
}

- (void)sendEmailBtnSelected {
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"输入你的邮件" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    view.alertViewStyle = UIAlertViewStylePlainTextInput;
    [view show];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UITextField* tf = [alertView textFieldAtIndex:0];
    NSString* email = tf.text;
    
    if ([self isValidateEmail:email]) {
		
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:email forKey:@"email"];
		
		AYFacade* f = [self.facades objectForKey:@"SendRemote"];
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"EmailSend"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"Update user detail remote result: %@", result);
            if (success) {
                
                NSString *title = @"文件已发送至您的邮箱";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
                
            } else {
                AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
}

@end
