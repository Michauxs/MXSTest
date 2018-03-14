//
//  AYPushSplitAnimationCommand.m
//  BabySharing
//
//  Created by BM on 9/2/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPushSplitAnimationCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"


@implementation AYPushSplitAnimationCommand

@synthesize para = _para;

- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"push command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    CGFloat height = ((NSNumber*)[dic objectForKey:kAYControllerSplitHeightKey]).floatValue;
    if (height == 0)
        height = SCREEN_HEIGHT / 2;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushSplitValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"push command 只能出来push 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"push command source controler 必须是一个navigation controller" userInfo:nil];
    }
    
    UIImage* img = [Tools SourceImageWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) fromView:des.view];
    UIImage* btm = nil;
    UIImage* top = [Tools splitImage:img from:height left:&btm];
    
    [source.view addSubview:des.view];
    UIImageView* topTmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    topTmp.image = top;
    UIImageView* btmTmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height)];
    btmTmp.image = btm;
    [source.view addSubview:topTmp];
    [source.view addSubview:btmTmp];
    
    des.hidesBottomBarWhenPushed = YES;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        topTmp.frame = CGRectMake(0, -height, SCREEN_WIDTH, height);
        btmTmp.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - height);
        
    } completion:^(BOOL finished) {
        [source.navigationController pushViewController:des animated:NO];
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        if (tmp != nil) {
            [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        }
        
        NSMutableDictionary* dic_split = [[NSMutableDictionary alloc]init];
        [dic_split setValue:[NSNumber numberWithFloat:height] forKey:kAYControllerSplitHeightKey];
        [dic_split setValue:top forKey:kAYControllerSplitTopImgKey];
        [dic_split setValue:btm forKey:kAYControllerSplitBtmImgKey];
        
        [dic_init setValue:[dic_split copy] forKey:kAYControllerSplitValueKey];
        [des performWithResult:&dic_init];
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
