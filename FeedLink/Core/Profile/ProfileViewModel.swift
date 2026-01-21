//
//  ProfileViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@MainActor
protocol ProfileInteractor {
    func updateViewState(showTabbarView: Bool)
}

extension CoreInteractor: ProfileInteractor {}

@MainActor
@Observable
class ProfileViewModel {
    private let interactor: ProfileInteractor
    
    init(interactor: ProfileInteractor) {
        self.interactor = interactor
    }
    
    func onLogoutPress() {
        print(">>> Logout <<<")
        interactor.updateViewState(showTabbarView: false)
    }
}
