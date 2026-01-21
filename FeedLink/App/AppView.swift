//
//  AppView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@MainActor
protocol AppViewInteractor {
    var showTabBar : Bool { get }
}

extension CoreInteractor: AppViewInteractor {}

@MainActor
@Observable
class AppViewModel {
    private let interactor: AppViewInteractor
    
    var showTabBar: Bool {
        interactor.showTabBar
    }
    
    init(interactor: AppViewInteractor) {
        self.interactor = interactor
    }
}

struct AppView: View {
    
    @Environment(CoreBuilder.self) private var builder
    
    @State var viewModel: AppViewModel
    
    var body: some View {
        AppViewBuilder(
            showTabBar: viewModel.showTabBar,
            tabBarView: {
                builder.tabBarView()
            },
            loginView: {
                builder.loginView()
            }
        )
    }
}

#Preview {
    let interactor = CoreInteractor(container: DevPreview.shared.container)
    CoreBuilder(interactor: interactor)
        .appView()
        .previewEnvironment()
}
