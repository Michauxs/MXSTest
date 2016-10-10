//
//  Tools.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "Tools.h"
#define kAYFontLight(FONTSIZE)                      [UIFont fontWithName:@"STHeitiSC-Light" size:FONTSIZE]
@implementation Tools

+ (NSString *)subStringWithByte:(NSInteger)byte str:(NSString *)str{
    NSString *subStr;
    int count = 0;
    for (int i = 0 ; i < [str length]; i++) {
        if ([str characterAtIndex:i] >= 32 && [str characterAtIndex:i] <= 126) {
            count += 1;
        } else {
            count += 2;
        }
        if (count > byte) {
            break;
        } else {
            subStr = [str substringToIndex:i + 1];
        }
    }
    return subStr;
}

//得到字节数函数
+ (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSInteger)bityWithStr:(NSString *)str {
    NSInteger count = 0;
    for (NSInteger i = 0; i < str.length; i++) {
        unichar aa = [str characterAtIndex:i];
        if (aa >= 32 && aa <= 126) {
            count += 1;
        } else {
            count += 2;
        }
    }
    return count;
}

+ (UIImage *)imageWithView:(UIView *)view {
    // 绘制UIview成图片
//    CGRect rect = [view bounds];
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer.presentationLayer renderInContext:context];
//    [view.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
    
    
    UIImage *image;
    CGSize blurredImageSize = [view frame].size;
    UIGraphicsBeginImageContextWithOptions(blurredImageSize, YES, .0f);
    [view drawViewHierarchyInRect: [view bounds] afterScreenUpdates: YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

+ (NSArray *)sortWithArr:(NSArray *)arr headStr:(NSString *)headStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *letterArr = [NSMutableArray array];
    for (NSString *value in arr) {
        // 建立关系
        if (value && ![value isEqualToString:@""]) {
            [letterArr addObject:[self ToPinYinWith:value dic:dic]];
        }
    }
    // 对字母表进行排序
    NSArray *resultArray1 = [letterArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
    }];
    // 判断字符串中是否含有首字母
    NSMutableArray *resultArray2 = [NSMutableArray array];
    for (NSString *tmp in resultArray1) {
        NSString* str = [dic objectForKey:tmp];
        if (str.length >= headStr.length) {
            NSString *cut = [str substringToIndex:headStr.length];
            if ([cut isEqualToString:headStr]) {
                [resultArray2 addObject:tmp];
            }
        }
    }
    NSMutableArray *resultArray3 = [NSMutableArray array];
    for (NSString *key in resultArray2) {
        [resultArray3 addObject:[dic objectForKey:key]];
    }
    return resultArray3;
}

+ (NSString *)ToPinYinWith:(NSString *)hanziText dic:(NSMutableDictionary *)dic{
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                // 方便以后新排序
                [dic setObject:hanziText forKey:ms];
                return ms;
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA {
    return [UIColor colorWithRed:RED / 255.0 green:GREEN / 255.0 blue:BLUE / 255.0 alpha:ALPHA];
}

+ (UIImage *)addPortraitToImage:(UIImage *)image userHead:(UIImage *)userhead userName:(NSString *)userName{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:5] addClip];
    // Draw your image
    [image drawInRect:frame];
    // Retrieve and return the new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    374 482
    CGFloat width = 375;
    CGFloat height = 482;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 定义矩形的rect
    CGRect rectangle = CGRectMake(0, 0, width, height);
    
    // 在当前路径下添加一个矩形路径
    CGContextAddRect(ctx, rectangle);
    
    // 设置试图的当前填充色
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    // 绘制当前路径区域
    CGContextFillPath(ctx);
    
    CGRect rect = CGRectInset(CGRectMake(0, 0, width, width), 10, 10);
    [newImage drawInRect:rect];
    
    // 画边框大圆
    [[UIColor whiteColor] set];
    CGFloat bigRadius = 50; //大圆半径
    CGFloat centerX = width / 2;
    CGFloat centerY = width - 20;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 昵称
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetRGBFillColor(ctx, 74.0 / 255.0, 74.0 / 255.0, 74.0 / 255.0, 1.0);
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    NSString *nickName = userName;
    CGSize size = [nickName sizeWithAttributes:@{ NSFontAttributeName :font }];
    [nickName drawInRect:CGRectMake(width / 2 - size.width / 2, rect.origin.y + rect.size.height + 50, size.width, size.height) withAttributes:@{ NSFontAttributeName :font }];
    
    // 画小圆
    CGFloat smallradius = 45;
    CGContextAddArc(ctx, centerX, centerY, smallradius, 0, M_PI * 2, 0);
    // 剪裁
    CGContextClip(ctx);
    // 画头像
    UIImage *userHead = userhead;
    [userHead drawInRect:CGRectMake(width / 2 - 50, width - 70, 100, 100)];
    
    
    // 画一个半透明的圆环
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+ (NSString *)compareCurrentTime:(NSDate *)compareDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
//    秒数差
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    // TODO: 一个bug， 2039穿越时间显示刚刚
    if (compareDate.timeIntervalSince1970 > [NSDate date].timeIntervalSince1970) {
        return @"";
    }
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    NSLog(@"MonkeyHengLog: %@ === %@", [dateFormatter stringFromDate:compareDate], result);
    return result;
}

