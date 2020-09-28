//
//  ComparisonViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/22/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class ComparisonViewModel {
    var pmftcWinsComparison: Bool  {
        return pmftcTotalProfit > otherBrandsTotalProfit
    }
    var pmftcTotalProfit: Double {
        return UserManager().user?.totalPmtcProfit ?? 0.0
    }
    var otherBrandsTotalProfit: Double {
        return UserManager().user?.totalOthersProfit ?? 0.0
    }
    
    var showsPmftcBackgroundView: Bool = false
    
    var topLabelText: String {
        if pmftcWinsComparison == true {
            return "Sa PMTC, ALL-IN ang KITA, ALL-IN ang PANALO!"
        }
        
        
        return "ALL-IN kami para tulungan kayong palakihin pa ang negosyo with PMFTC!"
    }
    
    var pmtcTextColor: UIColor  {
        if pmftcWinsComparison == true {
            return Constants.ColorTheme.appTheme
        }
        
        return UIColor.darkGray
    }
    
    var otherBrandsTextColor: UIColor  {
        if pmftcWinsComparison == true {
            return UIColor.darkGray
        }
        
        return Constants.ColorTheme.appTheme
    }
    
    var comparisonImagename: String {
        return pmftcWinsComparison == true ? "arrow-right" : "arrow-left"
    }
    
    func start() {
        //showsPmftcBackgroundView = pmftcWinsComparison
    }
}
