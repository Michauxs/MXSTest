//
//  UIButton+Factory.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int {
    BtnCreatPolicyNormal = 0,
    BtnCreatPolicySelect,
} BtnCreatPolicy;

@interface UIButton (Factory)

/**
 *  PS: fontSize.正常数值为细体/300+为正常/600+为粗体
 */
+ (UIButton*)creatBtnWithTitle:(NSString*)title titleColor:(UIColor*)TitleColor fontSize:(CGFloat)font backgroundColor:(UIColor*)backgroundColor;

+ (UIButton*)creatBtnWithImgName:(NSString*)imgName backgroundColor:(UIColor*)backgroun policy:(BtnCreatPolicy)policy;

@end
