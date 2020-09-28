//
//  PriceSheetCellView.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/29/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation


import UIKit
import SpreadsheetView
import SDWebImage

enum PriceSheetCellViewType {
    case none
    case topHeader
    case header
    case body
    case body2
    case footer
}

class PriceSheetCellViewModel: SpreadsheetItemViewModel {
    var rowHeight: Float {
        return 30.0
    }
    
    var text: String
    
    var titleColor: UIColor = UIColor.black
    var backGroundColor: UIColor? = Constants.ColorTheme.systemGray6
    var imageUrl: String = ""
    var isImageHidden: Bool = true
    var isLabelHidden: Bool = false
    var imageData: Data?
    
    var image: UIImage?
    
    var alignment: NSTextAlignment = .center
    
    
    var model: ProductEntity?
    
    var type: PriceSheetCellViewType = .none {
        didSet {
            switch type {
            case .topHeader:
                isImageHidden = false
                isLabelHidden = true
                titleColor = UIColor.black
                backGroundColor = UIColor.clear
                alignment = .center
            case .header:
                isImageHidden = true
                isLabelHidden = false
                titleColor = UIColor.white
                //backGroundColor = UIColor.darkGray
                alignment = .center
            case .body:
                isImageHidden = true
                isLabelHidden = false
                titleColor = UIColor.black
                backGroundColor = UIColor.white
            alignment = .center
            case .body2:
                isImageHidden = true
                isLabelHidden = false
                titleColor = UIColor.black
                backGroundColor = Constants.ColorTheme.systemGray5
                alignment = .center
            default:
                isImageHidden = true
                isLabelHidden = false
                titleColor = UIColor.black
                backGroundColor = UIColor.white
                alignment = .center
            }
        }
    }
    
    init(text: String, type: PriceSheetCellViewType = .none, imageData: Data? = nil, image: UIImage? = nil, backgroundColor: UIColor? = nil, model: ProductEntity? = nil) {
        self.text = text
        self.type = type
        self.imageData = imageData
        self.image = image
        
        self.model = model
        
        if let bgColor = backgroundColor {
            self.backGroundColor = bgColor
        }
    }
}

class PriceSheetCellView: Cell, NibFileOwnerLoadable, SpreadsheetCellConfigurable {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var displayLabel: UILabel!
    
    func setup(viewModel: SpreadsheetItemViewModel) {
        if let viewModel = viewModel as? PriceSheetCellViewModel {
            displayLabel.text = viewModel.text
            displayLabel.textColor = viewModel.titleColor
            mainView.backgroundColor = viewModel.backGroundColor
            displayImageView.isHidden = viewModel.isImageHidden
            displayLabel.textAlignment = viewModel.alignment
            displayLabel.isHidden = viewModel.isLabelHidden
            if let data = viewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }else {
                displayImageView.image = viewModel.image
            }
        }
        
        borders.left = .solid(width: 2, color: Constants.ColorTheme.systemGray4)
        borders.right = .solid(width: 2, color: Constants.ColorTheme.systemGray4)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNibContent()
        setup()
    }
    
    func setup() {
        //roundCorners([.bottomLeft, .bottomRight], radius: 49.0)
    }

}
