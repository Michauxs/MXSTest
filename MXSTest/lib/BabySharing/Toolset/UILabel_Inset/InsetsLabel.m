//
//  InsetsLabel.m
//  BabySharing
//
//  Created by Alfred Yang on 20/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel
@synthesize insets=_insets;

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
