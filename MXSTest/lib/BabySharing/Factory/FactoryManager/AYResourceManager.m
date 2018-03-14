//
//  AYResourceManager.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYResourceManager.h"
#import <UIKit/UIKit.h>

static AYResourceManager* instance = nil;

@interface AYResourceManager ()
@property (nonatomic, strong) NSMutableDictionary* resource_map;
@end

@implementation AYResourceManager {
    NSBundle* resourceBundle;
}

@synthesize resource_map =_resource_map;

+ (AYResourceManager*)sharedInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
            
        }
    }
    return instance;
}

+ (id) allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)init {
    @synchronized(self) {
        self = [super init];
        if (self) {
            _resource_map = [[NSMutableDictionary alloc]init];
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            resourceBundle = [NSBundle bundleWithPath:bundlePath];
        }
        return self;
    }
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (UIImage*)enumResourceImageWithName:(NSString*)image_name andExtension:(NSString*)extension {
    UIImage* result = [_resource_map objectForKey:image_name];
    if (result == nil) {
        result = [UIImage imageNamed:[resourceBundle pathForResource:image_name ofType:extension]];
        [_resource_map setObject:result forKey:image_name];
    }
    return result;
}

- (NSURL*)enumGIFResourceURLWithName:(NSString*)gif_name {
    return [NSURL fileURLWithPath:[resourceBundle pathForResource:gif_name ofType:@"gif"]];
}
@end
