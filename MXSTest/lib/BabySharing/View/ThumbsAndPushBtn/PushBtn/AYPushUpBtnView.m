//
//  AYPushUpBtnView.m
//  BabySharing
//
//  Created by BM on 5/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPushUpBtnView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "Define.h"

@implementation AYPushUpBtnView
- (void)postPerform {
    [super postPerform];
    self.btn.image = PNGRESOURCE(@"pushed");
    self.label.textColor = TextColor;
    self.label.text = @"咚";
}

- (void)selfClicked {

}
@end
