//
//  Cells.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 5/18/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SpreadsheetView
import SDWebImage

enum SpreadsheetItemType {
    case none
    case priceSheetItem
    case priceSheetHeader
    case priceSheetHeaderWithImage
    case priceSheetItemWithImage
    case profitSheetItemDark
    case profitSheetItemLight
    case profitSheetItemHeaderDark
    case profitSheetItemHeaderLight
}

class SpreadSheetCellViewModel: SpreadsheetItemViewModel {
    var rowHeight: Float {
        return 30.0
    }
    
    var text: String
    
    var titleColor: UIColor = UIColor.black
    var backGroundColor: UIColor = Constants.ColorTheme.systemGray6
    var imageUrl: String = ""
    var isImageHidden: Bool = true
    
    var imageData: Data?
    
    var image: UIImage?
    
    var alignment: NSTextAlignment = .center
    
    var type: SpreadsheetItemType = .none {
        didSet {
            switch type {
            case .priceSheetItemWithImage:
                isImageHidden = false
                titleColor = UIColor.black
                backGroundColor = Constants.ColorTheme.systemGray5
                alignment = .left
            case .priceSheetItem:
                isImageHidden = true
                titleColor = Constants.ColorTheme.appTheme
                backGroundColor = Constants.ColorTheme.systemGray5
                alignment = .center
            case .priceSheetHeaderWithImage:
                isImageHidden = false
                titleColor = UIColor.black
                backGroundColor = Constants.ColorTheme.systemGray4
                alignment = .center
            case .priceSheetHeader:
                isImageHidden = true
                titleColor = UIColor.black
                backGroundColor = Constants.ColorTheme.systemGray4
                alignment = .center
            default:
                print("none")
            }
        }
    }
    
    init(text: String, type: SpreadsheetItemType = .none, imageData: Data? = nil, image: UIImage? = nil) {
        self.text = text
        self.type = type
        self.imageData = imageData
        self.image = image
    }
}

class SampleSheetCellView: Cell, NibFileOwnerLoadable, SpreadsheetCellConfigurable {
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var displayImageView: UIImageView!
    
    func setup(viewModel: SpreadsheetItemViewModel) {
        if let viewModel = viewModel as? SpreadSheetCellViewModel {
            displayLabel.text = viewModel.text
            displayLabel.textColor = viewModel.titleColor
            mainView.backgroundColor = viewModel.backGroundColor
            displayImageView.isHidden = viewModel.isImageHidden
            displayLabel.textAlignment = viewModel.alignment
            
            if let data = viewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }else {
                displayImageView.image = viewModel.image
            }
            
            //displayImageView.sd_setImage(with: URL(string: viewModel.imageUrl), completed: nil)
            

        }
    }
    
    
    @IBOutlet weak var displayLabel: UILabel!
    
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
