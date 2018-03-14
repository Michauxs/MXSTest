//
//  AYSearchBar.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchBarView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "Tools.h"

#define CANCELBTN_WIDTH     61
#define CANCELBTN_HEIGHT    30

@implementation AYSearchBarView {
    CGSize sz;
    UILabel *placeLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize sb_bg = _sb_bg;
@synthesize textField = _textField;
@synthesize cancleBtn = _cancleBtn;
@synthesize showsSearchIcon = _showsSearchIcon;

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

#pragma mark -- life cycle
- (void)setSearchBarBackgroundColor:(UIColor *)sb_bg {
    if ([self viewWithTag:-1] == nil) {
        UIImageView* iv = [[UIImageView alloc] initWithImage:[Tools imageWithColor:sb_bg size:CGSizeMake(self.bounds.size.width, self.bounds.size.height)]];
        iv.tag = -1;
        [self insertSubview:iv atIndex:1];
    } else {
        UIImageView* iv = [self viewWithTag:-1];
        iv.image = [Tools imageWithColor:sb_bg size:self.bounds.size];
    }
}

- (UITextField *)getTextFiled {
    
    if (_textField == nil) {
        for (UIView* v in self.subviews.firstObject.subviews) {
            if ( [v isKindOfClass: [UITextField class]] ) {
                _textField = (UITextField *)v;
//                _textField.leftView = nil;
                break;
            }
        }
    }
    
    return _textField;
}

- (UIButton *)getCancelBtn {
    if (_cancleBtn == nil) {
        for (UIView* v in self.subviews.firstObject.subviews) {
            if ( [v isKindOfClass: [UIButton class]] ) {
                _cancleBtn = (UIButton*)v;
                break;
            }
        }
    }
    
    return _cancleBtn;
}

- (void)setPostLayoutSize:(CGSize)cancel_btn_sz {
    sz = cancel_btn_sz;
}

- (void)setShowsSearchIcon:(BOOL)showsSearchIcon {
    _showsSearchIcon = showsSearchIcon;
    if (_showsSearchIcon == NO) {
        self.textField.leftView = nil;
    }
}

- (UILabel *)getPlaceLabel {
    
    if (placeLabel == nil) {
        for (UIView* v in self.textField.subviews) {
            if ( [v isKindOfClass: [UILabel class]] ) {
                placeLabel = (UILabel *)v;
                break;
            }
        }
    }
    
    return placeLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
    if (sz.width != 0 && sz.height != 0) {
    
#define CONTENT_MARGIN                  10.5
#define TEXTFIELD_BTN_MARGIN_BETWEEN    13.5
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        CGFloat ver_margin = (height - sz.height) / 2;
        CGFloat textfield_width = width - CONTENT_MARGIN * 2 - TEXTFIELD_BTN_MARGIN_BETWEEN - sz.width;
    
        self.textField.font = [UIFont systemFontOfSize:12];
        self.textField.frame = CGRectMake(CONTENT_MARGIN, ver_margin, textfield_width, sz.height);
        self.cancleBtn.frame = CGRectMake(CONTENT_MARGIN + textfield_width + TEXTFIELD_BTN_MARGIN_BETWEEN, ver_margin, sz.width, sz.height);
        
        
    }
}

#pragma mark -- view commands
- (id)changeSearchBarPlaceHolder:(id)obj {
    NSString* place_holder = (NSString*)obj;
    [self setPlaceholder:place_holder];
    return nil;
}

- (id)registerDelegate:(id)obj {
    self.delegate = (id<UISearchBarDelegate>)obj;
    return nil;
}

- (id)foundTitleSearchBar {
    self.sb_bg = [UIColor whiteColor];
    self.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return nil;
}

- (id)roleTagSearchBar {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.bounds = CGRectMake(0, 0, width, 53);
    self.showsCancelButton = YES;
    
    self.sb_bg = [UIColor whiteColor];
    self.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateDisabled];
    [self.cancleBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.cancleBtn setTitle:@"添加" forState:UIControlStateDisabled];
    self.cancleBtn.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.f];
    self.cancleBtn.layer.cornerRadius = 5.f;
    self.cancleBtn.clipsToBounds = YES;
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.showsSearchIcon = NO;
    [self setPostLayoutSize:CGSizeMake(CANCELBTN_WIDTH, CANCELBTN_HEIGHT)];
    return nil;
}

- (id)foundSearchBar {
    self.showsCancelButton = YES;
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    UIColor* textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0];
    
    self.sb_bg = [UIColor whiteColor];
//    [self.cancleBtn setTintColor:textColor];
//    [self.cancleBtn.titleLabel setTextColor:textColor];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    [self.cancleBtn setTitleColor:[UIColor colorWithWhite:0.3059 alpha:1.f] forState:UIControlStateNormal];
//    [self.cancleBtn setTitleColor:[UIColor colorWithWhite:0.3059 alpha:1.f] forState:UIControlStateDisabled];
    [self.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateDisabled];
    self.cancleBtn.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.f];
    self.cancleBtn.layer.cornerRadius = 5.f;
    self.cancleBtn.clipsToBounds = YES;
    [self setPostLayoutSize:CGSizeMake(CANCELBTN_WIDTH, CANCELBTN_HEIGHT)];
    
    self.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return nil;
}
@end
