//
//  AYPopSplitAnimationCommand.m
//  BabySharing
//
//  Created by BM on 9/2/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPopSplitAnimationCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"


@implementation AYPopSplitAnimationCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"pop command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    NSDictionary* dic_split_value = [dic objectForKey:kAYControllerSplitValueKey];
    if (dic_split_value == nil)
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command 必须需要split value args 操作" userInfo:nil];
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopSplitValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command 只能出来push 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
//    AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command source controler 必须是一个navigation controller" userInfo:nil];
    }
   
    CGFloat height = ((NSNumber*)[dic_split_value objectForKey:kAYControllerSplitHeightKey]).floatValue;
    UIImage* top = [dic_split_value objectForKey:kAYControllerSplitTopImgKey];
    UIImage* btm = [dic_split_value objectForKey:kAYControllerSplitBtmImgKey];
    
    UIImageView* topTmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, -height, SCREEN_WIDTH, height)];
    topTmp.image = top;
    UIImageView* btmTmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - height)];
    btmTmp.image = btm;
    [source.view addSubview:topTmp];
    [source.view addSubview:btmTmp];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        topTmp.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        btmTmp.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height);
        
    } completion:^(BOOL finished) {
//        [source.navigationController popViewControllerAnimated:YES];
        UINavigationController * nav = source.navigationController;
        
        [source.navigationController popViewControllerAnimated:NO];
        
        AYViewController* des = nav.viewControllers.lastObject;
        
        id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        if (tmp != nil) {
            NSMutableDictionary* dic_back =[[NSMutableDictionary alloc]init];
            [dic_back setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
            [dic_back setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
            [des performWithResult:&dic_back];
        }
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
