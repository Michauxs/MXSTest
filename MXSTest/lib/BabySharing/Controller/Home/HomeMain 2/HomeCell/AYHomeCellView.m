//
//  HomeCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "AYHomeCellView.h"
#import "Tools.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
//#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagEnumDefines.h"
#import "QueryContentTag.h"
#import "QueryContentChaters.h"
#import "QueryContent+ContextOpt.h"
#import "AppDelegate.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYHomeCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "Masonry.h"

#import "AYThumbsAndPushDefines.h"

#import "InsetsLabel.h"
#import "OBShapedButton.h"

@interface AYHomeCellView ()
@property (nonatomic) NSInteger cell_index;

@property (nonatomic, strong, readonly) UIImageView *ownerImage;
@property (nonatomic, strong, readonly) UILabel *ownerNameLable;
//@property (nonatomic, strong, readonly) InsetsLabel *ownerRole;
@property (nonatomic, strong, readonly) UIButton *ownerRole;
@property (nonatomic, strong, readonly) UILabel *ownerRoleLabel;
@property (nonatomic, strong, readonly) UILabel *ownerDate;
@property (nonatomic, strong, readonly) UIImageView *mainImage;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UIImageView *firstImage;
@property (nonatomic, strong, readonly) UIImageView *secondImage;
@property (nonatomic, strong, readonly) UIImageView *thirdImage;
@property (nonatomic, strong, readonly) UILabel *talkerCount;
@property (nonatomic, strong, readonly) UITextField *jionGroup;
@property (nonatomic, strong, readonly) UIImageView *videoSign;

@property (nonatomic, strong, readonly) UIButton *crimeBtn;

@property (nonatomic, strong, readonly) QueryContentItem *queryContentItem;

@property (nonatomic, weak, setter=setCurrentContent:) QueryContent *content;

@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYHomeCellView {
    UIView *praiseView;
    UIView *pushView;
    UIImageView *jionImage;
    UIView *lineView;
    UIView *jionGroupView;
    NSInteger indexChater;
    CGFloat originX;
    NSString *nameString;
    NSString *roleString;
    
    BOOL isSetupViews;
}

@synthesize filterView = _filterView;
@synthesize cell_index = _cell_index;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indexPath = indexPath;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        isSetupViews = NO;
        
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)setCurrentContent:(QueryContent*)content {
    _content = content;
    
    if (!isSetupViews) {
        [self setUpViews];
    }
}

