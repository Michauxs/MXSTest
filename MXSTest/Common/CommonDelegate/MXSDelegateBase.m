//
//  MXSDelagateBase.m
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSDelegateBase.h"

@implementation MXSDelegateBase {
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dlgData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MXSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellName forIndexPath:indexPath];
	cell.controller = self.controller;
	cell.cellInfo = [_dlgData objectAtIndex:indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return _rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id args = @{@"row":[NSNumber numberWithInteger:indexPath.row],
				@"dlg":self
				};
	
	SEL sel = NSSelectorFromString(@"tableViewDidSelectRowAtIndexPath:");
	Method m = class_getInstanceMethod([_controller class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
		func(_controller, sel, args);
	}
}


//左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	id args = @{@"row":[NSNumber numberWithInteger:indexPath.row],
				@"dlg":self
				};
	
	SEL sel = NSSelectorFromString(@"cellDeleteFromTable:");
	Method m = class_getInstanceMethod([_controller class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
		func(_controller, sel, args);
	}
}

//- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//	UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"         " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//		NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
//		kAYDelegateSendNotify(self, @"cellDeleteFromTable:", &row)
//	}];
//	
//	rowAction.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"cell_delete")];
//	return @[rowAction];
//}

@end
