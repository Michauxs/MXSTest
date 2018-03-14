//
//  AYOneProfileController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOneProfileController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"


#define QUERY_VIEW_MARGIN_LEFT      10.5
#define QUERY_VIEW_MARGIN_RIGHT     QUERY_VIEW_MARGIN_LEFT
#define QUERY_VIEW_MARGIN_UP        STATUS_BAR_HEIGHT
#define QUERY_VIEW_MARGIN_BOTTOM    0

#define HEADER_VIEW_HEIGHT          183

#define MARGIN_LEFT                 10.5
#define MARGIN_RIGHT                10.5

#define SEG_CTR_HEIGHT              49
#define userPhotoInitHeight         250

@implementation AYOneProfileController {
    
    NSString* owner_id;
	NSDictionary *brandData;
	
    UIImageView *coverImg;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        owner_id = [dic objectForKey:kAYControllerChangeArgsKey];
        brandData = [dic objectForKey:kAYControllerChangeArgsKey];
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OneProfile"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSArray *arr_cell_name = @[@"AYOneProfileCellView"];
	for (NSString *cell_name in arr_cell_name) {
		id class_name = [cell_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name);
	}
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_table;
    coverImg = [[UIImageView alloc]init];
	NSString *img = [NSString stringWithFormat:@"avatar_%d", arc4random()%10];
	coverImg.image = IMGRESOURCE(img);
    coverImg.backgroundColor = [UIColor lightGrayColor];
    coverImg.contentMode = UIViewContentModeScaleAspectFill;
    coverImg.clipsToBounds = YES;
    [tableView addSubview:coverImg];
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView).offset(- userPhotoInitHeight);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, userPhotoInitHeight));
    }];
	
	CGFloat tagWidth = 72;
	NSString *tag = [brandData objectForKey:kAYBrandArgsTag];
	UILabel *BrandTagLabel = [UILabel creatLabelWithText:tag textColor:[UIColor white] fontSize:635 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[BrandTagLabel setRadius:72*0.5 borderWidth:2 borderColor:[UIColor colorWithWhite:1 alpha:0.28] background:[UIColor clearColor]];
	[tableView addSubview:BrandTagLabel];
	[BrandTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(coverImg);
		make.size.mas_equalTo(CGSizeMake(tagWidth, tagWidth));
	}];
	
	id tmp = [brandData copy];
	kAYDelegatesSendMessage(@"OneProfile", @"changeQueryData:", &tmp)
//	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	NSString *title = [brandData objectForKey:kAYBrandArgsName];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	
//	NSMutableDictionary* dic = [Tools getBaseRemoteData];
////	NSString* owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
//	[[dic objectForKey:kAYCommArgsCondition] setValue:owner_id  forKey:kAYCommArgsUserID];
//
//	id<AYFacadeBase> facade = [self.facades objectForKey:@"ProfileRemote"];
//	AYRemoteCallCommand* cmd = [facade.commands objectForKey:@"QueryUserProfile"];
//	[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
//        if (success) {
//			NSDictionary *info_prifole = [result objectForKey:kAYProfileArgsSelf];
//
//            id tmp = [info_prifole copy];
//            kAYDelegatesSendMessage(@"OneProfile", @"changeQueryData:", &tmp)
//            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
//
//            NSString *title = [info_prifole objectForKey:@"screen_name"];
//            kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
//
//            NSString* photo_name = [info_prifole objectForKey:@"screen_photo"];
//			if(photo_name) {
//				id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//				AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//				NSString *prefix = cmd.route;
//				[coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photo_name]] placeholderImage:IMGRESOURCE(@"default_image")];
//			}
//        }
//    }];
	
	UIButton *closeBtn = [[UIButton alloc]init];
	[closeBtn setImage:IMGRESOURCE(@"map_icon_close") forState:UIControlStateNormal];
	[self.view addSubview:closeBtn];
	[closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(25);
		make.left.equalTo(self.view).offset(10);
		make.size.mas_equalTo(CGSizeMake(51, 51));
	}];
	[closeBtn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(userPhotoInitHeight, 0, 0, 0);
	((UITableView*)view).estimatedRowHeight = 300;
	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"看护妈妈";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"content_close");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIImage *right = IMGRESOURCE(@"tips_off_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnImgMessage, &right)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报该用户", nil];
    [sheet showInView:self.view];
    
    return nil;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        NSMutableDictionary *expose = [[NSMutableDictionary alloc]init];
        [expose setValue:[NSNumber numberWithInt:0] forKey:@"expose_type"];
        [expose setValue:owner_id forKey:@"user_id"];
        
        id<AYFacadeBase> expose_remote = [self.facades objectForKey:@"ExposeRemote"];
        AYRemoteCallCommand* cmd = [expose_remote.commands objectForKey:@"ExposeUser"];
		[[AYRemoteCallManager shared] performWithRemoteCmd:cmd andArgs:[expose copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//        [cmd performWithResult:expose andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
				NSString *title = @"我们将尽快审查您举报的用户！\n感谢您的监督和支持！";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//					dispatch_async(dispatch_get_main_queue(), ^{
//					});
//				});
            } else {
                
            }
        }];
    } else  {
        
    }
}

- (id)didAllContent {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ContentList");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)relationChanged:(id)args {
    NSNumber* new_relations = (NSNumber*)args;
    NSLog(@"new relations %@", new_relations);
    
    id<AYViewBase> view_header = [self.views objectForKey:@"ProfileHeader"];
    id<AYCommand> cmd = [view_header.commands objectForKey:@"changeRelations:"];
    [cmd performWithResult:&new_relations];
    
    return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
    CGFloat offset_y = args.floatValue;
    CGFloat offsetH = userPhotoInitHeight + offset_y;
    
    if (offsetH < 0) {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        UITableView *tableView = (UITableView*)view_notify;
        
        [coverImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(- userPhotoInitHeight + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH , userPhotoInitHeight - offsetH));
            
            //            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
            //            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH * offsetH / kFlexibleHeight), kFlexibleHeight - offsetH));
        }];
    }
    return nil;
}
#pragma mark -- status

@end
