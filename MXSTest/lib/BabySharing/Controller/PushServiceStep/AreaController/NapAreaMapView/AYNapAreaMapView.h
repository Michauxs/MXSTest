//
//  AYNapAreaMapView.h
//  BabySharing
//
//  Created by Alfred Yang on 18/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "AYViewBase.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AYNapAreaMapView : MAMapView <AYViewBase, MAMapViewDelegate/*, AMapSearchDelegate*/>

@end
