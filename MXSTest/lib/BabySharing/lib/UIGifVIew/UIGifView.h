//
//  UIView+CenterGif.h
//  BabySharing
//
//  Created by Alfred Yang on 3/16/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@interface UIGifView : UIView <CAAnimationDelegate>
#else
@interface UIGifView : UIView
#endif
//@interface UIGifView : UIView
/*
 * @brief desingated initializer
 */
- (id)initWithCenter:(CGPoint)center fileURL:(NSURL*)fileURL andSize:(CGSize)sz;

/*
 * @brief start Gif Animation
 */
- (void)startGif;

/*
 * @brief stop Gif Animation
 */
- (void)stopGif;

/*
 * @brief get frames image(CGImageRef) in Gif
 */
+ (NSArray*)framesInGif:(NSURL*)fileURL;
@end
