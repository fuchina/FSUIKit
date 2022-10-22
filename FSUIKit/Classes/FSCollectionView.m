//
//  HECollectionView.m
//  OxfordLibrary
//
//  Created by 扶冬冬 on 2021/1/21.
//

#import "FSCollectionView.h"

@interface FSCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView      *collectionView;

@end

@implementation FSCollectionView {
    BOOL        _isScrollToLeft;    // 是否正在向左滑
    CGFloat     _lastOffsetX;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = nil;
        if (self.customFlowLayout) {
            flowLayout = self.customFlowLayout(self);
        } else {
            flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            if (self.configFlowLayout) {
                self.configFlowLayout(self, flowLayout);
            }
        }
//        flowLayout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 60);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [self addSubview:_collectionView];
        if (self.configUICollectionView) {
            self.configUICollectionView(self, _collectionView);
        }
    }
    return _collectionView;
}

- (UICollectionView *)notLazyCollectionView {
    return _collectionView;
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    // cellClass必须是UICollectionViewCell的子类，否则会崩溃
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)reloadData {
//    [_collectionView reloadItemsAtIndexPaths:[_collectionView indexPathsForVisibleItems]];
    [_collectionView reloadData];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    // [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated]; 有bug
    CGRect itemFrame = [_collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath].frame;
    [_collectionView setContentOffset:itemFrame.origin animated:animated];
}

- (void)setContentOffset:(CGFloat)offset animated:(BOOL)animated {
    CGSize contentSize = _collectionView.contentSize;
    CGFloat offsetMax = contentSize.width - _collectionView.frame.size.width;
    if (offset > offsetMax) {
        offset = offsetMax;
    }
    
    if (offset < 0) {
        offset = 0;
    }
    [_collectionView setContentOffset:CGPointMake(offset, 0) animated:animated];
}

// 由外界控制动画时间
- (void)setContentOffset:(CGFloat)offset {
    CGSize contentSize = _collectionView.contentSize;
    CGFloat offsetMax = contentSize.width - _collectionView.frame.size.width;
    CGFloat contentOffset = offset + _collectionView.contentOffset.x;
    if (contentOffset > offsetMax) {
        contentOffset = offsetMax;
    }
    [_collectionView setContentOffset:CGPointMake(contentOffset, 0)];
}

- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath {
    NSInteger cells = [_collectionView numberOfItemsInSection:0];
    if (indexPath.row >= cells) {
        return CGRectZero;
    }
    
    CGRect itemFrame = [self->_collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath].frame;
    return itemFrame;
}

- (UICollectionViewCell *)cellForIndex:(NSInteger)index {
    if (index < 0) {
        return nil;
    }
    NSInteger cells = [_collectionView numberOfItemsInSection:0];
    if (index >= cells) {
        return nil;
    }
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:ip];
    return cell;
}

- (NSArray<UICollectionViewCell *> *)visibleCells {
    return _collectionView.visibleCells;
}

- (NSArray<NSIndexPath *> *)indexPathsForVisibleItems {
    return _collectionView.indexPathsForVisibleItems;
}

#pragma mark UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSAssert(self.identifierForIndexPath, @"identifierForIndexPath必须实现");
    if (self.identifierForIndexPath) {
        identifier = self.identifierForIndexPath(self,indexPath);
    }
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.cellForItemAtIndexPath) {
        self.cellForItemAtIndexPath(self, cell, indexPath);
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.numberOfItemsInSection) {
        NSInteger number = self.numberOfItemsInSection(self, section);
        return number;
    }
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sizeForItemAtIndexPath) {
        return self.sizeForItemAtIndexPath(self,collectionViewLayout,indexPath);
    }
    return CGSizeZero;
}

/**
 * section的偏移
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.insetForSectionAtIndex) {
        return self.insetForSectionAtIndex(self,collectionViewLayout,section);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.minimumLineSpacingForSectionAtIndex) {
        return self.minimumLineSpacingForSectionAtIndex(self,collectionViewLayout,section);
    }
    return 1;
}

// 只走一遍，全局设置,cell间间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.minimumInteritemSpacingForSectionAtIndex) {
        return self.minimumInteritemSpacingForSectionAtIndex(self, collectionViewLayout, section);
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemAtIndexPath) {
        self.didSelectItemAtIndexPath(self, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.willDisplayCell) {
        self.willDisplayCell(self, cell, indexPath, _isScrollToLeft);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didEndDisplayingCell) {
        self.didEndDisplayingCell(self, cell, indexPath, _isScrollToLeft);
    }
}

/**
 * 给section用
 */
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    static NSString *i = @"m";
//    UICollectionReusableView *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:i forIndexPath:indexPath];
//    if (!v) {
//        v = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 60)];
//    }
//    v.backgroundColor = UIColor.greenColor;
//    return v;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = [self convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (self.indexOfPageChanged) {
        self.indexOfPageChanged(self, indexPath);
    }
    
    if (self.scrollDelgate && [self.scrollDelgate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelgate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_lastOffsetX > scrollView.contentOffset.x) {
        _isScrollToLeft = NO;
    } else {
        _isScrollToLeft = YES;
    }
    
    _lastOffsetX = scrollView.contentOffset.x;
    
    if (self.scrollDelgate && [self.scrollDelgate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelgate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollDelgate && [self.scrollDelgate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollDelgate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end
