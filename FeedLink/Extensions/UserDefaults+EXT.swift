//
//  UserDefaults+EXT.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import Foundation

extension UserDefaults {
    struct Keys {
        static let showTabBarView = "showTabBarView"
        static let accessToken = "accessToken"
    }
    
    static var showTabbarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabBarView)
        }
        set {
            standard.set(newValue, forKey: Keys.showTabBarView)
        }
    }
    
    static var accessToken: String {
        get {
            standard.string(forKey: Keys.accessToken) ?? ""
        }
        set {
            standard.set(newValue, forKey: Keys.accessToken)
        }
    }
}
