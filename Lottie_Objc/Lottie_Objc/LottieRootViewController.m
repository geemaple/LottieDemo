//
//  LottieRootViewController.m
//  LottieExamples
//
//  Created by brandon_withrow on 1/25/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import "LottieRootViewController.h"
#import <Lottie/Lottie.h>

@interface LottieRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LOTAnimationView *lottieLogo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewItems;

@end

@implementation LottieRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_playLottieAnimation)];
  tapGesture.numberOfTapsRequired = 2;
  [self.view addGestureRecognizer:tapGesture];
  
  [self _buildDataSource];
  self.lottieLogo = [LOTAnimationView animationNamed:@"LottieLogo1"];
  self.lottieLogo.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:self.lottieLogo];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
  [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.lottieLogo play];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.lottieLogo pause];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  CGRect lottieRect = CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, self.view.bounds.size.height * 0.4);
  self.lottieLogo.frame = lottieRect;
  self.tableView.frame = CGRectMake(0, CGRectGetMaxY(lottieRect), CGRectGetWidth(lottieRect), self.view.bounds.size.height - CGRectGetMaxY(lottieRect));
}

#pragma mark -- Internal Methods

- (void)_buildDataSource {
  self.tableViewItems = @[
    @{@"name" : @"Animation Explorer",
      @"vc" : @"AnimationExplorerViewController"},
    @{@"name" : @"Animated Keyboard",
      @"vc" : @"TypingDemoViewController"},
    @{@"name" : @"Animated Transitions(Objc Only)",
      @"vc" : @"AnimationTransitionViewController"},
    @{@"name" : @"Animated UIControls",
      @"vc" : @"LAControlsViewController"},
    @{@"name" : @"Download Progress",
      @"vc" : @"LADownloadTestViewController"},
    @{@"name" : @"Dynamic Image",
      @"vc" : @"LADynamicImageViewController"},
    @{@"name" : @"Intro Demo",
      @"vc" : @"LAIntroViewController"},];
}

- (void)_playLottieAnimation {
  self.lottieLogo.animationProgress = 0;
  [self.lottieLogo play];
}

#pragma mark -- UITableViewDataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tableViewItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  cell.textLabel.text = self.tableViewItems[indexPath.row][@"name"];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *vcClassName = self.tableViewItems[indexPath.row][@"vc"];
  Class vcClass = NSClassFromString(vcClassName);
  if (vcClass) {
    UIViewController *vc = [[vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
