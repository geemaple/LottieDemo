//
//  LADynamicImageViewController.m
//  Lottie_objc
//
//  Created by jixiangfeng on 2021/6/18.
//

#import "LADynamicImageViewController.h"
#import <Lottie/Lottie.h>

@interface LADynamicImageViewController()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@property (nonatomic, strong) LOTAnimationView *dynamicContent;

@end

@implementation LADynamicImageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendPostCard)];

  self.imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
  UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)];
  [self.imageView1 addGestureRecognizer:tap1];
  [self.imageView1 setUserInteractionEnabled:YES];
  
  self.imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img2"]];
  UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)];
  [self.imageView2 addGestureRecognizer:tap2];
  [self.imageView2 setUserInteractionEnabled:YES];
  
  [self.view addSubview:self.imageView1];
  [self.view addSubview:self.imageView2];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  self.imageView1.frame = CGRectMake(20, self.view.bounds.size.height - 150 - self.view.safeAreaInsets.bottom - 20, 150, 150);
  self.imageView2.frame = CGRectMake(self.view.bounds.size.width - 150 - 20, self.imageView1.frame.origin.y, 150, 150);
}

- (void)addAnimationView:(UIImageView *)imageView {
  
  if (self.dynamicContent) {
    [self.dynamicContent removeFromSuperview];
  }
  
  self.dynamicContent = [LOTAnimationView animationNamed:@"CardAnimation"];
  self.dynamicContent.center = self.view.center;
  CGRect frame = self.dynamicContent.frame;
  frame.origin.y = frame.origin.y - 100;
  self.dynamicContent.frame = frame;
  [self.dynamicContent addSubview:imageView toKeypathLayer:[LOTKeypath keypathWithString:@"Placeholder"]];
  [self.view addSubview:self.dynamicContent];
}

- (void)chooseImage:(UITapGestureRecognizer *)gesture {
  UIImage *image = [(UIImageView *)gesture.view image];
  UIImageView *sendImage = [[UIImageView alloc] initWithImage:image];
  [self addAnimationView:sendImage];
}

- (void)sendPostCard {
  [self.dynamicContent play];
}

@end
