//
//  HC_HotSaleTimeItemsView.m
//  HaiChi
//
//  Created by david on 2020/5/12.
//  Copyright © 2020 gwh. All rights reserved.
//

#import "DGTimeItemView.h"


#define dg_tiv_rgba(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
static const float titleFontHeightAdjustScale = 0.6;

#pragma mark -
@implementation DGTimeItemModel
@end

#pragma mark - DGItemButton
@interface DGTimeItemButton : UIButton
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIFont *topLabelNormalFont;
@property (nonatomic, strong) UIFont *topLabelSelectedFont;
@property (nonatomic, strong) UIColor *topLabelNormalColor;
@property (nonatomic, strong) UIColor *topLabelSelectedColor;

@property (nonatomic,strong) UIFont *selectedFont;
@property (nonatomic,strong) UIFont *normalFont;
@end


@implementation DGTimeItemButton
#pragma mark life circle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}
#pragma mark UI
-(void)setupUI {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel = [[UILabel alloc]init];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //按钮的高度
    CGFloat selfHeight = self.bounds.size.height;
    //按钮的宽度
    CGFloat selfWidth = self.bounds.size.width;
    
    //title
    CGFloat titleLabelHeight = MAX(self.normalFont.pointSize, self.selectedFont.pointSize)*(1+titleFontHeightAdjustScale);
    CGFloat titleY = selfHeight - titleLabelHeight;
    self.titleLabel.frame = CGRectMake(0, titleY, selfWidth, titleLabelHeight);
    
    //topTitle
    CGFloat topLabelHeight = MAX(self.topLabelNormalFont.pointSize, self.topLabelSelectedFont.pointSize);
    self.topLabel.frame = CGRectMake(0, 0, selfWidth, topLabelHeight+2);
}

#pragma mark setter
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    //titleLabel
    if (selected) {
         self.topLabel.textColor = self.topLabelSelectedColor ? self.topLabelSelectedColor : self.topLabelNormalColor;;
        self.topLabel.font = self.topLabelSelectedFont ? self.topLabelSelectedFont : self.topLabelNormalFont;
        self.titleLabel.font = self.selectedFont ? self.selectedFont : self.normalFont;
    }else{
        self.topLabel.textColor = self.topLabelNormalColor;
        self.topLabel.font = self.topLabelNormalFont;
        self.titleLabel.font = self.normalFont;
    }
}
@end
 
#pragma mark - DGTimeItemView

static const NSUInteger onePageItemCount = 5;

@interface DGTimeItemView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *indicatorView;

@property (nonatomic,strong) NSArray <DGTimeItemButton *>*buttonArr;
//之前选中Button 和 当前选中Button
//@property (nonatomic,weak) DGTimeItemButton *preSelectedButton;
@property (nonatomic,weak) DGTimeItemButton *currentSelectedButton;

@end

@implementation DGTimeItemView
 #pragma mark lazy load
 -(UIScrollView *)scrollView {
     if (!_scrollView) {
         [self setupScrollView];
     }
     return _scrollView;
 }

#pragma mark life circle
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaultValue];
        [self setupIndicatorView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaultValue];
        [self setupUI];
    }
    return self;
}



/** 设置默认值 */
-(void)setDefaultValue {
    self.backgroundColor = UIColor.clearColor;
    
    //1.是否等宽
    self.needEqualWidth = YES;
    
    //2.默认选中
    self.selectedIndex = 0;
    
    //3.indicator设置
    self.indicatorViewHidden = NO;
    self.indicatorColor = UIColor.purpleColor;
    _indicatorWidthScale = 1.0;
    _indicatorHeightScale = 1.0;
    
    //4.btn默认-选中
    self.titleNormalFont = [UIFont systemFontOfSize:11];
    self.titleNormalColor = UIColor.lightGrayColor;
    self.titleSelectedColor = UIColor.redColor;
    
    self.topTitleNormalFont = [UIFont systemFontOfSize:17];
    self.topTitleNormalColor = UIColor.lightGrayColor;
    self.topTitleSelectedColor = UIColor.darkGrayColor;
    
    //5.animation
    self.duration = 0.25;
}

#pragma mark UI
/** 设置UI */
-(void)setupUI {
    [self setupScrollView];
    [self setupIndicatorView];
}

