//
//  AYServiceMapView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServiceMapView.h"
#import "AYCommandDefines.h"
#import <MapKit/MapKit.h>
#import "AYAnnonation.h"

@interface AYServiceMapView () <MKMapViewDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation AYServiceMapView {
	
	NSArray *arrayWithLoc;
	NSMutableArray *annoArray;
	
	NSDictionary *tpLoc;
	NSDictionary *selfLoc;
	CLLocation *loc;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	
	self.delegate = self;
	[self setZoomLevel:120.1];
	annoArray = [[NSMutableArray alloc]init];
	
	UIButton *showMyself = [[UIButton alloc]init];
	[showMyself setImage:IMGRESOURCE(@"position_myself") forState:UIControlStateNormal];
	//	[Tools setViewRadius:showMyself withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	[self addSubview:showMyself];
	[showMyself mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(-20);
		make.bottom.equalTo(self).offset(-120);
		make.size.mas_equalTo(CGSizeMake(37, 37));
	}];
	[showMyself addTarget:self action:@selector(didShowMyselfBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	self.showsUserLocation = YES;
//	CLLocation *locat = self.userLocation.location;
	
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

-(id)changePositionData:(NSDictionary*)args {
	NSDictionary *dic_p2p = args;
	
	if (annoArray.count != 0) {
		[self removeAnnotations:annoArray];
		[annoArray removeAllObjects];
	}
	
	selfLoc = [dic_p2p objectForKey:@"self"];
	NSDictionary *service_info = [args objectForKey:kAYServiceArgsInfo];
	tpLoc = [[args objectForKey:kAYServiceArgsInfo] objectForKey:kAYServiceArgsLocationInfo];
	
	NSDictionary *dic_loc = [tpLoc objectForKey:kAYServiceArgsPin];
	NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
	NSNumber *longitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
	CLLocation *tp_location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
	
	loc = tp_location;
	
//	NSDictionary *info_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *serviceCat = [service_info objectForKey:kAYServiceArgsCat];
	NSString *cansCat = [service_info objectForKey:kAYServiceArgsType];
	NSString *pre_map_icon_name;
	NSArray *optios_title_arr;
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		pre_map_icon_name = @"map_icon_course";
		optios_title_arr = kAY_service_options_title_course;
		
	} else if([serviceCat isEqualToString:kAYStringNursery]) {
		pre_map_icon_name = @"map_icon_nursery";
		optios_title_arr = kAY_service_options_title_nursery;
	}
	
	
	AYAnnonation *anno = [[AYAnnonation alloc]init];
	anno.coordinate = tp_location.coordinate;
	NSString *annoTitle = [tpLoc objectForKey:kAYServiceArgsAddress];
	anno.title = annoTitle;
	anno.imageName_normal = [NSString stringWithFormat:@"%@_%ld_normal",pre_map_icon_name, [optios_title_arr indexOfObject:cansCat]];
	anno.imageName_select = [NSString stringWithFormat:@"%@_%ld_select",pre_map_icon_name, [optios_title_arr indexOfObject:cansCat]];
//	anno.imageName_normal = [NSString stringWithFormat:@"%@_%@_normal",pre_map_icon_name, cansCat];
	[self addAnnotation:anno];
	[annoArray addObject:anno];
	[self setCenterCoordinate:tp_location.coordinate animated:NO];
	
	return nil;
}

#pragma mark -- actios
- (void)didShowMyselfBtnClick {
	if (loc) {
		
		[self setCenterCoordinate:loc.coordinate animated:YES];
	}
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
		
		//展示详情界面
		annotationView.canShowCallout = NO;
		return annotationView;
	} else {
		//采用系统默认蓝色大头针
		return nil;
	}
}

#pragma mark -- mapView delegate
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {//MKAnnotation
	AYAnnonation *anno = view.annotation;
	if (anno.index == 9999) {
		return;
	}
	
	view.highlighted = YES;
	view.image = [UIImage imageNamed:anno.imageName_select];
	[self setCenterCoordinate:anno.coordinate animated:YES];
	
}

//- (void)dealloc {
//	[self clearDisk];
//}
@end
