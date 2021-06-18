//
//  ViewController.m
//  perspective
//
//  Created by jixiangfeng on 2021/6/18.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {

    CATransform3D transform3D = CATransform3DIdentity;

    transform3D.m34 = -1.0 / 1000;

    transform3D = CATransform3DRotate(transform3D, M_PI / 4, 0, 1, 0);

    self.view.layer.sublayerTransform = transform3D;

    CALayer *layer1 = [[CALayer alloc] init];
    layer1.zPosition = 66;
    layer1.frame = CGRectMake(100, 100, 100, 100);
    layer1.backgroundColor = [[UIColor orangeColor] CGColor];
  layer1.sublayerTransform = transform3D;
  
  
    CALayer *sub = [[CALayer alloc] init];
    sub.zPosition = 66;
    sub.frame = layer1.bounds;
    sub.backgroundColor = [[UIColor blueColor] CGColor];
  [layer1 addSublayer:sub];

    [self.view.layer addSublayer:layer1];

    CALayer *layer2 = [[CALayer alloc] init];
    layer2.zPosition = 88;
    layer2.frame = CGRectMake(100, 100, 100, 100);
    layer2.backgroundColor = [[UIColor yellowColor] CGColor];

    [self.view.layer addSublayer:layer2];

}


@end
