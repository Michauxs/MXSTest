//
//  AYServiceMapCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceMapCellView.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYPlayItemsView.h"
#import "AYAnnonation.h"

@implementation AYServiceMapCellView {
	
	MAMapView *orderMapView;
	AYAnnonation *currentAnno;
	
	UILabel *addressLabel;
	
	UIView *tapview;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
}

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

#pragma mark -- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *titleLabel = [UILabel creatLabelWithText:@"场地地址" textColor:[UIColor black13] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.top.equalTo(self).offset(20);
//			make.bottom.equalTo(self).offset(-100);
		}];
		
		addressLabel = [UILabel creatLabelWithText:@"Map address info" textColor:[UIColor black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		addressLabel.numberOfLines = 2;
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(titleLabel.mas_bottom).offset(9);
			make.left.equalTo(titleLabel);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
		}];
		
		orderMapView = [[MAMapView alloc] init];
		[self addSubview:orderMapView];
		[orderMapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(addressLabel.mas_bottom).offset(13);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SERVICEPAGE_MARGIN_LR*2, 118));
			make.bottom.equalTo(self).offset(-40);
		}];
		orderMapView.delegate = self;
		orderMapView.scrollEnabled = NO;
		orderMapView.zoomEnabled = NO;
		[AMapSearchServices sharedServices].apiKey = kAMapApiKey;
		
		tapview = [[UIView alloc]init];
		[self addSubview:tapview];
		[tapview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(orderMapView);
		}];
		tapview.alpha = 0.05;
		tapview.userInteractionEnabled = YES;
		[tapview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didMapTap)]];
		
		
	}
	return self;
}

- (id)setCellInfo:(id)args{
	
	NSDictionary *service_info = (NSDictionary*)args;
	
	NSDictionary *info_loc = [service_info objectForKey:kAYServiceArgsLocationInfo];
	NSString *addressStr = [info_loc objectForKey:kAYServiceArgsAddress];
	if (addressStr.length != 0) {
		addressLabel.text = addressStr;
	}
	
	NSDictionary *info_pin = [info_loc objectForKey:kAYServiceArgsPin];
	NSNumber *latitude = [info_pin objectForKey:kAYServiceArgsLatitude];
	NSNumber *longitude = [info_pin objectForKey:kAYServiceArgsLongtitude];
	
	if (latitude && longitude) {
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
		if (currentAnno) {
			[orderMapView removeAnnotation:currentAnno];
		}
		tapview.userInteractionEnabled = YES;
		
		
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
		
		//rang
//		orderMapView.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 2000, loc.coordinate.longitude - 1000, 4000, 2000);
		currentAnno = [[AYAnnonation alloc] init];
		currentAnno.coordinate = loc.coordinate;
		currentAnno.title = @"定位位置";
		currentAnno.imageName_normal = [NSString stringWithFormat:@"%@_%ld_normal",pre_map_icon_name, [optios_title_arr indexOfObject:cansCat]];
		currentAnno.imageName_select = [NSString stringWithFormat:@"%@_%ld_select",pre_map_icon_name, [optios_title_arr indexOfObject:cansCat]];
		currentAnno.index = 9999;
		[orderMapView addAnnotation:currentAnno];
		
		[orderMapView setCenterCoordinate:currentAnno.coordinate animated:YES];
	} else {
		tapview.userInteractionEnabled = NO;
	}
	
	return nil;
}

#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
	if ([annotation isKindOfClass:[AYAnnonation class]]) {
		
		static NSString *ID = @"anno";
		MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
		if (annotationView == nil) {
			annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
		}
		
		AYAnnonation *anno = (AYAnnonation *) annotation;
		annotationView.image = [UIImage imageNamed:anno.imageName_normal];	//设置属性 指定图片
		annotationView.tag = anno.index;
		annotationView.canShowCallout = NO;	//展示详情界面
		return annotationView;
	} else {
		
		return nil;
	}
}

#pragma mark -- actions
- (void)didMapTap {
	
	[(AYViewController*)self.controller performAYSel:@"showP2PMap" withResult:nil];
}

@end
