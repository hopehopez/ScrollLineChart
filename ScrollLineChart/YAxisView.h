//
//  YAxisView.h
//  ScrollLineChart
//
//  Created by 张树青 on 2017/7/13.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAxisView : UIView


- (instancetype)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin;

- (void)setYMax:(CGFloat)yMax yMin:(CGFloat)yMin;

@end