- (void)setUpViews {
    _ownerImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_ownerImage];
    
    _ownerNameLable = [[UILabel alloc] init];
    _ownerNameLable.text = nameString;
    _ownerNameLable.font = [UIFont systemFontOfSize:14.f];
    _ownerNameLable.textColor = TextColor;
    [self.contentView addSubview:_ownerNameLable];
    
    
    _ownerRole = [[UIButton alloc]init];
    //    [_ownerRole setInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
    _ownerRole.userInteractionEnabled = NO;
    //    UIImage *bg = PNGRESOURCE(@"login_role_bg");
    UIImage *bg = [UIImage imageNamed:@"login_role_bg2"];
    //    NSInteger leftCapWidth = bg.size.width * 0.5f;
    //    NSInteger topCapHeight = bg.size.height * 0.5f;
    //    bg = [bg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    //    bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(bg.size.width * 0.2, 0, bg.size.width * 0.3, bg.size.height) resizingMode:UIImageResizingModeStretch];
    bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 10) resizingMode:UIImageResizingModeStretch];
    [_ownerRole setBackgroundImage:bg forState:UIControlStateNormal];
    
    //    _ownerRole.text = @"";
    //    _ownerRole.layer.masksToBounds = YES;
    //    _ownerRole.layer.cornerRadius = 3;
    //    _ownerRole.layer.shouldRasterize = YES;
    //    _ownerRole.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //    _ownerRoleLabel.backgroundColor = [Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0];
    //    _ownerRoleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_ownerRole];
    
    _ownerRoleLabel = [[UILabel alloc]init];
    _ownerRoleLabel.text = roleString;
    _ownerRoleLabel.textColor = [UIColor whiteColor];
    _ownerRoleLabel.font = [UIFont systemFontOfSize:12];
    [_ownerRole addSubview:_ownerRoleLabel];
    
    
    _ownerDate = [[UILabel alloc] init];
    _ownerDate.font = [UIFont systemFontOfSize:11];
    _ownerDate.textAlignment = NSTextAlignmentRight;
    _ownerDate.textColor = TextColor;
    [self.contentView addSubview:_ownerDate];
    [self bringSubviewToFront:_ownerDate];
    
    _mainImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_mainImage];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont systemFontOfSize:15.0];
    _descriptionLabel.textColor = TextColor;
    [self.contentView addSubview:_descriptionLabel];
    
    _crimeBtn = [[UIButton alloc]init];
    [_crimeBtn setImage:[UIImage imageNamed:@"tips_off_black"] forState:UIControlStateNormal];
    [_crimeBtn addTarget:self action:@selector(crimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_crimeBtn];
    
    // 中间的一条线
    lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [Tools colorWithRED:231.0 GREEN:231.0 BLUE:231.0 ALPHA:1.0];
    
    _firstImage = [[UIImageView alloc] init];
    _firstImage.tag = 1;
    _firstImage.clipsToBounds = YES;
    
    [self.contentView addSubview:_firstImage];
    _secondImage = [[UIImageView alloc] init];
    _secondImage.tag = 2;
    _secondImage.clipsToBounds = YES;
    
    [self.contentView addSubview:_secondImage];
    _thirdImage = [[UIImageView alloc] init];
    _thirdImage.tag = 3;
    _thirdImage.clipsToBounds = YES;
    
    [self.contentView addSubview:_thirdImage];
    _talkerCount = [[UILabel alloc] init];
    _talkerCount.text = @"没有返回圈聊人数";
    _talkerCount.font = [UIFont systemFontOfSize:12];
    _talkerCount.textColor = TextColor;
    [self.contentView addSubview:_talkerCount];
    [self.contentView bringSubviewToFront:_talkerCount];
    
    _jionGroup = [[UITextField alloc] init];
    _jionGroup.enabled = YES;
    _jionGroup.font = [UIFont systemFontOfSize:12];
    _jionGroup.text = @"  加入圈聊";
    _jionGroup.textColor = TextColor;
    [self.contentView addSubview:_jionGroup];
    jionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    jionImage.image = PNGRESOURCE(@"home_chat");
    _jionGroup.leftView = jionImage;
    _jionGroup.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:_jionGroup];
    
    jionGroupView = [[UIView alloc] init];
    jionGroupView.alpha = 0.1;
    jionGroupView.backgroundColor = [UIColor whiteColor];
    [_jionGroup addSubview:jionGroupView];
    // 播放按钮
    _videoSign = [[UIImageView alloc] init];
    UIImage *image = PNGRESOURCE(@"playvideo");
    _videoSign.image = image;
    _videoSign.frame = CGRectMake(0, 0, 30, 30);
    [_mainImage addSubview:_videoSign];
    
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowOpacity = 0.25;
    self.contentView.layer.shadowRadius = 2;
    self.contentView.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.backgroundColor = [Tools colorWithRED:242.0 GREEN:242.0 BLUE:242.0 ALPHA:1.0];
    self.contentView.backgroundColor = [UIColor whiteColor];
    // 加入动作
    _ownerImage.userInteractionEnabled = YES;
    [_ownerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherInfo)]];
    
    _mainImage.userInteractionEnabled = YES;
    [_mainImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainImageTap)]];
    
    [_jionGroup addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jionGroupTap)]];
    
    [self setRoundCorner];
    isSetupViews = YES;
}

- (void)setUplayout {
    self.contentView.frame = CGRectMake(12.5, 10.5, CGRectGetWidth(self.contentView.frame) - 25, CGRectGetHeight(self.contentView.frame) - 10.5);
    [_ownerImage sizeToFit];
    _ownerImage.frame = CGRectMake(8, 8, 32, 32);
    
    [_ownerNameLable sizeToFit];
    
    _ownerNameLable.frame = CGRectMake(CGRectGetMaxX(_ownerImage.frame) + 10, CGRectGetMidY(_ownerImage.frame)- _ownerNameLable.bounds.size.height*0.5, _ownerNameLable.bounds.size.width, _ownerNameLable.bounds.size.height);
    
    [_ownerDate sizeToFit];
    [_ownerDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ownerNameLable);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_ownerRoleLabel sizeToFit];
    CGFloat name_w = CGRectGetWidth(_ownerNameLable.bounds);
    CGFloat role_w = CGRectGetWidth(_ownerRoleLabel.bounds) + 14;
    
