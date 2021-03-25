//
//  User.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation
import Firebase

struct User: Codable {
    let uid: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
    }
    
    static var currentUser: User? {
        get {
            return User.userCache
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
