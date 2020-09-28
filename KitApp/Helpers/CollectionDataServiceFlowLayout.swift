//
//  CollecitonFlowLayout.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/20/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

enum CollectionLayoutType {
    case Collections
    case Products
}

class CollectionDataServiceFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        minimumLineSpacing = 16.0
        minimumInteritemSpacing = 16.0
        itemSize = CGSize(width: 80.0, height: 80.0)
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class ProductsDataServiceFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        minimumLineSpacing = 16.0
        minimumInteritemSpacing = 16.0
        itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 24, height: 230.0)
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
