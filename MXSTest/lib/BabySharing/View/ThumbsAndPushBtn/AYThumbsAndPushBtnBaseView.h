//
//  AYThumbsAndPushBtnBaseView.h
//  BabySharing
//
//  Created by BM on 5/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYThumbsAndPushBtnBaseView : UIButton <AYViewBase>

@property (nonatomic, strong) UIImageView* btn;
@property (nonatomic, strong) UILabel* label;

@property (nonatomic, weak) NSString* post_id;
@property (nonatomic) NSInteger cell_index;

- (void)selfClicked;
- (id)changeCount:(id)obj;
- (id)changeBtnConnectInfo:(id)obj;
@end
