//
//  AYResourceManager.h
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface AYResourceManager : NSObject

+ (AYResourceManager*)sharedInstance;

- (UIImage*)enumResourceImageWithName:(NSString*)image_name andExtension:(NSString*)extension;
- (NSURL*)enumGIFResourceURLWithName:(NSString*)gif_name;
@end
