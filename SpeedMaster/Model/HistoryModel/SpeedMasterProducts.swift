//
//  SpeedMasterProducts.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation
import FirebaseDatabase
import StoreKit

var subscriptionPurchases: Set<ProductID> = []

struct Subscriptions {
    var ref: DatabaseReference?
    var key: String?
    var annualProductID: String
    var annualProductPrice: Double
    var monthlyProductID: String
    var monthlyProductPrice: Double
    var weeklyProductID: String
    var weeklyProductPrice: Double
    
    init(annualProductID: String = "", annualProductPrice: Double = 35.99, monthlyProductID: String = "", monthlyProductPrice: Double = 15.99, weeklyProductID: String = "", weeklyProductPrice: Double = 5.99) {
        self.ref = nil
        self.key = nil
        self.annualProductID = annualProductID
        self.annualProductPrice = annualProductPrice
        self.monthlyProductID = monthlyProductID
        self.monthlyProductPrice = monthlyProductPrice
        self.weeklyProductID = weeklyProductID
        self.weeklyProductPrice = weeklyProductPrice
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let annualProductID = value["annualProductID"] as? String,
            let annualProductPrice = value["annualProductPrice"] as? Double,
            let monthlyProductID = value["monthlyProductID"] as? String,
            let monthlyProductPrice = value["monthlyProductPrice"] as? Double,
            let weeklyProductID = value["weeklyProductID"] as? String,
            let weeklyProductPrice = value["weeklyProductPrice"] as? Double
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.annualProductID = annualProductID
        self.annualProductPrice = annualProductPrice
        self.monthlyProductID = monthlyProductID
        self.monthlyProductPrice = monthlyProductPrice
        self.weeklyProductID = weeklyProductID
        self.weeklyProductPrice = weeklyProductPrice
    }
}

