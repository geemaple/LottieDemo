//
//  LAControlsViewController.m
//  lottie-ios
//
//  Created by brandon_withrow on 8/28/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import "LAControlsViewController.h"
#import <Lottie/Lottie.h>

@interface LAControlsViewController ()

@property (nonatomic, strong) LOTAnimatedSwitch *toggle1;
@property (nonatomic, strong) LOTAnimatedSwitch *heartIcon;
@property (nonatomic, strong) LOTAnimatedSwitch *statefulSwitch;


@end

@implementation LAControlsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  /// An animated toggle with different ON and OFF animations.
  
  self.toggle1 = [LOTAnimatedSwitch switchNamed:@"Switch"];
  
  /// On animation is 0.5 to 1 progress.
  [self.toggle1 setProgressRangeForOnState:0.5 toProgress:1];
  /// Off animation is 0 to 0.5 progress.
  [self.toggle1 setProgressRangeForOffState:0 toProgress:0.5];
  
  [self.toggle1 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.toggle1];
  
  /// An animated 'like' or 'heart' button.
  /// Clicking toggles the Like or Heart state.
  /// The animation runs from 0-1, progress 0 is off, progress 1 is on
  self.heartIcon = [LOTAnimatedSwitch switchNamed:@"TwitterHeart"];
  
  [self.heartIcon addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.heartIcon];
  
  /// This is a switch that also has a Disabled state animation.
  /// When the switch is disabled then the disabled layer is displayed.
  
  self.statefulSwitch = [LOTAnimatedSwitch switchNamed:@"Switch_States"];
  
  /// Off animation is 0 to 1 progress.
  /// On animation is 1 to 0 progress.
  [self.statefulSwitch setProgressRangeForOnState:1 toProgress:0];
  [self.statefulSwitch setProgressRangeForOffState:0 toProgress:1];
  
  // Specify the layer names for different states
  [self.statefulSwitch setLayerName:@"Button" forState:UIControlStateNormal];
  [self.statefulSwitch setLayerName:@"Disabled" forState:UIControlStateDisabled];
  
  // Changes visual appearance by switching animation layer to "Disabled"
  self.statefulSwitch.enabled = NO;
  
  // Changes visual appearance by switching animation layer to "Button"
  self.statefulSwitch.enabled = YES;
  
  [self.statefulSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.statefulSwitch];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  self.toggle1.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.view.safeAreaInsets.top + 90);
  self.heartIcon.bounds = CGRectMake(0, 0, 200, 200);
  self.heartIcon.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.toggle1.frame) + (self.heartIcon.bounds.size.height * 0.5));
  self.statefulSwitch.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.heartIcon.frame) + (self.statefulSwitch.bounds.size.height * 0.5));
}

- (void)switchToggled:(LOTAnimatedSwitch *)animatedSwitch {
  NSLog(@"The switch is %@", (animatedSwitch.on ? @"ON" : @"OFF"));
}

@end
