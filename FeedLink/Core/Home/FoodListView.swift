//
//  FoodListView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import SwiftUI

struct FoodListView: View {
    
    enum SafetyFilter: String, CaseIterable {
        case all = "All"
        case safeForHumans = "Safe for humans"
        case safeForAnimals = "Safe for animals"
    }
    
    enum DietFilter: String, CaseIterable {
        case all = "All"
        case veg = "Veg"
        case nonVeg = "Non-veg"
    }
    
    @State var viewModel: FoodListViewModel
    @State private var searchText: String = ""
    @State private var selectedSafety: SafetyFilter = .all
    @State private var selectedDiet: DietFilter = .all
    @State private var nearByMeOnly: Bool = false
    @State var foods: [String] = [
        "daal bhat veg safe for humans near",
        "momo non-veg safe for humans",
        "laphing veg safe for humans near",
        "keemanoodles non-veg safe for animals",
        "sekuwa non-veg safe for humans near"
    ]
    
    private var filteredFoods: [String] {
        var result = foods
        
        let normalizedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !normalizedSearch.isEmpty {
            result = result.filter { $0.localizedCaseInsensitiveContains(normalizedSearch) }
        }
        
        if selectedSafety != .all {
            result = result.filter { $0.localizedCaseInsensitiveContains(selectedSafety.rawValue) }
        }
        
        if selectedDiet != .all {
            result = result.filter { $0.localizedCaseInsensitiveContains(selectedDiet.rawValue) }
        }
        
        if nearByMeOnly {
            result = result.filter { $0.localizedCaseInsensitiveContains("near") }
        }
        
        return result
    }
    
    var body: some View {
        
        NavigationStack {
            List(filteredFoods, id: \.self) { _ in
                FoodCard()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search foods..."
            )
            .task {
                await viewModel.fetchFoods()
            }
            .navigationTitle("Foods")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section("Safety") {
                            Menu {
                                ForEach(SafetyFilter.allCases, id: \.self) { option in
                                    Button {
                                        selectedSafety = option
                                    } label: {
                                        if selectedSafety == option {
                                            Label(option.rawValue, systemImage: "checkmark")
                                        } else {
                                            Text(option.rawValue)
                                        }
                                    }
                                }
                            } label: {
                                Text(selectedSafety.rawValue)
                            }
                        }
                        Menu {
                            Section("Type") {
                                ForEach(DietFilter.allCases, id: \.self) { option in
                                    Button {
                                        selectedDiet = option
                                    } label: {
                                        if selectedDiet == option {
                                            Label(option.rawValue, systemImage: "checkmark")
                                        } else {
                                            Text(option.rawValue)
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text(selectedDiet.rawValue)
                        }

                        
                        Section("Distance") {
                            Toggle("Near by me", isOn: $nearByMeOnly)
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
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