#define self_w  self.frame.size.width
#define MARGIN  10+10.5+10+80
    
    if ((32 + name_w + role_w + MARGIN) > self.frame.size.width) {
        
        CGFloat role_afterLimit = self_w - (32 + name_w + MARGIN);
        CGFloat min_role_limit = 45;
        
        if (role_w < min_role_limit) {
            CGFloat name_afterLimit = self_w - (32 + role_w + MARGIN);
            _ownerNameLable.frame = CGRectMake(_ownerNameLable.frame.origin.x, _ownerNameLable.frame.origin.y, name_afterLimit, _ownerNameLable.bounds.size.height);
            _ownerRole.frame = CGRectMake(_ownerNameLable.frame.origin.x + _ownerNameLable.bounds.size.width +10 , 14, role_w, 20 );
        }
        else{
            _ownerNameLable.frame = CGRectMake(_ownerNameLable.frame.origin.x, _ownerNameLable.frame.origin.y, name_w, _ownerNameLable.bounds.size.height);
            _ownerRole.frame = CGRectMake(_ownerNameLable.frame.origin.x + _ownerNameLable.bounds.size.width +10 ,14, role_afterLimit, 20);
        }
    }else
    {
        _ownerRole.frame = CGRectMake(_ownerNameLable.frame.origin.x + _ownerNameLable.bounds.size.width +10, 14, role_w, 20);
    }
    
    [_ownerRoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ownerRole);
        make.left.equalTo(_ownerRole).offset(10);
        make.right.equalTo(_ownerRole).offset(-4);
    }];
    
    [_mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ownerImage.mas_bottom).offset(8);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-128);
    }];
    
    [_videoSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10.5);
        make.top.equalTo(_mainImage.mas_top).offset(10.5);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainImage.mas_bottom).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@18);
    }];
    
    //********praiseView
    [praiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionLabel.mas_bottom).offset(14);
        make.left.equalTo(self.contentView).offset(17);
        make.width.equalTo(@45);
        make.height.equalTo(@22);
    }];
    //*****************
    
    //********pushImage
    [pushView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(praiseView);
        make.left.equalTo(praiseView.mas_right).offset(40);
        make.size.equalTo(praiseView);
    }];
    //************
    
    [_crimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pushView);
        make.right.equalTo(self.contentView).offset(-22.f);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pushView.mas_bottom).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    
    [_firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@28);
        make.height.equalTo(@28);
    }];
    
    [_secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstImage);
        make.left.equalTo(_firstImage).offset(22);
        make.size.equalTo(_firstImage);
    }];
    
    [_thirdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_secondImage);
        make.left.equalTo(_secondImage).offset(22);
        make.size.equalTo(_secondImage);
    }];
    
    [self.contentView bringSubviewToFront:_thirdImage];
    [self.contentView bringSubviewToFront:_secondImage];
    [self.contentView bringSubviewToFront:_firstImage];
    
    [_talkerCount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstImage);
        make.left.equalTo(self.contentView.mas_left).offset(originX);
    }];
    
    [_jionGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstImage);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@85);
        make.height.equalTo(@26);
    }];
    
    [jionGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_jionGroup);
        make.left.equalTo(_jionGroup);
        make.size.equalTo(_jionGroup);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUplayout];
}

