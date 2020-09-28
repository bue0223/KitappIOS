//
//  ProductEntity+CoreDataClass.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {
    var with_reward: Bool {
        if let rewards = rewards {
            if rewards.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    
    func computeProfitRetailer(packs: Double) -> Double {
        let totalInvestment = pack_price_retail * packs
        let totalSell = (stick_price * Double(quantity_per_pack)) * packs
        
        return totalSell - totalInvestment
    }
    
    var totalPuhunanRetailer: Double {
        return pack_price_retail * Double(ave_weekly_packs)
    }
    
    var totalBentaRetailer: Double {
        return stick_price * Double(quantity_per_pack) * Double(ave_weekly_packs)
    }
    
    var totalKitaRetailer: Double {
        return totalBentaRetailer - totalPuhunanRetailer
    }
        
    func computeProfitWholesaler(cartons: Double) -> Double {
        let totalInvestment = cartons * ream_price_wholesale
        
        let totalSell = (10 * pack_price_wholesale) * cartons
        
        
        return totalSell - totalInvestment
    }
    
    var totalPuhunanWholesaler: Double {
        return Double(ave_weekly_cartons) * ream_price_wholesale
    }
    
    var totalBentaWholesaler: Double {
        return 10 * pack_price_wholesale * Double(ave_weekly_cartons)
    }
    
    var totalKitaWholesaler: Double {
        return totalBentaWholesaler - totalPuhunanWholesaler
    }
    
    func computeRewardRetailer(packs: Double) -> Double {
        let totalRewards = packs * ((rewards?.first(where: { (reward) -> Bool in
            return (reward as? RewardEntity)?.type == "Retailer"
        }) as? RewardEntity)?.reward ?? 0.0)
        
        return totalRewards
    }
    
    func computeRewardWholesaler(cartons: Double) -> Double {
        let totalRewards = cartons * (((rewards?.first(where: { (reward) -> Bool in
            return (reward as? RewardEntity)?.type == "Wholesale"
        }) as? RewardEntity)?.reward ?? 0.0))
        
        return totalRewards
    }
}
