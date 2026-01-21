//
//  HomeViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@MainActor
protocol HomeInteractor {}

extension CoreInteractor: HomeInteractor {}

@MainActor
@Observable
class HomeViewModel {
    private let interactor: HomeInteractor
    
    init(interactor: HomeInteractor) {
        self.interactor = interactor
    }
}
