//
//  ViewController.m
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import "CHCardScanViewController.h"
#import "IPDFCameraViewController.h"
#import "CHCapturePreviewViewController.h"
#import "UIImagePickerController+CHPhotoPermissions.h"

@interface CHCardScanViewController ()

<IPDFCameraViewControllerCaptureDelegate,
CHCapturePreviewViewControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet IPDFCameraViewController *cameraViewController;
@property (strong, nonatomic) UIImage *captureImage;

- (IBAction)focusGesture:(id)sender;

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
    self.overlayColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cameraViewController start];
    [self pauseCapturing];
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
#pragma mark Actions

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
    if(self.focusIndicator != nil) {
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
}

- (IBAction)closeButtonPressed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate viewControllerDidCancel:self];
    }
}

- (IBAction)torchButtonPressed:(UIButton *)sender
{
    BOOL enable = !self.cameraViewController.isTorchEnabled;
    self.cameraViewController.enableTorch = enable;
    sender.selected = self.cameraViewController.isTorchEnabled;
}

- (IBAction)cameraRollButtonPressed:(id)sender {
    [self pauseCapturing];
    [self checkImagePickerPermissions];
}

#pragma mark - 
#pragma mark - Capturing

- (void)captureButton:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self.cameraViewController captureImageWithCompletionHander:^(NSString *imageFilePath)
     {
         [weakSelf processImageAt:imageFilePath];
     }];
}

- (void)pauseCapturing {
    [self.cameraViewController pauseCapture];
}

- (void)resumeCapturing {
    [self.cameraViewController resumeCapture];
}

#pragma mark - 
#pragma mark - Image processing

- (void)processImageAt:(NSString *)imageFilePath {
    UIImage *captureImage = [UIImage imageWithContentsOfFile:imageFilePath];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showPreviewControllerWithImage:captureImage];
    });
}

#pragma mark - 
#pragma mark - Preview, CHCapturePreviewViewControllerDelegate

- (void)showPreviewControllerWithImage:(UIImage *)image {
    self.captureImage = image;
    
    CHCapturePreviewViewController *previewViewController = [[CHCapturePreviewViewController alloc] init];
    previewViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:previewViewController];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    previewViewController.picture = self.captureImage;
    
    UIViewController *presented = [self presentedViewController];
    if(presented != nil) {
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf presentViewController:navigationController animated:YES completion:^{
                [weakSelf pauseCapturing];
            }];
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        [self presentViewController:navigationController animated:YES completion:^{
            [weakSelf pauseCapturing];
        }];
    }
}

- (void)capturePreviewViewControllerDidSelectRetakeOption:(CHCapturePreviewViewController *)controller {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf resumeCapturing];
    });
}

- (void)capturePreviewViewControllerDidSelectContinueOption:(CHCapturePreviewViewController *)controller {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(viewController:didFinishPickingImage:)]) {
            [weakSelf.delegate viewController:self didFinishPickingImage:weakSelf.captureImage];
        }
    });
}

#pragma mark -
#pragma mark - IPDFCameraViewControllerCaptureDelegate

- (void)cameraViewController:(IPDFCameraViewController *)controller didAutoCaptureWith:(NSString *)imageFilePath {
    [self processImageAt:imageFilePath];
}

- (void)cameraViewController:(IPDFCameraViewController *)controller didDetectPatronWithConfidence:(CGFloat)confidence overlayRect:(CGRect)rect {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.delegate viewController:weakSelf didDetectPatronWithConfidence:confidence overlayRect:rect];
    });
}

#pragma mark - 
#pragma mark - UIImagePicker

- (void)checkImagePickerPermissions {
    __weak typeof(self) weakSelf = self;
    [UIImagePickerController obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypePhotoLibrary
                                             withSuccessHandler:^{
        [weakSelf presentImagePicker];
    } andFailure:^{
        [weakSelf.delegate userDidDenyAccessToPhotosInViewController:weakSelf];
        [weakSelf resumeCapturing];
    }];
}

- (void)presentImagePicker {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.cameraViewController processImage:image WithCompletionHander:^(NSString *imageFilePath) {
            [weakSelf processImageAt:imageFilePath];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf resumeCapturing];
    }];
}


@end
