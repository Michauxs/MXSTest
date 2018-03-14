//
//  AYMapViewView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapViewView.h"
#import "AYCommandDefines.h"
#import <MapKit/MapKit.h>
#import "AYAnnonation.h"
//#import "MAUserLocationView7.h"

@interface AYMapViewView () <MKMapViewDelegate>
@property (nonatomic,strong)CLLocationManager *manager;
@end

@implementation AYMapViewView{
    MAAnnotationView *annoViewHandle;
    NSArray *arrayWithLoc;
    NSMutableArray *annoArray;
	
    NSArray *fiteResultData;
	CLLocation *loc;
	
	CLLocation *coustom_loc;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	
    self.delegate = self;
	[self setZoomLevel:60.1 animated:YES];
	self.zoomEnabled = NO;
    annoArray = [[NSMutableArray alloc]init];
	
	UIView *shadow_map = [UIView new];
	shadow_map.backgroundColor = [UIColor white];
	shadow_map.layer.shadowColor = [UIColor colorWithRED:44 GREEN:52 BLUE:109 ALPHA:1].CGColor;
	shadow_map.layer.shadowOffset = CGSizeMake(0, 2);
	shadow_map.layer.shadowRadius = 5;
	shadow_map.layer.shadowOpacity = 0.2f;
	shadow_map.layer.cornerRadius = 4;
	[self addSubview:shadow_map];
	[shadow_map mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(20);
		make.bottom.equalTo(self).offset(-195);
		make.size.mas_equalTo(CGSizeMake(34, 34));
	}];
	UIButton *showMyself = [[UIButton alloc]init];
	[showMyself setImage:IMGRESOURCE(@"map_position_user") forState:UIControlStateNormal];
	[self addSubview:showMyself];
	[showMyself mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(self).offset(20);
//		make.bottom.equalTo(self).offset(-195);
//		make.size.mas_equalTo(CGSizeMake(34, 34));
		make.edges.equalTo(shadow_map);
	}];
	[showMyself addTarget:self action:@selector(didShowMyselfBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)showUserLocation:(id)args {
	loc = args;
	[self setCenterCoordinate:loc.coordinate animated:NO];
	self.showsUserLocation = YES;
	return nil;
}

- (id)changeResultData:(NSDictionary*)args {
    NSDictionary *resultAndLoc = args;
    
    if (annoArray.count != 0) {
        [self removeAnnotations:annoArray];
		[annoArray removeAllObjects];
    }
    
//    loc = [resultAndLoc objectForKey:kAYServiceArgsLocationInfo];
    fiteResultData = [resultAndLoc objectForKey:@"result_data"];
    
    for (int i = 0; i < fiteResultData.count; ++i) {
        NSDictionary *service_info = fiteResultData[i];
        
		NSDictionary *dic_pin = [service_info objectForKey:kAYServiceArgsPin];
		NSNumber *latitude = [dic_pin objectForKey:kAYServiceArgsLatitude];
		NSNumber *longitude = [dic_pin objectForKey:kAYServiceArgsLongtitude];
		CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
		
		AYAnnonation *anno = [[AYAnnonation alloc]init];
		anno.coordinate = location.coordinate;
		NSString *annoTitle = [service_info objectForKey:kAYServiceArgsAddress];
		anno.title = annoTitle;
		anno.index = i;
		
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
		
		anno.imageName_normal = [NSString stringWithFormat:@"%@_%ld_normal",pre_map_icon_name, [optios_title_arr indexOfObject:cansCat]];
		anno.imageName_select = [NSString stringWithFormat:@"%@_%ld_select",pre_map_icon_name, [optios_title_arr indexOfObject:cansCat]];
		
        [self addAnnotation:anno];
        [annoArray addObject:anno];
    }
	
//    self.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 60000, loc.coordinate.longitude - 90000, 120000, 180000);
//    [self regionThatFits:MACoordinateRegionMake(loc.coordinate, MACoordinateSpanMake(loc.coordinate.latitude,loc.coordinate.longitude))];
	
	[self zoomToMapAnnotations:annoArray];
	[self highlightedFirstAnno];
	
    return nil;
}

#pragma mark -- actios
- (void)highlightedFirstAnno {
	
	AYAnnonation *first_anno = annoArray.firstObject;
	if (first_anno) {
		
		annoViewHandle = [self viewForAnnotation:first_anno];
		annoViewHandle.highlighted = YES;
		annoViewHandle.image = [UIImage imageNamed:first_anno.imageName_select];
	}
}

- (id)didShowMyselfBtnClick {
//	[self setCenterCoordinate:loc.coordinate animated:YES];
	coustom_loc = loc;
	id tmp = [coustom_loc copy];
	[((AYViewController*)self.controller) performAYSel:@"userMovedMap:" withResult:&tmp];
	return nil;
}

- (void)zoomToMapAnnotations:(NSArray*)annotations {
	double minLat = 360.0f, maxLat = -360.0f;
	double minLon = 360.0f, maxLon = -360.0f;
	
	CLLocation *handle = coustom_loc? coustom_loc : loc;
	double centerLat = handle.coordinate.latitude, centerLon = handle.coordinate.longitude;
	
	for (AYAnnonation *annotation in annotations) {
		if ( annotation.coordinate.latitude  < minLat ) {
			minLat = annotation.coordinate.latitude;
			maxLat = centerLat + (centerLat-minLat);
		}
		
		if ( annotation.coordinate.latitude  > maxLat ) {
			maxLat = annotation.coordinate.latitude;
			minLat = centerLat + (centerLat-maxLat);
		}
		
		if ( annotation.coordinate.longitude < minLon ) {
			minLon = annotation.coordinate.longitude;
			maxLon = centerLon + (centerLon-minLon);
		}
		
		if ( annotation.coordinate.longitude > maxLon ) {
			maxLon = annotation.coordinate.longitude;
			minLon = centerLon + (centerLon-maxLon);
		}
	}
//	CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLon + maxLon) / 2.0);
	MACoordinateSpan span = MACoordinateSpanMake((maxLat - minLat)*1.2, (maxLon - minLon)*1.2);
	MACoordinateRegion region = MACoordinateRegionMake(handle.coordinate, span);
	[self setRegion:region animated:YES];
	
}

#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
        static NSString *ID = @"AYMapAnnotationViewID";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        }
		
        AYAnnonation *anno = (AYAnnonation *) annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName_normal];
        annotationView.canShowCallout = NO;
        return annotationView;
		
    } else {
        return nil;
    }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
	if (wasUserAction) {
		MACoordinateRegion reg = self.region;
		CLLocationCoordinate2D center = reg.center;
		double lat = center.latitude;
		double lon = center.longitude;
		NSLog(@"\nlat:%f\nlon:%f", lat, lon);
		
		coustom_loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
		id tmp = [coustom_loc copy];
		[((AYViewController*)self.controller) performAYSel:@"userMovedMap:" withResult:&tmp];
	}
}

