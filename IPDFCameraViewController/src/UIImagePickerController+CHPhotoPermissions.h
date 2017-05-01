//
//  UIImagePickerController+CHPhotoPermissions.h
//  IPDFCameraViewControllerDemo
//
//  Created by Victor Soto on 5/1/17.
//  Copyright © 2017 Maximilian Mackh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (CHPhotoPermissions)

+ (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType withSuccessHandler:(void (^) ())successHandler andFailure:(void (^) ())failureHandler;

@end
