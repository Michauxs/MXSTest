//
//  AYOpenUIImagePickerPicRollCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYOpenUIImagePickerPicRollCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIkit.h>
#import "AYControllerActionDefines.h"

@implementation AYOpenUIImagePickerPicRollCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
//    NSDictionary* dic = (NSDictionary*)*obj;
//    UIViewController* controller = [dic objectForKey:kAYControllerActionSourceControllerKey];
    UIViewController* controller = [Tools activityViewController];
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = (id<UINavigationControllerDelegate ,UIImagePickerControllerDelegate>)controller;
    pickerImage.allowsEditing = YES;
    [controller presentViewController:pickerImage animated:YES completion:nil];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