- (void)setRoundCorner {
    // 圆角
    CGFloat radius = 14.f;
    CGFloat ownerImageRadius = 16.f;
    _ownerImage.layer.cornerRadius = ownerImageRadius;
    _ownerImage.layer.masksToBounds = YES;
    _ownerImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25].CGColor;
    _ownerImage.layer.borderWidth = 2;
    self.ownerImage.layer.shouldRasterize = YES;
    self.ownerImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    _thirdImage.layer.cornerRadius = radius;
    _thirdImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25 ].CGColor;
    _thirdImage.layer.borderWidth = 2.0;
    _secondImage.layer.cornerRadius = radius;
    _secondImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25 ].CGColor;
    _secondImage.layer.borderWidth = 2.0;
    self.secondImage.layer.shouldRasterize = YES;
    self.secondImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _firstImage.layer.cornerRadius = radius;
    _firstImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25 ].CGColor;
    _firstImage.layer.borderWidth = 2.0;
    self.firstImage.layer.shouldRasterize = YES;
    self.firstImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)updateViewWith:(QueryContent *)content {
    
    self.content = content;
    
    [self resetLikeBtn:self];
    [self resetPushBtn:self];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd_download = [f.commands objectForKey:@"DownloadUserFiles"];
    
    _firstImage.hidden = YES;
    _secondImage.hidden = YES;
    _thirdImage.hidden = YES;
    
    originX = 10;
    indexChater = 0;
    if (self.content.chaters.count > 0) {
        for (QueryContentChaters *chater in self.content.chaters) {
            if (indexChater == 3) {
                break;
            }
            UIImageView *imageView = [self.contentView viewWithTag:++indexChater];
            imageView.image = IMGRESOURCE(@"default_user");
            imageView.hidden = NO;
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:chater.chaterImg forKey:@"image"];
            [dic setValue:@"img_icon" forKey:@"expect_size"];
            [cmd_download performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                if (img != nil) {
                    imageView.image = img;
                }
            }];
        }
        originX = originX + (indexChater) * 28 + 10 - (indexChater - 1) * 5;
    }
    
    self.ownerNameLable.text = content.owner_name;
    self.descriptionLabel.text = content.content_description;
    self.ownerRoleLabel.text = content.owner_role;
    self.ownerDate.text = [Tools compareCurrentTime:content.content_post_date];
    if ((unsigned long)self.content.chaters.count > 3) {
        NSLog(@"MonkeyHengLog: %lu === %d, %@", (unsigned long)self.content.chaters.count, self.content.group_chat_count.intValue, self.content.content_post_id);
    }
    self.talkerCount.text = [NSString stringWithFormat:@"%lu人正在圈聊", (unsigned long)(self.content.chaters == nil ? 0 : self.content.chaters.count)];
    
    // 设置头像
    self.ownerImage.image = IMGRESOURCE(@"default_user");// [UIImage imageNamed:defaultHeadPath];
    
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.content.owner_photo forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    [cmd_download performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        self.ownerImage.image = img;
    }];
    
    // 设置大图
    for (QueryContentItem *item in self.content.items) {
        if (item.item_type.unsignedIntegerValue != PostPreViewMovie) {
            
            self.mainImage.image = PNGRESOURCE(@"chat_mine_bg"); //  [UIImage imageNamed:defaultMainPath];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:item.item_name forKey:@"image"];
            [dic setValue:@"img_desc" forKey:@"expect_size"];
            [cmd_download performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                self.mainImage.image = img;
            }];
            break;
        }
    }
    _videoSign.hidden = YES;
    _queryContentItem = nil;
    for (QueryContentItem *item in self.content.items) {
        if (item.item_type.unsignedIntegerValue == PostPreViewMovie) {
            _queryContentItem = item;
            _videoSign.hidden = NO;
        }
    }
    
    for (int index = kAYPhotoTagViewTag; index < kAYPhotoTagViewTag + TagTypeBrand + 1; ++index) {
        UIView* tmp = [_mainImage viewWithTag:index];
        [tmp removeFromSuperview];
    }
    
    id<AYCommand> cmd = COMMAND(@"Module", @"PhotoTagInit");
    QueryContent *tmp = (QueryContent*)_content;
    for (QueryContentTag *tag in tmp.tags) {
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:[NSNumber numberWithFloat:self.bounds.size.width] forKey:@"width"];
        [args setValue:[NSNumber numberWithFloat:self.bounds.size.height - 192] forKey:@"height"];
        [args setValue:tag.tag_offset_x forKey:@"offsetX"];
        [args setValue:tag.tag_offset_y forKey:@"offsetY"];
        [args setValue:tag.tag_content forKey:@"tag_text"];
        [args setValue:tag.tag_type forKey:@"tag_type"];
        
        UIView* view = nil;
        [cmd performWithResult:&args];
        view = (UIView*)args;
        
        [_mainImage addSubview:view];
    }
    
    //脉冲动画开始
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTagAnimation" object:nil];
}

- (void)changeMovie:(NSURL*)path {
    NSLog(@"start to play movie at home cell");
    
    if (path) {
        id<AYFacadeBase> f = MOVIEPLAYER;
        if (self.filterView == nil) {
            id<AYCommand> cmd_view = [f.commands objectForKey:@"MovieDisplayView"];
            id url = path;
            [cmd_view performWithResult:&url];
            
            self.filterView = url;
            
            self.filterView.frame = CGRectMake(0, 0, CGRectGetWidth(_mainImage.frame), CGRectGetHeight(_mainImage.frame));
            [_mainImage addSubview:self.filterView];
        }
        
        self.filterView.hidden = NO;
        id<AYCommand> cmd_play = [f.commands objectForKey:@"PlayMovie"];
        id url = path;
        [cmd_play performWithResult:&url];
    }
}

- (void)mainImageTap {
    if (_queryContentItem != nil) { //&& _gpuImageMovie.progress == 0) {
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd_download = [f.commands objectForKey:@"DownloadMovieFiles"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_queryContentItem.item_name forKey:@"name"];
        
        [cmd_download performWithResult:[dic copy] andFinishBlack:^(BOOL succcess, NSDictionary * result) {
            NSURL* path = (NSURL*)result;
            _videoSign.hidden = YES;
            [self changeMovie:path];
        }];
    }
}

