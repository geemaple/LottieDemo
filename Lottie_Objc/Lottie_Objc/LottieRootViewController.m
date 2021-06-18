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
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DEBUG" style:UIBarButtonItemStylePlain target:self action:@selector(debugPerspective)];
  
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

- (void)debugPerspective {
  CALayer *target = self.view.layer;
  BOOL isDebuging = !CATransform3DIsIdentity(target.sublayerTransform);
  
  CATransform3D perspective = CATransform3DIdentity;
  perspective.m34 = -1.0 / 1000;
  
  self.view.layer.sublayerTransform = CATransform3DRotate(perspective, M_PI / 4, 0, 1, 0);
  [self levelTravelLayer:self.view.layer transform:perspective borderLayer:isDebuging];
}

- (void)levelTravelLayer:(CALayer *)layer transform:(CATransform3D)perspective borderLayer:(BOOL)borderLayer {
  
  NSMutableArray *queue = [[NSMutableArray alloc] initWithArray:layer.sublayers];
  while (queue.count > 0) {
    NSUInteger count = queue.count;
    for (int i = 0; i < count; i++) {
      CALayer *sub = [queue firstObject];
      [queue removeObjectAtIndex:0];
      sub.sublayerTransform = perspective;
      sub.borderWidth = borderLayer ? 1.f : 0.f;
      sub.borderColor = [[self randomColorWithAlpha:1] CGColor];
      [queue addObjectsFromArray:sub.sublayers];
    }
  }
}

- (UIColor *)randomColorWithAlpha:(CGFloat)alpha {
  CGFloat red = arc4random_uniform(255) / 255.f;
  CGFloat green = arc4random_uniform(255) / 255.f;
  CGFloat blue = arc4random_uniform(255) / 255.f;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)handleGeature:(UIPanGestureRecognizer *)gesture {
  CGPoint translation = [gesture translationInView:gesture.view];
  self.lottieLogo.layer.transform = CATransform3DMakeRotation(translation.x / M_PI / 2 , 0, 1, 0);
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
  CGRect lottieRect = CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, self.view.bounds.size.height * 0.3);
  self.lottieLogo.frame = lottieRect;
  self.tableView.frame = CGRectMake(0, CGRectGetMaxY(lottieRect), CGRectGetWidth(lottieRect), self.view.bounds.size.height - CGRectGetMaxY(lottieRect));
}

#pragma mark -- Internal Methods

- (void)_buildDataSource {
  self.tableViewItems = @[@{@"name" : @"Animation Explorer",
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
                            @"vc" : @"LADynamicImageViewController"},];
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
