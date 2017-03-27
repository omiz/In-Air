//
//  UICollectionView.swift
//  In Air
//
//  Created by Omar Allaham on 3/27/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

extension UICollectionView {

    enum ReusableKind: Int {
        case header
        case footer
    }

    func register<T: UICollectionViewCell>(_ cell: T.Type) {

        let nib = UINib.init(nibName: "\(T.self)", bundle: nil)

        register(nib, forCellWithReuseIdentifier: "\(T.self)")
    }

    func register<T: UICollectionReusableView>(_ cell: T.Type, kind: ReusableKind = .header) {

        let nib = UINib.init(nibName: "\(T.self)", bundle: nil)

        let kind = kind == .header ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter

        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(T.self)")
    }

    func cell<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {

        let result = dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath)

        assert(result is T, "The found cell does not match the requested type \(T.self)")

        return result as! T
    }

    func cell<T: UICollectionReusableView>(_ cell: T.Type, indexPath: IndexPath, kind: ReusableKind = .header) -> T {

        let kind = kind == .header ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter

        let result = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(T.self)", for: indexPath) as? T

        assert(result != nil, "The found reusable view does not match the requested kind \(T.self)")

        return result!
    }

    func deselectItem(at indexPath: IndexPath) {
        delay(0) {
            self.deselectItem(at: indexPath, animated: false)
            self.delegate?.collectionView?(self, didDeselectItemAt: indexPath)
        }
    }
}
