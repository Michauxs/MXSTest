//
//  AYOpenUIImagePickerCameraCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYOpenUIImagePickerCameraCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIkit.h>
#import "AYControllerActionDefines.h"

@implementation AYOpenUIImagePickerCameraCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
//    NSDictionary* dic = (NSDictionary*)*obj;
//    UIViewController* controller = [dic objectForKey:kAYControllerActionSourceControllerKey];
    
    UIViewController* controller = [Tools activityViewController];
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
//        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
        
    } else {
        NSLog(@"设备不支持照相机");
    }
    pickerImage.delegate = (id<UINavigationControllerDelegate ,UIImagePickerControllerDelegate>)controller;
    pickerImage.allowsEditing = YES;
    [controller presentViewController:pickerImage animated:YES completion:nil];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
