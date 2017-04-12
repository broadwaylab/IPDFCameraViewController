//
//  IPDFCameraViewController.h
//  InstaPDF
//
//  Created by Maximilian Mackh on 06/01/15.
//  Copyright (c) 2015 mackh ag. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief: Default threshold to handle the auto detection, value is 20.
 */
extern const CGFloat IMAGE_DETECTION_CONFIDENCE_THRESHOLD;

typedef NS_ENUM(NSInteger,IPDFCameraViewType)
{
    IPDFCameraViewTypeBlackAndWhite,
    IPDFCameraViewTypeNormal
};

typedef void (^IPDFCameraCaptureBlock)(NSString *imageFilePath);

@class IPDFCameraViewController;

/*!
 @brief Protocol to handle the auto capture detection events.
 */
@protocol IPDFCameraViewControllerCaptureDelegate <NSObject>

@optional

/*!
 @brief Indicates when the picture has been auto captured.
 @param controller The camera view controller that performed the capture.
 @param imageFilePath The path where the image is located.
*/
- (void)cameraViewController:(IPDFCameraViewController *)controller didAutoCaptureWith:(NSString *)imageFilePath;

/*!
 @brief Indicates the confidence value (from 0 to 1) for the auto capture feature.
 @param controller The camera view controller that performed the capture.
 @param confidence The confidence value.
 */
- (void)cameraViewController:(IPDFCameraViewController *)controller didDetectPatronWithConfidence:(CGFloat)confidence;
@end

@interface IPDFCameraViewController : UIView

- (void)setupCameraView;

- (void)start;
- (void)stop;

@property (nonatomic,assign,getter=isBorderDetectionEnabled) BOOL enableBorderDetection;
@property (nonatomic,assign,getter=isTorchEnabled) BOOL enableTorch;

// Auto capture

/*!
 @brief BOOL to enable the auto capture feature, defaults to NO.
 */
@property (nonatomic, assign, getter=isAutoCaptureEnabled) BOOL autoCaptureEnabled;

/*!
 @brief Delegate to detect the auto capture events.
 @see IPDFCameraViewControllerCaptureDelegate .
 */
@property (nonatomic, weak) id <IPDFCameraViewControllerCaptureDelegate> delegate;

/*!
 @brief Numeric value to indicate the threshold the controller needs to detect to trigger the auto capture event
 @discussion Defaults to @see IPDFCameraViewControllerCaptureDelegate, the greater the more it will take to detect
*/
@property (nonatomic, assign) CGFloat confidenceThreshold;

@property (nonatomic,assign) IPDFCameraViewType cameraViewType;

@property (assign, nonatomic) BOOL forceBlackAndWhiteCapture;

@property (nonatomic, strong) UIColor *overlayColor;

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler;

- (void)captureImageWithCompletionHander:(IPDFCameraCaptureBlock)completionHandler;

@end