+ (NSString*)getDeviceUUID {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (UIViewController *)activityViewController2 {
    UIViewController* topVC = nil;
    UIViewController* appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    topVC = appRootVC;
        
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        topVC = ((UINavigationController*)topVC).viewControllers.lastObject;
    } else if ([topVC isKindOfClass:[UITabBarController class]]) {
        topVC = [((UITabBarController*)topVC).viewControllers objectAtIndex:((UITabBarController*)topVC).selectedIndex];
        
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            
            topVC = ((UINavigationController*)topVC).viewControllers.lastObject;
        }
    }
    
    return topVC;
}

// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController {
    UIViewController* topVC = nil;
    NSArray *ws = [[[UIApplication sharedApplication].windows reverseObjectEnumerator] allObjects];
    //    NSArray *ws = [UIApplication sharedApplication].windows;
    for (UIWindow* w in ws) {
        UIViewController* appRootVC = w.rootViewController;
        topVC = appRootVC;
        
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = ((UINavigationController*)topVC).viewControllers.lastObject;
            break;
        } else if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = [((UITabBarController*)topVC).viewControllers objectAtIndex:((UITabBarController*)topVC).selectedIndex];
            
            if ([topVC isKindOfClass:[UINavigationController class]]) {
                
                topVC = ((UINavigationController*)topVC).viewControllers.lastObject;
                break;
            }
        }
    }
    
    return topVC;
    
//    UIViewController* activityViewController = nil;
//    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if(window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow *tmpWin in windows)
//        {
//            if(tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    NSArray *viewsArray = [window subviews];
//    if([viewsArray count] > 0)
//    {
//        UIView *frontView = [viewsArray objectAtIndex:0];
//        
//        id nextResponder = [frontView nextResponder];
//        
//        if([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            activityViewController = nextResponder;
//        }
//        else
//        {
//            activityViewController = window.rootViewController;
//        }
//    }
//   
//    if ([activityViewController isKindOfClass:[UINavigationController class]]) {
//        activityViewController = ((UINavigationController*)activityViewController).viewControllers.lastObject;
//    }
//    
//    return activityViewController;
    
//    NSArray *appRootVC = [UIApplication sharedApplication].windows;
//    
//    UIViewController *topVC = appRootVC.firstObject;
    

}

//取消searchbar背景色
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 获取字体size
+ (CGSize)sizeWithString:(NSString*)str withFont:(UIFont*)font andMaxSize:(CGSize)sz {
    if (str) {
        NSLayoutManager* m = [[NSLayoutManager alloc]init];
        NSTextStorage* st = [[NSTextStorage alloc]initWithString:str];
//        NSTextContainer* con = [[NSTextContainer alloc]initWithSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        NSTextContainer* con = [[NSTextContainer alloc]initWithSize:sz];
        
        [m addTextContainer:con];
        [st addLayoutManager:m];
        
        [st addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, st.length)];
        con.lineFragmentPadding = 0;
        //    con.lineBreakMode = NSLineBreakByWordWrapping;
        con.lineBreakMode = NSLineBreakByCharWrapping;
        return [m usedRectForTextContainer:con].size;
    } else {
        return CGSizeMake(0.f, 0.f);
    }
}


