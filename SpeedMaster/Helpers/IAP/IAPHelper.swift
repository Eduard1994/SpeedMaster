//
//  IAPHelper.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/30/21.
//

import Foundation
import SwiftyStoreKit
import StoreKit

public typealias ProductID = String

var allPrices: [String: String] = [:]
var allProducts: Set<SKProduct> = []
var allProductIDs: Set<ProductID> = []
var purchasedAny = false

class IAPHelper {
    static let shared = IAPHelper()
    
    // MARK: - Setting up In-App Purchase
    public func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    print("Failed, or Purchasing or deferred")
                    break
                @unknown default:
                    break
                }
            }
            
            SwiftyStoreKit.updatedDownloadsHandler = { downloads in
                // contentURL is not nil if downloadState == .finished
                let contentURLs = downloads.compactMap { $0.contentURL }
                if contentURLs.count == downloads.count {
                    print("Saving: \(contentURLs)")
                    SwiftyStoreKit.finishTransaction(downloads[0].transaction)
                }
            }
        }
    }
    
    /// Finishing Purchasing
    public func finishPurchasing(purchase: PurchaseDetails) {
        let downloads = purchase.transaction.downloads
        if !downloads.isEmpty {
            SwiftyStoreKit.start(downloads)
        }
        // Deliver content from server, then:
        if purchase.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(purchase.transaction)
        }
    }
    
    /// FInishing Restoring
    public func finishingRestoring(restoreResults: RestoreResults) {
        for purchase in restoreResults.restoredPurchases {
            let downloads = purchase.transaction.downloads
            if !downloads.isEmpty {
                SwiftyStoreKit.start(downloads)
            } else if purchase.needsFinishTransaction {
                // Deliver content from server, then:
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
        }
    }
    
    /// Getting Subscriptions
    private func getSubscriptions(_ completion: @escaping (Set<ProductID>?, RetrieveResults?, NetworkError?) -> Void) {
        Service().getSubscriptions { (purchases, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, nil, .unowned(description: error.localizedDescription))
                }
                return
            }
            if let purchases = purchases {
                NetworkActivityIndicatorManager.networkOperationStarted()
                SwiftyStoreKit.retrieveProductsInfo(purchases) { result in
                    NetworkActivityIndicatorManager.networkOperationFinished()
                    DispatchQueue.main.async {
                        completion(purchases, result, nil)
                    }
                    //            self.showAlert(self.alertForProductRetrievalInfo(result))
//                    print(result.retrievedProducts)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, nil, .unowned(description: "Couldn't connect to Firebase"))
                }
            }
        }
    }
    
    /// Getting Info about the product
    public func getInfo(_ completion: @escaping (Set<ProductID>?, RetrieveResults?, NetworkError?) -> Void) {
        if User.currentUser != nil {
            self.getSubscriptions(completion)
        } else {
            Service().checkUser { (user, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, nil, .unowned(description: error.localizedDescription))
                    }
                    return
                }
                if let user = user {
                    print(user as Any)
                    User.currentUser = user
                    self.getSubscriptions(completion)
                } else {
                    DispatchQueue.main.async {
                        completion(nil, nil, .unowned(description: "Couldn't connect to Firebase"))
                    }
                }
            }
        }
    }
    
    public func purchase(_ purchase: ProductID, atomically: Bool, completion: @escaping (PurchaseResult) -> Void) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(purchase, atomically: atomically) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
//            if case .success(let purchase) = result {
//                let downloads = purchase.transaction.downloads
//                if !downloads.isEmpty {
//                    SwiftyStoreKit.start(downloads)
//                }
//                // Deliver content from server, then:
//                if purchase.needsFinishTransaction {
//                    SwiftyStoreKit.finishTransaction(purchase.transaction)
//                }
//            }
            //            if let alert = self.alertForPurchaseResult(result) {
            //                self.showAlert(alert)
            //            }
            print(result)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    public func restorePurchases(_ completion: @escaping (RestoreResults) -> Void) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
//            for purchase in results.restoredPurchases {
//                let downloads = purchase.transaction.downloads
//                if !downloads.isEmpty {
//                    SwiftyStoreKit.start(downloads)
//                } else if purchase.needsFinishTransaction {
//                    // Deliver content from server, then:
//                    SwiftyStoreKit.finishTransaction(purchase.transaction)
//                }
//            }
            //            self.showAlert(self.alertForRestorePurchases(results))
            print(results)
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    public func verifySubscriptions(_ purchases: Set<ProductID>, _ completion: @escaping (VerifySubscriptionResult?, Set<ProductID>?, VerifyReceiptResult?) -> Void) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                let productIds = Set(purchases.map { $0 })
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                //                self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: productIds))
                print(productIds, purchaseResult)
                DispatchQueue.main.async {
                    completion(purchaseResult, productIds, nil)
                }
            case .error:
                //                self.showAlert(self.alertForVerifyReceipt(result))
                print(result)
                DispatchQueue.main.async {
                    completion(nil, nil, result)
                }
            }
        }
    }
    
    private func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: kAppleSharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
}
