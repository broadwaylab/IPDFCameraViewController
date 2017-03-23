//
//  ViewController.h
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHCardScanViewControllerDelegate <NSObject>

- (void)viewController:(UIViewController *)viewController didFinishPickingImage:(UIImage *)image;
- (void)viewControllerDidCancel:(UIViewController *)viewController;

@end

@interface CHCardScanViewController : UIViewController

@property (nonatomic, assign) id<CHCardScanViewControllerDelegate> delegate;

@end

