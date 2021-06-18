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
@property (nonatomic, strong) UISlider *zSlider;
@property (nonatomic, strong) UISlider *rotateSlider;
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
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RESET" style:UIBarButtonItemStylePlain target:self action:@selector(resetPerspective)];
  
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
  
  self.rotateSlider = [[UISlider alloc] initWithFrame:CGRectZero];
  [self.rotateSlider addTarget:self action:@selector(_rotateChanged:) forControlEvents:UIControlEventValueChanged];
  self.rotateSlider.minimumValue = 0;
  self.rotateSlider.maximumValue = M_PI / 3;
  self.rotateSlider.value = 0;
  [self.view addSubview:self.rotateSlider];
  
  self.zSlider = [[UISlider alloc] initWithFrame:CGRectZero];
  [self.zSlider addTarget:self action:@selector(_zSliderChanged:) forControlEvents:UIControlEventValueChanged];
  self.zSlider.minimumValue = 0;
  self.zSlider.maximumValue = 2;
  self.zSlider.value = 0;
  [self.view addSubview:self.zSlider];
  
  [self _loadAnimationNamed:@"LottieLogo1"];
  [self.laAnimation play];
}

- (void)resetPerspective {
  self.rotateSlider.value = self.rotateSlider.minimumValue;
  self.zSlider.value = self.zSlider.minimumValue;
  
  CALayer *target = self.laAnimation.layer;
  
  CATransform3D perspective = CATransform3DIdentity;

  target.sublayerTransform = perspective;
  [self levelTravelLayer:target transform:perspective zIndexScale:self.zSlider.value];
}

- (void)debugPerspective {
  CALayer *target = self.laAnimation.layer;
  
  CATransform3D perspective = CATransform3DIdentity;
  perspective.m34 = -1.0 / 1000;
  perspective = CATransform3DRotate(perspective, self.rotateSlider.value, 0, 1, 0);

  target.sublayerTransform = perspective;
  [self levelTravelLayer:target transform:perspective zIndexScale:self.zSlider.value];
}

- (void)levelTravelLayer:(CALayer *)layer transform:(CATransform3D)perspective zIndexScale:(CGFloat)zIndexScale{
  layer.masksToBounds = YES;
  NSMutableArray *queue = [[NSMutableArray alloc] initWithArray:layer.sublayers];
  NSInteger level = 0;
  while (queue.count > 0) {
    NSUInteger count = queue.count;
    for (int i = 0; i < count; i++) {
      CALayer *sub = [queue firstObject];
      [queue removeObjectAtIndex:0];
      sub.sublayerTransform = perspective;
      sub.borderColor = [[self brightRandomColorWithAlpha:0.5] CGColor];
      sub.borderWidth = zIndexScale > 0 ? 1.f : 0.f;
      sub.zPosition = (level + i) * zIndexScale;
      NSLog(@"zPosition = %@ bounds = %@", @(sub.zPosition), NSStringFromCGRect(sub.bounds));
      [queue addObjectsFromArray:sub.sublayers];
    }
    level += count;
  }
}

- (UIColor *)brightRandomColorWithAlpha:(CGFloat)alpha {
  
  while (YES) {
    CGFloat red =  (CGFloat)arc4random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)arc4random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)arc4random()/(CGFloat)RAND_MAX;
    CGFloat gray = 0.299 * red + 0.587 * green + 0.114 * blue;
    if (gray < 0.6) {
      return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
  }
}

- (UIBarButtonItem *)flexItem {
  return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (void)_rotateChanged:(UISlider *)slider {
  [self showMessage:[NSString stringWithFormat:@"旋转%@", @(slider.value)]];
  [self debugPerspective];
}

- (void)_zSliderChanged:(UISlider *)slider {
  [self showMessage:[NSString stringWithFormat:@"ZIndex Scale=%@", @(slider.value)]];
  [self debugPerspective];
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

  self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - 44 - self.view.safeAreaInsets.bottom, self.view.bounds.size.width, 44);

  CGFloat sliderHeight = 44.f;
  self.slider.frame = CGRectMake(30, CGRectGetMinY(self.toolbar.frame) - sliderHeight, self.view.bounds.size.width - 60, sliderHeight);
  self.rotateSlider.frame = CGRectMake(30, CGRectGetMinY(self.slider.frame) - sliderHeight, self.view.bounds.size.width - 60, sliderHeight);
  self.zSlider.frame = CGRectMake(30, CGRectGetMinY(self.rotateSlider.frame) - sliderHeight, self.view.bounds.size.width - 60, sliderHeight);
  self.laAnimation.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, CGRectGetMinY(self.zSlider.frame) - self.view.safeAreaInsets.top);
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
  [self resetPerspective];
  [self.laAnimation removeFromSuperview];
  self.laAnimation = nil;
  [self resetAllButtons];
  
  self.laAnimation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
  self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
  [self.view insertSubview:self.laAnimation atIndex:0];
  [self.view setNeedsLayout];
}

- (void)_loadAnimationNamed:(NSString *)named {
  [self resetPerspective];
  [self.laAnimation removeFromSuperview];
  self.laAnimation = nil;
  [self resetAllButtons];
  
  self.laAnimation = [LOTAnimationView animationNamed:named];
  self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
  [self.view insertSubview:self.laAnimation atIndex:0];
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
  
  if (self.laAnimation.animationSpeed == 1) {
    self.laAnimation.animationSpeed = 0.5;
  } else if (self.laAnimation.animationSpeed < 3) {
    self.laAnimation.animationSpeed += 1;
  } else {
    self.laAnimation.animationSpeed = 1;
  }
  [self showMessage:[NSString stringWithFormat:@"Speed x%@", @(self.laAnimation.animationSpeed)]];
}

- (void)showMessage:(NSString *)message {
  self.title = message;
}

@end
