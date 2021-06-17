//
//  AnimationExplorerViewController.m
//  LottieExamples
//
//  Created by brandon_withrow on 1/25/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import "AnimationExplorerViewController.h"
#import "JSONExplorerViewController.h"
#import "LAQRScannerViewController.h"
#import <Lottie/Lottie.h>

typedef enum : NSUInteger {
  ViewBackgroundColorWhite,
  ViewBackgroundColorBlack,
  ViewBackgroundColorGreen,
  ViewBackgroundColorNone
} ViewBackgroundColor;

@interface AnimationExplorerViewController ()

@property (nonatomic, assign) ViewBackgroundColor currentBGColor;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) LOTAnimationView *laAnimation;

@end

@implementation AnimationExplorerViewController

- (void)setCurrentBGColor:(ViewBackgroundColor)currentBGColor {
  _currentBGColor = currentBGColor;
  switch (currentBGColor) {
    case ViewBackgroundColorWhite:
      self.view.backgroundColor = [UIColor whiteColor];
      break;
    case ViewBackgroundColorBlack:
      self.view.backgroundColor = [UIColor blackColor];
      break;
    case ViewBackgroundColorGreen:
      self.view.backgroundColor = [UIColor colorWithRed:50.f/255.f
                                                  green:207.f/255.f
                                                   blue:193.f/255.f
                                                  alpha:1.f];
      break;
    case ViewBackgroundColorNone:
      self.view.backgroundColor = nil;
      break;
    default:
      break;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.currentBGColor = ViewBackgroundColorWhite;
  self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
  
  UIBarButtonItem *open = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(_open:)];
  UIBarButtonItem *openWeb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(_showURLInput)];
  UIBarButtonItem *loop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(_loop:)];
  UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(_play:)];
  UIBarButtonItem *speed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(_setSpeed:)];
  UIBarButtonItem *zoom = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_setZoom:)];
  UIBarButtonItem *bgcolor = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(_setBGColor:)];
  
  self.toolbar.items = @[open, [self flexItem], openWeb, [self flexItem], loop, [self flexItem], play, [self flexItem], speed, [self flexItem], zoom, [self flexItem], bgcolor];
  [self.view addSubview:self.toolbar];
  [self resetAllButtons];
  
  self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
  [self.slider addTarget:self action:@selector(_sliderChanged:) forControlEvents:UIControlEventValueChanged];
  self.slider.minimumValue = 0;
  self.slider.maximumValue = 1;
  [self.view addSubview:self.slider];
  
  [self _loadAnimationNamed:@"LottieLogo2"];
}

- (UIBarButtonItem *)flexItem {
  return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (void)resetAllButtons {
  self.slider.value = 0;
  for (UIBarButtonItem *button in self.toolbar.items) {
    [self resetButton:button highlighted:NO];
  }
}

- (void)resetButton:(UIBarButtonItem *)button highlighted:(BOOL)highlighted {
  button.tintColor = highlighted ? [UIColor redColor] : [UIColor colorWithRed:50.f/255.f
                                                                        green:207.f/255.f
                                                                         blue:193.f/255.f
                                                                        alpha:1.f];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGRect b = self.view.bounds;
  CGFloat safeAreaBottomInset = 0;
  if (@available(iOS 11.0, *)) {
    safeAreaBottomInset = self.view.safeAreaInsets.bottom;
  }
  self.toolbar.frame = CGRectMake(0, b.size.height - 44 - safeAreaBottomInset, b.size.width, 44);
  CGSize sliderSize = [self.slider sizeThatFits:b.size];
  sliderSize.height += 12;
  self.slider.frame = CGRectMake(30, CGRectGetMinY(self.toolbar.frame) - sliderSize.height, b.size.width - 60, sliderSize.height);
  self.laAnimation.frame = CGRectMake(0, 0, b.size.width, CGRectGetMinY(self.slider.frame));
}

- (void)_sliderChanged:(UISlider *)slider {
  self.laAnimation.animationProgress = slider.value;
}

- (void)_open:(UIBarButtonItem *)button {
  [self _showJSONExplorer];
}

- (void)_setZoom:(UIBarButtonItem *)button {
  switch (self.laAnimation.contentMode) {
    case UIViewContentModeScaleAspectFit: {
      self.laAnimation.contentMode = UIViewContentModeScaleAspectFill;
      [self showMessage:@"Aspect Fill"];
    }  break;
    case UIViewContentModeScaleAspectFill:{
      self.laAnimation.contentMode = UIViewContentModeScaleToFill;
      [self showMessage:@"Scale Fill"];
    }
      break;
    case UIViewContentModeScaleToFill: {
      self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
      [self showMessage:@"Aspect Fit"];
    }
      break;
    default:
      break;
  }
}

- (void)_setBGColor:(UIBarButtonItem *)button {
  ViewBackgroundColor current = self.currentBGColor;
  current += 1;
  if (current == ViewBackgroundColorNone) {
    current = ViewBackgroundColorWhite;
  }
  self.currentBGColor = current;
}

- (void)_showURLInput {
  LAQRScannerViewController *qrVC = [[LAQRScannerViewController alloc] init];
  [qrVC setCompletionBlock:^(NSString *selectedAnimation) {
    if (selectedAnimation) {
      [self _loadAnimationFromURLString:selectedAnimation];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
  }];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qrVC];
  [self presentViewController:nav animated:YES completion:NULL];
}

- (void)_showJSONExplorer {
  JSONExplorerViewController *vc = [[JSONExplorerViewController alloc] init];
  [vc setCompletionBlock:^(NSString *selectedAnimation) {
    if (selectedAnimation) {
      [self _loadAnimationNamed:selectedAnimation];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
  }];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:navController animated:YES completion:NULL];
}

- (void)_loadAnimationFromURLString:(NSString *)URL {
  [self.laAnimation removeFromSuperview];
  self.laAnimation = nil;
  [self resetAllButtons];
  
  self.laAnimation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
  self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:self.laAnimation];
  [self.view setNeedsLayout];
}

