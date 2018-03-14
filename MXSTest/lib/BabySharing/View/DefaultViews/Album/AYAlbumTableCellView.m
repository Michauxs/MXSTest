//
//  PostTableCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "AYAlbumTableCellView.h"
#import "AlbumGridCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"

#define BORDER_MODIFY       1

@implementation AYAlbumTableCellView {
    NSMutableArray *arr;
}

//@synthesize delegate = _delegate;
@synthesize cannot_selected = _cannot_selected;
@synthesize grid_border_color = _grid_border_color;

@synthesize margin_left = _margin_left;
@synthesize margin_right = _margin_right;
@synthesize marign_between = _marign_between;
@synthesize cell_cor_radius = _cell_cor_radius;

- (AlbumGridCell*)queryGridCellByIndex:(NSInteger)index {
    return (AlbumGridCell*)[image_view objectAtIndex:index % 3];
}

- (void)setUpContentViewWithImageNames:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type {
//    views_count = [_delegate getViewsCount];
    views_count = 3;
    if (image_view == nil) {
        image_view = [[NSMutableArray alloc]initWithCapacity:views_count];
    }
    
    if (_marign_between == 0) {
        _marign_between = 1.f;
    }
    
    CGFloat screen_width = SCREEN_WIDTH - _margin_left - _margin_right - _marign_between * (views_count + 1);
    CGFloat step_width = screen_width / views_count;
    CGFloat height = step_width;
    
    for (int index = 0; index < image_view.count; ++index) {
        [((UIView*)[image_view objectAtIndex:index]) removeFromSuperview];
    }
    [image_view removeAllObjects];
    
    for (int index = 0; index < image_arr.count; ++index) {
        
        if (index > image_arr.count)
            continue;
        
        AlbumGridCell *tmp = [[AlbumGridCell alloc] initWithFrame:CGRectMake(index * (step_width + _marign_between) + _marign_between, _marign_between, step_width, height)];
        tmp.cell_cor_radius = _cell_cor_radius;
        tmp.grid_border_color = _grid_border_color;
        tmp.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSubViewTaped:)];
        tap.numberOfTapsRequired = 1;
        [tmp addGestureRecognizer:tap];
        
        id input_content = [image_arr objectAtIndex:index];
        if ([input_content isKindOfClass:[NSString class]]) {
            [tmp setShowingPhotoWithName:[image_arr objectAtIndex:index]];
        } else if ([input_content isKindOfClass:[UIImage class]]) {
            tmp.image = input_content;
        }
        
        tmp.row = row;
        tmp.col = index;
        
        if (!_cannot_selected) {
            NSNumber* iter = [NSNumber numberWithInteger:row * views_count + index];
            id<AYCommand> cmd = [self.notifies objectForKey:@"queryIsGridSelected:"];
            [cmd performWithResult:&iter];
            tmp.viewSelected = iter.boolValue;
        }

        [image_view addObject:tmp];
        [self addSubview:tmp];
    }
}

//- (void)layoutSubviews {
//    CGFloat width = CGRectGetWidth(self.frame) / 3;
//    CGFloat height = CGRectGetHeight(self.frame);
//    for (int i = 0; i < image_view.count; i++) {
//        UIView *view = [image_view objectAtIndex:i];
//        view.frame = CGRectMake(width * i, 0, width - 2, height);
//    }
//}

