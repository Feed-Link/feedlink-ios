//
//  FoodListViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 3/26/26.
//

import Observation

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
