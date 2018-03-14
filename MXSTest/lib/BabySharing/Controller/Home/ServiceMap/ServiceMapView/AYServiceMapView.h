//
//  AYServiceMapView.h
//  BabySharing
//
//  Created by Alfred Yang on 3/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AYViewBase.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AYServiceMapView : MAMapView <AYViewBase, MAMapViewDelegate/*, AMapSearchDelegate*/>

@end