#pragma mark -- mapView delegate
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {		//MKAnnotation
	
    AYAnnonation *anno = view.annotation;
	if ([anno isKindOfClass:[MAUserLocation class]]) {
		return;
	}
	
    if (annoViewHandle) {		//判断当前 是否已经有高亮的item
		if ( annoViewHandle != view) {		// 判断是否点击了已经是高亮的item
			AYAnnonation *anno_handleView = annoViewHandle.annotation;
			annoViewHandle.highlighted = NO;
			annoViewHandle.image = [UIImage imageNamed:anno_handleView.imageName_normal];
		} else
			return;
    }
	
	view.highlighted = YES;
    view.image = [UIImage imageNamed:anno.imageName_select];
//	[self setCenterCoordinate:anno.coordinate animated:YES];
	
    annoViewHandle = view;
	
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeOffsetMessage:"];
    NSNumber *index = [NSNumber numberWithFloat:(anno.index)];
    [cmd performWithResult:&index];
    
}

- (id)changeAnnoView:(NSNumber*)index {
    
    if (index.longValue >= fiteResultData.count) {
        return nil;
    }
	
    for ( AYAnnonation *one in annoArray) {
		
        if (one.index == index.longValue) {
            MAAnnotationView *change_view = [self viewForAnnotation:one];
			if (annoViewHandle) {		//判断当前 是否已经有高亮的item
				if ( annoViewHandle != change_view) {		// 判断是否点击了已经是高亮的item
					AYAnnonation *anno_handle = annoViewHandle.annotation;
					annoViewHandle.highlighted = NO;
					annoViewHandle.image = [UIImage imageNamed:anno_handle.imageName_normal];
				} else
					break;
			}
			
			NSDictionary *service_info = fiteResultData[index.longValue];
//			NSDictionary *info_location = [service_info objectForKey:kAYServiceArgsLocationInfo];
			NSDictionary *dic_loc = [service_info objectForKey:kAYServiceArgsPin];
			NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
			NSNumber *longitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
			if (latitude && longitude) {
				change_view.highlighted = YES;
				change_view.image = [UIImage imageNamed:one.imageName_select];
				
//				CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
//				[self setCenterCoordinate:location.coordinate animated:YES];
			}
			annoViewHandle = change_view;		//交接
			break;
        }
    }
    
    return nil;
}

- (void)dealloc {
	UIViewController *vc = [Tools activityViewController];
	if (vc == _controller) {
		[self clearDisk];
	}
}
@end
