//
//  CHCapturePreviewViewController.h
//  IPDFCameraViewControllerDemo
//
//  Created by Victor Soto on 4/12/17.
//  Copyright © 2017 Maximilian Mackh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCapturePreviewViewController;

@protocol CHCapturePreviewViewControllerDelegate <NSObject>
- (void)capturePreviewViewControllerDidSelectRetakeOption:(CHCapturePreviewViewController *)controller;
- (void)capturePreviewViewControllerDidSelectContinueOption:(CHCapturePreviewViewController *)controller;
@end

@interface CHCapturePreviewViewController : UIViewController

@property (weak, nonatomic) id <CHCapturePreviewViewControllerDelegate> delegate;
@property (weak, nonatomic) UIImage *picture;

@end
