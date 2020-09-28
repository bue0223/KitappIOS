//
//  RowViewModel.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation

protocol RowViewModel {
    //var columnViewModels: [RowViewModel] { get set }
    
    var rowHeight: Float {
        set
        get
    }
}

/// Conform this protocol to handles user press action
protocol ViewModelPressible {
    var cellPressed: (()->Void)? { get set }
}
