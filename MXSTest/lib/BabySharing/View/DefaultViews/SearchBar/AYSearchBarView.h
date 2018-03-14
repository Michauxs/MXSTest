//
//  AYSearchBar.h
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYSearchBarView : UISearchBar <AYViewBase>
@property (nonatomic, weak, getter=getTextFiled, readonly) UITextField* textField;
@property (nonatomic, weak, getter=getCancelBtn, readonly) UIButton* cancleBtn;
@property (nonatomic, weak, setter=setSearchBarBackgroundColor:) UIColor* sb_bg;
@property (nonatomic, setter=setShowsSearchIcon:) BOOL showsSearchIcon;
@end
