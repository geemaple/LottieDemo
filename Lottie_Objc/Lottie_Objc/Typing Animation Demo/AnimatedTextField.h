//
//  LAAnimatedTextField.h
//  LottieExamples
//
//  Created by Brandon Withrow on 1/10/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedTextField : UIView

@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIEdgeInsets scrollInsets;
@property (nonatomic, assign) BOOL enableDebuging;

- (void)changeInput:(NSString *)oldText charactersInRange:(NSRange)range toString:(NSString *)replacementString;

@end
