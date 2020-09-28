//
//  Observable.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/7/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation


class Observable<T> {
    var value: T {
//        didSet {
//
//        }
//        
        willSet {
            DispatchQueue.main.async {
                for valueChanged in self.valueChangedes {
                    valueChanged?(self.value)
                }
            }
        }
    }

    private var valueChangedes: [((T) -> Void)?] = []

    init(value: T) {
        self.value = value
    }

    /// Add closure as an observer and trigger the closure imeediately if fireNow = true
    func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
        valueChangedes.append(onChange)
        if fireNow {
            onChange?(value)
        }
    }

    func removeObserver() {
        valueChangedes = []
    }

}
