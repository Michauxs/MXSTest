//
//  AYScanQRCodeController.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScanQRCodeController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
//#import "AYSearchDefines.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>


@implementation AYScanQRCodeController{
    NSMutableArray *loading_status;
    
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        //        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    
    //1. 输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    
    //2. 输出设备 (解析输入的内容)
    self.output = [AVCaptureMetadataOutput new];
    [self.output setRectOfInterest:CGRectMake((124)/SCREEN_HEIGHT,((SCREEN_WIDTH-220)/2)/SCREEN_WIDTH,220/SCREEN_HEIGHT,220/SCREEN_WIDTH)];
    
    //3. 会话类
    self.session = [AVCaptureSession new];
    
    // 绑定输入和输出设备
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 设置代理 --> 获取数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        // 设置扫描的类型 --> 二维码 QRCode
        [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设定-隐私-相机”选项中，允许-咚哒-访问你的相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    // 设置扫描的类型 --> 二维码 QRCode
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //4. 展示扫描到的内容的layer --> 需要设置session
//    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//    self.preview.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.view.layer addSublayer:self.preview];
    
    self.preview = [[AYScanQRPreView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.preview.session = self.session;
    [self.view addSubview:self.preview];
    
    //5. 开始扫描
    [self.session startRunning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"扫描二维码";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
        //1. 停止扫描
        [self.session stopRunning];
        
        //2. 删除layer
        [self.preview removeFromSuperview];
        
        //3. 获取数据 AVMetadataMachineReadableCodeObject 头文件没提示
        AVMetadataMachineReadableCodeObject *obj =  metadataObjects[0];
        
        NSLog(@"%@", obj.stringValue);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"机密信息" message:obj.stringValue delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
//        if ([obj.stringValue hasPrefix:@"http"]) {
//            //iOS9 新增的控制器 可以方便的展示网页内容
//            SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:obj.stringValue]];
//            [self presentViewController:sf animated:YES completion:nil];
//        }
    }
}

#pragma mark -- actions
-(void)doSearchBtnClick{
    
}

#pragma mark -- notifies
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
    
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end
