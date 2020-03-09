//
//  PagerViewLayout.swift
//  PagerView
//
//  Created by Wenchao Ding on 20/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

class PagerViewLayout: UICollectionViewFlowLayout {
    
    internal var contentSize: CGSize = .zero
    internal var leadingSpacing: CGFloat = 0
    internal var itemSpacing: CGFloat = 0
    internal var needsReprepare = true

    fileprivate var collectionViewSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    fileprivate var numberOfItems = 0
    fileprivate var actualInteritemSpacing: CGFloat = 0
    fileprivate var actualItemSize: CGSize = .zero
    
    weak var helper: PagerViewHelper?
    
    override public func prepare() {
        guard let collectionView = self.collectionView, let pagerHelper = self.helper else {
            return
        }
        guard self.needsReprepare || self.collectionViewSize != collectionView.frame.size else {
            return
        }
        self.needsReprepare = false
        
        self.collectionViewSize = collectionView.frame.size
        
        // Calculate basic parameters/variables
        self.numberOfSections = pagerHelper.numberOfSections(in: collectionView)
        self.numberOfItems = pagerHelper.collectionView(collectionView, numberOfItemsInSection: 0)
        self.actualItemSize = {
            var size = pagerHelper.pagerViewConfig.itemSize
            if size == .zero {
                size = collectionView.frame.size
            }
            return size
        }()
        self.actualInteritemSpacing = {
            return pagerHelper.pagerViewConfig.interitemSpacing
        }()
        self.scrollDirection = pagerHelper.pagerViewConfig.scrollDirection
        self.leadingSpacing = pagerHelper.pagerViewConfig.leadingSpace ?? (self.scrollDirection == .horizontal ? (collectionView.frame.width-self.actualItemSize.width)*0.5 : (collectionView.frame.height-self.actualItemSize.height)*0.5)
        self.itemSpacing = (self.scrollDirection == .horizontal ? self.actualItemSize.width : self.actualItemSize.height) + self.actualInteritemSpacing
        
        // Calculate and cache contentSize, rather than calculating each time
        self.contentSize = {
            let numberOfItems = self.numberOfItems*self.numberOfSections
            switch self.scrollDirection {
            case .horizontal:
                var contentSizeWidth: CGFloat = self.leadingSpacing*2 // Leading & trailing spacing
                contentSizeWidth += CGFloat(numberOfItems-1)*self.actualInteritemSpacing // Interitem spacing
                contentSizeWidth += CGFloat(numberOfItems)*self.actualItemSize.width // Item sizes
                let contentSize = CGSize(width: contentSizeWidth, height: self.actualItemSize.height)
                return contentSize
            case .vertical:
                var contentSizeHeight: CGFloat = self.leadingSpacing*2 // Leading & trailing spacing
                contentSizeHeight += CGFloat(numberOfItems-1)*self.actualInteritemSpacing // Interitem spacing
                contentSizeHeight += CGFloat(numberOfItems)*self.actualItemSize.height // Item sizes
                let contentSize = CGSize(width: self.actualItemSize.width, height: contentSizeHeight)
                return contentSize
            }
        }()
        self.adjustCollectionViewBounds()
    }
    
    override public var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        guard self.itemSpacing > 0, !rect.isEmpty else {
            return layoutAttributes
        }
        let rect = rect.intersection(CGRect(origin: .zero, size: self.contentSize))
        guard !rect.isEmpty else {
            return layoutAttributes
        }
        // Calculate start position and index of certain rects
        let numberOfItemsBefore = self.scrollDirection == .horizontal ? max(Int((rect.minX-self.leadingSpacing)/self.itemSpacing),0) : max(Int((rect.minY-self.leadingSpacing)/self.itemSpacing),0)
        let startPosition = self.leadingSpacing + CGFloat(numberOfItemsBefore)*self.itemSpacing
        let startIndex = numberOfItemsBefore
        // Create layout attributes
        var itemIndex = startIndex
        
