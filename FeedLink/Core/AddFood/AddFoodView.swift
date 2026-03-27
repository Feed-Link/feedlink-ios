//
//  AddFoodView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 3/27/26.
//
import PhotosUI
import SwiftUI

struct AddFoodView: View {
    
    @State var viewModel: AddFoodViewModel
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name
        case description
        case quantity
    }
    
    private enum DS {
        static let sectionSpacing: CGFloat = 20
        static let cardRadius: CGFloat = 16
        static let cardPadding: CGFloat = 14
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DS.sectionSpacing) {
                    photoSection
                    detailsSection
                    tagsSection
                    checklistSection
                    postButton
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Add Food")
            .alert("Couldn’t continue", isPresented: errorBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onChange(of: viewModel.selectedPhotoItem) { oldValue, newValue in
                Task {
                    await viewModel.loadSelectedPhoto()
                }
            }
        }
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Food Photo")
                .font(.headline)
            
            PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 200)
                    
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 28, weight: .semibold))
                            Text("Add photo from library")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Add photo from photo library")
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 14) {
            FormField(
                label: "Food Name",
                placeholder: "e.g. Veg momo",
                text: $viewModel.foodName,
                validator: RequiredValidator(fieldName: "Food Name"),
                isSecure: false,
                keyboardType: .default,
                autocapitalization: .words,
                submitLabel: .next,
                onSubmit: { focusedField = .description}
            )
            
            FormField(
                label: "Description",
                placeholder: "Description",
                text: $viewModel.descriptionText,
                validator: RequiredValidator(fieldName: "Description"),
                isSecure: false,
                keyboardType: .default,
                autocapitalization: .sentences,
                submitLabel: .next,
                onSubmit: { focusedField = .description }
            )
            
            FormField(
                label: "Quantity (meals/kg)",
                placeholder: "e.g. 3 meals or 1.5 kg",
                text: $viewModel.quantity,
                validator: RequiredValidator(fieldName: "Quantity"),
                isSecure: false,
                keyboardType: .default,
                autocapitalization: .never,
                submitLabel: .next,
                onSubmit: nil
            )
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Tags")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Safety")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Picker("Safety", selection: $viewModel.selectedSafetyTag) {
                    ForEach(AddFoodViewModel.SafetyTag.allCases) { tag in
                        Text(tag.rawValue).tag(tag)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Food Type")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Picker("Food Type", selection: $viewModel.selectedDietTag) {
                    ForEach(AddFoodViewModel.DietTag.allCases) { tag in
                        Text(tag.rawValue).tag(tag)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(DS.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Safety Checklist")
                .font(.headline)
            
            checklistItem(
                "Food meets basic hygiene standards No onions, garlic, grapes, chocolate or other harmful items for dogs",
                isOn: $viewModel.hygieneChecked
            )
            
            checklistItem(
                "Pickup recommended within 4 hours",
                isOn: $viewModel.pickupWithinFourHoursChecked
            )
            
            checklistItem(
                "I confirm the food is safe and fresh",
                isOn: $viewModel.confirmSafeAndFreshChecked
            )
        }
        .padding(DS.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    private var postButton: some View {
        AsyncCallToActionButton(isLoading: viewModel.isPosting, title: "Post Listing") {
            Task {
                await viewModel.postListing()
            }
        }
        .disabled(!viewModel.canPost || viewModel.isPosting)
        .opacity((!viewModel.canPost || viewModel.isPosting) ? 0.6 : 1)
        .padding(.top, 4)
    }
    
    private func formInput(
        label: String,
        placeholder: String,
        text: Binding<String>,
        axis: Axis
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
            
            TextField(placeholder, text: text, axis: axis)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled(false)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        }
    }
    
    private func checklistItem(_ title: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
                .font(.subheadline)
        }
        .toggleStyle(.checkboxLike)
    }
    
    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { newValue in
                if !newValue { viewModel.errorMessage = nil }
            }
        )
    }
}

private struct CheckboxLikeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundStyle(configuration.isOn ? Color.green : Color.secondary)
                
                configuration.label
                    .foregroundStyle(.primary)
                
                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
    }
}

private extension ToggleStyle where Self == CheckboxLikeToggleStyle {
    static var checkboxLike: CheckboxLikeToggleStyle { .init() }
}

#Preview {
    let container = DevPreview.shared.container
    let interactor = CoreInteractor(container: container)
    AddFoodView(viewModel: AddFoodViewModel(interactor: interactor))
}