/** 设置ScrollView */
-(void)setupScrollView {
    //1.scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = self.backgroundColor;
    [self addSubview: scrollView];
    
    //2.IndicatorView
    //indicatorView在button下边, button背景透明
    [self setupIndicatorView];
}

/** 设置indicatorView */
- (void)setupIndicatorView {
    UIButton *indicatorV = [[UIButton alloc] init];
    indicatorV.userInteractionEnabled = NO;
    self.indicatorView = indicatorV;
    indicatorV.backgroundColor = self.indicatorColor;
    [self.scrollView addSubview:indicatorV];
}

/** 刷新scrollView里的buttons */
-(void)refreshButtons {
    //1.清空已有btn
    for(UIView *subview in self.buttonArr){
        [subview removeFromSuperview];
    }
    
    //2.设置尺寸参数
    NSInteger count = self.titleArr.count;
    CGFloat width = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnEqualW = width/(count*1.0);
    if(count > onePageItemCount){
        btnEqualW = width/(onePageItemCount*1.0);
    }
    
    //3.添加btns
    CGFloat totalBtnsW = 0;
    NSMutableArray *btnArr = [NSMutableArray array];
    
    //遍历titleArr添加btn
    for (NSUInteger i = 0; i<count; i++) {
        
        DGTimeItemModel *model = self.titleArr[i];
        NSString *title = model.title;
        NSString *topTitle = model.topTitle;
        
        //3.1 计算当前btn宽度
        CGFloat currentBtnW = btnEqualW;
        if (!self.needEqualWidth) {
            CGFloat titleFontSize = MAX(self.titleNormalFont.pointSize, self.titleSelectedFont.pointSize);
            CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:titleFontSize]} context:nil].size.width;
            
            CGFloat topTitleFontSize = MAX(self.topTitleNormalFont.pointSize, self.topTitleSelectedFont.pointSize);
            CGFloat topTitleWidth = [topTitle boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:topTitleFontSize]} context:nil].size.width;
            
            currentBtnW = MAX(titleWidth, topTitleWidth)*1.3;
        }
        
        //3.2 创建btn
        DGTimeItemButton *btn = [self createButtonWithFrame:CGRectMake(totalBtnsW, 0, currentBtnW, btnH) title:title topTitle:topTitle];
        btn.tag = i;
        
        //3.3 添加btn
        [self.scrollView addSubview:btn];
        [btnArr addObject:btn];
        
        //3.4 记录总宽度
        totalBtnsW += currentBtnW;
        
        //3.5 设置默认选中
        if (self.selectedIndex == i) {
            self.currentSelectedButton = btn;
            [self updateIndicatorViewPosition];
        }
        btn.selected = self.selectedIndex == i;
        
    }
    
    //4. 记录btns
    self.buttonArr = btnArr;
    
    //5.设置scrollView的contentSize
    CGFloat contentW = totalBtnsW >= width ? totalBtnsW : width;
    self.scrollView.contentSize = CGSizeMake(contentW, btnH);
}

