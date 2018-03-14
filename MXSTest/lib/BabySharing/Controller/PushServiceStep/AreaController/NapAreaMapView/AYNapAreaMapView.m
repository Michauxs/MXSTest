//
//  AYNapAreaMapView.m
//  BabySharing
//
//  Created by Alfred Yang on 18/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapAreaMapView.h"
#import "AYCommandDefines.h"
#import "Tools.h"
#import <MapKit/MapKit.h>
#import "AYAnnonation.h"

@implementation AYNapAreaMapView{
    MAAnnotationView *tmp;
    NSArray *arrayWithLoc;
    AYAnnonation *currentAnno;
    NSMutableArray *annoArray;
    
    NSDictionary *resultAndLoc;
    NSArray *fiteResultData;
    
    CLLocation *loc;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
//    self.scrollEnabled = NO;
//    self.zoomEnabled = NO;
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = kAMapApiKey;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

-(id)changeResultData:(NSDictionary*)args{
    resultAndLoc = args;
    return nil;
}
#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
        //默认红色小球
        static NSString *ID = @"anno";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        }
        //设置属性 指定图片
        AYAnnonation *anno = (AYAnnonation *) annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName_normal];
        annotationView.tag = anno.index;
        //展示详情界面
        annotationView.canShowCallout = NO;
        return annotationView;
    } else {
        //采用系统默认蓝色大头针
        return nil;
    }
}

- (id)queryOnesLocal:(id)args{
    
    loc = (CLLocation*)args;
    
    if (currentAnno) {
        [self removeAnnotation:currentAnno];
        NSLog(@"remove current_anno");
    }
    
//    self.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 40000, loc.coordinate.longitude - 70000, 80000, 140000);
    currentAnno = [[AYAnnonation alloc]init];
    currentAnno.coordinate = loc.coordinate;
    currentAnno.title = @"定位位置";
    currentAnno.imageName_normal = @"location_self";
    currentAnno.index = 9999;
    [self addAnnotation:currentAnno];
    [self showAnnotations:@[currentAnno] animated:NO];
    [self regionThatFits:MACoordinateRegionMake(loc.coordinate, MACoordinateSpanMake(loc.coordinate.latitude,loc.coordinate.longitude))];
    NSLog(@"add current_anno");
    
    //center
    [self setCenterCoordinate:loc.coordinate animated:YES];
    
    return nil;
}
@end
