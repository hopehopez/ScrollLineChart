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
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
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
    layout.itemSize = CGSizeMake(500, 300);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, 200, UIScreen.mainScreen.bounds.size.width - 50, 300) collectionViewLayout:layout ];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    NSArray *yArray = [self getYValues];
    [cell setXTitleArray:@[] yValueArray:yArray yMax:100 yMin:0];
    return cell;
    
}

- (NSArray *)getYValues{
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [yArray addObject:[NSString stringWithFormat:@"%.2lf",20.0+arc4random_uniform(80)]];
    }
    return yArray;
}

@end
