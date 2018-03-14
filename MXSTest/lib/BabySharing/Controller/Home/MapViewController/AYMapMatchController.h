//
//  AYMapViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import "AYViewBase.h"
#import <CoreLocation/CoreLocation.h>

@interface AYMapMatchController : AYViewController

@property (nonatomic, strong) CLGeocoder *geoC;

@end
