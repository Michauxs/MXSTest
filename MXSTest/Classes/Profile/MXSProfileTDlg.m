//
//  MXSProfileTDlg.m
//  MXSTest
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSProfileTDlg.h"

@implementation MXSProfileTDlg

@synthesize controller = _controller;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id args = @{@"index_path":indexPath,
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

@end
