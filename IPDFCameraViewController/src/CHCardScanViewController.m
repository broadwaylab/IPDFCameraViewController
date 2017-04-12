//
//  ViewController.m
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import "CHCardScanViewController.h"

#import "IPDFCameraViewController.h"

@interface CHCardScanViewController ()

<IPDFCameraViewControllerCaptureDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IPDFCameraViewController *cameraViewController;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndicator;
@property (strong, nonatomic) UILabel *percentageLabel;
@property (strong, nonatomic) NSNumberFormatter *formatter;

- (IBAction)focusGesture:(id)sender;

- (IBAction)captureButton:(id)sender;

@end

@implementation CHCardScanViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cameraViewController setupCameraView];
    [self.cameraViewController setEnableBorderDetection:YES];
    
    // Auto capture
    self.cameraViewController.delegate = self;
    self.cameraViewController.autoCaptureEnabled = YES;
    [self.cameraViewController setCameraViewType:IPDFCameraViewTypeNormal];
    [self.cameraViewController setForceBlackAndWhiteCapture:YES];
    
    // Overlay
    self.overlayColor = [UIColor redColor];
    
    self.percentageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.percentageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.percentageLabel];
    [[self.percentageLabel.heightAnchor constraintEqualToConstant:30] setActive:YES];
    [[self.percentageLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.percentageLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.percentageLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    self.percentageLabel.textColor = [UIColor whiteColor];
    self.percentageLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:22];
    self.percentageLabel.text = nil;
    self.percentageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    [self.formatter setNumberStyle:NSNumberFormatterPercentStyle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.cameraViewController start];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 
#pragma mark - Overlay Color

- (void)setOverlayColor:(UIColor *)overlayColor {
    _overlayColor = overlayColor;
    self.cameraViewController.overlayColor = overlayColor;
}

#pragma mark -
#pragma mark CameraVC Actions

- (IBAction)focusGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [sender locationInView:self.cameraViewController];
        
        [self focusIndicatorAnimateToPoint:location];
        
        [self.cameraViewController focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}

- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint
{
    [self.focusIndicator setCenter:targetPoint];
    self.focusIndicator.alpha = 0.0;
    self.focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
    {
         self.focusIndicator.alpha = 1.0;
    }
    completion:^(BOOL finished)
    {
         [UIView animateWithDuration:0.4 animations:^
         {
             self.focusIndicator.alpha = 0.0;
         }];
     }];
}

- (IBAction)borderDetectToggle:(id)sender
{
    // Cancel
    if (self.delegate != nil) {
        [self.delegate viewControllerDidCancel:self];
    }
}

- (IBAction)filterToggle:(id)sender
{
    [self.cameraViewController setCameraViewType:(self.cameraViewController.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? IPDFCameraViewTypeNormal : IPDFCameraViewTypeBlackAndWhite];
}

- (IBAction)torchToggle:(id)sender
{
    BOOL enable = !self.cameraViewController.isTorchEnabled;
    [self changeButton:sender targetTitle:(enable) ? @"FLASH On" : @"FLASH Off" toStateEnabled:enable];
    self.cameraViewController.enableTorch = enable;
}

- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:0.81 blue:0 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark CameraVC Capture Image

- (IBAction)captureButton:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self.cameraViewController captureImageWithCompletionHander:^(NSString *imageFilePath)
    {
        [weakSelf processImageAt:imageFilePath];
    }];
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap
{
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
    {
        dismissTap.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
    }
    completion:^(BOOL finished)
    {
        weakSelf.cameraViewController.autoCaptureEnabled = YES;
        [dismissTap.view removeFromSuperview];
    }];
}

#pragma mark - 
#pragma mark - Image processing

- (void)processImageAt:(NSString *)imageFilePath {
    UIImage *captureImage = [UIImage imageWithContentsOfFile:imageFilePath];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate != nil) {
            [weakSelf.delegate viewController:self
                        didFinishPickingImage:captureImage];
        }
    });
}

#pragma mark -
#pragma mark - IPDFCameraViewControllerCaptureDelegate

- (void)cameraViewController:(IPDFCameraViewController *)controller didAutoCaptureWith:(NSString *)imageFilePath {
    [self processImageAt:imageFilePath];
}

- (void)cameraViewController:(IPDFCameraViewController *)controller didDetectPatronWithConfidence:(CGFloat)confidence {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (confidence <= 0) {
            weakSelf.percentageLabel.text = nil;
        } else {
            weakSelf.percentageLabel.text = [self.formatter stringFromNumber:@(confidence)];
        }
    });
}

@end