+ (UIColor*)themeColor {
    return [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
}
+ (UIColor*)blackColor {
    return [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
}

+ (UIColor*)darkBackgroundColor {
    return [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
}

+ (UIColor*)whiteColor {
    return [UIColor whiteColor];
}

+ (UIColor*)garyColor {
    return [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
}
+ (UIColor*)garyLineColor {
    return [UIColor colorWithWhite:0.75 alpha:1.f];
}
+ (UIColor*)garyBackgroundColor {
    return [UIColor colorWithWhite:0.9490 alpha:1.f];
}

#pragma mark -- UI
/**
 *  设置label的 text color fontSize(正常数值为细体,大于100为粗体,-负数为正常粗细) background align
*/
+ (UILabel*)setLabelWith:(UILabel*)label andText:(NSString*)text andTextColor:(UIColor*)color andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor andTextAlignment:(NSTextAlignment)align {
    
    label.text = text;
    label.textColor = color;
    label.textAlignment = align;
    
    if (font < 0) {
        label.font = [UIFont systemFontOfSize:-font];
    } else if (font > 100.f) {
        label.font = [UIFont boldSystemFontOfSize:(font - 100)];
    } else {
        label.font = kAYFontLight(font);
    }
    
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    } else label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+ (UILabel*)creatUILabelWithText:(NSString*)text andTextColor:(UIColor*)color andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor andTextAlignment:(NSTextAlignment)align {
    
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = color;
    label.textAlignment = align;
    
    if (font < 0) {
        label.font = [UIFont systemFontOfSize:-font];
    } else if (font > 100.f) {
        label.font = [UIFont boldSystemFontOfSize:(font - 100)];
    } else {
        label.font = kAYFontLight(font);
    }
    
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    } else label.backgroundColor = [UIColor clearColor];
    
    return label;
}

/**
 *  设置btn的 title color fontSize(正常数值为细体,大于100为粗体,-负数为正常粗细) background align
 */
+ (UIButton*)setButton:(UIButton*)btn withTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor {
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:TitleColor forState:UIControlStateNormal];
    
    if (font < 0) {
        btn.titleLabel.font = [UIFont systemFontOfSize:-font];
    } else if (font > 100.f) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:(font - 100)];
    } else {
        btn.titleLabel.font = kAYFontLight(font);
    }
    
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    } else
        btn.backgroundColor = [UIColor clearColor];
    
    return btn;
}

+ (UIButton*)creatUIButtonWithTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor {
    
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:TitleColor forState:UIControlStateNormal];
    
    if (font < 0) {
        btn.titleLabel.font = [UIFont systemFontOfSize:-font];
    } else if (font > 100.f) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:(font - 100)];
    } else {
        btn.titleLabel.font = kAYFontLight(font);
    }
    
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    } else
        btn.backgroundColor = [UIColor clearColor];
    
    return btn;
}

#pragma mark -- NSTime
+ (NSDateFormatter*)creatDateFormatterWithString:(NSString*)formatter {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    return format;
}

+ (UIImage*)SourceImageWithRect:(CGRect)rc fromView:(UIView*)view {
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)splitImage:(UIImage *)image from:(CGFloat)height left:(UIImage**)pImg {
    CGFloat sf = [UIScreen mainScreen].scale;
    CGFloat imgWidth = image.size.width * sf;
    CGFloat imgheight = image.size.height * sf;
    height *= sf;
    CGRect topImgFrame = CGRectMake(0, 0, imgWidth, height);
    CGRect btmImgFrame = CGRectMake(0, height, imgWidth, imgheight - height);
    CGImageRef top =CGImageCreateWithImageInRect(image.CGImage, topImgFrame);
    CGImageRef btm =CGImageCreateWithImageInRect(image.CGImage, btmImgFrame);
    *pImg = [UIImage imageWithCGImage:btm];
    return [UIImage imageWithCGImage:top];
}

#pragma mark -- conv
+ (void)logLenghFromImage:(UIImage*)image {
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    NSLog(@"%lu", imageData.length);
}

@end
