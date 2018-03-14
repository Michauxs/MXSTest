
//
//  ViewController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "AYEditPhotosController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define kMaxImagesCount             9

static NSString* const defaultKeyIsHadSignedTips =      @"default_key_IsHadSignedTips";

@implementation AYEditPhotosController{
    BOOL isPush;
    
    NSMutableArray *selectedPhotos;
    //    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    LxGridViewFlowLayout *_layout;
    
    NSArray *servicePhotoNames;
    BOOL isAllImageDownload;
    
    NSInteger networkImageCount;    
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSArray *items = [dic objectForKey:kAYControllerChangeArgsKey];
        id item = [items firstObject];
        if ([item isKindOfClass:[UIImage class]]) {
            selectedPhotos = [NSMutableArray arrayWithArray:items];
            networkImageCount = selectedPhotos.count;
//            _selectedAssets = [NSMutableArray arrayWithArray:setedPhotos];
        }
        
        if ([item isKindOfClass:[NSString class]]) {
            servicePhotoNames = [NSArray arrayWithArray:items];
        }
        
        isPush = YES;
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *tipsView = [self.views objectForKey:@"TipsCollection"];
    [self.view bringSubviewToFront:tipsView];
    tipsView.hidden = YES;
    
    if (!isPush) {
        NSUserDefaults *default_info = [NSUserDefaults standardUserDefaults];
        BOOL isHadSignedTips = [default_info boolForKey:defaultKeyIsHadSignedTips];
        if (!isHadSignedTips) {
            kAYViewsSendMessage(@"TipsCollection", @"showTipsView", nil)
            tipsView.hidden = NO;
        }else {
            [self showActionSheet];
        }
        
        isPush = YES;
    }
    
//    if (!_selectedAssets) {
//        _selectedAssets = [NSMutableArray array];
//    }
    
    if (!selectedPhotos) {
        selectedPhotos = [NSMutableArray array];
    }
    
    [self configCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)showActionSheet {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"图片展示";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
    
	[self setNavRightBtnEnableStatus];
	
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil)
    return nil;
}

- (void)setNavRightBtnEnableStatus {
	if (selectedPhotos.count == 0 || !selectedPhotos) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:NavBarRightBtnFontSize backgroundColor:nil];
		bar_right_btn.userInteractionEnabled = NO;
		kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnWithBtn:", &bar_right_btn)
	} else {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:NavBarRightBtnFontSize backgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnWithBtn:", &bar_right_btn)
	}
}

- (id)TipsCollectionLayout:(UIView*)view {
    view.frame = self.view.frame;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    return nil;
}

