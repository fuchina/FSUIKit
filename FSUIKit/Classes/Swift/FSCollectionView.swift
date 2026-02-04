// FSCollectionViewS.swift
// Translated from FSCollectionView.h/m

import UIKit

@objcMembers
public class FSCollectionView: UIView {
    
    private var _collectionView: UICollectionView?
    private var _isScrollToLeft: Bool = false
    private var _lastOffsetX: CGFloat = 0
    
    public weak var scrollDelegate: UIScrollViewDelegate?
    
    public var customFlowLayout: ((FSCollectionViewS) -> UICollectionViewFlowLayout)?
    public var configFlowLayout: ((FSCollectionViewS, UICollectionViewFlowLayout) -> Void)?
    public var configUICollectionView: ((FSCollectionViewS, UICollectionView) -> Void)?
    public var identifierForIndexPath: ((FSCollectionViewS, IndexPath) -> String)?
    public var cellForItemAtIndexPath: ((FSCollectionViewS, UICollectionViewCell, IndexPath) -> Void)?
    public var numberOfItemsInSection: ((FSCollectionViewS, Int) -> Int)?
    public var sizeForItemAtIndexPath: ((FSCollectionViewS, UICollectionViewLayout, IndexPath) -> CGSize)?
    public var insetForSectionAtIndex: ((FSCollectionViewS, UICollectionViewLayout, Int) -> UIEdgeInsets)?
    public var minimumLineSpacingForSectionAtIndex: ((FSCollectionViewS, UICollectionViewLayout, Int) -> CGFloat)?
    public var minimumInteritemSpacingForSectionAtIndex: ((FSCollectionViewS, UICollectionViewLayout, Int) -> CGFloat)?
    public var didSelectItemAtIndexPath: ((FSCollectionViewS, IndexPath) -> Void)?
    public var indexOfPageChanged: ((FSCollectionViewS, IndexPath?) -> Void)?
    public var willDisplayCell: ((FSCollectionViewS, UICollectionViewCell, IndexPath, Bool) -> Void)?
    public var didEndDisplayingCell: ((FSCollectionViewS, UICollectionViewCell, IndexPath, Bool) -> Void)?
    
    public var collectionView: UICollectionView {
        if _collectionView == nil {
            let flowLayout: UICollectionViewFlowLayout
            if let custom = customFlowLayout {
                flowLayout = custom(self)
            } else {
                flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .horizontal
                configFlowLayout?(self, flowLayout)
            }
            
            let cv = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
            cv.dataSource = self
            cv.delegate = self
            cv.backgroundColor = .clear
            addSubview(cv)
            configUICollectionView?(self, cv)
            _collectionView = cv
        }
        return _collectionView!
    }
    
    public func notLazyCollectionView() -> UICollectionView? {
        return _collectionView
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _collectionView?.frame = bounds
    }
    
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func reloadData() {
        _collectionView?.reloadData()
    }
    
    public func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard let cv = _collectionView,
              let itemFrame = cv.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame else { return }
        cv.setContentOffset(itemFrame.origin, animated: animated)
    }
    
    public func setContentOffset(_ offset: CGFloat, animated: Bool) {
        guard let cv = _collectionView else { return }
        let contentSize = cv.contentSize
        if contentSize.width < 1 && contentSize.height < 1 { return }
        
        let offsetMax = contentSize.width - cv.frame.width
        var finalOffset = min(offset, offsetMax)
        finalOffset = max(finalOffset, 0)
        cv.setContentOffset(CGPoint(x: finalOffset, y: 0), animated: animated)
    }
    
    public func setContentOffset(_ offset: CGFloat) {
        guard let cv = _collectionView else { return }
        let contentSize = cv.contentSize
        let offsetMax = contentSize.width - cv.frame.width
        var contentOffset = offset + cv.contentOffset.x
        contentOffset = min(contentOffset, offsetMax)
        cv.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: false)
    }
    
    public func frame(for indexPath: IndexPath) -> CGRect {
        guard let cv = _collectionView else { return .zero }
        let cells = cv.numberOfItems(inSection: 0)
        if indexPath.row >= cells { return .zero }
        return cv.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
    }
    
    public func cell(for index: Int) -> UICollectionViewCell? {
        guard index >= 0, let cv = _collectionView else { return nil }
        let cells = cv.numberOfItems(inSection: 0)
        if index >= cells { return nil }
        let ip = IndexPath(row: index, section: 0)
        return cv.cellForItem(at: ip)
    }
    
    public func visibleCells() -> [UICollectionViewCell] {
        return _collectionView?.visibleCells ?? []
    }
    
    public func indexPathsForVisibleItems() -> [IndexPath] {
        return _collectionView?.indexPathsForVisibleItems ?? []
    }
}

extension FSCollectionViewS: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection?(self, section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = identifierForIndexPath?(self, indexPath) ?? ""
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        cellForItemAtIndexPath?(self, cell, indexPath)
        return cell
    }
}

extension FSCollectionViewS: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAtIndexPath?(self, collectionViewLayout, indexPath) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSectionAtIndex?(self, collectionViewLayout, section) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSectionAtIndex?(self, collectionViewLayout, section) ?? 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSectionAtIndex?(self, collectionViewLayout, section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAtIndexPath?(self, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCell?(self, cell, indexPath, _isScrollToLeft)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayingCell?(self, cell, indexPath, _isScrollToLeft)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = convert(collectionView.center, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        indexOfPageChanged?(self, indexPath)
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _isScrollToLeft = _lastOffsetX <= scrollView.contentOffset.x
        _lastOffsetX = scrollView.contentOffset.x
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
}