- (void)_loadAnimationNamed:(NSString *)named {
  [self.laAnimation removeFromSuperview];
  self.laAnimation = nil;
  [self resetAllButtons];
  
  self.laAnimation = [LOTAnimationView animationNamed:named];
  self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:self.laAnimation];
  [self.view setNeedsLayout];
}

- (void)_rewind:(UIBarButtonItem *)button {
  self.laAnimation.animationProgress = 0;
}

- (void)_play:(UIBarButtonItem *)button {
  if (self.laAnimation.isAnimationPlaying) {
    [self resetButton:button highlighted:NO];
    [self.laAnimation pause];
  } else {
    
    CADisplayLink *displayLink =[CADisplayLink displayLinkWithTarget:self selector:@selector(_updateSlider)] ;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self resetButton:button highlighted:YES];
    [self.laAnimation playWithCompletion:^(BOOL animationFinished) {
      [displayLink invalidate];
      [self resetButton:button highlighted:NO];
    }];
  }
}

- (void)_updateSlider {
  self.slider.value = self.laAnimation.animationProgress;
}

- (void)_loop:(UIBarButtonItem *)button {
  self.laAnimation.loopAnimation = !self.laAnimation.loopAnimation;
  [self resetButton:button highlighted:self.laAnimation.loopAnimation];
  [self showMessage:self.laAnimation.loopAnimation ? @"Loop Enabled" : @"Loop Disabled"];
}

- (void)_setSpeed:(UIBarButtonItem *)button {
  if (self.laAnimation.animationSpeed < 3) {
    self.laAnimation.animationSpeed += 1;
  } else {
    self.laAnimation.animationSpeed = 1;
  }
  [self showMessage:[NSString stringWithFormat:@"Speed x%@", @(self.laAnimation.animationSpeed)]];
}

- (void)showMessage:(NSString *)message {
  UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  messageLabel.textAlignment = NSTextAlignmentCenter;
  messageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
  messageLabel.textColor = [UIColor whiteColor];
  messageLabel.text = message;
  
  CGSize messageSize = [messageLabel sizeThatFits:self.view.bounds.size];
  messageSize.width += 14;
  messageSize.height += 14;
  messageLabel.frame = CGRectMake(10, self.view.safeAreaInsets.top + 30, messageSize.width, messageSize.height);
  messageLabel.alpha = 0;
  [self.view addSubview:messageLabel];
  
  [UIView animateWithDuration:0.3 animations:^{
    messageLabel.alpha = 1;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      messageLabel.alpha = 0;
    } completion:^(BOOL finished) {
      [messageLabel removeFromSuperview];
    }];
  }];
}

@end