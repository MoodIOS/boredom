//
//  FadingLayout.swift
//  boredom
//
//  Created by Jigyasaa Sood on 5/3/21.
//  Copyright © 2021 Codacity LLC. All rights reserved.
//

import UIKit

class FadingLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    //should be 0<fade<1
        private let fadeFactor: CGFloat = 0.8
        private let cellHeight : CGFloat = 60.0

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        init(scrollDirection:UICollectionViewScrollDirection) {
            super.init()
            self.scrollDirection = scrollDirection

        }

        override func prepare() {
          //  setupLayout()
            super.prepare()
        }

        /*func setupLayout() {
            self.itemSize = CGSize(width: self.collectionView!.bounds.size.width,height:cellHeight)
            self.minimumLineSpacing = 0
        }*/

        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }

        func scrollDirectionOver() -> UICollectionViewScrollDirection {
            return UICollectionViewScrollDirection.vertical
        }
        //this will fade both top and bottom but can be adjusted
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let attributesSuper: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) as [UICollectionViewLayoutAttributes]!
            if let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes]{
                var visibleRect = CGRect()
                visibleRect.origin = collectionView!.contentOffset
                visibleRect.size = collectionView!.bounds.size
                for attrs in attributes {
                    if attrs.frame.intersects(rect) {
                        let distance = visibleRect.midY - attrs.center.y
                        let normalizedDistance = abs(distance) / (visibleRect.height * fadeFactor) * 0.2
                        let fade = 1 - normalizedDistance
                        attrs.alpha = fade
                    }
                }
                return attributes
            }else{
                return nil
            }
        }
        //appear and disappear at 0
        override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
            attributes.alpha = 0
            return attributes
        }

        override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
            attributes.alpha = 0
            return attributes
        }

}
