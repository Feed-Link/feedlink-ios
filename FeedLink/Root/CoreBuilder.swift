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
    
    func registerView(path: Binding<[AuthPathOption]>) -> some View {
        RegisterView(viewModel: RegisterViewModel(interactor: interactor), path: path)
    }
    
    func verificationView(path: Binding<[AuthPathOption]>, email: String) -> some View {
        VerificationView(
            viewModel: VerificationViewModel(interactor: interactor),
            email: email,
            path: path
        )
    }
    
    func appView() -> some View {
        AppView(viewModel: AppViewModel(interactor: interactor))
    }
    
    func tabBarView() -> some View {
        TabBarView()
    }
    
    func foodListView() -> some View {
        FoodListView(viewModel: FoodListViewModel(interactor: interactor))
    }
    
    func profileView() -> some View {
        ProfileView(viewModel: ProfileViewModel(interactor: interactor))
    }
}
