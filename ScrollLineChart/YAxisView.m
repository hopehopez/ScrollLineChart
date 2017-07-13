//
//  YAxisView.m
//  ScrollLineChart
//
//  Created by 张树青 on 2017/7/13.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import "YAxisView.h"

#define xAxisTextGap 5 //x轴文字与坐标轴间隙
#define numberOfYAxisElements 5 // y轴分为几段
#define marginTop 30
@interface YAxisView()

@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;

@end

@implementation YAxisView

- (instancetype)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin{
    
    if (self = [super initWithFrame:frame]) {
        self.yMax = yMax;
        self.yMin = yMin;
        self.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

- (void)setYMax:(CGFloat)yMax yMin:(CGFloat)yMin{
    self.yMax = yMax;
    self.yMin = yMin;
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //y轴
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:8]};
    CGSize labelSize = [@"x" sizeWithAttributes:attr];
    [self drawLine:context startPoint:CGPointMake(self.frame.size.width - 1, 0) endPoint:CGPointMake(self.frame.size.width - 1, self.frame.size.height - labelSize.height - xAxisTextGap) lineColor:[UIColor grayColor] lineWidth:1];
    
    //间距
    CGFloat allLabelHeight = self.frame.size.height - xAxisTextGap - labelSize.height - marginTop;
    CGFloat labelMargin = (allLabelHeight  - numberOfYAxisElements * labelSize.height)/numberOfYAxisElements;
    
    //添加label
    for (int i=0; i<numberOfYAxisElements + 1; i++) {
        
        CGFloat avgValue = (self.yMax - self.yMin) / numberOfYAxisElements;
        
        // 判断是不是小数
        if ([self isPureFloat:self.yMin + avgValue * i]) {
            CGSize yLabelSize = [[NSString stringWithFormat:@"%.2f", self.yMin + avgValue * i] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8]}];
            [[NSString stringWithFormat:@"%.2f", self.yMin + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1 - 5 - yLabelSize.width, self.frame.size.height - labelSize.height - xAxisTextGap - (labelMargin + labelSize.height)* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName: [UIColor grayColor]}];
        }
        else {
            CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8]}];
            
            [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1 - 5 - yLabelSize.width, self.frame.size.height - labelSize.height - 5 - (labelMargin + labelSize.height)* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName: [UIColor grayColor]}];
        }

    }
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num
{
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}


@end
