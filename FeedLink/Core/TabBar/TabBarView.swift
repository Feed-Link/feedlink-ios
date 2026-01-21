//
//  TabBarView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

struct TabBarView: View {
    @Environment(CoreBuilder.self) private var builder
    
    var body: some View {
        TabView {
            builder.homeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            builder.profileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    let interactor = CoreInteractor(container: DevPreview.shared.container)
    CoreBuilder(interactor: interactor)
        .tabBarView()
        .previewEnvironment()
}
