//
//  AppState.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@Observable
class AppState {
    private(set) var showTabBar: Bool {
        didSet {
            UserDefaults.showTabbarView = showTabBar
        }
    }
    
    init(showTabBar: Bool = UserDefaults.showTabbarView) {
        self.showTabBar = showTabBar
    }
    
    func updateViewState(showTabbarView: Bool) {
        showTabBar = showTabbarView
    }
}
