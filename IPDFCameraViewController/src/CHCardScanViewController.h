//
//  ViewController.h
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCardScanViewController;

@protocol CHCardScanViewControllerDelegate <NSObject>

- (void)viewController:(CHCardScanViewController *)viewController didFinishPickingImage:(UIImage *)image;
- (void)viewControllerDidCancel:(CHCardScanViewController *)viewController;
- (void)viewController:(CHCardScanViewController *)controller didDetectPatronWithConfidence:(CGFloat)confidence;

@end

@interface CHCardScanViewController : UIViewController

@property (nonatomic, assign) id<CHCardScanViewControllerDelegate> delegate;

@end