        var origin = startPosition
        let maxPosition = self.scrollDirection == .horizontal ? min(rect.maxX,self.contentSize.width-self.actualItemSize.width-self.leadingSpacing) : min(rect.maxY,self.contentSize.height-self.actualItemSize.height-self.leadingSpacing)
        // https://stackoverflow.com/a/10335601/2398107
        while origin-maxPosition <= max(CGFloat(100.0) * .ulpOfOne * abs(origin+maxPosition), .leastNonzeroMagnitude) {
            let indexPath = IndexPath(item: itemIndex%self.numberOfItems, section: itemIndex/self.numberOfItems)
            if let attributes = self.layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
            itemIndex += 1
            origin += self.itemSpacing
        }
        return layoutAttributes
        
    }
    internal func forceInvalidate() {
        self.needsReprepare = true
        self.invalidateLayout()
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.indexPath = indexPath
        let frame = self.frame(for: indexPath)
        let center = CGPoint(x: frame.midX, y: frame.midY)
        attributes.center = center
        attributes.size = self.actualItemSize
        return attributes
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView, let helper = self.helper, helper.isPagingEnabled else {
            return proposedContentOffset
        }
        var proposedContentOffset = proposedContentOffset
        
        func calculateTargetOffset(by proposedOffset: CGFloat, boundedOffset: CGFloat) -> CGFloat {
            var targetOffset: CGFloat
            if helper.pagerViewConfig.decelerationDistance == PagerViewHelper.automaticDistance {
                if abs(velocity.x) >= 0.3 {
                    let vector: CGFloat = velocity.x >= 0 ? 1.0 : -1.0
                    targetOffset = round(proposedOffset/self.itemSpacing+0.35*vector) * self.itemSpacing // Ceil by 0.15, rather than 0.5
                } else {
                    targetOffset = round(proposedOffset/self.itemSpacing) * self.itemSpacing
                }
            } else {
                let extraDistance = max(helper.pagerViewConfig.decelerationDistance-1, 0)
                switch velocity.x {
                case 0.3 ... CGFloat.greatestFiniteMagnitude:
                    targetOffset = ceil(collectionView.contentOffset.x/self.itemSpacing+CGFloat(extraDistance)) * self.itemSpacing
                case -CGFloat.greatestFiniteMagnitude ... -0.3:
                    targetOffset = floor(collectionView.contentOffset.x/self.itemSpacing-CGFloat(extraDistance)) * self.itemSpacing
                default:
                    targetOffset = round(proposedOffset/self.itemSpacing) * self.itemSpacing
                }
            }
            targetOffset = max(0, targetOffset)
            targetOffset = min(boundedOffset, targetOffset)
            return targetOffset
        }
        let proposedContentOffsetX: CGFloat = {
            if self.scrollDirection == .vertical {
                return proposedContentOffset.x
            }
            let boundedOffset = collectionView.contentSize.width-self.itemSpacing
            return calculateTargetOffset(by: proposedContentOffset.x, boundedOffset: boundedOffset)
        }()
        let proposedContentOffsetY: CGFloat = {
            if self.scrollDirection == .horizontal {
                return proposedContentOffset.y
            }
            let boundedOffset = collectionView.contentSize.height-self.itemSpacing
            return calculateTargetOffset(by: proposedContentOffset.y, boundedOffset: boundedOffset)
        }()
        proposedContentOffset = CGPoint(x: proposedContentOffsetX, y: proposedContentOffsetY)
        return proposedContentOffset
    }
    
    internal func contentOffset(for indexPath: IndexPath) -> CGPoint {
        let origin = self.frame(for: indexPath).origin
        guard let collectionView = self.collectionView else {
            return origin
        }
        let contentOffsetX: CGFloat = {
            if self.scrollDirection == .vertical {
                return 0
            }
            let contentOffsetX = origin.x - (collectionView.frame.width*0.5-self.actualItemSize.width*0.5)
            return contentOffsetX
        }()
        let contentOffsetY: CGFloat = {
            if self.scrollDirection == .horizontal {
                return 0
            }
            let contentOffsetY = origin.y - (collectionView.frame.height*0.5-self.actualItemSize.height*0.5)
            return contentOffsetY
        }()
        let contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY)
        return contentOffset
    }
    
    internal func frame(for indexPath: IndexPath) -> CGRect {
        let numberOfItems = self.numberOfItems*indexPath.section + indexPath.item
        guard let collectionView = self.collectionView else {
            return CGRect(origin: CGPoint(x: 0, y: 0), size: self.actualItemSize)
        }
        let originX: CGFloat = {
            if self.scrollDirection == .vertical {
                return (collectionView.frame.width-self.actualItemSize.width)*0.5
            }
            return self.leadingSpacing + CGFloat(numberOfItems)*self.itemSpacing
        }()
        let originY: CGFloat = {
            if self.scrollDirection == .horizontal {
                return (collectionView.frame.height-self.actualItemSize.height)*0.5
            }
            return self.leadingSpacing + CGFloat(numberOfItems)*self.itemSpacing
        }()
        let origin = CGPoint(x: originX, y: originY)
        let frame = CGRect(origin: origin, size: self.actualItemSize)
        return frame
    }
    
    // MARK:- Private functions
    
    fileprivate func adjustCollectionViewBounds() {
        guard let collectionView = self.collectionView, let pagerHelper = self.helper else {
            return
        }
        let currentIndex = pagerHelper.currentIndex
        let newIndexPath = IndexPath(item: currentIndex, section: pagerHelper.pagerViewConfig.isInfiniteScrolling ? self.numberOfSections/2 : 0)
        let contentOffset = self.contentOffset(for: newIndexPath)
        let newBounds = CGRect(origin: contentOffset, size: collectionView.frame.size)
        collectionView.bounds = newBounds
    }

}
