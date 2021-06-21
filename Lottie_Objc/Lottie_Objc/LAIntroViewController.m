//
//  LAIntroViewController.m
//  Lottie_objc
//
//  Created by Dean Ji on 6/21/21.
//

#import "LAIntroViewController.h"
#import <Lottie/Lottie.h>

@interface LAIntroViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) LOTAnimationView *introView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *introTexts;


@end

@implementation LAIntroViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.whiteColor;
  
  self.introTexts = @[@"Swipe left to begin", @"Don't forget to make your bed", @"Clean your toilet", @"And windows", @"Make a snack", @"And go!"];
  
  self.introView = [LOTAnimationView animationNamed:@"tutorial"];
  self.introView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:self.introView];
 
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.delegate = self;
  self.scrollView.pagingEnabled = YES;
  self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.introTexts.count, 0);
  self.scrollView.backgroundColor = [UIColor colorWithRed:25.f/255.f green:170.f/255.f blue:159.f/255.f alpha:1];
  [self.view addSubview:self.scrollView];
  
  for (int i = 0; i < self.introTexts.count; i++) {
    
    CGFloat labelWidth = 300;
    CGFloat positionX = ((self.view.frame.size.width - labelWidth) / 2) + i * self.view.frame.size.width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(positionX, 0, labelWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18 weight:10];
    label.textColor = UIColor.whiteColor;
    label.text = self.introTexts[i];
    [self.scrollView addSubview:label];
  }
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.scrollView.frame = CGRectMake(0, self.view.bounds.size.height - 250, self.view.bounds.size.width, 250);
  self.introView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, CGRectGetMinY(self.scrollView.frame) - self.view.safeAreaInsets.top);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat progress = scrollView.contentOffset.x / scrollView.contentSize.width;
  self.introView.animationProgress = progress;
}

@end
