//
//  AYOrderTimesDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 13/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderTimesDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#define COMPLENTWIDTHMin           30
#define COMPLENTWIDTHMax           ([UIScreen mainScreen].bounds.size.width - COMPLENTWIDTHMin) / 2

@implementation AYOrderTimesDelegate {
    UIPickerView *picker;
    
    NSArray *hours;
    NSArray *mins;
    
    NSString *selectedProvince;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
    for (long i = 0; i< 24*20; ++i) {
        int tmpInt = i % 24;
        [tmpArr addObject:[NSString stringWithFormat:@"%.2d",tmpInt]];
    }
    hours = [tmpArr copy];
    
    NSMutableArray *tmpArr2 = [[NSMutableArray alloc]init];
    for (int i = 0; i< 50; ++i) {
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",00]];
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",15]];
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",30]];
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",45]];
    }
    mins = [tmpArr2 copy];
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

- (id)scrollToCenterWithOffset:(NSNumber*)offset {
    
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            [picker selectRow:hours.count/2 + offset.intValue inComponent:i animated:NO];
        } else if(i == 2)
            [picker selectRow:mins.count/2 inComponent:i animated:NO];
    }
    
    return nil;
}

#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    picker = pickerView;
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [hours count];
    } else if (component == 1)
        return 1;
    else {
        return [mins count];
    }
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [hours objectAtIndex: row];
    } else if (component == 1)
        return @":";
    else {
        return [mins objectAtIndex: row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if (component == 1) {
		return 100;
	}
	else {
		return 50;
	}
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UILabel *myView = nil;
//    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, COMPLENTWIDTH, 30)] ;
//    myView.textAlignment = NSTextAlignmentCenter;
//    myView.font = [UIFont systemFontOfSize:14];
//    myView.backgroundColor = [UIColor clearColor];
//    
//    if (component == 0) {
//        myView.text = [hours objectAtIndex:row];
//    } else myView.text = [mins objectAtIndex:row];
//    
//    return myView;
//}

#pragma mark -- messages
- (id)queryCurrentSelected:(id)args {
    NSInteger provinceIndex = [picker selectedRowInComponent: 0];
    NSInteger cityIndex = [picker selectedRowInComponent: 1];
    
    NSString *provinceStr = [hours objectAtIndex: provinceIndex];
    NSString *cityStr = [mins objectAtIndex: cityIndex];
    
    NSString *showMsg = [NSString stringWithFormat: @"%@:%@", provinceStr, cityStr];
    NSLog(@"%@",showMsg);
    return showMsg;
}

@end
