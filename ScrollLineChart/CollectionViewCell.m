//
//  CollectionViewCell.m
//  ScrollLineChart
//
//  Created by 张树青 on 2017/7/12.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import "CollectionViewCell.h"

#define xAxisTextGap 5 //x轴文字与坐标轴间隙
#define numberOfYAxisElements 5 // y轴分为几段
#define marginTop 30


@interface CollectionViewCell()
@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;

@property (assign, nonatomic) CGFloat defaultSpace;

@property (assign, nonatomic) CGRect firstStrFrame;//第一个点的文字的frame
@property (assign, nonatomic) BOOL isFirst;
@property (nonatomic, assign) CGFloat marginLeft;
@end

@implementation CollectionViewCell

- (void)setXTitleArray:(NSArray *)xTitleArray yValueArray:(NSArray *)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin isFirst:(BOOL)isFirst{
    
    self.xTitleArray = xTitleArray;
    self.yValueArray = yValueArray;
    self.yMax = yMax;
    self.yMin = yMin;
    self.defaultSpace = 30;
    self.pointGap = self.defaultSpace;
    if (isFirst) {
        self.marginLeft = 30;
    } else {
        self.marginLeft = 0;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    ////////////////////// X轴文字 //////////////////////////
    // 添加坐标轴Label
    for (int i=0; i<self.xTitleArray.count; i++) {
        NSString *title = self.xTitleArray[i];
        
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:8]};
        CGSize labelSize = [title sizeWithAttributes:attr];
        CGRect titleRect = CGRectMake(i* self.pointGap - labelSize.width/2 + self.marginLeft, rect.size.height - labelSize.height, labelSize.width, labelSize.height);
        
        [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        
    }
    
    //////////////// 画原点上的x轴 ///////////////////////
    NSDictionary *xattr = @{NSFontAttributeName: [UIFont systemFontOfSize:8]};
    CGSize textSize = [@"x" sizeWithAttributes:xattr];
    [self drawLine:context startPoint:CGPointMake(0, rect.size.height - textSize.height - 5) endPoint:CGPointMake(rect.size.width, rect.size.height - textSize.height -5) lineColor:[UIColor blackColor] lineWidth:1];
    
    //////////////// 画横向分割线 ///////////////////////
    CGFloat seperateSpace = (rect.size.height - xAxisTextGap - textSize.height - marginTop)/numberOfYAxisElements;
    for (int i=1; i<numberOfYAxisElements+1; i++) {
        [self drawLine:context startPoint:CGPointMake(0, rect.size.height - textSize.height - xAxisTextGap - seperateSpace*i) endPoint:CGPointMake(rect.size.width, rect.size.height - textSize.height - xAxisTextGap - seperateSpace * i) lineColor:[UIColor lightGrayColor] lineWidth:1];
    }
    
    /////////////////////// 根据数据源画折线 /////////////////////////
    CGFloat chartHeight = rect.size.height - xAxisTextGap - textSize.height - marginTop;

    UIBezierPath *path = [[UIBezierPath alloc] init];
    NSMutableArray *pointsArray = [NSMutableArray array];
    if (self.yValueArray && self.yValueArray.count>0) {
        for (int i=0; i<self.yValueArray.count; i++) {
            //如果非最后一个点
            if (i != self.yValueArray.count - 1) {
                
                NSNumber *startValue = self.yValueArray[i];
                NSNumber *endValue = self.yValueArray[i+1];
                
                CGPoint startPoint = CGPointMake(self.pointGap * (i) + self.marginLeft, chartHeight * (startValue.doubleValue - self.yMin) / (self.yMax - self.yMin) + marginTop);
                CGPoint endPoint = CGPointMake(self.pointGap * (i+1) + self.marginLeft, chartHeight * (endValue.doubleValue - self.yMin) / (self.yMax - self.yMin) + marginTop);
                
                CGFloat normal[1]={1};
                CGContextSetLineDash(context,0,normal,0); //画实线
                
                if (i==0) {
                    [path moveToPoint:CGPointMake(self.marginLeft, chartHeight + marginTop - 1)];
                    [path addLineToPoint:startPoint];
                }
                
                [path addLineToPoint:endPoint];
                
                [self drawLine:context startPoint:startPoint endPoint:endPoint lineColor:[UIColor colorWithRed:26/255.0 green:135/255.0 blue:254/255.0 alpha:1] lineWidth:2];
                
                [pointsArray addObject:[NSValue valueWithCGPoint:startPoint]];
                
            } else {
                NSNumber *endValue = self.yValueArray[i];
                
                CGPoint endPoint = CGPointMake(self.pointGap * i + self.marginLeft, chartHeight * (endValue.doubleValue - self.yMin) / (self.yMax - self.yMin) + marginTop);
                
                [path addLineToPoint:CGPointMake(self.pointGap * i + self.marginLeft, chartHeight + marginTop - 1)];
                
                [pointsArray addObject:[NSValue valueWithCGPoint:endPoint]];
            }
        }
    }
    
    [path closePath];    
    
    CAGradientLayer *gradientLayer = nil;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            gradientLayer = (CAGradientLayer *)layer;
        }
    }
    if (gradientLayer == nil) {
        gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id) [UIColor yellowColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [self.layer addSublayer:gradientLayer];
    }
    gradientLayer.frame = self.bounds;
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    gradientLayer.mask = shapeLayer;
    
    NSArray *subViews = self.subviews;
    for (UIView *subView in subViews) {
        if (subView.tag == 1000) {
            [subView removeFromSuperview];
        }
    }
    
    for (NSValue *pointValue in pointsArray) {
        CGPoint point = [pointValue CGPointValue];
        //画点
//        UIColor*aColor = [UIColor redColor]; //点的颜色
//        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//        CGContextAddArc(context, point.x, point.y, 3, 0, 2*M_PI, 0); //添加一个圆
//        CGContextDrawPath(context, kCGPathFill);//绘制填充
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        view.backgroundColor = [UIColor redColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 3;
        view.tag = 1000;
        view.center = point;
        [self addSubview:view];
    }
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


// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num {
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}


@end
