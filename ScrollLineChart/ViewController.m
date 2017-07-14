//
//  ViewController.m
//  ScrollLineChart
//
//  Created by 张树青 on 2017/7/12.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "YAxisView.h"
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YAxisView *yAxisView = [[YAxisView alloc] initWithFrame:CGRectMake(0, 200, 50, 300) yMax:100 yMin:0];
    [self.view addSubview:yAxisView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, 200, UIScreen.mainScreen.bounds.size.width - 50, 300) collectionViewLayout:layout ];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.bounces = NO;
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.collectionView];
    
    self.dataSource = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        NSArray *array = [self getYValues];
        [self.dataSource addObject:array];
    }
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //titles
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=1; i<=10; i++) {
        NSInteger index = indexPath.row * 10 + i;
        NSString *title  = [NSString stringWithFormat:@"%ld", index];
        [titles addObject:title];
    }
    
    NSInteger index = indexPath.row;
    
    if (index % 2 == 0) {
        cell.backgroundColor = [UIColor orangeColor];
    } else {
        cell.backgroundColor = [UIColor purpleColor];
    }
    
    NSArray *data = self.dataSource[index];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:data];
    if (index != self.dataSource.count - 1) {
        NSArray *nextArray = self.dataSource[index + 1];
        [muArr addObject:nextArray[0]];
        [titles addObject:[NSString stringWithFormat:@"%ld", index * 10 + 11]];
    }
    if (index == 0) {
        [cell setXTitleArray:titles yValueArray:muArr yMax:100 yMin:0 isFirst:YES];
    } else {
        [cell setXTitleArray:titles yValueArray:muArr yMax:100 yMin:0 isFirst:NO];
    }
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    NSArray *array = self.dataSource[index];
    CGFloat width = array.count * 30 + ( index == 0 ? 30 : 0);
    
    return  CGSizeMake(width, 300);
}

- (NSArray *)getYValues{
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        [yArray addObject:[NSString stringWithFormat:@"%.2lf",20.0+arc4random_uniform(80)]];
    }
    return yArray;
}

@end
