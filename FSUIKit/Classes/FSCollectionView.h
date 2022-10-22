//
//  FSCollectionView.h
//  OxfordLibrary
//
//  Created by 扶冬冬 on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 不要用来做多个section的需求实现，因为用了一个numbers来记录cell个数，没做多section处理，numbers是担心cellForIndex:方法里“越界”
@interface FSCollectionView : UIView


/**
 *  如果已经创建，就返回；否则返回nil。
 */
- (UICollectionView *)notLazyCollectionView;

/**
 * 滑动视图代理回调
 */
@property (nonatomic, assign) id <UIScrollViewDelegate> scrollDelgate;

/**
 * 自定义FlowLayout，用于做cell切换动画
 */
@property (nonatomic, copy) UICollectionViewFlowLayout* (^customFlowLayout)(FSCollectionView *bCollectionView);

/**
 * 配置flowLayout属性
 */
@property (nonatomic, copy) void (^configFlowLayout)(FSCollectionView *bCollectionView, UICollectionViewFlowLayout *bFlowLayout);

/**
 * 配置UICollectionView属性
 */
@property (nonatomic, copy) void (^configUICollectionView)(FSCollectionView *bView, UICollectionView *bCollectionView);

/**
 * 获取当前的复用identifier
 */
@property (nonatomic, copy) NSString *(^identifierForIndexPath)(FSCollectionView *bCollectionView, NSIndexPath *bIndexPath);

/**
 * 用于给cell设值
 */
@property (nonatomic, copy) void (^cellForItemAtIndexPath)(FSCollectionView *bCollectionView, UICollectionViewCell *bCell, NSIndexPath *bIndexPath);

/**
 * section里cell的数量
 */
@property (nonatomic, copy) NSInteger (^numberOfItemsInSection)(FSCollectionView *bCollectionView, NSInteger bSection);

/**
 * 设置每个cell的size
 */
@property (nonatomic, copy) CGSize (^sizeForItemAtIndexPath)(FSCollectionView *bCollectionView, UICollectionViewLayout *bLayout, NSIndexPath *bIndexPath);

/**
 * section的偏移，设置整个section
 */
@property (nonatomic, copy) UIEdgeInsets (^insetForSectionAtIndex)(FSCollectionView *bCollectionView, UICollectionViewLayout *bLayout, NSInteger bSection);

/**
 * 多行时每行间的列距离
 */
@property (nonatomic, copy) CGFloat (^minimumLineSpacingForSectionAtIndex)(FSCollectionView *bCollectionView,UICollectionViewLayout *bLayout, NSInteger bSection);

/**
 * 只走一遍，全局设置cell间间距
 */
@property (nonatomic, copy) CGFloat (^minimumInteritemSpacingForSectionAtIndex)(FSCollectionView *bCollectionView,UICollectionViewLayout *bLayout, NSInteger bSection);

/**
 * 入口函数，在前面的block方法都设置后，调用这个方法来初始化UICollectionView
 */
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

/**
 * 点击cell的回调
 */
@property (nonatomic, copy) void (^didSelectItemAtIndexPath)(FSCollectionView *bCollectionView, NSIndexPath *bIndexPath);

/**
 * cell滑动时index变化后的回调
 */
@property (nonatomic, copy) void (^indexOfPageChanged)(FSCollectionView *bCollectionView, NSIndexPath *indexPath);

/**
 *  cell将要展示
 */
@property (nonatomic, copy) void (^willDisplayCell)(FSCollectionView *bCollectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, BOOL isScrollToLeft);

/**
 * cell将要消失
 */
@property (nonatomic, copy) void (^didEndDisplayingCell)(FSCollectionView *bCollectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, BOOL isScrollToLeft);

/**
 * 刷新数据
 */
- (void)reloadData;

/**
 * 滑动cell，注意！！！：如果视图还没完成就调用，可能出现不生效的情况，需要做一个队尾处理，在dispatch_async(dispatch_get_main_queue(), ^{ }；里调用
 */
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 * 偏移，如果已经超过最大可偏移距离，则只移动最大可偏移
 */
- (void)setContentOffset:(CGFloat)offset animated:(BOOL)animated;

/**
 * 不带动画，方便由外界控制动画时间
 */
- (void)setContentOffset:(CGFloat)offset;

/**
 * 获取某个cell的frame，如果cell没显示，获取cell会为nil，但是可以获取到frame，这个frame的x坐标为contentOffset对应的X，即可以滑到
 */
- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath;

/**
 * 获取index对应的cell，如果cell没有在屏幕中展示，会返回nil
 */
- (UICollectionViewCell *)cellForIndex:(NSInteger)index;

/**
 * 当前展示的cell
 */
- (NSArray<UICollectionViewCell *> *)visibleCells;
- (NSArray<NSIndexPath *> *)indexPathsForVisibleItems;


@end

NS_ASSUME_NONNULL_END
