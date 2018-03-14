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

@interface AYHomeController : AYViewController <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) CLLocationManager  *manager;

@end
