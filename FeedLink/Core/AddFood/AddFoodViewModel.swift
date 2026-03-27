//
//  AddFoodViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 3/27/26.
//

import PhotosUI
import UIKit
import SwiftUI

@MainActor
protocol AddFoodInteractor {
}

extension CoreInteractor: AddFoodInteractor {}

@MainActor
@Observable
class AddFoodViewModel {
    private let interactor: AddFoodInteractor
    
    var selectedPhotoItem: PhotosPickerItem?
    var selectedImage: UIImage?
    
    var foodName: String = ""
    var descriptionText: String = ""
    var quantity: String = ""
    
    enum SafetyTag: String, CaseIterable, Identifiable {
        case human = "Safe for humans"
        case dogs = "Safe for street dogs"
        
        var id: String { rawValue }
    }
    
    enum DietTag: String, CaseIterable, Identifiable {
        case veg = "Veg"
        case nonVeg = "Non-veg"
        
        var id: String { rawValue }
    }
    
    var selectedSafetyTag: SafetyTag = .human
    var selectedDietTag: DietTag = .veg
    
    var hygieneChecked: Bool = false
    var pickupWithinFourHoursChecked: Bool = false
    var confirmSafeAndFreshChecked: Bool = false
    
    var isPosting: Bool = false
    var errorMessage: String?
    
    init(interactor: AddFoodInteractor) {
        self.interactor = interactor
    }
    
    var canPost: Bool {
        !foodName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        hygieneChecked &&
        pickupWithinFourHoursChecked &&
        confirmSafeAndFreshChecked
    }
    
    func loadSelectedPhoto() async {
        guard let selectedPhotoItem else { return }
        
        do {
            if let data = try await selectedPhotoItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
            }
        } catch {
            errorMessage = "Unable to load image. Please try another photo."
        }
    }
    
    func postListing() async {
        guard canPost else {
            errorMessage = "Please complete all fields and safety checks."
            return
        }
        
        isPosting = true
        defer { isPosting = false }
        
        // Placeholder submission flow aligned with current architecture.
        // Wire this to interactor/service when endpoint is ready.
        try? await Task.sleep(nanoseconds: 600_000_000)
    }
}

