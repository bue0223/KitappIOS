//
//  Cells.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 5/18/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SpreadsheetView


class TextCellViewModel: RowViewModel {
    var rowHeight: Float {
        return 30.0
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
}

class SampleSheetCellView: Cell, NibFileOwnerLoadable {
    
    
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
