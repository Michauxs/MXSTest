//
//  AYSetServiceCapacityCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceCapacityCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYSetServiceCapacityCellView {
    
    UILabel *titleLabel;
    UILabel *countLabel;
    NSNumber *index;
    int countNumb;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CALayer *separator = [CALayer layer];
        CGFloat margin = 20;
        separator.frame = CGRectMake(margin, 55, SCREEN_WIDTH - margin*2, 50);
        separator.backgroundColor = [Tools whiteColor].CGColor;
        [self.layer addSublayer:separator];
        
        titleLabel = [Tools creatLabelWithText:@"" textColor:[Tools blackColor] fontSize:16.f backgroundColor:nil textAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
        }];
		
		UIView *divView = [[UIView alloc]init];
		[Tools setViewBorder:divView withRadius:0 andBorderWidth:1.f andBorderColor:[Tools garyLineColor] andBackground:nil];
		[self addSubview:divView];
		[divView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 60, 50));
		}];
		
		[Tools creatCALayerWithFrame:CGRectMake(50, 4, 1, 42) andColor:[Tools garyLineColor] inSuperView:divView];
		[Tools creatCALayerWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 50, 4, 1, 42) andColor:[Tools garyLineColor] inSuperView:divView];
		
        UIButton *minusBtn = [[UIButton alloc]init];
        CALayer *minuslayer = [CALayer layer];
        minuslayer.frame = CGRectMake(0, 0, 15, 2);
        minuslayer.position = CGPointMake(25, 25);
        minuslayer.backgroundColor = [Tools theme].CGColor;
        [minusBtn.layer addSublayer:minuslayer];
        [divView addSubview:minusBtn];
        [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(divView);
            make.left.equalTo(divView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [minusBtn addTarget:self action:@selector(didMinusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addBtn = [[UIButton alloc]init];
        CALayer *addlayerX = [CALayer layer];
        addlayerX.frame = CGRectMake(0, 0, 15, 2);
        CALayer *addlayerY = [CALayer layer];
        addlayerY.frame = CGRectMake(0, 0, 2, 15);
        addlayerY.position = addlayerX.position = CGPointMake(25, 25);
        addlayerY.backgroundColor = addlayerX.backgroundColor = [Tools theme].CGColor;
        [addBtn.layer addSublayer:addlayerX];
        [addBtn.layer addSublayer:addlayerY];
        [divView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(divView);
			make.right.equalTo(divView);
            make.size.equalTo(minusBtn);
        }];
        [addBtn addTarget:self action:@selector(didAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        countLabel = [Tools creatLabelWithText:@"0" textColor:[Tools theme] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [divView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(divView);
            make.centerX.equalTo(divView);
        }];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SetServiceCapacityCell", @"SetServiceCapacityCell");
    
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

#pragma mark -- actions
- (void)didAddBtnClick:(UIButton*)btn {
    if (index.intValue == 0 || index.intValue == 1) {      //lsl
        if (countNumb >= 11) {
            return;
        }
    }
    else if (index.intValue == 2) {     //capacity
        if (countNumb >= 8) {
            return;
        }
    }
    else if (index.intValue == 3) {     //servant_no
        if (countNumb >= 4) {
            return;
        }
    }
    countNumb ++ ;
    [self resetCapacityNumb];
}

- (void)didMinusBtnClick:(UIButton*)btn {
    if (index.intValue == 0 || index.intValue == 1) {      //lsl
        if (countNumb <= 2) {
            return;
        }
    }
    else if (index.intValue == 2 || index.intValue == 3) {     //capacity
        if (countNumb <= 1) {
            return;
        }
    }
    countNumb -- ;
    [self resetCapacityNumb];
}

- (void)resetCapacityNumb {
    
    countLabel.text = [NSString stringWithFormat:@"%d", countNumb];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
    [tmp setValue:[NSNumber numberWithInt:countNumb] forKey:@"count"];
    [tmp setValue:index forKey:@"index"];
    kAYViewSendNotify(self, @"resetCapacityNumb:", &tmp)
}

#pragma mark -- notifies
- (id)setCellInfo:(NSDictionary*)args {
    
    countNumb = 0;
    titleLabel.text = [args objectForKey:@"title"];
    index = [args objectForKey:@"index"];
    
    if (index.intValue == 0) {      //lsl
        countNumb = 2;
    }
    else if (index.intValue == 1) {     //usl
        countNumb = 11;
    }
    else if (index.intValue == 2) {     //capacity
        countNumb = 4;
    }
    else if (index.intValue == 3) {     //servant_no
        countNumb = 1;
    }
    else {
        
    }
    
    countLabel.text = [NSString stringWithFormat:@"%d", countNumb];
    return nil;
}

@end
