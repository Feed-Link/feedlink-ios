//
//  AppViewBuilder.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

struct AppViewBuilder<TabBarView: View, LoginView: View>: View {
    
    var showTabBar: Bool = false
    
    @ViewBuilder var tabBarView: TabBarView
    @ViewBuilder var loginView: LoginView
    
    var body: some View {
        ZStack {
            if showTabBar {
                tabBarView
                    .transition(.move(edge: .trailing))
            } else {
                loginView
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabBar)
    }
}

private struct Preview: View {
    @State private var showTabBar: Bool = false
    var body: some View {
        
        AppViewBuilder(
            showTabBar: showTabBar,
            tabBarView: {
                ZStack {
                    Color.red.ignoresSafeArea()
                    Text("TabBar")
                }
            },
            loginView: {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("Login")
                }
            }
        )
        .onTapGesture {
            showTabBar.toggle()
        }
    }
}

#Preview {
    Preview()
}
