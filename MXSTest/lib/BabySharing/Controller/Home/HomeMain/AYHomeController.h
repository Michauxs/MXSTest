//
//  AYHomeController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AYRemoteCallManager.h"

@interface AYHomeController : AYViewController <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *geoC;

@end