#pragma mark UI tool
/** 创建temButton */
-(DGTimeItemButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title topTitle:(NSString *)topTitle {
    
    //1.创建
    DGTimeItemButton *btn = [[DGTimeItemButton alloc]initWithFrame:frame];
    
    //2.设ttitle
    [btn setTitle:title forState:UIControlStateNormal];
    
    //3.设置状态
    //titleLabel
    btn.normalFont = self.titleNormalFont;
    btn.selectedFont = self.titleSelectedFont ? self.titleSelectedFont : self.titleNormalFont;
    [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    //topLabel
    btn.topLabel.font = self.topTitleNormalFont;
    btn.topLabel.textColor = self.topTitleNormalColor;
    btn.topLabel.text = topTitle;
    btn.topLabelNormalFont = self.topTitleNormalFont;
    btn.topLabelSelectedFont = self.topTitleSelectedFont;
    btn.topLabelNormalColor = self.topTitleNormalColor;
    btn.topLabelSelectedColor = self.topTitleSelectedColor;
    
    //4.点击
    [btn addTarget:self action:@selector(clickItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //5.文本缩放
//    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    btn.titleLabel.minimumScaleFactor = 0.9;
//    btn.topLabel.adjustsFontSizeToFitWidth = YES;
//    btn.topLabel.minimumScaleFactor = 0.9;
    
    //6.return
    return btn;
}

/** 更新ItemButtonsFont */
-(void)updateItemButtonsFont:(BOOL)isTopTitle {
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
            if (isTopTitle) {
                btn.topLabelNormalFont = self.topTitleNormalFont;
                btn.topLabelSelectedFont = self.topTitleSelectedFont;
            }
            btn.normalFont = self.titleNormalFont;
            btn.selectedFont = self.titleSelectedFont ? self.titleSelectedFont : self.titleNormalFont;
            
        }
    }
}
/** 获取指定index对应的itemButton */
-(UIButton *)itemButtonAtIndex:(NSUInteger)index {
    //1.过滤数组越界
    if (index >= self.buttonArr.count) {
        return nil;
    }
    //2.return
    return self.buttonArr[index];
}


#pragma mark interacton
/** 点击itemButton */
-(void)clickItemButton:(DGTimeItemButton *)btn {
    
    //1.过滤点击已选的btn
    if(btn == self.currentSelectedButton){
        return ;
    }
    
    //2.调代理方法
    _selectedIndex = [self.buttonArr indexOfObject:btn];
    BOOL effective = [self.delegate timeItemView:self didSelectedAtIndex:_selectedIndex];
    if(!effective){
        return ;
    }
    
    //3.改变选中状态
    self.currentSelectedButton.selected = NO;
    btn.selected = YES;
    self.currentSelectedButton = btn;
    
    //4.更新IndicatorView的位置
    [self updateIndicatorViewPosition];
}



/** 改变IndicatorView的位置 */
- (void)updateIndicatorViewPosition {
    
    //1.获取btn
    DGTimeItemButton *btn = self.currentSelectedButton;
    CGFloat titleH = MAX(btn.normalFont.pointSize, btn.selectedFont.pointSize)*(1+titleFontHeightAdjustScale);
    CGFloat titleW = btn.bounds.size.width;
    
    //2.计算
    CGPoint indicatorCenter = btn.center;
    indicatorCenter.y = btn.bounds.size.height-titleH/2.0;
    CGRect indicatorBounds = CGRectMake(0, 0, titleW * self.indicatorWidthScale, titleH*self.indicatorHeightScale);
    CGFloat cornerRadius = indicatorBounds.size.height/2.0;
    
    //3.动画
    [UIView animateWithDuration:self.duration animations:^{
        self.indicatorView.center = indicatorCenter;
        self.indicatorView.bounds = indicatorBounds;
        self.indicatorView.layer.cornerRadius = cornerRadius;
    }];
}





#pragma mark setter
-(void)setTitleArr:(NSArray <DGTimeItemModel *>*)titleArr {
    _titleArr = titleArr;
    
    [self refreshButtons];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    //1.没设置buttonArr,及设置默认选中index
    if(!self.buttonArr){
        _selectedIndex = selectedIndex;
        return ;
    }
    
    //2.过滤数组越界
    if (selectedIndex >= self.buttonArr.count) {
        return ;
    }
    
    //3.赋值
    _selectedIndex = selectedIndex;
    
    //4.触发点击方法
    [self clickItemButton:self.buttonArr[selectedIndex]];
}


#pragma mark btn
-(void)setTitleNormalFont:(UIFont *)titleNormalFont {
    //1.赋值
    _titleNormalFont = titleNormalFont;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
            btn.normalFont = self.titleNormalFont;
            btn.selectedFont = self.titleSelectedFont ? self.titleSelectedFont : self.titleNormalFont;
        }
    }
}

-(void)setTitleSelectedFont:(UIFont *)titleSelectedFont {
    //1.赋值
    _titleSelectedFont = titleSelectedFont;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
            btn.normalFont = self.titleNormalFont;
            btn.selectedFont = self.titleSelectedFont ? self.titleSelectedFont : self.titleNormalFont;
        }
    }
}

-(void)setTitleNormalColor:(UIColor *)titleNormalColor{
    //1.赋值
    _titleNormalColor = titleNormalColor;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
            [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
            [btn setTitleColor:self.titleSelectedColor?self.titleSelectedColor:self.titleNormalColor forState:UIControlStateNormal];
        }
    }
}

