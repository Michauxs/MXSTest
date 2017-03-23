//
//  Tools.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+ (UIImage *)imageWithView:(UIView *)view;
+ (NSString *)subStringWithByte:(NSInteger)byte str:(NSString *)str;
+ (NSInteger)bityWithStr:(NSString *)str;
+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (NSArray *)sortWithArr:(NSArray *)arr headStr:(NSString *)headStr;
+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA;
+ (UIImage *)addPortraitToImage:(UIImage *)image userHead:(UIImage *)userhead userName:(NSString *)userName;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)compareCurrentTime:(NSDate*) compareDate;
+ (NSString*)getDeviceUUID;
+ (UIViewController *)activityViewController;
+ (UIViewController *)activityViewController2;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (CGSize)sizeWithString:(NSString*)str withFont:(UIFont*)font andMaxSize:(CGSize)sz;

+ (UIColor *)randomColor;
+ (UIColor*)themeColor;
+ (UIColor*)blackColor;
+ (UIColor*)whiteColor;
+ (UIColor*)garyColor;
+ (UIColor*)garyLineColor;
+ (UIColor*)garyBackgroundColor;
+ (UIColor*)darkBackgroundColor;

#pragma mark -- conv
+ (void)logLenghFromImage:(UIImage*)image;

#pragma mark -- UI
+ (UILabel*)creatUILabelWithText:(NSString*)text andTextColor:(UIColor*)color andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor andTextAlignment:(NSTextAlignment)align;
+ (UIButton*)creatUIButtonWithTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor;

#pragma mark -- NSTime
+ (NSDateFormatter*)creatDateFormatterWithString:(NSString*)formatter;

+ (UIImage*)SourceImageWithRect:(CGRect)rc fromView:(UIView*)view;
+ (UIImage*)splitImage:(UIImage *)image from:(CGFloat)height left:(UIImage**)pImg;
@end
