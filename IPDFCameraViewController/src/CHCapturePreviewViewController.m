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
@property (strong, nonatomic) UIButton *retakeButton;
@property (strong, nonatomic) UIButton *continueButton;

@end

@implementation CHCapturePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
    [self configureNavigationBar];
    [self configureBlur];
    [self configureRetakeButton];
    [self configureContinueButton];
    [self configurePreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Configuration

- (void)configureBlur {
    
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blur =[[UIVisualEffectView alloc] initWithEffect:effect];
    [self.view addSubview:self.blur];
    
    self.blur.frame = self.view.bounds;
    self.blur.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.blur.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.blur.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.blur.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-64] setActive:YES];
    [[self.blur.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
}

- (void)configurePreview {
    
    self.preview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.preview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.preview];
    [[self.preview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.preview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.preview.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.preview.bottomAnchor constraintEqualToAnchor:self.continueButton.topAnchor constant:-10] setActive:YES];
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
}

- (void)configureRetakeButton {
    UIButton *retakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    retakeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:retakeButton];
    [[retakeButton.heightAnchor constraintEqualToConstant:40] setActive:YES];
    [[retakeButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:self.view.layoutMargins.left] setActive:YES];
    [[retakeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-self.view.layoutMargins.right] setActive:YES];
    [[retakeButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10] setActive:YES];
    [retakeButton setTitleColor:[UIColor colorWithRed:0.945 green:0.231 blue:0.212 alpha:1.000] forState:UIControlStateNormal];
    [retakeButton setTitle:@"Retake screenshot" forState:UIControlStateNormal];
    retakeButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [retakeButton addTarget:self action:@selector(userDidTouchUpInsideRetakeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.retakeButton = retakeButton;
}

- (void)configureContinueButton {
    UIButton *continueButton = [[UIButton alloc] initWithFrame:CGRectZero];
    continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:continueButton];
    [[continueButton.heightAnchor constraintEqualToConstant:55] setActive:YES];
    [[continueButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:self.view.layoutMargins.left] setActive:YES];
    [[continueButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-self.view.layoutMargins.right] setActive:YES];
    [[continueButton.bottomAnchor constraintEqualToAnchor:self.retakeButton.topAnchor constant:-10] setActive:YES];
    [continueButton setBackgroundColor:[UIColor colorWithRed:0.271 green:0.557 blue:0.898 alpha:1.000]];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(userDidTouchUpInsideContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    continueButton.layer.cornerRadius = 22.5;
    self.continueButton = continueButton;
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