-(void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    //1.赋值
    _titleSelectedColor = titleSelectedColor;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
             [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
             [btn setTitleColor:self.titleSelectedColor?self.titleSelectedColor:self.titleNormalColor forState:UIControlStateNormal];
        }
    }
}

-(void)setTopTitleNormalFont:(UIFont *)topTitleNormalFont {
    //1.赋值
    _topTitleNormalFont = topTitleNormalFont;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
            btn.topLabelNormalFont = self.topTitleNormalFont;
            btn.topLabelSelectedFont = self.topTitleSelectedFont?self.topTitleSelectedFont:self.topTitleNormalFont;
            [btn setNeedsDisplay];
        }
    }
}

-(void)setTopTitleSelectedFont:(UIFont *)topTitleSelectedFont {
    //1.赋值
    _topTitleSelectedFont = topTitleSelectedFont;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
             btn.topLabelNormalFont = self.topTitleNormalFont;
             btn.topLabelSelectedFont = self.topTitleSelectedFont?self.topTitleSelectedFont:self.topTitleNormalFont;
            [btn setNeedsDisplay];
        }
    }
}

-(void)setTopTitleNormalColor:(UIColor *)topTitleNormalColor {
    //1.赋值
    _topTitleNormalColor = topTitleNormalColor;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
            btn.topLabelNormalColor = self.topTitleNormalColor;
            btn.topLabelSelectedColor = self.topTitleSelectedColor?self.topTitleSelectedColor:self.topTitleNormalColor;
            [btn setNeedsDisplay];
        }
    }
}

-(void)setTopTitleSelectedColor:(UIColor *)topTitleSelectedColor {
    //1.赋值
    _topTitleSelectedColor = topTitleSelectedColor;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGTimeItemButton *btn in self.buttonArr) {
             btn.topLabelNormalColor = self.topTitleNormalColor;
             btn.topLabelSelectedColor = self.topTitleSelectedColor?self.topTitleSelectedColor:self.topTitleNormalColor;
            [btn setNeedsDisplay];
        }
    }
}

#pragma mark indicator
-(void)setIndicatorViewHidden:(BOOL)indicatorViewHidden {
    _indicatorViewHidden = indicatorViewHidden;
    self.indicatorView.hidden = indicatorViewHidden;
}

-(void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

-(void)setIndicatorImage:(UIImage *)indicatorImage {
    _indicatorImage = indicatorImage;
    [self.indicatorView setBackgroundImage:indicatorImage forState:UIControlStateNormal];
}
 

-(void)setIndicatorWidthScale:(CGFloat)indicatorWidthScale{
    
    //1.取值范围过滤
    if(indicatorWidthScale > 1.0 || indicatorWidthScale < 0){
        indicatorWidthScale = 1.0;
    }
    
    //2.过滤取值范围
    if (self.needEqualWidth) {
        indicatorWidthScale = indicatorWidthScale >= 0.4 ? indicatorWidthScale : 0.4;
    }else{
        indicatorWidthScale = 1.0;
    }
    
    //3.赋值
    _indicatorWidthScale = indicatorWidthScale;
    
    //4.更新indicatorView的位置
    [self updateIndicatorViewPosition];
}

-(void)setIndicatorHeightScale:(CGFloat)indicatorHeightScale {
    
    //1.取值范围过滤
    if(indicatorHeightScale > 1.0 || indicatorHeightScale < 0){
        indicatorHeightScale = 1.0;
    }
    
    //2.过滤取值范围
    if (self.needEqualWidth) {
        indicatorHeightScale = indicatorHeightScale >= 0.4 ? indicatorHeightScale : 0.4;
    }else{
        indicatorHeightScale = 1.0;
    }
    
    //3.赋值
    _indicatorHeightScale = indicatorHeightScale;
    
    //4.更新indicatorView的位置
    [self updateIndicatorViewPosition];
}

 
#pragma mark  animation
-(void)setDuration:(CGFloat)duration {
    //1.限制最大值
    if (duration > 3.0) {
        duration = 3.0;
    }
    
    //2.限制最小值
    if (duration < 0.05) {
        duration = 0.05;
    }
    
    //3.赋值
    _duration = duration;
}


@end
