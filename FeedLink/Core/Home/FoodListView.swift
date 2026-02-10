//
//  FoodListView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import SwiftUI

@MainActor
protocol FoodListInteractor {
    func fetchFoods() async throws -> [Food]
}

extension CoreInteractor: FoodListInteractor {}

@MainActor
@Observable
class FoodListViewModel {
    private let interactor: FoodListInteractor
    
    private(set) var foods: [Food] = []
    var showAlert: AnyAppAlert?
    
    init(interactor: FoodListInteractor) {
        self.interactor = interactor
    }
    
    func fetchFoods() async {
        do {
            let foods = try await interactor.fetchFoods()
            self.foods = foods
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
    }
}

struct FoodListView: View {
    
    @State var viewModel: FoodListViewModel
    
    var body: some View {
        List(viewModel.foods) { food in
            Text(food.title)
                .padding()
        }
        .task {
            await viewModel.fetchFoods()
        }
        .showCustomAlert(alert: $viewModel.showAlert)
    }
}

#Preview {
    let interactor = CoreInteractor(container: DevPreview.shared.container)
    CoreBuilder(interactor: interactor)
        .foodListView()
        .previewEnvironment()
}
