//
//  CoreBuilder.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@Observable
@MainActor
class CoreBuilder {
    let interactor: CoreInteractor
    
    init(interactor: CoreInteractor) {
        self.interactor = interactor
    }
    
    func loginView() -> some View {
        LoginView(viewModel: LoginViewModel(interactor: interactor))
    }
    
    func appView() -> some View {
        AppView(viewModel: AppViewModel(interactor: interactor))
    }
    
    func tabBarView() -> some View {
        TabBarView()
    }
    
    func homeView() -> some View {
        HomeView(viewModel: HomeViewModel(interactor: interactor))
    }
    
    func profileView() -> some View {
        ProfileView(viewModel: ProfileViewModel(interactor: interactor))
    }
}
