//
//  AYServiceTimesPickDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceTimesPickDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#define COMPLENTWIDTHMin           30
#define COMPLENTWIDTHMax           ([UIScreen mainScreen].bounds.size.width - COMPLENTWIDTHMin) / 2

@implementation AYServiceTimesPickDelegate {
    UIPickerView *picker;
    
    NSArray *hours;
    NSArray *mins;
    
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (long i = 0; i< 24 * 5; ++i) {
        int tmpInt = i % 24;
        [tmpArr addObject:[NSString stringWithFormat:@"%.2d",tmpInt]];
    }
    hours = [tmpArr copy];
    mins = @[@"00", @"30"];
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

- (id)changeOptionData:(id)args {
	NSArray *h = [args objectForKey:@"hours"];
	if (h && h.count != 0) {
		hours = h;
	}
		
	NSArray *m = [args objectForKey:@"mins"];
	if (m && m.count != 0) {
		mins = m;
	}
	return nil;
}

- (id)scrollToCenterWithOffset:(NSNumber*)offset {
    for (int i = 0; i < 7; i++) {
        if (i == 0 || i == 4) {
            [picker selectRow:hours.count/2 + offset.intValue inComponent:i animated:NO];
        }
    }
    
    return nil;
}

#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    picker = pickerView;
    return 7;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0 || component == 4) {
        return [hours count];
    } else if (component == 2 || component == 6)
        return [mins count];
    else {
        return 1;
    }
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0 || component == 4) {
        return [hours objectAtIndex: row];
    }
    else if(component == 1 || component == 5){
        return @":";
    }
    else if (component == 2 || component == 6)
        return [mins objectAtIndex: row];
    else
        return @"--";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 3) {
        return 50;
    }
    else {
        return 30;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *customLabel = nil;
    customLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    if (component == 0 || component == 4) {
        customLabel.text = [hours objectAtIndex:row];
    }
    else if(component == 1 || component == 5){
        customLabel.text = @":";
    }
    else if (component == 2 || component == 6) {
        customLabel.text = [mins objectAtIndex:row];
    }
    else
        customLabel.text = @"-";
    
    return customLabel;
}

#pragma mark -- messages
- (id)queryCurrentSelected:(id)args {
    NSInteger fromHourIndex = [picker selectedRowInComponent: 0];
    NSInteger fromMinIndex = [picker selectedRowInComponent: 2];
    NSInteger toHourIndex = [picker selectedRowInComponent: 4];
    NSInteger toMinIndex = [picker selectedRowInComponent: 6];
    
    NSString *fromHourStr = [hours objectAtIndex:fromHourIndex];
    NSString *fromMinStr = [mins objectAtIndex:fromMinIndex];
    NSString *toHourStr = [hours objectAtIndex:toHourIndex];
    NSString *toMinStr = [mins objectAtIndex:toMinIndex];
    
//    NSString *showMsg = [NSString stringWithFormat: @"%@:%@-%@:%@", fromHourStr, fromMinStr, toHourStr, toMinStr];
//    NSLog(@"%@",showMsg);
    
    int startTimeSpan = [fromHourStr stringByAppendingString:fromMinStr].intValue;
    int endTimeSpan = [toHourStr stringByAppendingString:toMinStr].intValue;
    if (startTimeSpan >= endTimeSpan) {
        return nil;
    }
    
    NSMutableDictionary *times_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [times_dic setValue:[NSNumber numberWithInt:startTimeSpan] forKey:@"start"];
    [times_dic setValue:[NSNumber numberWithInt:endTimeSpan] forKey:@"end"];
    
    return times_dic;
}

@end
