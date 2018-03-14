//
//  AYPickerView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPickerView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"

#define SHOW_OFFSET_Y           SCREEN_HEIGHT - 196
#define kPickBgHeight             196

@implementation AYPickerView {
	UIView *pickBgView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.backgroundColor = [UIColor clearColor];
	
	self.userInteractionEnabled = YES;
	[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapElse)]];
	
	pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickBgHeight)];
	[self addSubview:pickBgView];
	pickBgView.backgroundColor = [Tools garyBackgroundColor];
    pickBgView.clipsToBounds = YES;
    
    UIButton *save = [[UIButton alloc]init];
    [pickBgView addSubview:save];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[Tools theme] forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pickBgView);
        make.top.equalTo(pickBgView);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [save addTarget:self action:@selector(didSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [[UIButton alloc]init];
    [pickBgView addSubview:cancel];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[Tools black] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickBgView);
        make.top.equalTo(pickBgView);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [cancel addTarget:self action:@selector(didCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, kPickBgHeight - 30)];
    [pickBgView addSubview:_pickerView];
    
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
- (void)didTapElse {
	[self didCancelClick:nil];
}

- (void)didSaveClick:(UIButton*)btn {
    
    [self hidePickerView];
    
    id<AYCommand> save = [self.notifies objectForKey:@"didSaveClick"];
    [save performWithResult:nil];
}

- (void)didCancelClick:(UIButton*)btn {
    
    [self hidePickerView];
    
    id<AYCommand> cancel = [self.notifies objectForKey:@"didCancelClick"];
    [cancel performWithResult:nil];
}

#pragma mark -- view commands
- (id)registerDatasource:(id)obj {
    id<UIPickerViewDataSource> d = (id<UIPickerViewDataSource>)obj;
    _pickerView.dataSource = d;
    return nil;
}

- (id)registerDelegate:(id)obj {
    id<UIPickerViewDelegate> d = (id<UIPickerViewDelegate>)obj;
    _pickerView.delegate = d;
    return nil;
}

- (id)showPickerView {
	
	self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        pickBgView.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, kPickBgHeight);
    }];
    return nil;
}

- (id)hidePickerView {
	
    [UIView animateWithDuration:0.25 animations:^{
        pickBgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickBgHeight);
	} completion:^(BOOL finished) {
		self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
	}];
    return nil;
}

- (id)refresh {
	[_pickerView reloadAllComponents];
	return nil;
}

- (id)setPickerBackground:(id)color {
	pickBgView.backgroundColor = color;
	return nil;
}

@end

@implementation AYPicker2View

//-(void)didSaveClick:(UIButton*)btn{
//    id<AYCommand> save = [self.notifies objectForKey:@"didSave2Click"];
//    [save performWithResult:nil];
//}

@end
