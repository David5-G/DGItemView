//
//  ViewController.m
//  DGItemView
//
//  Created by david on 2018/12/10.
//  Copyright © 2018 david. All rights reserved.
//

#import "ViewController.h"
//view
#import "DGItemView.h"
#import "DGTimeItemView.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<DGItemViewDelegate,DGTimeItemViewDelegate>

@property (nonatomic,weak)DGItemView *lineItemView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI

/** 设置UI */
- (void)setupUI {
    self.view.backgroundColor = UIColor.grayColor;
    
    [self setupLineItemView];
    [self setupEquelWidthLayerItemView];
    [self setupLayerItemView];
    [self setupTimeItemView];
}

/** lineItemView */
-(void)setupLineItemView {
    DGItemView *itemV = [[DGItemView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 40)];
    self.lineItemView = itemV;
    [self.view addSubview:itemV];
    
    itemV.backgroundColor = UIColor.whiteColor;
    itemV.indicatorStyle = DGItemViewIndicatorStyleLine;
    itemV.indicatorColor = UIColor.redColor;
    itemV.indicatorScale = 0.32;
    itemV.normalFont = [UIFont systemFontOfSize:13];
    itemV.normalColor = UIColor.blackColor;
    itemV.selectedColor = UIColor.redColor;
    itemV.selectedIndex = 0;
    itemV.titleArr = @[@"全部", @"状态1", @"状态2"];
    itemV.delegate = self;
    
    [self addCountLabelToItemAtIndex:0];
    [self addCountLabelToItemAtIndex:1];
}

/** 给指定item添加计数label */
-(void )addCountLabelToItemAtIndex:(NSUInteger)index {
    
    UIButton *btn = [self.lineItemView itemButtonAtIndex:index];
    
    UILabel *countL = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.size.width-40, 13, 20, 14)];
    countL.font = [UIFont systemFontOfSize:11];
    countL.textColor = UIColor.purpleColor;
    countL.text = @"(6)";
    [btn addSubview:countL];
}


#pragma mark -
/** 设置等宽LayerItemView  */
-(void)setupEquelWidthLayerItemView {
    
    //2.tiemV
    DGItemView *itemV = [[DGItemView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 40)];
    [self.view addSubview:itemV];
    
    itemV.backgroundColor = UIColor.whiteColor;
    itemV.indicatorStyle = DGItemViewIndicatorStyleLayer;
    itemV.indicatorColor = UIColor.blueColor;
    itemV.indicatorScale = 0.9;
    itemV.normalFont = [UIFont systemFontOfSize:14];
    itemV.normalColor = UIColor.blackColor;
    itemV.selectedColor = UIColor.whiteColor;
    itemV.selectedIndex = 0;
    itemV.titleArr = @[@"全部",@"状态1",@"状态2",@"状态3",@"状态4",@"55"];
    itemV.delegate = self;
}

/** 设置不等宽layerItemView  */
-(void)setupLayerItemView {
    
    //2.tiemV
    DGItemView *itemV = [[DGItemView alloc]initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 40)];
    [self.view addSubview:itemV];
    
    itemV.backgroundColor = UIColor.whiteColor;
    itemV.indicatorStyle = DGItemViewIndicatorStyleLayer;
    itemV.needEqualWidth = NO;
    itemV.indicatorColor = UIColor.orangeColor;
    itemV.indicatorScale = 0.9;
    itemV.normalFont = [UIFont systemFontOfSize:14];
    itemV.normalColor = UIColor.blueColor;
    itemV.selectedColor = UIColor.blueColor;
    itemV.selectedIndex = 0;
    itemV.titleArr = @[@"全部",@"状态1",@"状态2",@"状态3333",@"状态4",@"55",@"一个状态",@"另一个别的状态"];
    itemV.delegate = self;
}


#pragma mark - DGItemViewDelegate
-(BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"itemView点击index: %lu",(unsigned long)index);
    return YES;
}



#pragma mark - timeItemView
-(void)setupTimeItemView {
    //itemView
    DGTimeItemView *itemV = [[DGTimeItemView alloc]initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 40)];
    itemV.backgroundColor = UIColor.whiteColor;
    itemV.topTitleNormalFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    itemV.topTitleNormalColor = rgba(255, 164, 164, 1);
    itemV.topTitleSelectedColor = UIColor.purpleColor;
    itemV.titleNormalFont = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    itemV.titleNormalColor = rgba(255, 164, 164, 1);
    itemV.titleSelectedColor = rgba(240, 60, 39, 1);
    itemV.indicatorWidthScale = 0.8;
    itemV.indicatorColor = UIColor.purpleColor;
    itemV.needEqualWidth = NO;
    itemV.delegate = self;
    [self.view addSubview:itemV];
    
    //
    NSMutableArray *itemModelArr = [NSMutableArray arrayWithCapacity:8];
    for (NSInteger i=0; i<8; i++) {
        DGTimeItemModel *itemModel = [[DGTimeItemModel alloc]init];
        itemModel.topTitle = [NSString stringWithFormat:@"topTitle%ld",i];
        itemModel.title = [NSString stringWithFormat:@"title%ld",i];
        [itemModelArr addObject:itemModel];
    }
    itemV.titleArr = itemModelArr;
}

- (BOOL)timeItemView:(DGTimeItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    return YES;
}

@end
