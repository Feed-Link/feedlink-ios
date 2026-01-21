//
//  ProfileView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel
    
    var body: some View {
        Button("Logout") {
            viewModel.onLogoutPress()
        }
    }
}

#Preview {
    let interactor = CoreInteractor(container: DevPreview.shared.container)
    CoreBuilder(interactor: interactor)
        .profileView()
        .previewEnvironment()
}
