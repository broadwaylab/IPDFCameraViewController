//
//  UIImagePickerController+CHPhotoPermissions.m
//  IPDFCameraViewControllerDemo
//
//  Created by Victor Soto on 5/1/17.
//  Copyright © 2017 Maximilian Mackh. All rights reserved.
//

#import "UIImagePickerController+CHPhotoPermissions.h"
#import <Photos/Photos.h>

@implementation UIImagePickerController (CHPhotoPermissions)

+ (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType withSuccessHandler:(void (^) ())successHandler andFailure:(void (^) ())failureHandler {    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        // Denied when photo disabled, authorized when photos is enabled. Not affected by camera
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    if (successHandler)
                        dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
                }; break;
                    
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:{
                    if (failureHandler)
                        dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
                }; break;
                    
                default:
                    break;
            }
        }];
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera){
        // Checks for Camera access:
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status){
                
            case AVAuthorizationStatusAuthorized:{
                if (successHandler)
                    dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
            }; break;
                
            case AVAuthorizationStatusNotDetermined:{
                // seek access first:
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        if (successHandler)
                            dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
                    } else {
                        if (failureHandler)
                            dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
                    }
                }];
            }; break;
                
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            default:{
                if (failureHandler)
                    dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
            }; break;
        }
    }
    else{
        NSAssert(NO, @"Permission type not found");
    }
}

@end
