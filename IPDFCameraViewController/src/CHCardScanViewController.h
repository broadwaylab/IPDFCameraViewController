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
@end

@interface CHCardScanViewController : UIViewController

@property (nonatomic, assign) id<CHCardScanViewControllerDelegate> delegate;
@property (nonatomic, weak) UIColor *overlayColor;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndicator;

- (void)showControls;
- (void)hideControls;
- (void)pauseCapturing;
- (void)resumeCapturing;

@end

