//
//  HC_HotSaleTimeItemsView.h
//  HaiChi
//
//  Created by david on 2020/5/12.
//  Copyright © 2020 gwh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface DGTimeItemModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topTitle;
@end



#pragma mark -
@class DGTimeItemView;
@protocol DGTimeItemViewDelegate <NSObject>
/**
 点击button让delegate调用代理方法
 
 @param itemView 触发代理方法的itemView
 @param index    当前点击item的index
 @return 此次点击是否有效
 */
-(BOOL)timeItemView:(DGTimeItemView *)itemView didSelectedAtIndex:(NSUInteger)index;
@end


#pragma mark -
@interface DGTimeItemView : UIView

@property (nonatomic,weak) id<DGTimeItemViewDelegate> delegate;

/** itemStr数组, 赋值是,开始添加item控件
 * 最好在其他属性赋值之后在对titleArr赋值
 */
@property (nonatomic, copy) NSArray <DGTimeItemModel *>*titleArr;

/** 选中index
 * 在titleArr属性前赋值: 为默认选中index; 若超出titleArr的最大下标,及没有默认选中
 * 在titleArr属性后赋值: 会触发代理方法; 若超出titleArr的最大下标此次赋值无效
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

#pragma mark indicator
/** 是否显示indicatorView */
@property (nonatomic, assign) BOOL indicatorViewHidden;
/** indicator颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** indicator图片 */
@property (nonatomic, strong) UIImage *indicatorImage;
/** 缩放比例
 * DGItemViewIndicatorStyleLine: 总是有效 0~1
 * DGItemViewIndicatorStyleLayer: 在needEqualWidth=YES时才有效,且>=0.4
 */
@property (nonatomic,assign) CGFloat indicatorWidthScale;
/** 缩放比例
 * DGItemViewIndicatorStyleLine: 总是有效 0~1
 * DGItemViewIndicatorStyleLayer: 在needEqualWidth=YES时才有效,且>=0.4
 */
@property (nonatomic,assign) CGFloat indicatorHeightScale;

#pragma mark btn
/** 是否需要等宽
 * 需要在titleArr属性前赋值, 默认为YES
 */
@property (nonatomic,assign) BOOL needEqualWidth;

/** title普通状态font */
@property (nonatomic, assign) UIFont *titleNormalFont;
/** title选中状态font */
@property (nonatomic, assign) UIFont *titleSelectedFont;
/** title普通状态 颜色 */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** title选中状态 颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/** topTitle普通状态font */
@property (nonatomic, assign) UIFont *topTitleNormalFont;
/** topTitle选中状态font */
@property (nonatomic, assign) UIFont *topTitleSelectedFont;
/** topTitle普通状态 颜色 */
@property (nonatomic, strong) UIColor *topTitleNormalColor;
/** topTitle选中状态 颜色 */
@property (nonatomic, strong) UIColor *topTitleSelectedColor;


#pragma mark animation
/** 动画时间,默认0.25, 范围:0.05~3.0 */
@property (nonatomic,assign) CGFloat duration;

@end

NS_ASSUME_NONNULL_END
