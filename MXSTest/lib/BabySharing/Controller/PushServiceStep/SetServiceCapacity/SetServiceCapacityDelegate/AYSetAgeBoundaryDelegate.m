//
//  AYSetAgeBoundaryDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 19/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetAgeBoundaryDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYPickerView.h"

#define COMPLENTWIDTHMin           30
#define COMPLENTWIDTHMax           ([UIScreen mainScreen].bounds.size.width - COMPLENTWIDTHMin) / 2

typedef enum : int {
	DelegateModeAge = 0,
	DelegateModekid = 1,
	DelegateModeServant = 2
} DelegateMode;

@implementation AYSetAgeBoundaryDelegate {
	
	NSArray *ageLimit;
	NSArray *kidLimit;
	NSArray *servantLimit;
	
	DelegateMode dlgMode;
	
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
	NSMutableArray *tmpArr_age = [[NSMutableArray alloc] init];
	NSMutableArray *tmpArr_kid = [[NSMutableArray alloc] init];
	NSMutableArray *tmpArr_serv = [[NSMutableArray alloc] init];
	for (int i = 0; i < 6; ++i) {
		[tmpArr_age addObject:[NSString stringWithFormat:@"%d", i]];
		[tmpArr_age addObject:[NSString stringWithFormat:@"%.1f", i+0.5]];
	}
	for (int i = 6; i < 13; ++i) {
		[tmpArr_age addObject:[NSString stringWithFormat:@"%d", i]];
	}
	ageLimit = [tmpArr_age copy];
	
	for (int i = 1; i < 12; ++i) {
		[tmpArr_kid addObject:[NSString stringWithFormat:@"%d", i]];
	}
	kidLimit = [tmpArr_kid copy];
	
	for (int i = 1; i < 12; ++i) {
		[tmpArr_serv addObject:[NSString stringWithFormat:@"%d", i]];
	}
	servantLimit = [tmpArr_serv copy];
	
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
	dlgMode = [args intValue];
	return nil;
}

#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if (dlgMode == DelegateModeAge) {
		return 3;
	} else
		return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (dlgMode == DelegateModeAge) {
		if (component == 0 || component == 2) {
			return ageLimit.count;
		} else
			return 1;
		
	} else if(dlgMode == DelegateModekid) {
		return kidLimit.count;
	} else
		return servantLimit.count;
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (dlgMode == DelegateModeAge) {
		if (component == 0 || component == 2) {
			return [ageLimit objectAtIndex: row];
		} else
			return @"-";
		
	} else if(dlgMode == DelegateModekid) {
		return [kidLimit objectAtIndex: row];
	} else
		return [servantLimit objectAtIndex: row];
	
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if (dlgMode == DelegateModeAge) {
		return SCREEN_WIDTH/5;
	} else
		return SCREEN_WIDTH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UILabel *customLabel = nil;
	customLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	
	if (dlgMode == DelegateModeAge) {
		if (component == 0 || component == 2) {
			customLabel.text = [ageLimit objectAtIndex: row];
		} else
			customLabel.text = @"-";
		
	} else if(dlgMode == DelegateModekid) {
		customLabel.text = [kidLimit objectAtIndex: row];
	} else
		customLabel.text = [servantLimit objectAtIndex: row];
	
	return customLabel;
}

#pragma mark -- messages
- (id)queryCurrentSelected:(id)args {
	
	UIPickerView *pickerView = ((AYPickerView*)args).pickerView;
	if (dlgMode == DelegateModeAge) {
		
		NSString *lslStr = [ageLimit objectAtIndex:[pickerView selectedRowInComponent: 0]];
		NSString *uslStr = [ageLimit objectAtIndex:[pickerView selectedRowInComponent: 2]];
		if (lslStr.floatValue > uslStr.floatValue) {
			return nil;
		}
		
		NSMutableDictionary *dic_age = [[NSMutableDictionary alloc]initWithCapacity:2];
		[dic_age setValue:[NSNumber numberWithFloat:lslStr.floatValue] forKey:kAYServiceArgsAgeBoundaryLow];
		[dic_age setValue:[NSNumber numberWithFloat:uslStr.floatValue] forKey:kAYServiceArgsAgeBoundaryUp];
		
		NSMutableDictionary *dic_boundary = [[NSMutableDictionary alloc] init];
		[dic_boundary setValue:dic_age forKey:kAYServiceArgsAgeBoundary];
		return [dic_boundary copy];
		
	} else if(dlgMode == DelegateModekid) {
		NSString *kidNumb = [kidLimit objectAtIndex:[pickerView selectedRowInComponent: 0]];
		NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
		[dic setValue:[NSNumber numberWithInt:kidNumb.intValue] forKey:kAYServiceArgsCapacity];
		return [dic copy];
	} else {
		NSString *servNumb = [servantLimit objectAtIndex:[pickerView selectedRowInComponent: 0]];
		NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
		[dic setValue:[NSNumber numberWithInt:servNumb.intValue] forKey:kAYServiceArgsServantNumb];
		return [dic copy];
	}
	
}

@end
