//
//  AYOrderMapCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderMapCellView.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYAnnonation.h"

@implementation AYOrderMapCellView {
    MAMapView *orderMapView;
    
    MAAnnotationView *tmp;
    NSArray *arrayWithLoc;
    AYAnnonation *currentAnno;
    NSMutableArray *annoArray;
    
    NSDictionary *resultAndLoc;
    NSArray *fiteResultData;
    
    CLLocation *loc;
    
    UILabel *addressLabel;
    UIImageView *addressBg;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        
        orderMapView = [[MAMapView alloc]init];
        [self addSubview:orderMapView];
        [orderMapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        orderMapView.delegate = self;
        orderMapView.scrollEnabled = NO;
        orderMapView.zoomEnabled = NO;
        //配置用户Key
        [AMapSearchServices sharedServices].apiKey = kAMapApiKey;
        
        addressLabel = [Tools creatLabelWithText:@"service address" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(0);
            make.centerY.equalTo(self).offset(-35);
//            make.width.mas_equalTo(200);
        }];
        
		addressBg = [[UIImageView alloc]init];
		[self addSubview:addressBg];
		//		addressBg.contentMode = UIViewContentModeBottom;
		addressBg.image =  [IMGRESOURCE(@"address_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
		[addressBg mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(addressLabel).insets(UIEdgeInsetsMake(-10, -15, -10, -15));
		}];
		
        [self bringSubviewToFront:addressBg];
        [self bringSubviewToFront:addressLabel];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderMapCell", @"OrderMapCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

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

- (id)setCellInfo:(id)args{
    
    NSDictionary *info = (NSDictionary*)args;
    
    NSString *addressStr = [info objectForKey:@"address"];
    addressLabel.text = addressStr;
    
    NSDictionary *dic_loc = [info objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:kAYServiceArgsLatitude];
    NSNumber *longtitude = [dic_loc objectForKey:kAYServiceArgsLongtitude];
    loc = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longtitude.doubleValue];
    
    if (currentAnno) {
        [orderMapView removeAnnotation:currentAnno];
        NSLog(@"remove current_anno");
    }
    
    //rang
//    orderMapView.visibleMapRect = MAMapRectMake(loc.coordinate.latitude - 40000, loc.coordinate.longitude - 70000, 80000, 140000);
    currentAnno = [[AYAnnonation alloc]init];
    currentAnno.coordinate = loc.coordinate;
    currentAnno.title = @"定位位置";
    currentAnno.imageName_normal = @"location_self";
    currentAnno.index = 9999;
    [orderMapView addAnnotation:currentAnno];
    [orderMapView showAnnotations:@[currentAnno] animated:NO];
    NSLog(@"add current_anno");
    
    //center
    [orderMapView setCenterCoordinate:loc.coordinate animated:YES];
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
@end
