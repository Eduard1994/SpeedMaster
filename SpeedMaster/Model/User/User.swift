//
//  User.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation
import Firebase
import FirebaseAuth

struct User: Codable {
    let uid: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
    }
    
    static var currentUser: User? {
        set {
            User.userCache?.set(newValue)
        }
        get {
            return User.userCache
        }
    }
    
    @discardableResult
    private func set(_ newValue: User?) -> Bool {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
        
        guard let value = newValue else {
            return false
        }
        
        do {
            try storage.save(value, for: kUserDataKey)
            return true
        } catch {
            print("User Error")
            return false
        }
    }
    
    private static let userCache: User? = {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
        
        var user: User!
        
        do {
            return try storage.fetch(for: kUserDataKey)
        } catch {
            return nil
        }
    }()
}
