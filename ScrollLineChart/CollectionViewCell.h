//
//  CollectionViewCell.h
//  ScrollLineChart
//
//  Created by 张树青 on 2017/7/12.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) CGFloat pointGap;//点之间的距离
@property (assign,nonatomic)BOOL isShowLabel;//是否显示文字

@property (assign,nonatomic)BOOL isLongPress;//是不是长按状态
@property (assign, nonatomic) CGPoint currentLoc; //长按时当前定位位置
@property (assign, nonatomic) CGPoint screenLoc; //相对于屏幕位置


- (void)setXTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin isFirst:(BOOL)isFirst ;

@end
