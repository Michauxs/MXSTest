//
//  AYYardTypePickDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYYardTypePickDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYPickerView.h"

@implementation AYYardTypePickDelegate {
	
	NSArray *yardTypeArr;
	
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	yardTypeArr = @[@"室内", @"室外", @"室内+室外"];
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)changeQueryData:(id)args {
//	dlgMode = [args intValue];
	return nil;
}

#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return yardTypeArr.count;
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [yardTypeArr objectAtIndex: row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return SCREEN_WIDTH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UILabel *customLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	customLabel.text = [yardTypeArr objectAtIndex: row];
	return customLabel;
}

#pragma mark -- messages
- (id)queryCurrentSelected:(id)args {
	
	UIPickerView *pickerView = ((AYPickerView*)args).pickerView;
	NSString *type = [yardTypeArr objectAtIndex:[pickerView selectedRowInComponent: 0]];
	return type;
	
}

@end