- (void)setUpContentViewWithImageURLs2:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type {
//    views_count = [_delegate getViewsCount];
    views_count = 3;
    if (image_view == nil) {
        image_view = [[NSMutableArray alloc]initWithCapacity:views_count];
    }
    CGFloat screen_width = SCREEN_WIDTH - _margin_left - _margin_right;
    CGFloat step_width = screen_width / views_count;
    //      CGFloat height = rc.size.height;
    CGFloat height = [AYAlbumTableCellView prefferCellHeight];
    
    for (int index = 0; index < image_view.count; ++index) {
        [((UIView*)[image_view objectAtIndex:index]) removeFromSuperview];
    }
    [image_view removeAllObjects];
    
    for (int index = 0; index < image_arr.count; ++index) {
        
        if (index > image_arr.count)
            continue;
        
//        ALAsset* at = [image_arr objectAtIndex:index];
//        UIImage* img = [UIImage imageWithCGImage:[at aspectRatioThumbnail]];
        UIImage *img = [image_arr objectAtIndex:index];
        
        
        AlbumGridCell* tmp = [[AlbumGridCell alloc]initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
        tmp.cell_cor_radius = _cell_cor_radius;
        tmp.grid_border_color = _grid_border_color;
//        if ([[at valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
//            NSNumber* duration = [at valueForProperty:ALAssetPropertyDuration];
//            [tmp setMovieDurationLayer:duration];
//        }
        tmp.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSubViewTaped:)];
        tap.numberOfTapsRequired = 1;
        [tmp addGestureRecognizer:tap];
        
        tmp.image = img;
        tmp.row = row;
        tmp.col = index;
        
        if (!_cannot_selected) {
            NSNumber* iter = [NSNumber numberWithInteger:row * views_count + index];
            id<AYCommand> cmd = [self.notifies objectForKey:@"queryIsGridSelected:"];
            [cmd performWithResult:&iter];
            tmp.viewSelected = iter.boolValue;
        }
        
        [image_view addObject:tmp];
        [self addSubview:tmp];
    }
}

//- (void)setUpContentViewWithImageURLs:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type {
////    views_count = [_delegate getViewsCount];
//    views_count = 3;
//    if (image_view == nil) {
//        image_view = [[NSMutableArray alloc]initWithCapacity:views_count];
//    }
//    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width - _margin_left - _margin_right;;
//    CGFloat step_width = screen_width / views_count;
//    CGFloat height = [AYAlbumTableCellView prefferCellHeight];
//
//    for (int index = 0; index < image_view.count; ++index) {
//        [((UIView*)[image_view objectAtIndex:index]) removeFromSuperview];
//    }
//    if (image_view == nil) {
//        image_view = [NSMutableArray array];
//    }
//    [image_view removeAllObjects];
//        
//    for (int index = 0; index < views_count; ++index) {
//        
//        if (row == 0 && index == 0) {
//            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
//            
//            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//            if (type == AlbumControllerTypePhoto) {
//                UIImage *image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Camera"] ofType:@"png"]];
//                [btn setBackgroundImage:image forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(didSelectCameraBtn) forControlEvents:UIControlEventTouchDown];
//            } else if (type == AlbumControllerTypeMovie) {
//                UIImage *image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Movie"] ofType:@"png"]];
//                [btn setBackgroundImage:image forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(didSelectMovieBtn) forControlEvents:UIControlEventTouchDown];
//            } else if (type == AlbumControllerTypeCompire) {
//                 UIImage *image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Explore"] ofType:@"png"]];
//                [btn setBackgroundImage:image forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(didSelectCompareBtn) forControlEvents:UIControlEventTouchDown];
//            } else {
//                
//            }
//            
//            [image_view addObject:btn];
//            [self addSubview:btn];
//        
//        }  else if (row == 0 && index != 0) {
//
//            if (index > image_arr.count)
//                continue;
//            
//            ALAsset* at = [image_arr objectAtIndex:index - 1];
//            UIImage* img = [UIImage imageWithCGImage:[at thumbnail]];
//            AlbumGridCell* tmp = [[AlbumGridCell alloc] initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
//            tmp.grid_border_color = _grid_border_color;
//            if ([[at valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
//                id duration = [at valueForProperty:ALAssetPropertyDuration];
//                [tmp setMovieDurationLayer:duration];
//            }
//            tmp.userInteractionEnabled = YES;
//            
//            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSubViewTaped:)];
//            tap.numberOfTapsRequired = 1;
//            [tmp addGestureRecognizer:tap];
//            
//            tmp.image = img;
//            tmp.row = row;
//            tmp.col = index;
//           
////            NSInteger iter = [_delegate indexByRow:row andCol:index];
////            if ([_delegate isSelectedAtIndex:iter]) {
//                tmp.viewSelected = YES;
////            }
//            
//            [image_view addObject:tmp];
//            [self addSubview:tmp];
//            
//        }else {
//
//            if (index > image_arr.count)
//                continue;
//            
//            ALAsset* at = [image_arr objectAtIndex:index];
//            UIImage* img = [UIImage imageWithCGImage:[at thumbnail]];
//            AlbumGridCell* tmp = [[AlbumGridCell alloc] initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
//            tmp.grid_border_color = _grid_border_color;
//            if ([[at valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
//                NSNumber* duration = [at valueForProperty:ALAssetPropertyDuration];
//                [tmp setMovieDurationLayer:duration];
//            }
//            tmp.userInteractionEnabled = YES;
//
//            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSubViewTaped:)];
//            tap.numberOfTapsRequired = 1;
//            [tmp addGestureRecognizer:tap];
//            
//            tmp.image = img;
//            tmp.row = row;
//            tmp.col = index;
//            
////            NSInteger iter = [_delegate indexByRow:row andCol:index];
////            if ([_delegate isSelectedAtIndex:iter]) {
//                tmp.viewSelected = YES;
////            }
//            
//            [image_view addObject:tmp];
//            [self addSubview:tmp];
//        }
//    }
//}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    NSLog(@"dequeue table cell");
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self != nil) {
//    }
//    return self;
//}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awake from nib");
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)prefferCellHeight {
    CGFloat screen_width = SCREEN_WIDTH;
//    return 96;
    return screen_width / 3;
}

