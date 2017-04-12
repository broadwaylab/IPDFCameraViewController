//
//  CHCapturePreviewViewController.m
//  IPDFCameraViewControllerDemo
//
//  Created by Victor Soto on 4/12/17.
//  Copyright © 2017 Maximilian Mackh. All rights reserved.
//

#import "CHCapturePreviewViewController.h"

@interface CHCapturePreviewViewController ()

@property (strong, nonatomic) UIVisualEffectView *blur;
@property (strong, nonatomic) UIImageView *preview;
@property (strong, nonatomic) UIBarButtonItem *retakeButton;
@property (strong, nonatomic) UIBarButtonItem *continueButton;

@end

@implementation CHCapturePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
    [self configureNavigationBar];
    [self configurePreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configuration

- (void)configurePreview {
    
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blur =[[UIVisualEffectView alloc] initWithEffect:effect];
    [self.view addSubview:self.blur];
    self.blur.frame = self.view.bounds;
    self.blur.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.blur.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.blur.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.blur.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-64] setActive:YES];
    [[self.blur.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    
    self.preview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.preview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.preview];
    [[self.preview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.preview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.preview.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.preview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    self.preview.contentMode = UIViewContentModeScaleAspectFit;
    
    self.preview.image = self.picture;    
}

- (void)configureViewController {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)configureNavigationBar {
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.retakeButton = [[UIBarButtonItem alloc] initWithTitle:@"Retake"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(userDidTouchUpInsideRetakeButton:)];
    self.navigationItem.leftBarButtonItem = self.retakeButton;
    
    self.continueButton = [[UIBarButtonItem alloc] initWithTitle:@"Continue"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(userDidTouchUpInsideContinueButton:)];
    self.navigationItem.rightBarButtonItem = self.continueButton;
}

#pragma mark - Actions

- (void)userDidTouchUpInsideRetakeButton:(id)sender {
    if([self.delegate respondsToSelector:@selector(capturePreviewViewControllerDidSelectRetakeOption:)]) {
        [self.delegate capturePreviewViewControllerDidSelectRetakeOption:self];
    }
}

- (void)userDidTouchUpInsideContinueButton:(id)sender {
    if([self.delegate respondsToSelector:@selector(capturePreviewViewControllerDidSelectContinueOption:)]) {
        [self.delegate capturePreviewViewControllerDidSelectContinueOption:self];
    }
}

@end