- (void)stopViedo {
    NSLog(@"end to play movie at home cell");
    _videoSign.hidden = NO;
    
    id<AYFacadeBase> f = MOVIEPLAYER;
    id<AYCommand> cmd = [f.commands objectForKey:@"ReleaseMovie"];
    id url = [TmpFileStorageModel enumFileWithName:_queryContentItem.item_name andType:_queryContentItem.item_type.unsignedIntegerValue withDownLoadFinishBlock:nil];
    if (url != nil) {
        [cmd performWithResult:&url];
    }
    [self.filterView removeFromSuperview];
}

- (void)jionGroupTap {
    NSLog(@"加入圈聊");
    id<AYCommand> cmd = [self.notifies objectForKey:@"joinGroup:"];
    id args = self.content;
    [cmd performWithResult:&args];
}

- (void)otherInfo {
    id<AYCommand> cmd = [self.notifies objectForKey:@"showUserInfo:"];
    QueryContent* args = _content;
    [cmd performWithResult:&args];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYHomeCellName, kAYHomeCellName);
    
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
- (id)willDisappear:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    [cell stopViedo];
    
    return nil;
}

- (id)resetContent:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    QueryContent* content = [dic objectForKey:kAYHomeCellContentKey];
    cell.cell_index = ((NSNumber*)[dic objectForKey:kAYHomeCellCellIndexKey]).integerValue;
    [cell updateViewWith:content];
    return nil;
}

- (id)queryContentCellHeight {
    return [NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.height - 60 - 44 - 35];
}

- (id)resetLike:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    NSNumber* like_result = [dic objectForKey:kAYThumbsPushBtnContentResultKey];
    
    cell.content.isLike = like_result;
    
    [self resetLikeBtn:cell];
    [self setNeedsLayout];
    return nil;
}

- (id)queryPostId:(NSString*)postid{
    return self.content.content_post_id;
}

- (void)resetLikeBtn:(AYHomeCellView*)cell {
    [praiseView removeFromSuperview];
    praiseView = nil;
    
    id<AYCommand> cmd = MODULE(@"ThumbsAndPushInit");
    NSNumber* thumbs = [NSNumber numberWithInteger:cell.content.isLike.integerValue];
    [cmd performWithResult:&thumbs];
    
    id<AYViewBase> tmp_thumbs =  (id<AYViewBase>)thumbs;
    tmp_thumbs.controller = cell.controller;
    id<AYCommand> cmd_thumbs = [tmp_thumbs.commands objectForKey:@"changeBtnConnectInfo:"];
    NSMutableDictionary* thumbs_args = [[NSMutableDictionary alloc]init];
    [thumbs_args setValue:_content.content_post_id forKey:kAYThumbsPushBtnContentIDKey];
    [thumbs_args setValue:[NSNumber numberWithFloat:cell.cell_index] forKey:kAYThumbsPushBtnContentIndexKey];
    [cmd_thumbs performWithResult:&thumbs_args];
    
    praiseView = (UIView*)thumbs;
    [self.contentView addSubview:praiseView];
}

- (id)resetPush:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    NSNumber* push_result = [dic objectForKey:kAYThumbsPushBtnContentResultKey];
    
    cell.content.isPush = push_result;
    
    [self resetPushBtn:cell];
    [self setNeedsLayout];
    return nil;
}

- (void)resetPushBtn:(AYHomeCellView*)cell {
    [pushView removeFromSuperview];
    pushView = nil;
    
    id<AYCommand> cmd = MODULE(@"ThumbsAndPushInit");
    NSNumber* pushed = [NSNumber numberWithInteger:cell.content.isPush.integerValue + 2];
    [cmd performWithResult:&pushed];
    
    id<AYViewBase> tmp_push =  (id<AYViewBase>)pushed;
    tmp_push.controller = cell.controller;
    id<AYCommand> cmd_push = [tmp_push.commands objectForKey:@"changeBtnConnectInfo:"];
    NSMutableDictionary* thumbs_args = [[NSMutableDictionary alloc]init];
    [thumbs_args setValue:_content.content_post_id forKey:kAYThumbsPushBtnContentIDKey];
    [thumbs_args setValue:[NSNumber numberWithFloat:cell.cell_index] forKey:kAYThumbsPushBtnContentIndexKey];
    [cmd_push performWithResult:&thumbs_args];
    
    pushView = (UIView*)pushed;
    [self.contentView addSubview:pushView];
}

-(void)crimeBtnClick{
    id<AYCommand> cmd = [self.notifies objectForKey:@"crimeReport:"];
    NSString *post_id = self.content.content_post_id;
    [cmd performWithResult:&post_id];
}

@end
