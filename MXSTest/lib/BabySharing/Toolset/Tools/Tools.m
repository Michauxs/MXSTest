//
//  Tools.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>

#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"

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
	
    return result;
}

+ (NSString *)compareFutureTime:(NSDate *)compareDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //    秒数差
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    //未来为正 过去为负
    
    // TODO: 一个bug， 2039穿越时间显示刚刚
//    if (compareDate.timeIntervalSince1970 > [NSDate date].timeIntervalSince1970) {
//        return @"";
//    }
    
    double temp = 0;
    NSString *result;
    
    if (timeInterval < 0) {
        result = [NSString stringWithFormat:@"正在进行"];
    } else {
//        timeInterval = - timeInterval;
        if (timeInterval < 60) {
            result = [NSString stringWithFormat:@"即将开始"];
        }
        else if((temp = timeInterval/60) <60){
            result = [NSString stringWithFormat:@"%ld分钟后",(long)temp];
        }
        
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"%ld小时后",(long)temp];
        }
        
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"%ld天后",(long)temp];
        }
        
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"%ld月后",(long)temp];
        }
        else{
            temp = temp/12;
            result = [NSString stringWithFormat:@"%ld年后",(long)temp];
        }
    }
    
    return result;
}
+ (NSString*)getUUIDString {
	
	CFUUIDRef puuid = CFUUIDCreate( nil );
	CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
	NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
	CFRelease(puuid);
	CFRelease(uuidString);
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
    __block UIViewController* topVC = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
		
		NSArray *ws = [[[UIApplication sharedApplication].windows reverseObjectEnumerator] allObjects];
		//    NSArray *ws = [UIApplication sharedApplication].windows;
		for (UIWindow* w in ws) {
			UIViewController* appRootVC = w.rootViewController;
			topVC = appRootVC;
			
			if (topVC.presentedViewController && ![topVC isKindOfClass:[UIAlertController class]]) {
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
//    });
    
    return topVC;

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
//        con.lineFragmentPadding = 4;
        //    con.lineBreakMode = NSLineBreakByWordWrapping;
        con.lineBreakMode = NSLineBreakByCharWrapping;
        
        return [m usedRectForTextContainer:con].size;
    } else {
        return CGSizeMake(0.f, 0.f);
    }
}


+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA {
	return [UIColor colorWithRed:RED / 255.0 green:GREEN / 255.0 blue:BLUE / 255.0 alpha:ALPHA];
}

+ (UIColor*)theme {
    return [UIColor colorWithRed:89.0/255.0 green:213.0/255.0 blue:199.0/255.0 alpha:1.0];
}
+ (UIColor*)themeBorderColor {
	return [UIColor colorWithRed:189.f/255.0 green:238.f/255.0 blue:233.f/255.0 alpha:1.0];
}
+ (UIColor*)themeLightColor {
	return [UIColor colorWithRed:198.f/255.0 green:238.f/255.0 blue:233.f/255.0 alpha:1.0];
}

+ (UIColor*)black {
    return [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
}

+ (UIColor*)whiteColor {
    return [UIColor whiteColor];
}

+ (UIColor*)garyColor {
    return [UIColor colorWithRed:178.f / 255.f green:178.f / 255.f blue:178.f / 255.f alpha:1.f];
}
+ (UIColor*)lightGaryColor {
    return [UIColor colorWithRed:204.f / 255.f green:204.f / 255.f blue:204.f / 255.f alpha:1.f];
}
+ (UIColor*)garyLineColor {
    return [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.f];
}
+ (UIColor*)RGB153GaryColor {
	return [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1.f];
}
+ (UIColor*)RGB89GaryColor {
	return [UIColor colorWithRed:89.f / 255.f green:89.f / 255.f blue:89.f / 255.f alpha:1.f];
}
+ (UIColor*)RGB127GaryColor {
	return [UIColor colorWithRed:127.f / 255.f green:127.f / 255.f blue:127.f / 255.f alpha:1.f];
}
+ (UIColor*)RGB225GaryColor {
	return [UIColor colorWithRed:225.f / 255.f green:225.f / 255.f blue:225.f / 255.f alpha:1.f];
}

+ (UIColor*)darkBackgroundColor {
	return [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
}
+ (UIColor*)garyBackgroundColor {
    return [UIColor colorWithRed:246.f / 255.f green:249.f / 255.f blue:251.f / 255.f alpha:1.f];
}
+ (UIColor*)disableBackgroundColor {
	return [UIColor colorWithRed:144.f / 255.f green:144.f / 255.f blue:144.f / 255.f alpha:1.f];
}

+ (UIColor*)borderAlphaColor {
    return [UIColor colorWithWhite:1.f alpha:0.25f];
}

+ (UIColor *)randomColor {
	return [Tools colorWithRED:(arc4random()%255) GREEN:(arc4random()%255) BLUE:(arc4random()%255) ALPHA:1.f];
}

#pragma mark -- UI
/**
 *  设置label的 text\ color \fontSize(正常数值为细体, 300+为正常, 600+为粗体) \background \align
*/
+ (UILabel*)creatLabelWithText:(NSString*)text textColor:(UIColor*)color fontSize:(CGFloat)font backgroundColor:(UIColor*)backgroundColor textAlignment:(NSTextAlignment)align {
    
    UILabel *label = [UILabel new];
	if (text){
		label.text = text;
	}
    label.textColor = color;
    label.textAlignment = align;
	
	if (font > 600.f) {
		label.font = kAYFontMedium(font - 600);
	} else if (font < 600.f && font > 300.f) {
			label.font = [UIFont systemFontOfSize:(font - 300)];
	} else {
        label.font = kAYFontLight(font);
    }
    
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    } else
		label.backgroundColor = [UIColor clearColor];
    
    return label;
}

/**
 *  设置btn的 title color fontSize(正常数值为细体,大于100为粗体,-负数为正常粗细) background align
 */
+ (UIButton*)creatBtnWithTitle:(NSString*)title titleColor:(UIColor*)TitleColor fontSize:(CGFloat)font backgroundColor:(UIColor*)backgroundColor {
    
    UIButton *btn = [UIButton new];
	if (title) {
		[btn setTitle:title forState:UIControlStateNormal];
	}
    [btn setTitleColor:TitleColor forState:UIControlStateNormal];
	
	if (font > 600.f) {
		btn.titleLabel.font = kAYFontMedium((font - 600));
	} else if (font < 600.f && font > 300.f) {
		btn.titleLabel.font = [UIFont systemFontOfSize:(font - 300)];
	} else {
		btn.titleLabel.font = kAYFontLight(font);
	}
	
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    } else
        btn.backgroundColor = [UIColor clearColor];
    
    return btn;
}

+ (void)setViewBorder:(UIView*)view withRadius:(CGFloat)radius andBorderWidth:(CGFloat)width andBorderColor:(UIColor*)color andBackground:(UIColor*)backColor {
	view.layer.cornerRadius = radius;
	view.layer.borderWidth = width;
//	view.layer.border
	view.layer.rasterizationScale = [UIScreen mainScreen].scale;
	view.clipsToBounds = YES;
	if (color) {
		view.layer.borderColor = color.CGColor;
	}
	if (backColor) {
		view.backgroundColor = backColor;
	}
}

+ (void)setShadowOfView:(UIView*)view withViewRadius:(CGFloat)radius_v andColor:(UIColor*)color andOffset:(CGSize)size andOpacity:(CGFloat)opacity andShadowRadius:(CGFloat)radius_s {
	
	if (radius_v != 0) {
		view.layer.cornerRadius = radius_v;
	}
	view.layer.shadowColor = color.CGColor;
	view.layer.shadowOffset = size;
	view.layer.shadowRadius = radius_s;
	view.layer.shadowOpacity = opacity;
}

#pragma mark -- CALayer
+ (void)addBtmLineWithMargin:(CGFloat)margin andAlignment:(NSInteger)alignment andColor:(UIColor*)lineColor inSuperView:(UIView*)superView {
	UIView *line_btm = [[UIView alloc]init];
	line_btm.backgroundColor = lineColor;
	[superView addSubview:line_btm];
	[line_btm mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(superView);
		if(alignment == NSTextAlignmentCenter) {
			make.left.equalTo(superView).offset(margin);
			make.right.equalTo(superView).offset(-margin);
		} else if (alignment == NSTextAlignmentLeft) {
			make.left.equalTo(superView);
			make.right.equalTo(superView).offset(-margin);
		} else if (alignment == NSTextAlignmentRight) {
			make.left.equalTo(superView).offset(margin);
			make.right.equalTo(superView);
		}
		make.height.mas_equalTo(0.5);
	}];
}

