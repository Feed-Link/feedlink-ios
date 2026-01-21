//
//  FeedLinkApp.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/12/25.
//

import SwiftUI
import SwiftData

@main
struct FeedLinkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            delegate.builder.appView()
                .environment(delegate.builder)
        }
    }
}