+ (CGFloat)prefferCellHeightWithMarginLeft:(CGFloat)left Right:(CGFloat)right Margin:(CGFloat)margin {
    CGFloat screen_width = SCREEN_WIDTH - left - right - (3 + 1) * margin;
    return screen_width / 3 + margin;
}

#pragma mark -- tap actions
- (void)imageSubViewTaped:(UITapGestureRecognizer*)sender {
    id<AYCommand> cmd = [self.notifies objectForKey:@"selectedValueChanged:"];
    AlbumGridCell* tmp = (AlbumGridCell*)sender.view;
    id args = [NSNumber numberWithInteger:tmp.row * 3 + tmp.col];
    [cmd performWithResult:&args];
}

//#pragma mark -- tap actions
//
//- (void)didSelectCameraBtn {
//    [_delegate didSelectCameraBtn];
//}
//
//- (void)didSelectMovieBtn {
//    [_delegate didSelectMovieBtn];
//}
//
//- (void)didSelectCompareBtn {
//    [_delegate didSelectCompareBtn];
//}
//
//- (void)imageSubViewTaped:(id)sender {
//    UITapGestureRecognizer* tap = (UITapGestureRecognizer*)sender;
//    AlbumGridCell* ck = (AlbumGridCell*)(tap.view);
//    NSInteger index = [_delegate indexByRow:ck.row andCol:ck.col];
//   
//    if ([_delegate isAllowMultipleSelected]) {
//        if (ck.viewSelected) {
//            [_delegate didUnSelectOneImageAtIndex:index];
//            ck.viewSelected = NO;
//        } else {
//            [_delegate didSelectOneImageAtIndex:index];
//            if (_cannot_selected == NO) {
//                ck.viewSelected = YES;
//            }
//        }
//    } else {
//        [_delegate didSelectOneImageAtIndex:index];
//        if (_cannot_selected == NO) {
//            ck.viewSelected = YES;
//        }
//    }
//}