+ (void)creatCALayerWithFrame:(CGRect)frame andColor:(UIColor*)color  inSuperView:(UIView*)view {
	
	CALayer *layer = [CALayer layer];
	layer.frame = frame;
	layer.backgroundColor = color.CGColor;
	[view.layer addSublayer:layer];
}

#pragma mark -- AYBtmAlert
- (void)AYShowBtmAlertWithArgs:(NSDictionary*)args {
    
}

#pragma mark -- NSAttributedString
+ (NSAttributedString*)transStingToAttributeString:(NSString *)string withLineSpace:(CGFloat)lineSpace {
	// 调整行间距
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = lineSpace;
	paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
	return attributedString;
}

#pragma mark -- NSDate
+ (NSDateFormatter*)creatDateFormatterWithString:(NSString*)formatter {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	if (formatter) {
		[format setDateFormat:formatter];
	} else
		[format setDateFormat:@"yyyy-MM-dd"];
		
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

+ (NSString*)Bit64String:(NSString *)string {
	/*1.
	const char *cStr = [string UTF8String];
	unsigned char result[CC_MD5_BLOCK_BYTES];
	CC_MD5(cStr, (unsigned)strlen(cStr), result);
	
	return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1], result[2], result[3],
			 result[4], result[5], result[6], result[7]] uppercaseString];
	*/
	
	/*2.
	 */
	const char *cStr = [string UTF8String];
	return [[[NSString alloc] initWithBytes:cStr length:16 encoding:NSUTF8StringEncoding] uppercaseString];
	
}

+ (NSDictionary*)montageServiceInfoWithServiceData:(NSDictionary*)serviceData {
	
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	
	NSDictionary *info_cat = [serviceData objectForKey:kAYServiceArgsCategoryInfo];
	
	NSString *ownerName = [[serviceData objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenName];
	
	[data setValue:ownerName forKey:kAYProfileArgsScreenName];
	NSString *motageName = @"SERVICE";
	NSString *unitCat = @"UNIT";
	NSString *service_cat = [info_cat objectForKey:kAYServiceArgsCat];
	if ([service_cat containsString:@"看"]) {
		unitCat = @"小时";
		motageName = [info_cat objectForKey:kAYServiceArgsCatSecondary];
	}
	else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
		
		motageName = [info_cat objectForKey:kAYServiceArgsConcert];
		if (!motageName || [motageName isEqualToString:@""]) {
			motageName = [info_cat objectForKey:kAYServiceArgsCatThirdly];
			if (!motageName || [motageName isEqualToString:@""]) {
				motageName = [info_cat objectForKey:kAYServiceArgsCatSecondary];
			}
		}
		motageName = [NSString stringWithFormat:@"%@%@", motageName, service_cat];

	} else {
		NSLog(@"---null---");
	}
	
	NSDictionary *info_detail = [serviceData objectForKey:kAYServiceArgsDetailInfo];
	NSNumber *price = [info_detail objectForKey:kAYServiceArgsPrice];
	NSString *priceStr = [NSString stringWithFormat:@"%.f", price.intValue * 0.01];
	
	[data setValue:motageName forKey:@"montage"];
	[data setValue:priceStr forKey:kAYServiceArgsPrice];
	[data setValue:unitCat forKey:@"unit"];
	
	return [data copy];
}

+ (NSString*)serviceCompleteNameFromSKUWith:(NSDictionary *)service_info {
	NSString *completeTheme;
	NSArray *options_title_cans;
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsCat];
	NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCatSecondary];
	
	if (service_cat.intValue == ServiceTypeNursery) {
		
		options_title_cans = kAY_service_options_title_nursery;
		//kangu 服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			completeTheme = @"待调整主题服务";
		} else {
			completeTheme = options_title_cans[cans_cat.integerValue];
		}
		
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		
		NSString *servCatStr = @"课程";
		options_title_cans = kAY_service_options_title_course;
		NSNumber *cans = [service_info objectForKey:kAYServiceArgsCatThirdly];
		//kecheng服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			completeTheme = @"待调整主题服务";
		}
		else {
			
			NSString *costomStr = [service_info objectForKey:kAYServiceArgsCourseCoustom];
			if (costomStr && ![costomStr isEqualToString:@""]) {
				completeTheme = [NSString stringWithFormat:@"%@%@", costomStr, servCatStr];
				
			} else {
				NSDictionary *courseTitleOfAll = kAY_service_course_title_ofall;
				NSArray *signTitleArr = [courseTitleOfAll objectForKey:cans_cat];
				if (cans.integerValue < signTitleArr.count) {
					NSString *courseSignStr = [signTitleArr objectAtIndex:cans.integerValue];
					completeTheme = [NSString stringWithFormat:@"%@%@", courseSignStr, servCatStr];
				} else {
					completeTheme = @"待调整主题服务";
				}
			}//是否自定义课程标签判断end
		}
	} else {
		
		NSLog(@"---null---");
		completeTheme = @"待调整主题服务";
	}
	return completeTheme;
}


+ (NSMutableDictionary*)getBaseRemoteData {
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_remote = [[NSMutableDictionary alloc] init];;
	[dic_remote setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	/*condition*/
	NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
//	[condition setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_remote setValue:condition forKey:kAYCommArgsCondition];
	
	return dic_remote;
}

+ (NSMutableDictionary*)getBaseRemoteData:(NSDictionary*)user {
	NSMutableDictionary *dic_remote = [[NSMutableDictionary alloc] init];;
	[dic_remote setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	/*condition*/
	NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
	//	[condition setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_remote setValue:condition forKey:kAYCommArgsCondition];
	
	return dic_remote;
}

@end