#pragma mark -- actions
- (void)configCollectionView {
    
    _layout = [[LxGridViewFlowLayout alloc] init];
    
    CGFloat margin = 2;
    _layout.minimumInteritemSpacing = margin;
    _layout.minimumLineSpacing = margin;
    
    _layout.itemCount = selectedPhotos.count;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [Tools whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [self.view sendSubviewToBack:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
}

#pragma mark -- UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (selectedPhotos.count == 0 && !servicePhotoNames) {
        return 2;
    }
    else
        return selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic_cell_info = [[NSMutableDictionary alloc]init];
    [dic_cell_info setValue:[NSNumber numberWithBool:NO] forKey:@"is_hidden"];
    [dic_cell_info setValue:[NSNumber numberWithBool:NO] forKey:@"is_first"];
    
    if (selectedPhotos.count == 0 && !servicePhotoNames) {
        if (indexPath.row == 1) {
            [dic_cell_info setValue:[UIImage imageNamed:@"AlbumAddBtn.png"] forKey:@"image"];
            [dic_cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_hidden"];
        } else {
            [dic_cell_info setValue:[UIImage imageNamed:@""] forKey:@"image"];
            [dic_cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_hidden"];
            
        }
    }
    else {
        
        if (indexPath.row == selectedPhotos.count) {
            
            [dic_cell_info setValue:[UIImage imageNamed:@"AlbumAddBtn.png"] forKey:@"image"];
            [dic_cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_hidden"];
        } else {
            
            [dic_cell_info setValue:selectedPhotos[indexPath.row] forKey:@"image"];
            [dic_cell_info setValue:[NSNumber numberWithBool:NO] forKey:@"is_hidden"];
            
        }
    }
    
    if (indexPath.row == 0) {
        [dic_cell_info setValue:[NSNumber numberWithBool:YES] forKey:@"is_first"];
    }
    
    [dic_cell_info setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"tag_index"];
    cell.cellInfo = dic_cell_info;
	
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == selectedPhotos.count || selectedPhotos.count == 0) {
        if (selectedPhotos.count >= 9) {
            NSString *title = @"您无法再添加更多的照片了";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSetCoverAtIndexPath:(NSIndexPath *)indexPath {
    [selectedPhotos exchangeObjectAtIndex:indexPath.item withObjectAtIndex:0];
    [_collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    [_collectionView performBatchUpdates:^{
        
        UIImage *dataDict = selectedPhotos[sourceIndexPath.item];
        [selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [selectedPhotos insertObject:dataDict atIndex:destinationIndexPath.item];
        
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许-咚哒-访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount - selectedPhotos.count delegate:self];
    
    //四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
//    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 是否显示拍照按钮
    
    // 2. 在这里设置imagePickerVc的外观
     imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
     imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [selectedPhotos removeObjectAtIndex:sender.tag];
//    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    NSInteger numbCount = selectedPhotos.count;
    if (numbCount == 0) {
        [_collectionView reloadData];
		[self setNavRightBtnEnableStatus];
    } else {
        _layout.itemCount = numbCount;
        
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    }
}

#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
     NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [selectedPhotos addObject:image];
        _layout.itemCount = selectedPhotos.count;
        [_collectionView reloadData];
		
		[self setNavRightBtnEnableStatus];
		
        // 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            
            [tzImagePickerVc hideProgressHUD];
            
//            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
////                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
////                    [tzImagePickerVc hideProgressHUD];
//////                    TZAssetModel *assetModel = [models firstObject];
//////                    TZAssetModel *assetModel = [models lastObject];
//////                    [_selectedAssets addObject:assetModel.asset];
////                    [selectedPhotos addObject:image];
////                    [_collectionView reloadData];
////                    
////                }];
//            }];
        }];
    }
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
	
//    NSArray *subArrNetworkImage = [_selectedPhotos subarrayWithRange:NSMakeRange(0, networkImageCount)];
//    _selectedPhotos = [NSMutableArray arrayWithArray:subArrNetworkImage];
    [selectedPhotos addObjectsFromArray:photos];
	
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = selectedPhotos.count;
    [_collectionView reloadData];
	
	[self setNavRightBtnEnableStatus];
	
}

/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
//    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = selectedPhotos.count;
    [_collectionView reloadData];
}

#pragma mark -- collectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat margin = 2;
    CGFloat itemWH = (SCREEN_WIDTH - margin * 3) / 3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (indexPath.row == 0) {
        return CGSizeMake(width, 250);
        
    } else {
        return CGSizeMake(itemWH, itemWH);
    }
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
//    if (selectedPhotos.count == 0) {
//        NSString *title = @"您未选择图片,返回上一页请点击返回";
//        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        return nil;
//    }
	
    NSArray *cover = [selectedPhotos copy];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:cover forKey:@"content"];
    [dic_info setValue:@"nap_cover" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)hideTipsView {
    
    NSUserDefaults *default_info = [NSUserDefaults standardUserDefaults];
    [default_info setBool:YES forKey:defaultKeyIsHadSignedTips];
    
    UIView *tipsView = [self.views objectForKey:@"TipsCollection"];
    tipsView.hidden = YES;
    
    [self showActionSheet];
    
    return nil;
}
@end
