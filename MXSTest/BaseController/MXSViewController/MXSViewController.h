//
//  MXSViewController.h
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSVCBase.h"
#import "MXSNavigationBar.h"

@interface MXSViewController : UIViewController <MXSVCBase>

@property (nonatomic, strong) MXSNavigationBar *NavBar;

@end
