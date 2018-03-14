//
//  AYMapViewView.h
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AYViewBase.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AYMapViewView : MAMapView <AYViewBase, MAMapViewDelegate/*, AMapSearchDelegate*/>

@end