- (void)selectedAtIndex:(NSInteger)index {
//    [_delegate didSelectOneImageAtIndex:index];
    ((AlbumGridCell*)[image_view objectAtIndex:index]).viewSelected = YES;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
        _grid_border_color = [UIColor clearColor];
    }
    return self;
}

- (void)setUpReuseCell {
    //    id<AYViewBase> header = VIEW([self getViewName], [self getViewName]);
    id<AYViewBase> cell = VIEW(@"AlbumTableCell", @"AlbumTableCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

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

#pragma mark -- messages
- (id)setCellInfo:(id)obj {
    NSDictionary* dic = (NSDictionary*)obj;
    
    AYAlbumTableCellView* view  =  [dic objectForKey:kAYAlbumTableCellSelfKey];
    for (NSString* key in dic.allKeys) {
        if ([key isEqualToString:kAYAlbumTableCellMarginLeftKey]) {
            view.margin_left = ((NSNumber*)[dic objectForKey:key]).floatValue;
        } else if ([key isEqualToString:kAYAlbumTableCellMarginRightKey]) {
            view.margin_right = ((NSNumber*)[dic objectForKey:key]).floatValue;
        } else if ([key isEqualToString:kAYAlbumTableCellMarginBetweenKey]) {
            view.marign_between = ((NSNumber*)[dic objectForKey:key]).floatValue;
        } else if ([key isEqualToString:kAYAlbumTableCellGridBorderColorKey]) {
            view.grid_border_color = (UIColor*)[dic objectForKey:key];
        } else if ([key isEqualToString:kAYAlbumTableCellCanSelectedKey]) {
            view.cannot_selected = ((NSNumber*)[dic objectForKey:key]).boolValue;
        } else if ([key isEqualToString:kAYAlbumTableCellCornerRadiusKey]) {
            view.cell_cor_radius = ((NSNumber*)[dic objectForKey:key]).floatValue;
        } else if ([key isEqualToString:kAYAlbumTableCellLineViewCountKey]) {
            views_count = ((NSNumber*)[dic objectForKey:key]).intValue;
        }
    }
    
    return nil;
}

- (id)setUpItems:(id)obj {
    NSDictionary* dic = (NSDictionary*)obj;

    NSLog(@"set items %@", dic);
    
    NSArray* arr_content =  [dic objectForKey:kAYAlbumTableCellItemKey];
    AYAlbumTableCellView* view  =  [dic objectForKey:kAYAlbumTableCellSelfKey];
    int row = ((NSNumber*)[dic objectForKey:kAYAlbumTableCellRowKey]).intValue;
    AlbumControllerType act = ((NSNumber*)[dic objectForKey:kAYAlbumTableCellControllerTypeKey]).intValue;
    
//    AlbumTableCellType t = ((NSNumber*)[dic objectForKey:kAYAlbumTableCellTypeKey]).intValue;
//    switch (t) {
//        case AlbumTableCellTypeImage:
            [view setUpContentViewWithImageNames:arr_content atLine:row andType:act];
//            break;
//        case AlbumTableCellTypeUrl:
//            [self setUpContentViewWithImageURLs2:content_arr atLine:row andType:act];
//            break;
//        default:
//            break;
//    }
    
    return  nil;
}

- (id)selectAtIndex:(id)obj {
    NSInteger index = ((NSNumber*)obj).integerValue;
    [self selectedAtIndex:index % 3];
    return nil;
}

- (id)unSelectAtIndex:(id)obj {
    NSInteger index = ((NSNumber*)obj).integerValue;
    ((AlbumGridCell*)[image_view objectAtIndex:index % 3]).viewSelected = NO;
    return nil;
}

- (id)queryPerferedHeight {
    return [NSNumber numberWithFloat:[AYAlbumTableCellView prefferCellHeightWithMarginLeft:self.margin_left Right:self.margin_right Margin:self.marign_between]];
}

- (id)queryCurrentGridViewByIndex:(id)obj {
    return [self queryGridCellByIndex:((NSNumber*)obj).intValue];
}
@end
