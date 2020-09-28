//
//  DiskManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class ProductList: Decodable, Serializable {
    var products: [Product] = []
}

class DiskManager {
    
    var productList: ProductList? {
        get {
            let model = Disk.retrieve("ProductList", from: .documents, as: ProductList.self)
            return model
        }
    }
    
    func save(products: [Product]) {
        let productList = ProductList()
        productList.products = products
        
        setProducts(products: productList)
    }
    
    func setProducts(products: ProductList){
        Disk.store(products, to: .documents, as: "ProductList")
    }
    
    func removeProducts() {
        Disk.remove("ProductList", from: .documents)
    }
}
